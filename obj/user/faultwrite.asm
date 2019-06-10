
obj/user/faultwrite.debug:     file format elf32-i386


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
	*(unsigned*)0 = 0;
  800033:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
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
  8000c1:	68 80 25 80 00       	push   $0x802580
  8000c6:	e8 15 01 00 00       	call   8001e0 <cprintf>
	cprintf("before umain\n");
  8000cb:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000d2:	e8 09 01 00 00       	call   8001e0 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d7:	83 c4 08             	add    $0x8,%esp
  8000da:	ff 75 0c             	pushl  0xc(%ebp)
  8000dd:	ff 75 08             	pushl  0x8(%ebp)
  8000e0:	e8 4e ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000e5:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000ec:	e8 ef 00 00 00       	call   8001e0 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000f1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000f6:	8b 40 48             	mov    0x48(%eax),%eax
  8000f9:	83 c4 08             	add    $0x8,%esp
  8000fc:	50                   	push   %eax
  8000fd:	68 b9 25 80 00       	push   $0x8025b9
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
  800125:	68 e4 25 80 00       	push   $0x8025e4
  80012a:	50                   	push   %eax
  80012b:	68 d8 25 80 00       	push   $0x8025d8
  800130:	e8 ab 00 00 00       	call   8001e0 <cprintf>
	close_all();
  800135:	e8 c4 10 00 00       	call   8011fe <close_all>
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
  80028d:	e8 8e 20 00 00       	call   802320 <__udivdi3>
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
  8002b6:	e8 75 21 00 00       	call   802430 <__umoddi3>
  8002bb:	83 c4 14             	add    $0x14,%esp
  8002be:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
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
  800367:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
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
  800432:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800439:	85 d2                	test   %edx,%edx
  80043b:	74 18                	je     800455 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80043d:	52                   	push   %edx
  80043e:	68 3d 2a 80 00       	push   $0x802a3d
  800443:	53                   	push   %ebx
  800444:	56                   	push   %esi
  800445:	e8 a6 fe ff ff       	call   8002f0 <printfmt>
  80044a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800450:	e9 fe 02 00 00       	jmp    800753 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800455:	50                   	push   %eax
  800456:	68 01 26 80 00       	push   $0x802601
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
  80047d:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
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
  800815:	bf 1d 27 80 00       	mov    $0x80271d,%edi
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
  800841:	bf 55 27 80 00       	mov    $0x802755,%edi
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
  800ce2:	68 68 29 80 00       	push   $0x802968
  800ce7:	6a 43                	push   $0x43
  800ce9:	68 85 29 80 00       	push   $0x802985
  800cee:	e8 89 14 00 00       	call   80217c <_panic>

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
  800d63:	68 68 29 80 00       	push   $0x802968
  800d68:	6a 43                	push   $0x43
  800d6a:	68 85 29 80 00       	push   $0x802985
  800d6f:	e8 08 14 00 00       	call   80217c <_panic>

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
  800da5:	68 68 29 80 00       	push   $0x802968
  800daa:	6a 43                	push   $0x43
  800dac:	68 85 29 80 00       	push   $0x802985
  800db1:	e8 c6 13 00 00       	call   80217c <_panic>

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
  800de7:	68 68 29 80 00       	push   $0x802968
  800dec:	6a 43                	push   $0x43
  800dee:	68 85 29 80 00       	push   $0x802985
  800df3:	e8 84 13 00 00       	call   80217c <_panic>

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
  800e29:	68 68 29 80 00       	push   $0x802968
  800e2e:	6a 43                	push   $0x43
  800e30:	68 85 29 80 00       	push   $0x802985
  800e35:	e8 42 13 00 00       	call   80217c <_panic>

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
  800e6b:	68 68 29 80 00       	push   $0x802968
  800e70:	6a 43                	push   $0x43
  800e72:	68 85 29 80 00       	push   $0x802985
  800e77:	e8 00 13 00 00       	call   80217c <_panic>

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
  800ead:	68 68 29 80 00       	push   $0x802968
  800eb2:	6a 43                	push   $0x43
  800eb4:	68 85 29 80 00       	push   $0x802985
  800eb9:	e8 be 12 00 00       	call   80217c <_panic>

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
  800f11:	68 68 29 80 00       	push   $0x802968
  800f16:	6a 43                	push   $0x43
  800f18:	68 85 29 80 00       	push   $0x802985
  800f1d:	e8 5a 12 00 00       	call   80217c <_panic>

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
  800ff5:	68 68 29 80 00       	push   $0x802968
  800ffa:	6a 43                	push   $0x43
  800ffc:	68 85 29 80 00       	push   $0x802985
  801001:	e8 76 11 00 00       	call   80217c <_panic>

00801006 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	57                   	push   %edi
  80100a:	56                   	push   %esi
  80100b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	b8 14 00 00 00       	mov    $0x14,%eax
  801019:	89 cb                	mov    %ecx,%ebx
  80101b:	89 cf                	mov    %ecx,%edi
  80101d:	89 ce                	mov    %ecx,%esi
  80101f:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	05 00 00 00 30       	add    $0x30000000,%eax
  801031:	c1 e8 0c             	shr    $0xc,%eax
}
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801041:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801046:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80104b:	5d                   	pop    %ebp
  80104c:	c3                   	ret    

0080104d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801055:	89 c2                	mov    %eax,%edx
  801057:	c1 ea 16             	shr    $0x16,%edx
  80105a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801061:	f6 c2 01             	test   $0x1,%dl
  801064:	74 2d                	je     801093 <fd_alloc+0x46>
  801066:	89 c2                	mov    %eax,%edx
  801068:	c1 ea 0c             	shr    $0xc,%edx
  80106b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801072:	f6 c2 01             	test   $0x1,%dl
  801075:	74 1c                	je     801093 <fd_alloc+0x46>
  801077:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80107c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801081:	75 d2                	jne    801055 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80108c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801091:	eb 0a                	jmp    80109d <fd_alloc+0x50>
			*fd_store = fd;
  801093:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801096:	89 01                	mov    %eax,(%ecx)
			return 0;
  801098:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80109d:	5d                   	pop    %ebp
  80109e:	c3                   	ret    

0080109f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80109f:	55                   	push   %ebp
  8010a0:	89 e5                	mov    %esp,%ebp
  8010a2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010a5:	83 f8 1f             	cmp    $0x1f,%eax
  8010a8:	77 30                	ja     8010da <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010aa:	c1 e0 0c             	shl    $0xc,%eax
  8010ad:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010b2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010b8:	f6 c2 01             	test   $0x1,%dl
  8010bb:	74 24                	je     8010e1 <fd_lookup+0x42>
  8010bd:	89 c2                	mov    %eax,%edx
  8010bf:	c1 ea 0c             	shr    $0xc,%edx
  8010c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010c9:	f6 c2 01             	test   $0x1,%dl
  8010cc:	74 1a                	je     8010e8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d1:	89 02                	mov    %eax,(%edx)
	return 0;
  8010d3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d8:	5d                   	pop    %ebp
  8010d9:	c3                   	ret    
		return -E_INVAL;
  8010da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010df:	eb f7                	jmp    8010d8 <fd_lookup+0x39>
		return -E_INVAL;
  8010e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e6:	eb f0                	jmp    8010d8 <fd_lookup+0x39>
  8010e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ed:	eb e9                	jmp    8010d8 <fd_lookup+0x39>

008010ef <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010ef:	55                   	push   %ebp
  8010f0:	89 e5                	mov    %esp,%ebp
  8010f2:	83 ec 08             	sub    $0x8,%esp
  8010f5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010fd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801102:	39 08                	cmp    %ecx,(%eax)
  801104:	74 38                	je     80113e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801106:	83 c2 01             	add    $0x1,%edx
  801109:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	75 ee                	jne    801102 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801114:	a1 08 40 80 00       	mov    0x804008,%eax
  801119:	8b 40 48             	mov    0x48(%eax),%eax
  80111c:	83 ec 04             	sub    $0x4,%esp
  80111f:	51                   	push   %ecx
  801120:	50                   	push   %eax
  801121:	68 94 29 80 00       	push   $0x802994
  801126:	e8 b5 f0 ff ff       	call   8001e0 <cprintf>
	*dev = 0;
  80112b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801134:	83 c4 10             	add    $0x10,%esp
  801137:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80113c:	c9                   	leave  
  80113d:	c3                   	ret    
			*dev = devtab[i];
  80113e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801141:	89 01                	mov    %eax,(%ecx)
			return 0;
  801143:	b8 00 00 00 00       	mov    $0x0,%eax
  801148:	eb f2                	jmp    80113c <dev_lookup+0x4d>

0080114a <fd_close>:
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
  801150:	83 ec 24             	sub    $0x24,%esp
  801153:	8b 75 08             	mov    0x8(%ebp),%esi
  801156:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801159:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80115c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80115d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801163:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801166:	50                   	push   %eax
  801167:	e8 33 ff ff ff       	call   80109f <fd_lookup>
  80116c:	89 c3                	mov    %eax,%ebx
  80116e:	83 c4 10             	add    $0x10,%esp
  801171:	85 c0                	test   %eax,%eax
  801173:	78 05                	js     80117a <fd_close+0x30>
	    || fd != fd2)
  801175:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801178:	74 16                	je     801190 <fd_close+0x46>
		return (must_exist ? r : 0);
  80117a:	89 f8                	mov    %edi,%eax
  80117c:	84 c0                	test   %al,%al
  80117e:	b8 00 00 00 00       	mov    $0x0,%eax
  801183:	0f 44 d8             	cmove  %eax,%ebx
}
  801186:	89 d8                	mov    %ebx,%eax
  801188:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80118b:	5b                   	pop    %ebx
  80118c:	5e                   	pop    %esi
  80118d:	5f                   	pop    %edi
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801190:	83 ec 08             	sub    $0x8,%esp
  801193:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801196:	50                   	push   %eax
  801197:	ff 36                	pushl  (%esi)
  801199:	e8 51 ff ff ff       	call   8010ef <dev_lookup>
  80119e:	89 c3                	mov    %eax,%ebx
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	85 c0                	test   %eax,%eax
  8011a5:	78 1a                	js     8011c1 <fd_close+0x77>
		if (dev->dev_close)
  8011a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011aa:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011b2:	85 c0                	test   %eax,%eax
  8011b4:	74 0b                	je     8011c1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011b6:	83 ec 0c             	sub    $0xc,%esp
  8011b9:	56                   	push   %esi
  8011ba:	ff d0                	call   *%eax
  8011bc:	89 c3                	mov    %eax,%ebx
  8011be:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011c1:	83 ec 08             	sub    $0x8,%esp
  8011c4:	56                   	push   %esi
  8011c5:	6a 00                	push   $0x0
  8011c7:	e8 ea fb ff ff       	call   800db6 <sys_page_unmap>
	return r;
  8011cc:	83 c4 10             	add    $0x10,%esp
  8011cf:	eb b5                	jmp    801186 <fd_close+0x3c>

008011d1 <close>:

int
close(int fdnum)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011da:	50                   	push   %eax
  8011db:	ff 75 08             	pushl  0x8(%ebp)
  8011de:	e8 bc fe ff ff       	call   80109f <fd_lookup>
  8011e3:	83 c4 10             	add    $0x10,%esp
  8011e6:	85 c0                	test   %eax,%eax
  8011e8:	79 02                	jns    8011ec <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    
		return fd_close(fd, 1);
  8011ec:	83 ec 08             	sub    $0x8,%esp
  8011ef:	6a 01                	push   $0x1
  8011f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011f4:	e8 51 ff ff ff       	call   80114a <fd_close>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	eb ec                	jmp    8011ea <close+0x19>

008011fe <close_all>:

void
close_all(void)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	53                   	push   %ebx
  801202:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801205:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80120a:	83 ec 0c             	sub    $0xc,%esp
  80120d:	53                   	push   %ebx
  80120e:	e8 be ff ff ff       	call   8011d1 <close>
	for (i = 0; i < MAXFD; i++)
  801213:	83 c3 01             	add    $0x1,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	83 fb 20             	cmp    $0x20,%ebx
  80121c:	75 ec                	jne    80120a <close_all+0xc>
}
  80121e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	57                   	push   %edi
  801227:	56                   	push   %esi
  801228:	53                   	push   %ebx
  801229:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80122c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80122f:	50                   	push   %eax
  801230:	ff 75 08             	pushl  0x8(%ebp)
  801233:	e8 67 fe ff ff       	call   80109f <fd_lookup>
  801238:	89 c3                	mov    %eax,%ebx
  80123a:	83 c4 10             	add    $0x10,%esp
  80123d:	85 c0                	test   %eax,%eax
  80123f:	0f 88 81 00 00 00    	js     8012c6 <dup+0xa3>
		return r;
	close(newfdnum);
  801245:	83 ec 0c             	sub    $0xc,%esp
  801248:	ff 75 0c             	pushl  0xc(%ebp)
  80124b:	e8 81 ff ff ff       	call   8011d1 <close>

	newfd = INDEX2FD(newfdnum);
  801250:	8b 75 0c             	mov    0xc(%ebp),%esi
  801253:	c1 e6 0c             	shl    $0xc,%esi
  801256:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80125c:	83 c4 04             	add    $0x4,%esp
  80125f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801262:	e8 cf fd ff ff       	call   801036 <fd2data>
  801267:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801269:	89 34 24             	mov    %esi,(%esp)
  80126c:	e8 c5 fd ff ff       	call   801036 <fd2data>
  801271:	83 c4 10             	add    $0x10,%esp
  801274:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801276:	89 d8                	mov    %ebx,%eax
  801278:	c1 e8 16             	shr    $0x16,%eax
  80127b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801282:	a8 01                	test   $0x1,%al
  801284:	74 11                	je     801297 <dup+0x74>
  801286:	89 d8                	mov    %ebx,%eax
  801288:	c1 e8 0c             	shr    $0xc,%eax
  80128b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801292:	f6 c2 01             	test   $0x1,%dl
  801295:	75 39                	jne    8012d0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801297:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80129a:	89 d0                	mov    %edx,%eax
  80129c:	c1 e8 0c             	shr    $0xc,%eax
  80129f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a6:	83 ec 0c             	sub    $0xc,%esp
  8012a9:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ae:	50                   	push   %eax
  8012af:	56                   	push   %esi
  8012b0:	6a 00                	push   $0x0
  8012b2:	52                   	push   %edx
  8012b3:	6a 00                	push   $0x0
  8012b5:	e8 ba fa ff ff       	call   800d74 <sys_page_map>
  8012ba:	89 c3                	mov    %eax,%ebx
  8012bc:	83 c4 20             	add    $0x20,%esp
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	78 31                	js     8012f4 <dup+0xd1>
		goto err;

	return newfdnum;
  8012c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012c6:	89 d8                	mov    %ebx,%eax
  8012c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cb:	5b                   	pop    %ebx
  8012cc:	5e                   	pop    %esi
  8012cd:	5f                   	pop    %edi
  8012ce:	5d                   	pop    %ebp
  8012cf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012d7:	83 ec 0c             	sub    $0xc,%esp
  8012da:	25 07 0e 00 00       	and    $0xe07,%eax
  8012df:	50                   	push   %eax
  8012e0:	57                   	push   %edi
  8012e1:	6a 00                	push   $0x0
  8012e3:	53                   	push   %ebx
  8012e4:	6a 00                	push   $0x0
  8012e6:	e8 89 fa ff ff       	call   800d74 <sys_page_map>
  8012eb:	89 c3                	mov    %eax,%ebx
  8012ed:	83 c4 20             	add    $0x20,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	79 a3                	jns    801297 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	56                   	push   %esi
  8012f8:	6a 00                	push   $0x0
  8012fa:	e8 b7 fa ff ff       	call   800db6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ff:	83 c4 08             	add    $0x8,%esp
  801302:	57                   	push   %edi
  801303:	6a 00                	push   $0x0
  801305:	e8 ac fa ff ff       	call   800db6 <sys_page_unmap>
	return r;
  80130a:	83 c4 10             	add    $0x10,%esp
  80130d:	eb b7                	jmp    8012c6 <dup+0xa3>

0080130f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	53                   	push   %ebx
  801313:	83 ec 1c             	sub    $0x1c,%esp
  801316:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801319:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80131c:	50                   	push   %eax
  80131d:	53                   	push   %ebx
  80131e:	e8 7c fd ff ff       	call   80109f <fd_lookup>
  801323:	83 c4 10             	add    $0x10,%esp
  801326:	85 c0                	test   %eax,%eax
  801328:	78 3f                	js     801369 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80132a:	83 ec 08             	sub    $0x8,%esp
  80132d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801330:	50                   	push   %eax
  801331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801334:	ff 30                	pushl  (%eax)
  801336:	e8 b4 fd ff ff       	call   8010ef <dev_lookup>
  80133b:	83 c4 10             	add    $0x10,%esp
  80133e:	85 c0                	test   %eax,%eax
  801340:	78 27                	js     801369 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801342:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801345:	8b 42 08             	mov    0x8(%edx),%eax
  801348:	83 e0 03             	and    $0x3,%eax
  80134b:	83 f8 01             	cmp    $0x1,%eax
  80134e:	74 1e                	je     80136e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801350:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801353:	8b 40 08             	mov    0x8(%eax),%eax
  801356:	85 c0                	test   %eax,%eax
  801358:	74 35                	je     80138f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80135a:	83 ec 04             	sub    $0x4,%esp
  80135d:	ff 75 10             	pushl  0x10(%ebp)
  801360:	ff 75 0c             	pushl  0xc(%ebp)
  801363:	52                   	push   %edx
  801364:	ff d0                	call   *%eax
  801366:	83 c4 10             	add    $0x10,%esp
}
  801369:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80136e:	a1 08 40 80 00       	mov    0x804008,%eax
  801373:	8b 40 48             	mov    0x48(%eax),%eax
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	53                   	push   %ebx
  80137a:	50                   	push   %eax
  80137b:	68 d5 29 80 00       	push   $0x8029d5
  801380:	e8 5b ee ff ff       	call   8001e0 <cprintf>
		return -E_INVAL;
  801385:	83 c4 10             	add    $0x10,%esp
  801388:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80138d:	eb da                	jmp    801369 <read+0x5a>
		return -E_NOT_SUPP;
  80138f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801394:	eb d3                	jmp    801369 <read+0x5a>

00801396 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801396:	55                   	push   %ebp
  801397:	89 e5                	mov    %esp,%ebp
  801399:	57                   	push   %edi
  80139a:	56                   	push   %esi
  80139b:	53                   	push   %ebx
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013a2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013aa:	39 f3                	cmp    %esi,%ebx
  8013ac:	73 23                	jae    8013d1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ae:	83 ec 04             	sub    $0x4,%esp
  8013b1:	89 f0                	mov    %esi,%eax
  8013b3:	29 d8                	sub    %ebx,%eax
  8013b5:	50                   	push   %eax
  8013b6:	89 d8                	mov    %ebx,%eax
  8013b8:	03 45 0c             	add    0xc(%ebp),%eax
  8013bb:	50                   	push   %eax
  8013bc:	57                   	push   %edi
  8013bd:	e8 4d ff ff ff       	call   80130f <read>
		if (m < 0)
  8013c2:	83 c4 10             	add    $0x10,%esp
  8013c5:	85 c0                	test   %eax,%eax
  8013c7:	78 06                	js     8013cf <readn+0x39>
			return m;
		if (m == 0)
  8013c9:	74 06                	je     8013d1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013cb:	01 c3                	add    %eax,%ebx
  8013cd:	eb db                	jmp    8013aa <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013cf:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013d1:	89 d8                	mov    %ebx,%eax
  8013d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5f                   	pop    %edi
  8013d9:	5d                   	pop    %ebp
  8013da:	c3                   	ret    

008013db <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	53                   	push   %ebx
  8013df:	83 ec 1c             	sub    $0x1c,%esp
  8013e2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	53                   	push   %ebx
  8013ea:	e8 b0 fc ff ff       	call   80109f <fd_lookup>
  8013ef:	83 c4 10             	add    $0x10,%esp
  8013f2:	85 c0                	test   %eax,%eax
  8013f4:	78 3a                	js     801430 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013f6:	83 ec 08             	sub    $0x8,%esp
  8013f9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fc:	50                   	push   %eax
  8013fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801400:	ff 30                	pushl  (%eax)
  801402:	e8 e8 fc ff ff       	call   8010ef <dev_lookup>
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 22                	js     801430 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80140e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801411:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801415:	74 1e                	je     801435 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141a:	8b 52 0c             	mov    0xc(%edx),%edx
  80141d:	85 d2                	test   %edx,%edx
  80141f:	74 35                	je     801456 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801421:	83 ec 04             	sub    $0x4,%esp
  801424:	ff 75 10             	pushl  0x10(%ebp)
  801427:	ff 75 0c             	pushl  0xc(%ebp)
  80142a:	50                   	push   %eax
  80142b:	ff d2                	call   *%edx
  80142d:	83 c4 10             	add    $0x10,%esp
}
  801430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801433:	c9                   	leave  
  801434:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801435:	a1 08 40 80 00       	mov    0x804008,%eax
  80143a:	8b 40 48             	mov    0x48(%eax),%eax
  80143d:	83 ec 04             	sub    $0x4,%esp
  801440:	53                   	push   %ebx
  801441:	50                   	push   %eax
  801442:	68 f1 29 80 00       	push   $0x8029f1
  801447:	e8 94 ed ff ff       	call   8001e0 <cprintf>
		return -E_INVAL;
  80144c:	83 c4 10             	add    $0x10,%esp
  80144f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801454:	eb da                	jmp    801430 <write+0x55>
		return -E_NOT_SUPP;
  801456:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80145b:	eb d3                	jmp    801430 <write+0x55>

0080145d <seek>:

int
seek(int fdnum, off_t offset)
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801463:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801466:	50                   	push   %eax
  801467:	ff 75 08             	pushl  0x8(%ebp)
  80146a:	e8 30 fc ff ff       	call   80109f <fd_lookup>
  80146f:	83 c4 10             	add    $0x10,%esp
  801472:	85 c0                	test   %eax,%eax
  801474:	78 0e                	js     801484 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801476:	8b 55 0c             	mov    0xc(%ebp),%edx
  801479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80147f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801484:	c9                   	leave  
  801485:	c3                   	ret    

00801486 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801486:	55                   	push   %ebp
  801487:	89 e5                	mov    %esp,%ebp
  801489:	53                   	push   %ebx
  80148a:	83 ec 1c             	sub    $0x1c,%esp
  80148d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801490:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	53                   	push   %ebx
  801495:	e8 05 fc ff ff       	call   80109f <fd_lookup>
  80149a:	83 c4 10             	add    $0x10,%esp
  80149d:	85 c0                	test   %eax,%eax
  80149f:	78 37                	js     8014d8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a1:	83 ec 08             	sub    $0x8,%esp
  8014a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a7:	50                   	push   %eax
  8014a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ab:	ff 30                	pushl  (%eax)
  8014ad:	e8 3d fc ff ff       	call   8010ef <dev_lookup>
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 1f                	js     8014d8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c0:	74 1b                	je     8014dd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c5:	8b 52 18             	mov    0x18(%edx),%edx
  8014c8:	85 d2                	test   %edx,%edx
  8014ca:	74 32                	je     8014fe <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014cc:	83 ec 08             	sub    $0x8,%esp
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	50                   	push   %eax
  8014d3:	ff d2                	call   *%edx
  8014d5:	83 c4 10             	add    $0x10,%esp
}
  8014d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014dd:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014e2:	8b 40 48             	mov    0x48(%eax),%eax
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	53                   	push   %ebx
  8014e9:	50                   	push   %eax
  8014ea:	68 b4 29 80 00       	push   $0x8029b4
  8014ef:	e8 ec ec ff ff       	call   8001e0 <cprintf>
		return -E_INVAL;
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fc:	eb da                	jmp    8014d8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801503:	eb d3                	jmp    8014d8 <ftruncate+0x52>

00801505 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	53                   	push   %ebx
  801509:	83 ec 1c             	sub    $0x1c,%esp
  80150c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801512:	50                   	push   %eax
  801513:	ff 75 08             	pushl  0x8(%ebp)
  801516:	e8 84 fb ff ff       	call   80109f <fd_lookup>
  80151b:	83 c4 10             	add    $0x10,%esp
  80151e:	85 c0                	test   %eax,%eax
  801520:	78 4b                	js     80156d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801522:	83 ec 08             	sub    $0x8,%esp
  801525:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801528:	50                   	push   %eax
  801529:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152c:	ff 30                	pushl  (%eax)
  80152e:	e8 bc fb ff ff       	call   8010ef <dev_lookup>
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	85 c0                	test   %eax,%eax
  801538:	78 33                	js     80156d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80153a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801541:	74 2f                	je     801572 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801543:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801546:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80154d:	00 00 00 
	stat->st_isdir = 0;
  801550:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801557:	00 00 00 
	stat->st_dev = dev;
  80155a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	53                   	push   %ebx
  801564:	ff 75 f0             	pushl  -0x10(%ebp)
  801567:	ff 50 14             	call   *0x14(%eax)
  80156a:	83 c4 10             	add    $0x10,%esp
}
  80156d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801570:	c9                   	leave  
  801571:	c3                   	ret    
		return -E_NOT_SUPP;
  801572:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801577:	eb f4                	jmp    80156d <fstat+0x68>

00801579 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	56                   	push   %esi
  80157d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80157e:	83 ec 08             	sub    $0x8,%esp
  801581:	6a 00                	push   $0x0
  801583:	ff 75 08             	pushl  0x8(%ebp)
  801586:	e8 22 02 00 00       	call   8017ad <open>
  80158b:	89 c3                	mov    %eax,%ebx
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	78 1b                	js     8015af <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	ff 75 0c             	pushl  0xc(%ebp)
  80159a:	50                   	push   %eax
  80159b:	e8 65 ff ff ff       	call   801505 <fstat>
  8015a0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015a2:	89 1c 24             	mov    %ebx,(%esp)
  8015a5:	e8 27 fc ff ff       	call   8011d1 <close>
	return r;
  8015aa:	83 c4 10             	add    $0x10,%esp
  8015ad:	89 f3                	mov    %esi,%ebx
}
  8015af:	89 d8                	mov    %ebx,%eax
  8015b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b4:	5b                   	pop    %ebx
  8015b5:	5e                   	pop    %esi
  8015b6:	5d                   	pop    %ebp
  8015b7:	c3                   	ret    

008015b8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015b8:	55                   	push   %ebp
  8015b9:	89 e5                	mov    %esp,%ebp
  8015bb:	56                   	push   %esi
  8015bc:	53                   	push   %ebx
  8015bd:	89 c6                	mov    %eax,%esi
  8015bf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015c1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015c8:	74 27                	je     8015f1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ca:	6a 07                	push   $0x7
  8015cc:	68 00 50 80 00       	push   $0x805000
  8015d1:	56                   	push   %esi
  8015d2:	ff 35 00 40 80 00    	pushl  0x804000
  8015d8:	e8 69 0c 00 00       	call   802246 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015dd:	83 c4 0c             	add    $0xc,%esp
  8015e0:	6a 00                	push   $0x0
  8015e2:	53                   	push   %ebx
  8015e3:	6a 00                	push   $0x0
  8015e5:	e8 f3 0b 00 00       	call   8021dd <ipc_recv>
}
  8015ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ed:	5b                   	pop    %ebx
  8015ee:	5e                   	pop    %esi
  8015ef:	5d                   	pop    %ebp
  8015f0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	6a 01                	push   $0x1
  8015f6:	e8 a3 0c 00 00       	call   80229e <ipc_find_env>
  8015fb:	a3 00 40 80 00       	mov    %eax,0x804000
  801600:	83 c4 10             	add    $0x10,%esp
  801603:	eb c5                	jmp    8015ca <fsipc+0x12>

00801605 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80160b:	8b 45 08             	mov    0x8(%ebp),%eax
  80160e:	8b 40 0c             	mov    0xc(%eax),%eax
  801611:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801616:	8b 45 0c             	mov    0xc(%ebp),%eax
  801619:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80161e:	ba 00 00 00 00       	mov    $0x0,%edx
  801623:	b8 02 00 00 00       	mov    $0x2,%eax
  801628:	e8 8b ff ff ff       	call   8015b8 <fsipc>
}
  80162d:	c9                   	leave  
  80162e:	c3                   	ret    

0080162f <devfile_flush>:
{
  80162f:	55                   	push   %ebp
  801630:	89 e5                	mov    %esp,%ebp
  801632:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801635:	8b 45 08             	mov    0x8(%ebp),%eax
  801638:	8b 40 0c             	mov    0xc(%eax),%eax
  80163b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801640:	ba 00 00 00 00       	mov    $0x0,%edx
  801645:	b8 06 00 00 00       	mov    $0x6,%eax
  80164a:	e8 69 ff ff ff       	call   8015b8 <fsipc>
}
  80164f:	c9                   	leave  
  801650:	c3                   	ret    

00801651 <devfile_stat>:
{
  801651:	55                   	push   %ebp
  801652:	89 e5                	mov    %esp,%ebp
  801654:	53                   	push   %ebx
  801655:	83 ec 04             	sub    $0x4,%esp
  801658:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	8b 40 0c             	mov    0xc(%eax),%eax
  801661:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801666:	ba 00 00 00 00       	mov    $0x0,%edx
  80166b:	b8 05 00 00 00       	mov    $0x5,%eax
  801670:	e8 43 ff ff ff       	call   8015b8 <fsipc>
  801675:	85 c0                	test   %eax,%eax
  801677:	78 2c                	js     8016a5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801679:	83 ec 08             	sub    $0x8,%esp
  80167c:	68 00 50 80 00       	push   $0x805000
  801681:	53                   	push   %ebx
  801682:	e8 b8 f2 ff ff       	call   80093f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801687:	a1 80 50 80 00       	mov    0x805080,%eax
  80168c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801692:	a1 84 50 80 00       	mov    0x805084,%eax
  801697:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80169d:	83 c4 10             	add    $0x10,%esp
  8016a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <devfile_write>:
{
  8016aa:	55                   	push   %ebp
  8016ab:	89 e5                	mov    %esp,%ebp
  8016ad:	53                   	push   %ebx
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ba:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016bf:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016c5:	53                   	push   %ebx
  8016c6:	ff 75 0c             	pushl  0xc(%ebp)
  8016c9:	68 08 50 80 00       	push   $0x805008
  8016ce:	e8 5c f4 ff ff       	call   800b2f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d8:	b8 04 00 00 00       	mov    $0x4,%eax
  8016dd:	e8 d6 fe ff ff       	call   8015b8 <fsipc>
  8016e2:	83 c4 10             	add    $0x10,%esp
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	78 0b                	js     8016f4 <devfile_write+0x4a>
	assert(r <= n);
  8016e9:	39 d8                	cmp    %ebx,%eax
  8016eb:	77 0c                	ja     8016f9 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f2:	7f 1e                	jg     801712 <devfile_write+0x68>
}
  8016f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    
	assert(r <= n);
  8016f9:	68 24 2a 80 00       	push   $0x802a24
  8016fe:	68 2b 2a 80 00       	push   $0x802a2b
  801703:	68 98 00 00 00       	push   $0x98
  801708:	68 40 2a 80 00       	push   $0x802a40
  80170d:	e8 6a 0a 00 00       	call   80217c <_panic>
	assert(r <= PGSIZE);
  801712:	68 4b 2a 80 00       	push   $0x802a4b
  801717:	68 2b 2a 80 00       	push   $0x802a2b
  80171c:	68 99 00 00 00       	push   $0x99
  801721:	68 40 2a 80 00       	push   $0x802a40
  801726:	e8 51 0a 00 00       	call   80217c <_panic>

0080172b <devfile_read>:
{
  80172b:	55                   	push   %ebp
  80172c:	89 e5                	mov    %esp,%ebp
  80172e:	56                   	push   %esi
  80172f:	53                   	push   %ebx
  801730:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
  801736:	8b 40 0c             	mov    0xc(%eax),%eax
  801739:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80173e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801744:	ba 00 00 00 00       	mov    $0x0,%edx
  801749:	b8 03 00 00 00       	mov    $0x3,%eax
  80174e:	e8 65 fe ff ff       	call   8015b8 <fsipc>
  801753:	89 c3                	mov    %eax,%ebx
  801755:	85 c0                	test   %eax,%eax
  801757:	78 1f                	js     801778 <devfile_read+0x4d>
	assert(r <= n);
  801759:	39 f0                	cmp    %esi,%eax
  80175b:	77 24                	ja     801781 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80175d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801762:	7f 33                	jg     801797 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801764:	83 ec 04             	sub    $0x4,%esp
  801767:	50                   	push   %eax
  801768:	68 00 50 80 00       	push   $0x805000
  80176d:	ff 75 0c             	pushl  0xc(%ebp)
  801770:	e8 58 f3 ff ff       	call   800acd <memmove>
	return r;
  801775:	83 c4 10             	add    $0x10,%esp
}
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    
	assert(r <= n);
  801781:	68 24 2a 80 00       	push   $0x802a24
  801786:	68 2b 2a 80 00       	push   $0x802a2b
  80178b:	6a 7c                	push   $0x7c
  80178d:	68 40 2a 80 00       	push   $0x802a40
  801792:	e8 e5 09 00 00       	call   80217c <_panic>
	assert(r <= PGSIZE);
  801797:	68 4b 2a 80 00       	push   $0x802a4b
  80179c:	68 2b 2a 80 00       	push   $0x802a2b
  8017a1:	6a 7d                	push   $0x7d
  8017a3:	68 40 2a 80 00       	push   $0x802a40
  8017a8:	e8 cf 09 00 00       	call   80217c <_panic>

008017ad <open>:
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
  8017b0:	56                   	push   %esi
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 1c             	sub    $0x1c,%esp
  8017b5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017b8:	56                   	push   %esi
  8017b9:	e8 48 f1 ff ff       	call   800906 <strlen>
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017c6:	7f 6c                	jg     801834 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017c8:	83 ec 0c             	sub    $0xc,%esp
  8017cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ce:	50                   	push   %eax
  8017cf:	e8 79 f8 ff ff       	call   80104d <fd_alloc>
  8017d4:	89 c3                	mov    %eax,%ebx
  8017d6:	83 c4 10             	add    $0x10,%esp
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	78 3c                	js     801819 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017dd:	83 ec 08             	sub    $0x8,%esp
  8017e0:	56                   	push   %esi
  8017e1:	68 00 50 80 00       	push   $0x805000
  8017e6:	e8 54 f1 ff ff       	call   80093f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ee:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017fb:	e8 b8 fd ff ff       	call   8015b8 <fsipc>
  801800:	89 c3                	mov    %eax,%ebx
  801802:	83 c4 10             	add    $0x10,%esp
  801805:	85 c0                	test   %eax,%eax
  801807:	78 19                	js     801822 <open+0x75>
	return fd2num(fd);
  801809:	83 ec 0c             	sub    $0xc,%esp
  80180c:	ff 75 f4             	pushl  -0xc(%ebp)
  80180f:	e8 12 f8 ff ff       	call   801026 <fd2num>
  801814:	89 c3                	mov    %eax,%ebx
  801816:	83 c4 10             	add    $0x10,%esp
}
  801819:	89 d8                	mov    %ebx,%eax
  80181b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80181e:	5b                   	pop    %ebx
  80181f:	5e                   	pop    %esi
  801820:	5d                   	pop    %ebp
  801821:	c3                   	ret    
		fd_close(fd, 0);
  801822:	83 ec 08             	sub    $0x8,%esp
  801825:	6a 00                	push   $0x0
  801827:	ff 75 f4             	pushl  -0xc(%ebp)
  80182a:	e8 1b f9 ff ff       	call   80114a <fd_close>
		return r;
  80182f:	83 c4 10             	add    $0x10,%esp
  801832:	eb e5                	jmp    801819 <open+0x6c>
		return -E_BAD_PATH;
  801834:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801839:	eb de                	jmp    801819 <open+0x6c>

0080183b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801841:	ba 00 00 00 00       	mov    $0x0,%edx
  801846:	b8 08 00 00 00       	mov    $0x8,%eax
  80184b:	e8 68 fd ff ff       	call   8015b8 <fsipc>
}
  801850:	c9                   	leave  
  801851:	c3                   	ret    

00801852 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801852:	55                   	push   %ebp
  801853:	89 e5                	mov    %esp,%ebp
  801855:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801858:	68 57 2a 80 00       	push   $0x802a57
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	e8 da f0 ff ff       	call   80093f <strcpy>
	return 0;
}
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    

0080186c <devsock_close>:
{
  80186c:	55                   	push   %ebp
  80186d:	89 e5                	mov    %esp,%ebp
  80186f:	53                   	push   %ebx
  801870:	83 ec 10             	sub    $0x10,%esp
  801873:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801876:	53                   	push   %ebx
  801877:	e8 5d 0a 00 00       	call   8022d9 <pageref>
  80187c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80187f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801884:	83 f8 01             	cmp    $0x1,%eax
  801887:	74 07                	je     801890 <devsock_close+0x24>
}
  801889:	89 d0                	mov    %edx,%eax
  80188b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80188e:	c9                   	leave  
  80188f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801890:	83 ec 0c             	sub    $0xc,%esp
  801893:	ff 73 0c             	pushl  0xc(%ebx)
  801896:	e8 b9 02 00 00       	call   801b54 <nsipc_close>
  80189b:	89 c2                	mov    %eax,%edx
  80189d:	83 c4 10             	add    $0x10,%esp
  8018a0:	eb e7                	jmp    801889 <devsock_close+0x1d>

008018a2 <devsock_write>:
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
  8018a5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	ff 75 10             	pushl  0x10(%ebp)
  8018ad:	ff 75 0c             	pushl  0xc(%ebp)
  8018b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b3:	ff 70 0c             	pushl  0xc(%eax)
  8018b6:	e8 76 03 00 00       	call   801c31 <nsipc_send>
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <devsock_read>:
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	ff 75 10             	pushl  0x10(%ebp)
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	ff 70 0c             	pushl  0xc(%eax)
  8018d1:	e8 ef 02 00 00       	call   801bc5 <nsipc_recv>
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <fd2sockid>:
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018de:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018e1:	52                   	push   %edx
  8018e2:	50                   	push   %eax
  8018e3:	e8 b7 f7 ff ff       	call   80109f <fd_lookup>
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	78 10                	js     8018ff <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f2:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018f8:	39 08                	cmp    %ecx,(%eax)
  8018fa:	75 05                	jne    801901 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018fc:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    
		return -E_NOT_SUPP;
  801901:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801906:	eb f7                	jmp    8018ff <fd2sockid+0x27>

00801908 <alloc_sockfd>:
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	56                   	push   %esi
  80190c:	53                   	push   %ebx
  80190d:	83 ec 1c             	sub    $0x1c,%esp
  801910:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801912:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801915:	50                   	push   %eax
  801916:	e8 32 f7 ff ff       	call   80104d <fd_alloc>
  80191b:	89 c3                	mov    %eax,%ebx
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	78 43                	js     801967 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801924:	83 ec 04             	sub    $0x4,%esp
  801927:	68 07 04 00 00       	push   $0x407
  80192c:	ff 75 f4             	pushl  -0xc(%ebp)
  80192f:	6a 00                	push   $0x0
  801931:	e8 fb f3 ff ff       	call   800d31 <sys_page_alloc>
  801936:	89 c3                	mov    %eax,%ebx
  801938:	83 c4 10             	add    $0x10,%esp
  80193b:	85 c0                	test   %eax,%eax
  80193d:	78 28                	js     801967 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801942:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801948:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80194a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801954:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801957:	83 ec 0c             	sub    $0xc,%esp
  80195a:	50                   	push   %eax
  80195b:	e8 c6 f6 ff ff       	call   801026 <fd2num>
  801960:	89 c3                	mov    %eax,%ebx
  801962:	83 c4 10             	add    $0x10,%esp
  801965:	eb 0c                	jmp    801973 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801967:	83 ec 0c             	sub    $0xc,%esp
  80196a:	56                   	push   %esi
  80196b:	e8 e4 01 00 00       	call   801b54 <nsipc_close>
		return r;
  801970:	83 c4 10             	add    $0x10,%esp
}
  801973:	89 d8                	mov    %ebx,%eax
  801975:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801978:	5b                   	pop    %ebx
  801979:	5e                   	pop    %esi
  80197a:	5d                   	pop    %ebp
  80197b:	c3                   	ret    

0080197c <accept>:
{
  80197c:	55                   	push   %ebp
  80197d:	89 e5                	mov    %esp,%ebp
  80197f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801982:	8b 45 08             	mov    0x8(%ebp),%eax
  801985:	e8 4e ff ff ff       	call   8018d8 <fd2sockid>
  80198a:	85 c0                	test   %eax,%eax
  80198c:	78 1b                	js     8019a9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80198e:	83 ec 04             	sub    $0x4,%esp
  801991:	ff 75 10             	pushl  0x10(%ebp)
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	50                   	push   %eax
  801998:	e8 0e 01 00 00       	call   801aab <nsipc_accept>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	78 05                	js     8019a9 <accept+0x2d>
	return alloc_sockfd(r);
  8019a4:	e8 5f ff ff ff       	call   801908 <alloc_sockfd>
}
  8019a9:	c9                   	leave  
  8019aa:	c3                   	ret    

008019ab <bind>:
{
  8019ab:	55                   	push   %ebp
  8019ac:	89 e5                	mov    %esp,%ebp
  8019ae:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	e8 1f ff ff ff       	call   8018d8 <fd2sockid>
  8019b9:	85 c0                	test   %eax,%eax
  8019bb:	78 12                	js     8019cf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019bd:	83 ec 04             	sub    $0x4,%esp
  8019c0:	ff 75 10             	pushl  0x10(%ebp)
  8019c3:	ff 75 0c             	pushl  0xc(%ebp)
  8019c6:	50                   	push   %eax
  8019c7:	e8 31 01 00 00       	call   801afd <nsipc_bind>
  8019cc:	83 c4 10             	add    $0x10,%esp
}
  8019cf:	c9                   	leave  
  8019d0:	c3                   	ret    

008019d1 <shutdown>:
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019da:	e8 f9 fe ff ff       	call   8018d8 <fd2sockid>
  8019df:	85 c0                	test   %eax,%eax
  8019e1:	78 0f                	js     8019f2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019e3:	83 ec 08             	sub    $0x8,%esp
  8019e6:	ff 75 0c             	pushl  0xc(%ebp)
  8019e9:	50                   	push   %eax
  8019ea:	e8 43 01 00 00       	call   801b32 <nsipc_shutdown>
  8019ef:	83 c4 10             	add    $0x10,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <connect>:
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
  8019f7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	e8 d6 fe ff ff       	call   8018d8 <fd2sockid>
  801a02:	85 c0                	test   %eax,%eax
  801a04:	78 12                	js     801a18 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	ff 75 10             	pushl  0x10(%ebp)
  801a0c:	ff 75 0c             	pushl  0xc(%ebp)
  801a0f:	50                   	push   %eax
  801a10:	e8 59 01 00 00       	call   801b6e <nsipc_connect>
  801a15:	83 c4 10             	add    $0x10,%esp
}
  801a18:	c9                   	leave  
  801a19:	c3                   	ret    

00801a1a <listen>:
{
  801a1a:	55                   	push   %ebp
  801a1b:	89 e5                	mov    %esp,%ebp
  801a1d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a20:	8b 45 08             	mov    0x8(%ebp),%eax
  801a23:	e8 b0 fe ff ff       	call   8018d8 <fd2sockid>
  801a28:	85 c0                	test   %eax,%eax
  801a2a:	78 0f                	js     801a3b <listen+0x21>
	return nsipc_listen(r, backlog);
  801a2c:	83 ec 08             	sub    $0x8,%esp
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	50                   	push   %eax
  801a33:	e8 6b 01 00 00       	call   801ba3 <nsipc_listen>
  801a38:	83 c4 10             	add    $0x10,%esp
}
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <socket>:

int
socket(int domain, int type, int protocol)
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a43:	ff 75 10             	pushl  0x10(%ebp)
  801a46:	ff 75 0c             	pushl  0xc(%ebp)
  801a49:	ff 75 08             	pushl  0x8(%ebp)
  801a4c:	e8 3e 02 00 00       	call   801c8f <nsipc_socket>
  801a51:	83 c4 10             	add    $0x10,%esp
  801a54:	85 c0                	test   %eax,%eax
  801a56:	78 05                	js     801a5d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a58:	e8 ab fe ff ff       	call   801908 <alloc_sockfd>
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	53                   	push   %ebx
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a68:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a6f:	74 26                	je     801a97 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a71:	6a 07                	push   $0x7
  801a73:	68 00 60 80 00       	push   $0x806000
  801a78:	53                   	push   %ebx
  801a79:	ff 35 04 40 80 00    	pushl  0x804004
  801a7f:	e8 c2 07 00 00       	call   802246 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a84:	83 c4 0c             	add    $0xc,%esp
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	e8 4b 07 00 00       	call   8021dd <ipc_recv>
}
  801a92:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a97:	83 ec 0c             	sub    $0xc,%esp
  801a9a:	6a 02                	push   $0x2
  801a9c:	e8 fd 07 00 00       	call   80229e <ipc_find_env>
  801aa1:	a3 04 40 80 00       	mov    %eax,0x804004
  801aa6:	83 c4 10             	add    $0x10,%esp
  801aa9:	eb c6                	jmp    801a71 <nsipc+0x12>

00801aab <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801aab:	55                   	push   %ebp
  801aac:	89 e5                	mov    %esp,%ebp
  801aae:	56                   	push   %esi
  801aaf:	53                   	push   %ebx
  801ab0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801abb:	8b 06                	mov    (%esi),%eax
  801abd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ac2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac7:	e8 93 ff ff ff       	call   801a5f <nsipc>
  801acc:	89 c3                	mov    %eax,%ebx
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	79 09                	jns    801adb <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ad2:	89 d8                	mov    %ebx,%eax
  801ad4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad7:	5b                   	pop    %ebx
  801ad8:	5e                   	pop    %esi
  801ad9:	5d                   	pop    %ebp
  801ada:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801adb:	83 ec 04             	sub    $0x4,%esp
  801ade:	ff 35 10 60 80 00    	pushl  0x806010
  801ae4:	68 00 60 80 00       	push   $0x806000
  801ae9:	ff 75 0c             	pushl  0xc(%ebp)
  801aec:	e8 dc ef ff ff       	call   800acd <memmove>
		*addrlen = ret->ret_addrlen;
  801af1:	a1 10 60 80 00       	mov    0x806010,%eax
  801af6:	89 06                	mov    %eax,(%esi)
  801af8:	83 c4 10             	add    $0x10,%esp
	return r;
  801afb:	eb d5                	jmp    801ad2 <nsipc_accept+0x27>

00801afd <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801afd:	55                   	push   %ebp
  801afe:	89 e5                	mov    %esp,%ebp
  801b00:	53                   	push   %ebx
  801b01:	83 ec 08             	sub    $0x8,%esp
  801b04:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b07:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b0f:	53                   	push   %ebx
  801b10:	ff 75 0c             	pushl  0xc(%ebp)
  801b13:	68 04 60 80 00       	push   $0x806004
  801b18:	e8 b0 ef ff ff       	call   800acd <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b1d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b23:	b8 02 00 00 00       	mov    $0x2,%eax
  801b28:	e8 32 ff ff ff       	call   801a5f <nsipc>
}
  801b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b43:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b48:	b8 03 00 00 00       	mov    $0x3,%eax
  801b4d:	e8 0d ff ff ff       	call   801a5f <nsipc>
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <nsipc_close>:

int
nsipc_close(int s)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b62:	b8 04 00 00 00       	mov    $0x4,%eax
  801b67:	e8 f3 fe ff ff       	call   801a5f <nsipc>
}
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	53                   	push   %ebx
  801b72:	83 ec 08             	sub    $0x8,%esp
  801b75:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b78:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b80:	53                   	push   %ebx
  801b81:	ff 75 0c             	pushl  0xc(%ebp)
  801b84:	68 04 60 80 00       	push   $0x806004
  801b89:	e8 3f ef ff ff       	call   800acd <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b8e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b94:	b8 05 00 00 00       	mov    $0x5,%eax
  801b99:	e8 c1 fe ff ff       	call   801a5f <nsipc>
}
  801b9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bb9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bbe:	e8 9c fe ff ff       	call   801a5f <nsipc>
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	56                   	push   %esi
  801bc9:	53                   	push   %ebx
  801bca:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bd5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bdb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bde:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801be3:	b8 07 00 00 00       	mov    $0x7,%eax
  801be8:	e8 72 fe ff ff       	call   801a5f <nsipc>
  801bed:	89 c3                	mov    %eax,%ebx
  801bef:	85 c0                	test   %eax,%eax
  801bf1:	78 1f                	js     801c12 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bf3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bf8:	7f 21                	jg     801c1b <nsipc_recv+0x56>
  801bfa:	39 c6                	cmp    %eax,%esi
  801bfc:	7c 1d                	jl     801c1b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	50                   	push   %eax
  801c02:	68 00 60 80 00       	push   $0x806000
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	e8 be ee ff ff       	call   800acd <memmove>
  801c0f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c12:	89 d8                	mov    %ebx,%eax
  801c14:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c17:	5b                   	pop    %ebx
  801c18:	5e                   	pop    %esi
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c1b:	68 63 2a 80 00       	push   $0x802a63
  801c20:	68 2b 2a 80 00       	push   $0x802a2b
  801c25:	6a 62                	push   $0x62
  801c27:	68 78 2a 80 00       	push   $0x802a78
  801c2c:	e8 4b 05 00 00       	call   80217c <_panic>

00801c31 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	53                   	push   %ebx
  801c35:	83 ec 04             	sub    $0x4,%esp
  801c38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c43:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c49:	7f 2e                	jg     801c79 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	53                   	push   %ebx
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	68 0c 60 80 00       	push   $0x80600c
  801c57:	e8 71 ee ff ff       	call   800acd <memmove>
	nsipcbuf.send.req_size = size;
  801c5c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c62:	8b 45 14             	mov    0x14(%ebp),%eax
  801c65:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c6a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c6f:	e8 eb fd ff ff       	call   801a5f <nsipc>
}
  801c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    
	assert(size < 1600);
  801c79:	68 84 2a 80 00       	push   $0x802a84
  801c7e:	68 2b 2a 80 00       	push   $0x802a2b
  801c83:	6a 6d                	push   $0x6d
  801c85:	68 78 2a 80 00       	push   $0x802a78
  801c8a:	e8 ed 04 00 00       	call   80217c <_panic>

00801c8f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cad:	b8 09 00 00 00       	mov    $0x9,%eax
  801cb2:	e8 a8 fd ff ff       	call   801a5f <nsipc>
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cc1:	83 ec 0c             	sub    $0xc,%esp
  801cc4:	ff 75 08             	pushl  0x8(%ebp)
  801cc7:	e8 6a f3 ff ff       	call   801036 <fd2data>
  801ccc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cce:	83 c4 08             	add    $0x8,%esp
  801cd1:	68 90 2a 80 00       	push   $0x802a90
  801cd6:	53                   	push   %ebx
  801cd7:	e8 63 ec ff ff       	call   80093f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cdc:	8b 46 04             	mov    0x4(%esi),%eax
  801cdf:	2b 06                	sub    (%esi),%eax
  801ce1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801ce7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cee:	00 00 00 
	stat->st_dev = &devpipe;
  801cf1:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cf8:	30 80 00 
	return 0;
}
  801cfb:	b8 00 00 00 00       	mov    $0x0,%eax
  801d00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d03:	5b                   	pop    %ebx
  801d04:	5e                   	pop    %esi
  801d05:	5d                   	pop    %ebp
  801d06:	c3                   	ret    

00801d07 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
  801d0a:	53                   	push   %ebx
  801d0b:	83 ec 0c             	sub    $0xc,%esp
  801d0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d11:	53                   	push   %ebx
  801d12:	6a 00                	push   $0x0
  801d14:	e8 9d f0 ff ff       	call   800db6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d19:	89 1c 24             	mov    %ebx,(%esp)
  801d1c:	e8 15 f3 ff ff       	call   801036 <fd2data>
  801d21:	83 c4 08             	add    $0x8,%esp
  801d24:	50                   	push   %eax
  801d25:	6a 00                	push   $0x0
  801d27:	e8 8a f0 ff ff       	call   800db6 <sys_page_unmap>
}
  801d2c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <_pipeisclosed>:
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
  801d34:	57                   	push   %edi
  801d35:	56                   	push   %esi
  801d36:	53                   	push   %ebx
  801d37:	83 ec 1c             	sub    $0x1c,%esp
  801d3a:	89 c7                	mov    %eax,%edi
  801d3c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d3e:	a1 08 40 80 00       	mov    0x804008,%eax
  801d43:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d46:	83 ec 0c             	sub    $0xc,%esp
  801d49:	57                   	push   %edi
  801d4a:	e8 8a 05 00 00       	call   8022d9 <pageref>
  801d4f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d52:	89 34 24             	mov    %esi,(%esp)
  801d55:	e8 7f 05 00 00       	call   8022d9 <pageref>
		nn = thisenv->env_runs;
  801d5a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d60:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d63:	83 c4 10             	add    $0x10,%esp
  801d66:	39 cb                	cmp    %ecx,%ebx
  801d68:	74 1b                	je     801d85 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d6a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d6d:	75 cf                	jne    801d3e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d6f:	8b 42 58             	mov    0x58(%edx),%eax
  801d72:	6a 01                	push   $0x1
  801d74:	50                   	push   %eax
  801d75:	53                   	push   %ebx
  801d76:	68 97 2a 80 00       	push   $0x802a97
  801d7b:	e8 60 e4 ff ff       	call   8001e0 <cprintf>
  801d80:	83 c4 10             	add    $0x10,%esp
  801d83:	eb b9                	jmp    801d3e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d85:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d88:	0f 94 c0             	sete   %al
  801d8b:	0f b6 c0             	movzbl %al,%eax
}
  801d8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5f                   	pop    %edi
  801d94:	5d                   	pop    %ebp
  801d95:	c3                   	ret    

00801d96 <devpipe_write>:
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	57                   	push   %edi
  801d9a:	56                   	push   %esi
  801d9b:	53                   	push   %ebx
  801d9c:	83 ec 28             	sub    $0x28,%esp
  801d9f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801da2:	56                   	push   %esi
  801da3:	e8 8e f2 ff ff       	call   801036 <fd2data>
  801da8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801daa:	83 c4 10             	add    $0x10,%esp
  801dad:	bf 00 00 00 00       	mov    $0x0,%edi
  801db2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801db5:	74 4f                	je     801e06 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801db7:	8b 43 04             	mov    0x4(%ebx),%eax
  801dba:	8b 0b                	mov    (%ebx),%ecx
  801dbc:	8d 51 20             	lea    0x20(%ecx),%edx
  801dbf:	39 d0                	cmp    %edx,%eax
  801dc1:	72 14                	jb     801dd7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dc3:	89 da                	mov    %ebx,%edx
  801dc5:	89 f0                	mov    %esi,%eax
  801dc7:	e8 65 ff ff ff       	call   801d31 <_pipeisclosed>
  801dcc:	85 c0                	test   %eax,%eax
  801dce:	75 3b                	jne    801e0b <devpipe_write+0x75>
			sys_yield();
  801dd0:	e8 3d ef ff ff       	call   800d12 <sys_yield>
  801dd5:	eb e0                	jmp    801db7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dda:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dde:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801de1:	89 c2                	mov    %eax,%edx
  801de3:	c1 fa 1f             	sar    $0x1f,%edx
  801de6:	89 d1                	mov    %edx,%ecx
  801de8:	c1 e9 1b             	shr    $0x1b,%ecx
  801deb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dee:	83 e2 1f             	and    $0x1f,%edx
  801df1:	29 ca                	sub    %ecx,%edx
  801df3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801df7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dfb:	83 c0 01             	add    $0x1,%eax
  801dfe:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e01:	83 c7 01             	add    $0x1,%edi
  801e04:	eb ac                	jmp    801db2 <devpipe_write+0x1c>
	return i;
  801e06:	8b 45 10             	mov    0x10(%ebp),%eax
  801e09:	eb 05                	jmp    801e10 <devpipe_write+0x7a>
				return 0;
  801e0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e13:	5b                   	pop    %ebx
  801e14:	5e                   	pop    %esi
  801e15:	5f                   	pop    %edi
  801e16:	5d                   	pop    %ebp
  801e17:	c3                   	ret    

00801e18 <devpipe_read>:
{
  801e18:	55                   	push   %ebp
  801e19:	89 e5                	mov    %esp,%ebp
  801e1b:	57                   	push   %edi
  801e1c:	56                   	push   %esi
  801e1d:	53                   	push   %ebx
  801e1e:	83 ec 18             	sub    $0x18,%esp
  801e21:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e24:	57                   	push   %edi
  801e25:	e8 0c f2 ff ff       	call   801036 <fd2data>
  801e2a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e2c:	83 c4 10             	add    $0x10,%esp
  801e2f:	be 00 00 00 00       	mov    $0x0,%esi
  801e34:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e37:	75 14                	jne    801e4d <devpipe_read+0x35>
	return i;
  801e39:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3c:	eb 02                	jmp    801e40 <devpipe_read+0x28>
				return i;
  801e3e:	89 f0                	mov    %esi,%eax
}
  801e40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e43:	5b                   	pop    %ebx
  801e44:	5e                   	pop    %esi
  801e45:	5f                   	pop    %edi
  801e46:	5d                   	pop    %ebp
  801e47:	c3                   	ret    
			sys_yield();
  801e48:	e8 c5 ee ff ff       	call   800d12 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e4d:	8b 03                	mov    (%ebx),%eax
  801e4f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e52:	75 18                	jne    801e6c <devpipe_read+0x54>
			if (i > 0)
  801e54:	85 f6                	test   %esi,%esi
  801e56:	75 e6                	jne    801e3e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e58:	89 da                	mov    %ebx,%edx
  801e5a:	89 f8                	mov    %edi,%eax
  801e5c:	e8 d0 fe ff ff       	call   801d31 <_pipeisclosed>
  801e61:	85 c0                	test   %eax,%eax
  801e63:	74 e3                	je     801e48 <devpipe_read+0x30>
				return 0;
  801e65:	b8 00 00 00 00       	mov    $0x0,%eax
  801e6a:	eb d4                	jmp    801e40 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e6c:	99                   	cltd   
  801e6d:	c1 ea 1b             	shr    $0x1b,%edx
  801e70:	01 d0                	add    %edx,%eax
  801e72:	83 e0 1f             	and    $0x1f,%eax
  801e75:	29 d0                	sub    %edx,%eax
  801e77:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e7f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e82:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e85:	83 c6 01             	add    $0x1,%esi
  801e88:	eb aa                	jmp    801e34 <devpipe_read+0x1c>

00801e8a <pipe>:
{
  801e8a:	55                   	push   %ebp
  801e8b:	89 e5                	mov    %esp,%ebp
  801e8d:	56                   	push   %esi
  801e8e:	53                   	push   %ebx
  801e8f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e92:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e95:	50                   	push   %eax
  801e96:	e8 b2 f1 ff ff       	call   80104d <fd_alloc>
  801e9b:	89 c3                	mov    %eax,%ebx
  801e9d:	83 c4 10             	add    $0x10,%esp
  801ea0:	85 c0                	test   %eax,%eax
  801ea2:	0f 88 23 01 00 00    	js     801fcb <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea8:	83 ec 04             	sub    $0x4,%esp
  801eab:	68 07 04 00 00       	push   $0x407
  801eb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801eb3:	6a 00                	push   $0x0
  801eb5:	e8 77 ee ff ff       	call   800d31 <sys_page_alloc>
  801eba:	89 c3                	mov    %eax,%ebx
  801ebc:	83 c4 10             	add    $0x10,%esp
  801ebf:	85 c0                	test   %eax,%eax
  801ec1:	0f 88 04 01 00 00    	js     801fcb <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ec7:	83 ec 0c             	sub    $0xc,%esp
  801eca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ecd:	50                   	push   %eax
  801ece:	e8 7a f1 ff ff       	call   80104d <fd_alloc>
  801ed3:	89 c3                	mov    %eax,%ebx
  801ed5:	83 c4 10             	add    $0x10,%esp
  801ed8:	85 c0                	test   %eax,%eax
  801eda:	0f 88 db 00 00 00    	js     801fbb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	68 07 04 00 00       	push   $0x407
  801ee8:	ff 75 f0             	pushl  -0x10(%ebp)
  801eeb:	6a 00                	push   $0x0
  801eed:	e8 3f ee ff ff       	call   800d31 <sys_page_alloc>
  801ef2:	89 c3                	mov    %eax,%ebx
  801ef4:	83 c4 10             	add    $0x10,%esp
  801ef7:	85 c0                	test   %eax,%eax
  801ef9:	0f 88 bc 00 00 00    	js     801fbb <pipe+0x131>
	va = fd2data(fd0);
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	ff 75 f4             	pushl  -0xc(%ebp)
  801f05:	e8 2c f1 ff ff       	call   801036 <fd2data>
  801f0a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f0c:	83 c4 0c             	add    $0xc,%esp
  801f0f:	68 07 04 00 00       	push   $0x407
  801f14:	50                   	push   %eax
  801f15:	6a 00                	push   $0x0
  801f17:	e8 15 ee ff ff       	call   800d31 <sys_page_alloc>
  801f1c:	89 c3                	mov    %eax,%ebx
  801f1e:	83 c4 10             	add    $0x10,%esp
  801f21:	85 c0                	test   %eax,%eax
  801f23:	0f 88 82 00 00 00    	js     801fab <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f29:	83 ec 0c             	sub    $0xc,%esp
  801f2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f2f:	e8 02 f1 ff ff       	call   801036 <fd2data>
  801f34:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f3b:	50                   	push   %eax
  801f3c:	6a 00                	push   $0x0
  801f3e:	56                   	push   %esi
  801f3f:	6a 00                	push   $0x0
  801f41:	e8 2e ee ff ff       	call   800d74 <sys_page_map>
  801f46:	89 c3                	mov    %eax,%ebx
  801f48:	83 c4 20             	add    $0x20,%esp
  801f4b:	85 c0                	test   %eax,%eax
  801f4d:	78 4e                	js     801f9d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f4f:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f54:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f57:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f59:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f5c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f63:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f66:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f68:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f72:	83 ec 0c             	sub    $0xc,%esp
  801f75:	ff 75 f4             	pushl  -0xc(%ebp)
  801f78:	e8 a9 f0 ff ff       	call   801026 <fd2num>
  801f7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f80:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f82:	83 c4 04             	add    $0x4,%esp
  801f85:	ff 75 f0             	pushl  -0x10(%ebp)
  801f88:	e8 99 f0 ff ff       	call   801026 <fd2num>
  801f8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f90:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f93:	83 c4 10             	add    $0x10,%esp
  801f96:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f9b:	eb 2e                	jmp    801fcb <pipe+0x141>
	sys_page_unmap(0, va);
  801f9d:	83 ec 08             	sub    $0x8,%esp
  801fa0:	56                   	push   %esi
  801fa1:	6a 00                	push   $0x0
  801fa3:	e8 0e ee ff ff       	call   800db6 <sys_page_unmap>
  801fa8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fab:	83 ec 08             	sub    $0x8,%esp
  801fae:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb1:	6a 00                	push   $0x0
  801fb3:	e8 fe ed ff ff       	call   800db6 <sys_page_unmap>
  801fb8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fbb:	83 ec 08             	sub    $0x8,%esp
  801fbe:	ff 75 f4             	pushl  -0xc(%ebp)
  801fc1:	6a 00                	push   $0x0
  801fc3:	e8 ee ed ff ff       	call   800db6 <sys_page_unmap>
  801fc8:	83 c4 10             	add    $0x10,%esp
}
  801fcb:	89 d8                	mov    %ebx,%eax
  801fcd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd0:	5b                   	pop    %ebx
  801fd1:	5e                   	pop    %esi
  801fd2:	5d                   	pop    %ebp
  801fd3:	c3                   	ret    

00801fd4 <pipeisclosed>:
{
  801fd4:	55                   	push   %ebp
  801fd5:	89 e5                	mov    %esp,%ebp
  801fd7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdd:	50                   	push   %eax
  801fde:	ff 75 08             	pushl  0x8(%ebp)
  801fe1:	e8 b9 f0 ff ff       	call   80109f <fd_lookup>
  801fe6:	83 c4 10             	add    $0x10,%esp
  801fe9:	85 c0                	test   %eax,%eax
  801feb:	78 18                	js     802005 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff3:	e8 3e f0 ff ff       	call   801036 <fd2data>
	return _pipeisclosed(fd, p);
  801ff8:	89 c2                	mov    %eax,%edx
  801ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffd:	e8 2f fd ff ff       	call   801d31 <_pipeisclosed>
  802002:	83 c4 10             	add    $0x10,%esp
}
  802005:	c9                   	leave  
  802006:	c3                   	ret    

00802007 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802007:	b8 00 00 00 00       	mov    $0x0,%eax
  80200c:	c3                   	ret    

0080200d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80200d:	55                   	push   %ebp
  80200e:	89 e5                	mov    %esp,%ebp
  802010:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802013:	68 af 2a 80 00       	push   $0x802aaf
  802018:	ff 75 0c             	pushl  0xc(%ebp)
  80201b:	e8 1f e9 ff ff       	call   80093f <strcpy>
	return 0;
}
  802020:	b8 00 00 00 00       	mov    $0x0,%eax
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <devcons_write>:
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	57                   	push   %edi
  80202b:	56                   	push   %esi
  80202c:	53                   	push   %ebx
  80202d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802033:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802038:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80203e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802041:	73 31                	jae    802074 <devcons_write+0x4d>
		m = n - tot;
  802043:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802046:	29 f3                	sub    %esi,%ebx
  802048:	83 fb 7f             	cmp    $0x7f,%ebx
  80204b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802050:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802053:	83 ec 04             	sub    $0x4,%esp
  802056:	53                   	push   %ebx
  802057:	89 f0                	mov    %esi,%eax
  802059:	03 45 0c             	add    0xc(%ebp),%eax
  80205c:	50                   	push   %eax
  80205d:	57                   	push   %edi
  80205e:	e8 6a ea ff ff       	call   800acd <memmove>
		sys_cputs(buf, m);
  802063:	83 c4 08             	add    $0x8,%esp
  802066:	53                   	push   %ebx
  802067:	57                   	push   %edi
  802068:	e8 08 ec ff ff       	call   800c75 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80206d:	01 de                	add    %ebx,%esi
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	eb ca                	jmp    80203e <devcons_write+0x17>
}
  802074:	89 f0                	mov    %esi,%eax
  802076:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802079:	5b                   	pop    %ebx
  80207a:	5e                   	pop    %esi
  80207b:	5f                   	pop    %edi
  80207c:	5d                   	pop    %ebp
  80207d:	c3                   	ret    

0080207e <devcons_read>:
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
  802081:	83 ec 08             	sub    $0x8,%esp
  802084:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802089:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80208d:	74 21                	je     8020b0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80208f:	e8 ff eb ff ff       	call   800c93 <sys_cgetc>
  802094:	85 c0                	test   %eax,%eax
  802096:	75 07                	jne    80209f <devcons_read+0x21>
		sys_yield();
  802098:	e8 75 ec ff ff       	call   800d12 <sys_yield>
  80209d:	eb f0                	jmp    80208f <devcons_read+0x11>
	if (c < 0)
  80209f:	78 0f                	js     8020b0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020a1:	83 f8 04             	cmp    $0x4,%eax
  8020a4:	74 0c                	je     8020b2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a9:	88 02                	mov    %al,(%edx)
	return 1;
  8020ab:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    
		return 0;
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b7:	eb f7                	jmp    8020b0 <devcons_read+0x32>

008020b9 <cputchar>:
{
  8020b9:	55                   	push   %ebp
  8020ba:	89 e5                	mov    %esp,%ebp
  8020bc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020c5:	6a 01                	push   $0x1
  8020c7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ca:	50                   	push   %eax
  8020cb:	e8 a5 eb ff ff       	call   800c75 <sys_cputs>
}
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	c9                   	leave  
  8020d4:	c3                   	ret    

008020d5 <getchar>:
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020db:	6a 01                	push   $0x1
  8020dd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e0:	50                   	push   %eax
  8020e1:	6a 00                	push   $0x0
  8020e3:	e8 27 f2 ff ff       	call   80130f <read>
	if (r < 0)
  8020e8:	83 c4 10             	add    $0x10,%esp
  8020eb:	85 c0                	test   %eax,%eax
  8020ed:	78 06                	js     8020f5 <getchar+0x20>
	if (r < 1)
  8020ef:	74 06                	je     8020f7 <getchar+0x22>
	return c;
  8020f1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    
		return -E_EOF;
  8020f7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020fc:	eb f7                	jmp    8020f5 <getchar+0x20>

008020fe <iscons>:
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802104:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802107:	50                   	push   %eax
  802108:	ff 75 08             	pushl  0x8(%ebp)
  80210b:	e8 8f ef ff ff       	call   80109f <fd_lookup>
  802110:	83 c4 10             	add    $0x10,%esp
  802113:	85 c0                	test   %eax,%eax
  802115:	78 11                	js     802128 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802117:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802120:	39 10                	cmp    %edx,(%eax)
  802122:	0f 94 c0             	sete   %al
  802125:	0f b6 c0             	movzbl %al,%eax
}
  802128:	c9                   	leave  
  802129:	c3                   	ret    

0080212a <opencons>:
{
  80212a:	55                   	push   %ebp
  80212b:	89 e5                	mov    %esp,%ebp
  80212d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802130:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802133:	50                   	push   %eax
  802134:	e8 14 ef ff ff       	call   80104d <fd_alloc>
  802139:	83 c4 10             	add    $0x10,%esp
  80213c:	85 c0                	test   %eax,%eax
  80213e:	78 3a                	js     80217a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802140:	83 ec 04             	sub    $0x4,%esp
  802143:	68 07 04 00 00       	push   $0x407
  802148:	ff 75 f4             	pushl  -0xc(%ebp)
  80214b:	6a 00                	push   $0x0
  80214d:	e8 df eb ff ff       	call   800d31 <sys_page_alloc>
  802152:	83 c4 10             	add    $0x10,%esp
  802155:	85 c0                	test   %eax,%eax
  802157:	78 21                	js     80217a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802162:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802164:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802167:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80216e:	83 ec 0c             	sub    $0xc,%esp
  802171:	50                   	push   %eax
  802172:	e8 af ee ff ff       	call   801026 <fd2num>
  802177:	83 c4 10             	add    $0x10,%esp
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	56                   	push   %esi
  802180:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802181:	a1 08 40 80 00       	mov    0x804008,%eax
  802186:	8b 40 48             	mov    0x48(%eax),%eax
  802189:	83 ec 04             	sub    $0x4,%esp
  80218c:	68 e0 2a 80 00       	push   $0x802ae0
  802191:	50                   	push   %eax
  802192:	68 d8 25 80 00       	push   $0x8025d8
  802197:	e8 44 e0 ff ff       	call   8001e0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80219c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80219f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021a5:	e8 49 eb ff ff       	call   800cf3 <sys_getenvid>
  8021aa:	83 c4 04             	add    $0x4,%esp
  8021ad:	ff 75 0c             	pushl  0xc(%ebp)
  8021b0:	ff 75 08             	pushl  0x8(%ebp)
  8021b3:	56                   	push   %esi
  8021b4:	50                   	push   %eax
  8021b5:	68 bc 2a 80 00       	push   $0x802abc
  8021ba:	e8 21 e0 ff ff       	call   8001e0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021bf:	83 c4 18             	add    $0x18,%esp
  8021c2:	53                   	push   %ebx
  8021c3:	ff 75 10             	pushl  0x10(%ebp)
  8021c6:	e8 c4 df ff ff       	call   80018f <vcprintf>
	cprintf("\n");
  8021cb:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021d2:	e8 09 e0 ff ff       	call   8001e0 <cprintf>
  8021d7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021da:	cc                   	int3   
  8021db:	eb fd                	jmp    8021da <_panic+0x5e>

008021dd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	56                   	push   %esi
  8021e1:	53                   	push   %ebx
  8021e2:	8b 75 08             	mov    0x8(%ebp),%esi
  8021e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021eb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021ed:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021f2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021f5:	83 ec 0c             	sub    $0xc,%esp
  8021f8:	50                   	push   %eax
  8021f9:	e8 e3 ec ff ff       	call   800ee1 <sys_ipc_recv>
	if(ret < 0){
  8021fe:	83 c4 10             	add    $0x10,%esp
  802201:	85 c0                	test   %eax,%eax
  802203:	78 2b                	js     802230 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802205:	85 f6                	test   %esi,%esi
  802207:	74 0a                	je     802213 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802209:	a1 08 40 80 00       	mov    0x804008,%eax
  80220e:	8b 40 74             	mov    0x74(%eax),%eax
  802211:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802213:	85 db                	test   %ebx,%ebx
  802215:	74 0a                	je     802221 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802217:	a1 08 40 80 00       	mov    0x804008,%eax
  80221c:	8b 40 78             	mov    0x78(%eax),%eax
  80221f:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802221:	a1 08 40 80 00       	mov    0x804008,%eax
  802226:	8b 40 70             	mov    0x70(%eax),%eax
}
  802229:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80222c:	5b                   	pop    %ebx
  80222d:	5e                   	pop    %esi
  80222e:	5d                   	pop    %ebp
  80222f:	c3                   	ret    
		if(from_env_store)
  802230:	85 f6                	test   %esi,%esi
  802232:	74 06                	je     80223a <ipc_recv+0x5d>
			*from_env_store = 0;
  802234:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80223a:	85 db                	test   %ebx,%ebx
  80223c:	74 eb                	je     802229 <ipc_recv+0x4c>
			*perm_store = 0;
  80223e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802244:	eb e3                	jmp    802229 <ipc_recv+0x4c>

00802246 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802246:	55                   	push   %ebp
  802247:	89 e5                	mov    %esp,%ebp
  802249:	57                   	push   %edi
  80224a:	56                   	push   %esi
  80224b:	53                   	push   %ebx
  80224c:	83 ec 0c             	sub    $0xc,%esp
  80224f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802252:	8b 75 0c             	mov    0xc(%ebp),%esi
  802255:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802258:	85 db                	test   %ebx,%ebx
  80225a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80225f:	0f 44 d8             	cmove  %eax,%ebx
  802262:	eb 05                	jmp    802269 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802264:	e8 a9 ea ff ff       	call   800d12 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802269:	ff 75 14             	pushl  0x14(%ebp)
  80226c:	53                   	push   %ebx
  80226d:	56                   	push   %esi
  80226e:	57                   	push   %edi
  80226f:	e8 4a ec ff ff       	call   800ebe <sys_ipc_try_send>
  802274:	83 c4 10             	add    $0x10,%esp
  802277:	85 c0                	test   %eax,%eax
  802279:	74 1b                	je     802296 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80227b:	79 e7                	jns    802264 <ipc_send+0x1e>
  80227d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802280:	74 e2                	je     802264 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802282:	83 ec 04             	sub    $0x4,%esp
  802285:	68 e7 2a 80 00       	push   $0x802ae7
  80228a:	6a 46                	push   $0x46
  80228c:	68 fc 2a 80 00       	push   $0x802afc
  802291:	e8 e6 fe ff ff       	call   80217c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802296:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802299:	5b                   	pop    %ebx
  80229a:	5e                   	pop    %esi
  80229b:	5f                   	pop    %edi
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    

0080229e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022a4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022a9:	89 c2                	mov    %eax,%edx
  8022ab:	c1 e2 07             	shl    $0x7,%edx
  8022ae:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022b4:	8b 52 50             	mov    0x50(%edx),%edx
  8022b7:	39 ca                	cmp    %ecx,%edx
  8022b9:	74 11                	je     8022cc <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022bb:	83 c0 01             	add    $0x1,%eax
  8022be:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022c3:	75 e4                	jne    8022a9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ca:	eb 0b                	jmp    8022d7 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022cc:	c1 e0 07             	shl    $0x7,%eax
  8022cf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022d4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022d7:	5d                   	pop    %ebp
  8022d8:	c3                   	ret    

008022d9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022d9:	55                   	push   %ebp
  8022da:	89 e5                	mov    %esp,%ebp
  8022dc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022df:	89 d0                	mov    %edx,%eax
  8022e1:	c1 e8 16             	shr    $0x16,%eax
  8022e4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022eb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022f0:	f6 c1 01             	test   $0x1,%cl
  8022f3:	74 1d                	je     802312 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022f5:	c1 ea 0c             	shr    $0xc,%edx
  8022f8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022ff:	f6 c2 01             	test   $0x1,%dl
  802302:	74 0e                	je     802312 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802304:	c1 ea 0c             	shr    $0xc,%edx
  802307:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80230e:	ef 
  80230f:	0f b7 c0             	movzwl %ax,%eax
}
  802312:	5d                   	pop    %ebp
  802313:	c3                   	ret    
  802314:	66 90                	xchg   %ax,%ax
  802316:	66 90                	xchg   %ax,%ax
  802318:	66 90                	xchg   %ax,%ax
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
