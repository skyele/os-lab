
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
  80004d:	e8 9d 0c 00 00       	call   800cef <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b6:	8b 40 48             	mov    0x48(%eax),%eax
  8000b9:	83 ec 08             	sub    $0x8,%esp
  8000bc:	50                   	push   %eax
  8000bd:	68 40 25 80 00       	push   $0x802540
  8000c2:	e8 15 01 00 00       	call   8001dc <cprintf>
	cprintf("before umain\n");
  8000c7:	c7 04 24 5e 25 80 00 	movl   $0x80255e,(%esp)
  8000ce:	e8 09 01 00 00       	call   8001dc <cprintf>
	// call user main routine
	umain(argc, argv);
  8000d3:	83 c4 08             	add    $0x8,%esp
  8000d6:	ff 75 0c             	pushl  0xc(%ebp)
  8000d9:	ff 75 08             	pushl  0x8(%ebp)
  8000dc:	e8 52 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000e1:	c7 04 24 6c 25 80 00 	movl   $0x80256c,(%esp)
  8000e8:	e8 ef 00 00 00       	call   8001dc <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000ed:	a1 08 40 80 00       	mov    0x804008,%eax
  8000f2:	8b 40 48             	mov    0x48(%eax),%eax
  8000f5:	83 c4 08             	add    $0x8,%esp
  8000f8:	50                   	push   %eax
  8000f9:	68 79 25 80 00       	push   $0x802579
  8000fe:	e8 d9 00 00 00       	call   8001dc <cprintf>
	// exit gracefully
	exit();
  800103:	e8 0b 00 00 00       	call   800113 <exit>
}
  800108:	83 c4 10             	add    $0x10,%esp
  80010b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010e:	5b                   	pop    %ebx
  80010f:	5e                   	pop    %esi
  800110:	5f                   	pop    %edi
  800111:	5d                   	pop    %ebp
  800112:	c3                   	ret    

00800113 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800113:	55                   	push   %ebp
  800114:	89 e5                	mov    %esp,%ebp
  800116:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800119:	a1 08 40 80 00       	mov    0x804008,%eax
  80011e:	8b 40 48             	mov    0x48(%eax),%eax
  800121:	68 a4 25 80 00       	push   $0x8025a4
  800126:	50                   	push   %eax
  800127:	68 98 25 80 00       	push   $0x802598
  80012c:	e8 ab 00 00 00       	call   8001dc <cprintf>
	close_all();
  800131:	e8 a4 10 00 00       	call   8011da <close_all>
	sys_env_destroy(0);
  800136:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80013d:	e8 6c 0b 00 00       	call   800cae <sys_env_destroy>
}
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	53                   	push   %ebx
  80014b:	83 ec 04             	sub    $0x4,%esp
  80014e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800151:	8b 13                	mov    (%ebx),%edx
  800153:	8d 42 01             	lea    0x1(%edx),%eax
  800156:	89 03                	mov    %eax,(%ebx)
  800158:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80015f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800164:	74 09                	je     80016f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800166:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80016d:	c9                   	leave  
  80016e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	68 ff 00 00 00       	push   $0xff
  800177:	8d 43 08             	lea    0x8(%ebx),%eax
  80017a:	50                   	push   %eax
  80017b:	e8 f1 0a 00 00       	call   800c71 <sys_cputs>
		b->idx = 0;
  800180:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	eb db                	jmp    800166 <putch+0x1f>

0080018b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800194:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019b:	00 00 00 
	b.cnt = 0;
  80019e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a8:	ff 75 0c             	pushl  0xc(%ebp)
  8001ab:	ff 75 08             	pushl  0x8(%ebp)
  8001ae:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 47 01 80 00       	push   $0x800147
  8001ba:	e8 4a 01 00 00       	call   800309 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001bf:	83 c4 08             	add    $0x8,%esp
  8001c2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001ce:	50                   	push   %eax
  8001cf:	e8 9d 0a 00 00       	call   800c71 <sys_cputs>

	return b.cnt;
}
  8001d4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001da:	c9                   	leave  
  8001db:	c3                   	ret    

008001dc <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e5:	50                   	push   %eax
  8001e6:	ff 75 08             	pushl  0x8(%ebp)
  8001e9:	e8 9d ff ff ff       	call   80018b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	57                   	push   %edi
  8001f4:	56                   	push   %esi
  8001f5:	53                   	push   %ebx
  8001f6:	83 ec 1c             	sub    $0x1c,%esp
  8001f9:	89 c6                	mov    %eax,%esi
  8001fb:	89 d7                	mov    %edx,%edi
  8001fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800200:	8b 55 0c             	mov    0xc(%ebp),%edx
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800206:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800209:	8b 45 10             	mov    0x10(%ebp),%eax
  80020c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80020f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800213:	74 2c                	je     800241 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800215:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800218:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80021f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800222:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800225:	39 c2                	cmp    %eax,%edx
  800227:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80022a:	73 43                	jae    80026f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80022c:	83 eb 01             	sub    $0x1,%ebx
  80022f:	85 db                	test   %ebx,%ebx
  800231:	7e 6c                	jle    80029f <printnum+0xaf>
				putch(padc, putdat);
  800233:	83 ec 08             	sub    $0x8,%esp
  800236:	57                   	push   %edi
  800237:	ff 75 18             	pushl  0x18(%ebp)
  80023a:	ff d6                	call   *%esi
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	eb eb                	jmp    80022c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	6a 20                	push   $0x20
  800246:	6a 00                	push   $0x0
  800248:	50                   	push   %eax
  800249:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024c:	ff 75 e0             	pushl  -0x20(%ebp)
  80024f:	89 fa                	mov    %edi,%edx
  800251:	89 f0                	mov    %esi,%eax
  800253:	e8 98 ff ff ff       	call   8001f0 <printnum>
		while (--width > 0)
  800258:	83 c4 20             	add    $0x20,%esp
  80025b:	83 eb 01             	sub    $0x1,%ebx
  80025e:	85 db                	test   %ebx,%ebx
  800260:	7e 65                	jle    8002c7 <printnum+0xd7>
			putch(padc, putdat);
  800262:	83 ec 08             	sub    $0x8,%esp
  800265:	57                   	push   %edi
  800266:	6a 20                	push   $0x20
  800268:	ff d6                	call   *%esi
  80026a:	83 c4 10             	add    $0x10,%esp
  80026d:	eb ec                	jmp    80025b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	ff 75 18             	pushl  0x18(%ebp)
  800275:	83 eb 01             	sub    $0x1,%ebx
  800278:	53                   	push   %ebx
  800279:	50                   	push   %eax
  80027a:	83 ec 08             	sub    $0x8,%esp
  80027d:	ff 75 dc             	pushl  -0x24(%ebp)
  800280:	ff 75 d8             	pushl  -0x28(%ebp)
  800283:	ff 75 e4             	pushl  -0x1c(%ebp)
  800286:	ff 75 e0             	pushl  -0x20(%ebp)
  800289:	e8 62 20 00 00       	call   8022f0 <__udivdi3>
  80028e:	83 c4 18             	add    $0x18,%esp
  800291:	52                   	push   %edx
  800292:	50                   	push   %eax
  800293:	89 fa                	mov    %edi,%edx
  800295:	89 f0                	mov    %esi,%eax
  800297:	e8 54 ff ff ff       	call   8001f0 <printnum>
  80029c:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	57                   	push   %edi
  8002a3:	83 ec 04             	sub    $0x4,%esp
  8002a6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002a9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002af:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b2:	e8 49 21 00 00       	call   802400 <__umoddi3>
  8002b7:	83 c4 14             	add    $0x14,%esp
  8002ba:	0f be 80 a9 25 80 00 	movsbl 0x8025a9(%eax),%eax
  8002c1:	50                   	push   %eax
  8002c2:	ff d6                	call   *%esi
  8002c4:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002ca:	5b                   	pop    %ebx
  8002cb:	5e                   	pop    %esi
  8002cc:	5f                   	pop    %edi
  8002cd:	5d                   	pop    %ebp
  8002ce:	c3                   	ret    

008002cf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002cf:	55                   	push   %ebp
  8002d0:	89 e5                	mov    %esp,%ebp
  8002d2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002d9:	8b 10                	mov    (%eax),%edx
  8002db:	3b 50 04             	cmp    0x4(%eax),%edx
  8002de:	73 0a                	jae    8002ea <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e3:	89 08                	mov    %ecx,(%eax)
  8002e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e8:	88 02                	mov    %al,(%edx)
}
  8002ea:	5d                   	pop    %ebp
  8002eb:	c3                   	ret    

008002ec <printfmt>:
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f5:	50                   	push   %eax
  8002f6:	ff 75 10             	pushl  0x10(%ebp)
  8002f9:	ff 75 0c             	pushl  0xc(%ebp)
  8002fc:	ff 75 08             	pushl  0x8(%ebp)
  8002ff:	e8 05 00 00 00       	call   800309 <vprintfmt>
}
  800304:	83 c4 10             	add    $0x10,%esp
  800307:	c9                   	leave  
  800308:	c3                   	ret    

00800309 <vprintfmt>:
{
  800309:	55                   	push   %ebp
  80030a:	89 e5                	mov    %esp,%ebp
  80030c:	57                   	push   %edi
  80030d:	56                   	push   %esi
  80030e:	53                   	push   %ebx
  80030f:	83 ec 3c             	sub    $0x3c,%esp
  800312:	8b 75 08             	mov    0x8(%ebp),%esi
  800315:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800318:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031b:	e9 32 04 00 00       	jmp    800752 <vprintfmt+0x449>
		padc = ' ';
  800320:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800324:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80032b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800332:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800339:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800340:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800347:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034c:	8d 47 01             	lea    0x1(%edi),%eax
  80034f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800352:	0f b6 17             	movzbl (%edi),%edx
  800355:	8d 42 dd             	lea    -0x23(%edx),%eax
  800358:	3c 55                	cmp    $0x55,%al
  80035a:	0f 87 12 05 00 00    	ja     800872 <vprintfmt+0x569>
  800360:	0f b6 c0             	movzbl %al,%eax
  800363:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
  80036a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800371:	eb d9                	jmp    80034c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800373:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800376:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80037a:	eb d0                	jmp    80034c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80037c:	0f b6 d2             	movzbl %dl,%edx
  80037f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800382:	b8 00 00 00 00       	mov    $0x0,%eax
  800387:	89 75 08             	mov    %esi,0x8(%ebp)
  80038a:	eb 03                	jmp    80038f <vprintfmt+0x86>
  80038c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80038f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800392:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800396:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800399:	8d 72 d0             	lea    -0x30(%edx),%esi
  80039c:	83 fe 09             	cmp    $0x9,%esi
  80039f:	76 eb                	jbe    80038c <vprintfmt+0x83>
  8003a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a7:	eb 14                	jmp    8003bd <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ac:	8b 00                	mov    (%eax),%eax
  8003ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8d 40 04             	lea    0x4(%eax),%eax
  8003b7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c1:	79 89                	jns    80034c <vprintfmt+0x43>
				width = precision, precision = -1;
  8003c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003c9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d0:	e9 77 ff ff ff       	jmp    80034c <vprintfmt+0x43>
  8003d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d8:	85 c0                	test   %eax,%eax
  8003da:	0f 48 c1             	cmovs  %ecx,%eax
  8003dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e3:	e9 64 ff ff ff       	jmp    80034c <vprintfmt+0x43>
  8003e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003eb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003f2:	e9 55 ff ff ff       	jmp    80034c <vprintfmt+0x43>
			lflag++;
  8003f7:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003fe:	e9 49 ff ff ff       	jmp    80034c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800403:	8b 45 14             	mov    0x14(%ebp),%eax
  800406:	8d 78 04             	lea    0x4(%eax),%edi
  800409:	83 ec 08             	sub    $0x8,%esp
  80040c:	53                   	push   %ebx
  80040d:	ff 30                	pushl  (%eax)
  80040f:	ff d6                	call   *%esi
			break;
  800411:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800414:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800417:	e9 33 03 00 00       	jmp    80074f <vprintfmt+0x446>
			err = va_arg(ap, int);
  80041c:	8b 45 14             	mov    0x14(%ebp),%eax
  80041f:	8d 78 04             	lea    0x4(%eax),%edi
  800422:	8b 00                	mov    (%eax),%eax
  800424:	99                   	cltd   
  800425:	31 d0                	xor    %edx,%eax
  800427:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800429:	83 f8 11             	cmp    $0x11,%eax
  80042c:	7f 23                	jg     800451 <vprintfmt+0x148>
  80042e:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  800435:	85 d2                	test   %edx,%edx
  800437:	74 18                	je     800451 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800439:	52                   	push   %edx
  80043a:	68 fd 29 80 00       	push   $0x8029fd
  80043f:	53                   	push   %ebx
  800440:	56                   	push   %esi
  800441:	e8 a6 fe ff ff       	call   8002ec <printfmt>
  800446:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800449:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044c:	e9 fe 02 00 00       	jmp    80074f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800451:	50                   	push   %eax
  800452:	68 c1 25 80 00       	push   $0x8025c1
  800457:	53                   	push   %ebx
  800458:	56                   	push   %esi
  800459:	e8 8e fe ff ff       	call   8002ec <printfmt>
  80045e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800461:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800464:	e9 e6 02 00 00       	jmp    80074f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800469:	8b 45 14             	mov    0x14(%ebp),%eax
  80046c:	83 c0 04             	add    $0x4,%eax
  80046f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800472:	8b 45 14             	mov    0x14(%ebp),%eax
  800475:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800477:	85 c9                	test   %ecx,%ecx
  800479:	b8 ba 25 80 00       	mov    $0x8025ba,%eax
  80047e:	0f 45 c1             	cmovne %ecx,%eax
  800481:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800484:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800488:	7e 06                	jle    800490 <vprintfmt+0x187>
  80048a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80048e:	75 0d                	jne    80049d <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800490:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800493:	89 c7                	mov    %eax,%edi
  800495:	03 45 e0             	add    -0x20(%ebp),%eax
  800498:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049b:	eb 53                	jmp    8004f0 <vprintfmt+0x1e7>
  80049d:	83 ec 08             	sub    $0x8,%esp
  8004a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a3:	50                   	push   %eax
  8004a4:	e8 71 04 00 00       	call   80091a <strnlen>
  8004a9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ac:	29 c1                	sub    %eax,%ecx
  8004ae:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004b1:	83 c4 10             	add    $0x10,%esp
  8004b4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b6:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004bd:	eb 0f                	jmp    8004ce <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004bf:	83 ec 08             	sub    $0x8,%esp
  8004c2:	53                   	push   %ebx
  8004c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c8:	83 ef 01             	sub    $0x1,%edi
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	85 ff                	test   %edi,%edi
  8004d0:	7f ed                	jg     8004bf <vprintfmt+0x1b6>
  8004d2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d5:	85 c9                	test   %ecx,%ecx
  8004d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dc:	0f 49 c1             	cmovns %ecx,%eax
  8004df:	29 c1                	sub    %eax,%ecx
  8004e1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e4:	eb aa                	jmp    800490 <vprintfmt+0x187>
					putch(ch, putdat);
  8004e6:	83 ec 08             	sub    $0x8,%esp
  8004e9:	53                   	push   %ebx
  8004ea:	52                   	push   %edx
  8004eb:	ff d6                	call   *%esi
  8004ed:	83 c4 10             	add    $0x10,%esp
  8004f0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f3:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f5:	83 c7 01             	add    $0x1,%edi
  8004f8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fc:	0f be d0             	movsbl %al,%edx
  8004ff:	85 d2                	test   %edx,%edx
  800501:	74 4b                	je     80054e <vprintfmt+0x245>
  800503:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800507:	78 06                	js     80050f <vprintfmt+0x206>
  800509:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050d:	78 1e                	js     80052d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80050f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800513:	74 d1                	je     8004e6 <vprintfmt+0x1dd>
  800515:	0f be c0             	movsbl %al,%eax
  800518:	83 e8 20             	sub    $0x20,%eax
  80051b:	83 f8 5e             	cmp    $0x5e,%eax
  80051e:	76 c6                	jbe    8004e6 <vprintfmt+0x1dd>
					putch('?', putdat);
  800520:	83 ec 08             	sub    $0x8,%esp
  800523:	53                   	push   %ebx
  800524:	6a 3f                	push   $0x3f
  800526:	ff d6                	call   *%esi
  800528:	83 c4 10             	add    $0x10,%esp
  80052b:	eb c3                	jmp    8004f0 <vprintfmt+0x1e7>
  80052d:	89 cf                	mov    %ecx,%edi
  80052f:	eb 0e                	jmp    80053f <vprintfmt+0x236>
				putch(' ', putdat);
  800531:	83 ec 08             	sub    $0x8,%esp
  800534:	53                   	push   %ebx
  800535:	6a 20                	push   $0x20
  800537:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800539:	83 ef 01             	sub    $0x1,%edi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	85 ff                	test   %edi,%edi
  800541:	7f ee                	jg     800531 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800543:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800546:	89 45 14             	mov    %eax,0x14(%ebp)
  800549:	e9 01 02 00 00       	jmp    80074f <vprintfmt+0x446>
  80054e:	89 cf                	mov    %ecx,%edi
  800550:	eb ed                	jmp    80053f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800552:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800555:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80055c:	e9 eb fd ff ff       	jmp    80034c <vprintfmt+0x43>
	if (lflag >= 2)
  800561:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800565:	7f 21                	jg     800588 <vprintfmt+0x27f>
	else if (lflag)
  800567:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80056b:	74 68                	je     8005d5 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80056d:	8b 45 14             	mov    0x14(%ebp),%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800575:	89 c1                	mov    %eax,%ecx
  800577:	c1 f9 1f             	sar    $0x1f,%ecx
  80057a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8d 40 04             	lea    0x4(%eax),%eax
  800583:	89 45 14             	mov    %eax,0x14(%ebp)
  800586:	eb 17                	jmp    80059f <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8b 50 04             	mov    0x4(%eax),%edx
  80058e:	8b 00                	mov    (%eax),%eax
  800590:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800593:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8d 40 08             	lea    0x8(%eax),%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80059f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005ab:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005af:	78 3f                	js     8005f0 <vprintfmt+0x2e7>
			base = 10;
  8005b1:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005ba:	0f 84 71 01 00 00    	je     800731 <vprintfmt+0x428>
				putch('+', putdat);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	53                   	push   %ebx
  8005c4:	6a 2b                	push   $0x2b
  8005c6:	ff d6                	call   *%esi
  8005c8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d0:	e9 5c 01 00 00       	jmp    800731 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d8:	8b 00                	mov    (%eax),%eax
  8005da:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005dd:	89 c1                	mov    %eax,%ecx
  8005df:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8d 40 04             	lea    0x4(%eax),%eax
  8005eb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ee:	eb af                	jmp    80059f <vprintfmt+0x296>
				putch('-', putdat);
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	53                   	push   %ebx
  8005f4:	6a 2d                	push   $0x2d
  8005f6:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fe:	f7 d8                	neg    %eax
  800600:	83 d2 00             	adc    $0x0,%edx
  800603:	f7 da                	neg    %edx
  800605:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800608:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800613:	e9 19 01 00 00       	jmp    800731 <vprintfmt+0x428>
	if (lflag >= 2)
  800618:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80061c:	7f 29                	jg     800647 <vprintfmt+0x33e>
	else if (lflag)
  80061e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800622:	74 44                	je     800668 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	ba 00 00 00 00       	mov    $0x0,%edx
  80062e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800631:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800642:	e9 ea 00 00 00       	jmp    800731 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800647:	8b 45 14             	mov    0x14(%ebp),%eax
  80064a:	8b 50 04             	mov    0x4(%eax),%edx
  80064d:	8b 00                	mov    (%eax),%eax
  80064f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800652:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800655:	8b 45 14             	mov    0x14(%ebp),%eax
  800658:	8d 40 08             	lea    0x8(%eax),%eax
  80065b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800663:	e9 c9 00 00 00       	jmp    800731 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	ba 00 00 00 00       	mov    $0x0,%edx
  800672:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800675:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8d 40 04             	lea    0x4(%eax),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800681:	b8 0a 00 00 00       	mov    $0xa,%eax
  800686:	e9 a6 00 00 00       	jmp    800731 <vprintfmt+0x428>
			putch('0', putdat);
  80068b:	83 ec 08             	sub    $0x8,%esp
  80068e:	53                   	push   %ebx
  80068f:	6a 30                	push   $0x30
  800691:	ff d6                	call   *%esi
	if (lflag >= 2)
  800693:	83 c4 10             	add    $0x10,%esp
  800696:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80069a:	7f 26                	jg     8006c2 <vprintfmt+0x3b9>
	else if (lflag)
  80069c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a0:	74 3e                	je     8006e0 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006af:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8d 40 04             	lea    0x4(%eax),%eax
  8006b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c0:	eb 6f                	jmp    800731 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8b 50 04             	mov    0x4(%eax),%edx
  8006c8:	8b 00                	mov    (%eax),%eax
  8006ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8d 40 08             	lea    0x8(%eax),%eax
  8006d6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006de:	eb 51                	jmp    800731 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8d 40 04             	lea    0x4(%eax),%eax
  8006f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006fe:	eb 31                	jmp    800731 <vprintfmt+0x428>
			putch('0', putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	53                   	push   %ebx
  800704:	6a 30                	push   $0x30
  800706:	ff d6                	call   *%esi
			putch('x', putdat);
  800708:	83 c4 08             	add    $0x8,%esp
  80070b:	53                   	push   %ebx
  80070c:	6a 78                	push   $0x78
  80070e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800710:	8b 45 14             	mov    0x14(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	ba 00 00 00 00       	mov    $0x0,%edx
  80071a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800720:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800723:	8b 45 14             	mov    0x14(%ebp),%eax
  800726:	8d 40 04             	lea    0x4(%eax),%eax
  800729:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800731:	83 ec 0c             	sub    $0xc,%esp
  800734:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800738:	52                   	push   %edx
  800739:	ff 75 e0             	pushl  -0x20(%ebp)
  80073c:	50                   	push   %eax
  80073d:	ff 75 dc             	pushl  -0x24(%ebp)
  800740:	ff 75 d8             	pushl  -0x28(%ebp)
  800743:	89 da                	mov    %ebx,%edx
  800745:	89 f0                	mov    %esi,%eax
  800747:	e8 a4 fa ff ff       	call   8001f0 <printnum>
			break;
  80074c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80074f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800752:	83 c7 01             	add    $0x1,%edi
  800755:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800759:	83 f8 25             	cmp    $0x25,%eax
  80075c:	0f 84 be fb ff ff    	je     800320 <vprintfmt+0x17>
			if (ch == '\0')
  800762:	85 c0                	test   %eax,%eax
  800764:	0f 84 28 01 00 00    	je     800892 <vprintfmt+0x589>
			putch(ch, putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	50                   	push   %eax
  80076f:	ff d6                	call   *%esi
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	eb dc                	jmp    800752 <vprintfmt+0x449>
	if (lflag >= 2)
  800776:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80077a:	7f 26                	jg     8007a2 <vprintfmt+0x499>
	else if (lflag)
  80077c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800780:	74 41                	je     8007c3 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
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
  8007a0:	eb 8f                	jmp    800731 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8b 50 04             	mov    0x4(%eax),%edx
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ad:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b3:	8d 40 08             	lea    0x8(%eax),%eax
  8007b6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007be:	e9 6e ff ff ff       	jmp    800731 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	8b 00                	mov    (%eax),%eax
  8007c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007cd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8d 40 04             	lea    0x4(%eax),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007dc:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e1:	e9 4b ff ff ff       	jmp    800731 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e9:	83 c0 04             	add    $0x4,%eax
  8007ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f2:	8b 00                	mov    (%eax),%eax
  8007f4:	85 c0                	test   %eax,%eax
  8007f6:	74 14                	je     80080c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f8:	8b 13                	mov    (%ebx),%edx
  8007fa:	83 fa 7f             	cmp    $0x7f,%edx
  8007fd:	7f 37                	jg     800836 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007ff:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800801:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800804:	89 45 14             	mov    %eax,0x14(%ebp)
  800807:	e9 43 ff ff ff       	jmp    80074f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80080c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800811:	bf dd 26 80 00       	mov    $0x8026dd,%edi
							putch(ch, putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	50                   	push   %eax
  80081b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081d:	83 c7 01             	add    $0x1,%edi
  800820:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	85 c0                	test   %eax,%eax
  800829:	75 eb                	jne    800816 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082e:	89 45 14             	mov    %eax,0x14(%ebp)
  800831:	e9 19 ff ff ff       	jmp    80074f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800836:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800838:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083d:	bf 15 27 80 00       	mov    $0x802715,%edi
							putch(ch, putdat);
  800842:	83 ec 08             	sub    $0x8,%esp
  800845:	53                   	push   %ebx
  800846:	50                   	push   %eax
  800847:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800849:	83 c7 01             	add    $0x1,%edi
  80084c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800850:	83 c4 10             	add    $0x10,%esp
  800853:	85 c0                	test   %eax,%eax
  800855:	75 eb                	jne    800842 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800857:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085a:	89 45 14             	mov    %eax,0x14(%ebp)
  80085d:	e9 ed fe ff ff       	jmp    80074f <vprintfmt+0x446>
			putch(ch, putdat);
  800862:	83 ec 08             	sub    $0x8,%esp
  800865:	53                   	push   %ebx
  800866:	6a 25                	push   $0x25
  800868:	ff d6                	call   *%esi
			break;
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	e9 dd fe ff ff       	jmp    80074f <vprintfmt+0x446>
			putch('%', putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	6a 25                	push   $0x25
  800878:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	89 f8                	mov    %edi,%eax
  80087f:	eb 03                	jmp    800884 <vprintfmt+0x57b>
  800881:	83 e8 01             	sub    $0x1,%eax
  800884:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800888:	75 f7                	jne    800881 <vprintfmt+0x578>
  80088a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088d:	e9 bd fe ff ff       	jmp    80074f <vprintfmt+0x446>
}
  800892:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800895:	5b                   	pop    %ebx
  800896:	5e                   	pop    %esi
  800897:	5f                   	pop    %edi
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	83 ec 18             	sub    $0x18,%esp
  8008a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008a9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ad:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b7:	85 c0                	test   %eax,%eax
  8008b9:	74 26                	je     8008e1 <vsnprintf+0x47>
  8008bb:	85 d2                	test   %edx,%edx
  8008bd:	7e 22                	jle    8008e1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bf:	ff 75 14             	pushl  0x14(%ebp)
  8008c2:	ff 75 10             	pushl  0x10(%ebp)
  8008c5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c8:	50                   	push   %eax
  8008c9:	68 cf 02 80 00       	push   $0x8002cf
  8008ce:	e8 36 fa ff ff       	call   800309 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
}
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    
		return -E_INVAL;
  8008e1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e6:	eb f7                	jmp    8008df <vsnprintf+0x45>

008008e8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e8:	55                   	push   %ebp
  8008e9:	89 e5                	mov    %esp,%ebp
  8008eb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ee:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f1:	50                   	push   %eax
  8008f2:	ff 75 10             	pushl  0x10(%ebp)
  8008f5:	ff 75 0c             	pushl  0xc(%ebp)
  8008f8:	ff 75 08             	pushl  0x8(%ebp)
  8008fb:	e8 9a ff ff ff       	call   80089a <vsnprintf>
	va_end(ap);

	return rc;
}
  800900:	c9                   	leave  
  800901:	c3                   	ret    

00800902 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800908:	b8 00 00 00 00       	mov    $0x0,%eax
  80090d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800911:	74 05                	je     800918 <strlen+0x16>
		n++;
  800913:	83 c0 01             	add    $0x1,%eax
  800916:	eb f5                	jmp    80090d <strlen+0xb>
	return n;
}
  800918:	5d                   	pop    %ebp
  800919:	c3                   	ret    

0080091a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800920:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800923:	ba 00 00 00 00       	mov    $0x0,%edx
  800928:	39 c2                	cmp    %eax,%edx
  80092a:	74 0d                	je     800939 <strnlen+0x1f>
  80092c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800930:	74 05                	je     800937 <strnlen+0x1d>
		n++;
  800932:	83 c2 01             	add    $0x1,%edx
  800935:	eb f1                	jmp    800928 <strnlen+0xe>
  800937:	89 d0                	mov    %edx,%eax
	return n;
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800945:	ba 00 00 00 00       	mov    $0x0,%edx
  80094a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800951:	83 c2 01             	add    $0x1,%edx
  800954:	84 c9                	test   %cl,%cl
  800956:	75 f2                	jne    80094a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800958:	5b                   	pop    %ebx
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	83 ec 10             	sub    $0x10,%esp
  800962:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800965:	53                   	push   %ebx
  800966:	e8 97 ff ff ff       	call   800902 <strlen>
  80096b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096e:	ff 75 0c             	pushl  0xc(%ebp)
  800971:	01 d8                	add    %ebx,%eax
  800973:	50                   	push   %eax
  800974:	e8 c2 ff ff ff       	call   80093b <strcpy>
	return dst;
}
  800979:	89 d8                	mov    %ebx,%eax
  80097b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097e:	c9                   	leave  
  80097f:	c3                   	ret    

00800980 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	56                   	push   %esi
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098b:	89 c6                	mov    %eax,%esi
  80098d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800990:	89 c2                	mov    %eax,%edx
  800992:	39 f2                	cmp    %esi,%edx
  800994:	74 11                	je     8009a7 <strncpy+0x27>
		*dst++ = *src;
  800996:	83 c2 01             	add    $0x1,%edx
  800999:	0f b6 19             	movzbl (%ecx),%ebx
  80099c:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 fb 01             	cmp    $0x1,%bl
  8009a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a5:	eb eb                	jmp    800992 <strncpy+0x12>
	}
	return ret;
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5e                   	pop    %esi
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009b9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bb:	85 d2                	test   %edx,%edx
  8009bd:	74 21                	je     8009e0 <strlcpy+0x35>
  8009bf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c5:	39 c2                	cmp    %eax,%edx
  8009c7:	74 14                	je     8009dd <strlcpy+0x32>
  8009c9:	0f b6 19             	movzbl (%ecx),%ebx
  8009cc:	84 db                	test   %bl,%bl
  8009ce:	74 0b                	je     8009db <strlcpy+0x30>
			*dst++ = *src++;
  8009d0:	83 c1 01             	add    $0x1,%ecx
  8009d3:	83 c2 01             	add    $0x1,%edx
  8009d6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009d9:	eb ea                	jmp    8009c5 <strlcpy+0x1a>
  8009db:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e0:	29 f0                	sub    %esi,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    

008009e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e6:	55                   	push   %ebp
  8009e7:	89 e5                	mov    %esp,%ebp
  8009e9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ec:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ef:	0f b6 01             	movzbl (%ecx),%eax
  8009f2:	84 c0                	test   %al,%al
  8009f4:	74 0c                	je     800a02 <strcmp+0x1c>
  8009f6:	3a 02                	cmp    (%edx),%al
  8009f8:	75 08                	jne    800a02 <strcmp+0x1c>
		p++, q++;
  8009fa:	83 c1 01             	add    $0x1,%ecx
  8009fd:	83 c2 01             	add    $0x1,%edx
  800a00:	eb ed                	jmp    8009ef <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a02:	0f b6 c0             	movzbl %al,%eax
  800a05:	0f b6 12             	movzbl (%edx),%edx
  800a08:	29 d0                	sub    %edx,%eax
}
  800a0a:	5d                   	pop    %ebp
  800a0b:	c3                   	ret    

00800a0c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
  800a0f:	53                   	push   %ebx
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a16:	89 c3                	mov    %eax,%ebx
  800a18:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a1b:	eb 06                	jmp    800a23 <strncmp+0x17>
		n--, p++, q++;
  800a1d:	83 c0 01             	add    $0x1,%eax
  800a20:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a23:	39 d8                	cmp    %ebx,%eax
  800a25:	74 16                	je     800a3d <strncmp+0x31>
  800a27:	0f b6 08             	movzbl (%eax),%ecx
  800a2a:	84 c9                	test   %cl,%cl
  800a2c:	74 04                	je     800a32 <strncmp+0x26>
  800a2e:	3a 0a                	cmp    (%edx),%cl
  800a30:	74 eb                	je     800a1d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a32:	0f b6 00             	movzbl (%eax),%eax
  800a35:	0f b6 12             	movzbl (%edx),%edx
  800a38:	29 d0                	sub    %edx,%eax
}
  800a3a:	5b                   	pop    %ebx
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    
		return 0;
  800a3d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a42:	eb f6                	jmp    800a3a <strncmp+0x2e>

00800a44 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4e:	0f b6 10             	movzbl (%eax),%edx
  800a51:	84 d2                	test   %dl,%dl
  800a53:	74 09                	je     800a5e <strchr+0x1a>
		if (*s == c)
  800a55:	38 ca                	cmp    %cl,%dl
  800a57:	74 0a                	je     800a63 <strchr+0x1f>
	for (; *s; s++)
  800a59:	83 c0 01             	add    $0x1,%eax
  800a5c:	eb f0                	jmp    800a4e <strchr+0xa>
			return (char *) s;
	return 0;
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a6f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a72:	38 ca                	cmp    %cl,%dl
  800a74:	74 09                	je     800a7f <strfind+0x1a>
  800a76:	84 d2                	test   %dl,%dl
  800a78:	74 05                	je     800a7f <strfind+0x1a>
	for (; *s; s++)
  800a7a:	83 c0 01             	add    $0x1,%eax
  800a7d:	eb f0                	jmp    800a6f <strfind+0xa>
			break;
	return (char *) s;
}
  800a7f:	5d                   	pop    %ebp
  800a80:	c3                   	ret    

00800a81 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a81:	55                   	push   %ebp
  800a82:	89 e5                	mov    %esp,%ebp
  800a84:	57                   	push   %edi
  800a85:	56                   	push   %esi
  800a86:	53                   	push   %ebx
  800a87:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a8a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8d:	85 c9                	test   %ecx,%ecx
  800a8f:	74 31                	je     800ac2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a91:	89 f8                	mov    %edi,%eax
  800a93:	09 c8                	or     %ecx,%eax
  800a95:	a8 03                	test   $0x3,%al
  800a97:	75 23                	jne    800abc <memset+0x3b>
		c &= 0xFF;
  800a99:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9d:	89 d3                	mov    %edx,%ebx
  800a9f:	c1 e3 08             	shl    $0x8,%ebx
  800aa2:	89 d0                	mov    %edx,%eax
  800aa4:	c1 e0 18             	shl    $0x18,%eax
  800aa7:	89 d6                	mov    %edx,%esi
  800aa9:	c1 e6 10             	shl    $0x10,%esi
  800aac:	09 f0                	or     %esi,%eax
  800aae:	09 c2                	or     %eax,%edx
  800ab0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab5:	89 d0                	mov    %edx,%eax
  800ab7:	fc                   	cld    
  800ab8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aba:	eb 06                	jmp    800ac2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800abc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800abf:	fc                   	cld    
  800ac0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac2:	89 f8                	mov    %edi,%eax
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5f                   	pop    %edi
  800ac7:	5d                   	pop    %ebp
  800ac8:	c3                   	ret    

00800ac9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac9:	55                   	push   %ebp
  800aca:	89 e5                	mov    %esp,%ebp
  800acc:	57                   	push   %edi
  800acd:	56                   	push   %esi
  800ace:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad7:	39 c6                	cmp    %eax,%esi
  800ad9:	73 32                	jae    800b0d <memmove+0x44>
  800adb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ade:	39 c2                	cmp    %eax,%edx
  800ae0:	76 2b                	jbe    800b0d <memmove+0x44>
		s += n;
		d += n;
  800ae2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae5:	89 fe                	mov    %edi,%esi
  800ae7:	09 ce                	or     %ecx,%esi
  800ae9:	09 d6                	or     %edx,%esi
  800aeb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af1:	75 0e                	jne    800b01 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af3:	83 ef 04             	sub    $0x4,%edi
  800af6:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800afc:	fd                   	std    
  800afd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aff:	eb 09                	jmp    800b0a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b01:	83 ef 01             	sub    $0x1,%edi
  800b04:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b07:	fd                   	std    
  800b08:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b0a:	fc                   	cld    
  800b0b:	eb 1a                	jmp    800b27 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0d:	89 c2                	mov    %eax,%edx
  800b0f:	09 ca                	or     %ecx,%edx
  800b11:	09 f2                	or     %esi,%edx
  800b13:	f6 c2 03             	test   $0x3,%dl
  800b16:	75 0a                	jne    800b22 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b18:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1b:	89 c7                	mov    %eax,%edi
  800b1d:	fc                   	cld    
  800b1e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b20:	eb 05                	jmp    800b27 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b22:	89 c7                	mov    %eax,%edi
  800b24:	fc                   	cld    
  800b25:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b27:	5e                   	pop    %esi
  800b28:	5f                   	pop    %edi
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b31:	ff 75 10             	pushl  0x10(%ebp)
  800b34:	ff 75 0c             	pushl  0xc(%ebp)
  800b37:	ff 75 08             	pushl  0x8(%ebp)
  800b3a:	e8 8a ff ff ff       	call   800ac9 <memmove>
}
  800b3f:	c9                   	leave  
  800b40:	c3                   	ret    

00800b41 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
  800b44:	56                   	push   %esi
  800b45:	53                   	push   %ebx
  800b46:	8b 45 08             	mov    0x8(%ebp),%eax
  800b49:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4c:	89 c6                	mov    %eax,%esi
  800b4e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b51:	39 f0                	cmp    %esi,%eax
  800b53:	74 1c                	je     800b71 <memcmp+0x30>
		if (*s1 != *s2)
  800b55:	0f b6 08             	movzbl (%eax),%ecx
  800b58:	0f b6 1a             	movzbl (%edx),%ebx
  800b5b:	38 d9                	cmp    %bl,%cl
  800b5d:	75 08                	jne    800b67 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b5f:	83 c0 01             	add    $0x1,%eax
  800b62:	83 c2 01             	add    $0x1,%edx
  800b65:	eb ea                	jmp    800b51 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b67:	0f b6 c1             	movzbl %cl,%eax
  800b6a:	0f b6 db             	movzbl %bl,%ebx
  800b6d:	29 d8                	sub    %ebx,%eax
  800b6f:	eb 05                	jmp    800b76 <memcmp+0x35>
	}

	return 0;
  800b71:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5d                   	pop    %ebp
  800b79:	c3                   	ret    

00800b7a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b83:	89 c2                	mov    %eax,%edx
  800b85:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b88:	39 d0                	cmp    %edx,%eax
  800b8a:	73 09                	jae    800b95 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b8c:	38 08                	cmp    %cl,(%eax)
  800b8e:	74 05                	je     800b95 <memfind+0x1b>
	for (; s < ends; s++)
  800b90:	83 c0 01             	add    $0x1,%eax
  800b93:	eb f3                	jmp    800b88 <memfind+0xe>
			break;
	return (void *) s;
}
  800b95:	5d                   	pop    %ebp
  800b96:	c3                   	ret    

00800b97 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	57                   	push   %edi
  800b9b:	56                   	push   %esi
  800b9c:	53                   	push   %ebx
  800b9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba3:	eb 03                	jmp    800ba8 <strtol+0x11>
		s++;
  800ba5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba8:	0f b6 01             	movzbl (%ecx),%eax
  800bab:	3c 20                	cmp    $0x20,%al
  800bad:	74 f6                	je     800ba5 <strtol+0xe>
  800baf:	3c 09                	cmp    $0x9,%al
  800bb1:	74 f2                	je     800ba5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb3:	3c 2b                	cmp    $0x2b,%al
  800bb5:	74 2a                	je     800be1 <strtol+0x4a>
	int neg = 0;
  800bb7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bbc:	3c 2d                	cmp    $0x2d,%al
  800bbe:	74 2b                	je     800beb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc6:	75 0f                	jne    800bd7 <strtol+0x40>
  800bc8:	80 39 30             	cmpb   $0x30,(%ecx)
  800bcb:	74 28                	je     800bf5 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bcd:	85 db                	test   %ebx,%ebx
  800bcf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd4:	0f 44 d8             	cmove  %eax,%ebx
  800bd7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdc:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bdf:	eb 50                	jmp    800c31 <strtol+0x9a>
		s++;
  800be1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be4:	bf 00 00 00 00       	mov    $0x0,%edi
  800be9:	eb d5                	jmp    800bc0 <strtol+0x29>
		s++, neg = 1;
  800beb:	83 c1 01             	add    $0x1,%ecx
  800bee:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf3:	eb cb                	jmp    800bc0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf5:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bf9:	74 0e                	je     800c09 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bfb:	85 db                	test   %ebx,%ebx
  800bfd:	75 d8                	jne    800bd7 <strtol+0x40>
		s++, base = 8;
  800bff:	83 c1 01             	add    $0x1,%ecx
  800c02:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c07:	eb ce                	jmp    800bd7 <strtol+0x40>
		s += 2, base = 16;
  800c09:	83 c1 02             	add    $0x2,%ecx
  800c0c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c11:	eb c4                	jmp    800bd7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c13:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c16:	89 f3                	mov    %esi,%ebx
  800c18:	80 fb 19             	cmp    $0x19,%bl
  800c1b:	77 29                	ja     800c46 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c1d:	0f be d2             	movsbl %dl,%edx
  800c20:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c23:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c26:	7d 30                	jge    800c58 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c28:	83 c1 01             	add    $0x1,%ecx
  800c2b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c2f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c31:	0f b6 11             	movzbl (%ecx),%edx
  800c34:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c37:	89 f3                	mov    %esi,%ebx
  800c39:	80 fb 09             	cmp    $0x9,%bl
  800c3c:	77 d5                	ja     800c13 <strtol+0x7c>
			dig = *s - '0';
  800c3e:	0f be d2             	movsbl %dl,%edx
  800c41:	83 ea 30             	sub    $0x30,%edx
  800c44:	eb dd                	jmp    800c23 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c46:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c49:	89 f3                	mov    %esi,%ebx
  800c4b:	80 fb 19             	cmp    $0x19,%bl
  800c4e:	77 08                	ja     800c58 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c50:	0f be d2             	movsbl %dl,%edx
  800c53:	83 ea 37             	sub    $0x37,%edx
  800c56:	eb cb                	jmp    800c23 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c58:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5c:	74 05                	je     800c63 <strtol+0xcc>
		*endptr = (char *) s;
  800c5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c61:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c63:	89 c2                	mov    %eax,%edx
  800c65:	f7 da                	neg    %edx
  800c67:	85 ff                	test   %edi,%edi
  800c69:	0f 45 c2             	cmovne %edx,%eax
}
  800c6c:	5b                   	pop    %ebx
  800c6d:	5e                   	pop    %esi
  800c6e:	5f                   	pop    %edi
  800c6f:	5d                   	pop    %ebp
  800c70:	c3                   	ret    

00800c71 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c71:	55                   	push   %ebp
  800c72:	89 e5                	mov    %esp,%ebp
  800c74:	57                   	push   %edi
  800c75:	56                   	push   %esi
  800c76:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c77:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c82:	89 c3                	mov    %eax,%ebx
  800c84:	89 c7                	mov    %eax,%edi
  800c86:	89 c6                	mov    %eax,%esi
  800c88:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c8a:	5b                   	pop    %ebx
  800c8b:	5e                   	pop    %esi
  800c8c:	5f                   	pop    %edi
  800c8d:	5d                   	pop    %ebp
  800c8e:	c3                   	ret    

00800c8f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c8f:	55                   	push   %ebp
  800c90:	89 e5                	mov    %esp,%ebp
  800c92:	57                   	push   %edi
  800c93:	56                   	push   %esi
  800c94:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c95:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9a:	b8 01 00 00 00       	mov    $0x1,%eax
  800c9f:	89 d1                	mov    %edx,%ecx
  800ca1:	89 d3                	mov    %edx,%ebx
  800ca3:	89 d7                	mov    %edx,%edi
  800ca5:	89 d6                	mov    %edx,%esi
  800ca7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ca9:	5b                   	pop    %ebx
  800caa:	5e                   	pop    %esi
  800cab:	5f                   	pop    %edi
  800cac:	5d                   	pop    %ebp
  800cad:	c3                   	ret    

00800cae <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	57                   	push   %edi
  800cb2:	56                   	push   %esi
  800cb3:	53                   	push   %ebx
  800cb4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc4:	89 cb                	mov    %ecx,%ebx
  800cc6:	89 cf                	mov    %ecx,%edi
  800cc8:	89 ce                	mov    %ecx,%esi
  800cca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccc:	85 c0                	test   %eax,%eax
  800cce:	7f 08                	jg     800cd8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd8:	83 ec 0c             	sub    $0xc,%esp
  800cdb:	50                   	push   %eax
  800cdc:	6a 03                	push   $0x3
  800cde:	68 28 29 80 00       	push   $0x802928
  800ce3:	6a 43                	push   $0x43
  800ce5:	68 45 29 80 00       	push   $0x802945
  800cea:	e8 69 14 00 00       	call   802158 <_panic>

00800cef <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	57                   	push   %edi
  800cf3:	56                   	push   %esi
  800cf4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfa:	b8 02 00 00 00       	mov    $0x2,%eax
  800cff:	89 d1                	mov    %edx,%ecx
  800d01:	89 d3                	mov    %edx,%ebx
  800d03:	89 d7                	mov    %edx,%edi
  800d05:	89 d6                	mov    %edx,%esi
  800d07:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d09:	5b                   	pop    %ebx
  800d0a:	5e                   	pop    %esi
  800d0b:	5f                   	pop    %edi
  800d0c:	5d                   	pop    %ebp
  800d0d:	c3                   	ret    

00800d0e <sys_yield>:

void
sys_yield(void)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	57                   	push   %edi
  800d12:	56                   	push   %esi
  800d13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d14:	ba 00 00 00 00       	mov    $0x0,%edx
  800d19:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1e:	89 d1                	mov    %edx,%ecx
  800d20:	89 d3                	mov    %edx,%ebx
  800d22:	89 d7                	mov    %edx,%edi
  800d24:	89 d6                	mov    %edx,%esi
  800d26:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d28:	5b                   	pop    %ebx
  800d29:	5e                   	pop    %esi
  800d2a:	5f                   	pop    %edi
  800d2b:	5d                   	pop    %ebp
  800d2c:	c3                   	ret    

00800d2d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2d:	55                   	push   %ebp
  800d2e:	89 e5                	mov    %esp,%ebp
  800d30:	57                   	push   %edi
  800d31:	56                   	push   %esi
  800d32:	53                   	push   %ebx
  800d33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d36:	be 00 00 00 00       	mov    $0x0,%esi
  800d3b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d41:	b8 04 00 00 00       	mov    $0x4,%eax
  800d46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d49:	89 f7                	mov    %esi,%edi
  800d4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4d:	85 c0                	test   %eax,%eax
  800d4f:	7f 08                	jg     800d59 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d54:	5b                   	pop    %ebx
  800d55:	5e                   	pop    %esi
  800d56:	5f                   	pop    %edi
  800d57:	5d                   	pop    %ebp
  800d58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d59:	83 ec 0c             	sub    $0xc,%esp
  800d5c:	50                   	push   %eax
  800d5d:	6a 04                	push   $0x4
  800d5f:	68 28 29 80 00       	push   $0x802928
  800d64:	6a 43                	push   $0x43
  800d66:	68 45 29 80 00       	push   $0x802945
  800d6b:	e8 e8 13 00 00       	call   802158 <_panic>

00800d70 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	57                   	push   %edi
  800d74:	56                   	push   %esi
  800d75:	53                   	push   %ebx
  800d76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d84:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d87:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8f:	85 c0                	test   %eax,%eax
  800d91:	7f 08                	jg     800d9b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d96:	5b                   	pop    %ebx
  800d97:	5e                   	pop    %esi
  800d98:	5f                   	pop    %edi
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9b:	83 ec 0c             	sub    $0xc,%esp
  800d9e:	50                   	push   %eax
  800d9f:	6a 05                	push   $0x5
  800da1:	68 28 29 80 00       	push   $0x802928
  800da6:	6a 43                	push   $0x43
  800da8:	68 45 29 80 00       	push   $0x802945
  800dad:	e8 a6 13 00 00       	call   802158 <_panic>

00800db2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	57                   	push   %edi
  800db6:	56                   	push   %esi
  800db7:	53                   	push   %ebx
  800db8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc6:	b8 06 00 00 00       	mov    $0x6,%eax
  800dcb:	89 df                	mov    %ebx,%edi
  800dcd:	89 de                	mov    %ebx,%esi
  800dcf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd1:	85 c0                	test   %eax,%eax
  800dd3:	7f 08                	jg     800ddd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddd:	83 ec 0c             	sub    $0xc,%esp
  800de0:	50                   	push   %eax
  800de1:	6a 06                	push   $0x6
  800de3:	68 28 29 80 00       	push   $0x802928
  800de8:	6a 43                	push   $0x43
  800dea:	68 45 29 80 00       	push   $0x802945
  800def:	e8 64 13 00 00       	call   802158 <_panic>

00800df4 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df4:	55                   	push   %ebp
  800df5:	89 e5                	mov    %esp,%ebp
  800df7:	57                   	push   %edi
  800df8:	56                   	push   %esi
  800df9:	53                   	push   %ebx
  800dfa:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e02:	8b 55 08             	mov    0x8(%ebp),%edx
  800e05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e08:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0d:	89 df                	mov    %ebx,%edi
  800e0f:	89 de                	mov    %ebx,%esi
  800e11:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e13:	85 c0                	test   %eax,%eax
  800e15:	7f 08                	jg     800e1f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1a:	5b                   	pop    %ebx
  800e1b:	5e                   	pop    %esi
  800e1c:	5f                   	pop    %edi
  800e1d:	5d                   	pop    %ebp
  800e1e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1f:	83 ec 0c             	sub    $0xc,%esp
  800e22:	50                   	push   %eax
  800e23:	6a 08                	push   $0x8
  800e25:	68 28 29 80 00       	push   $0x802928
  800e2a:	6a 43                	push   $0x43
  800e2c:	68 45 29 80 00       	push   $0x802945
  800e31:	e8 22 13 00 00       	call   802158 <_panic>

00800e36 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e36:	55                   	push   %ebp
  800e37:	89 e5                	mov    %esp,%ebp
  800e39:	57                   	push   %edi
  800e3a:	56                   	push   %esi
  800e3b:	53                   	push   %ebx
  800e3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	89 de                	mov    %ebx,%esi
  800e53:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7f 08                	jg     800e61 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5c:	5b                   	pop    %ebx
  800e5d:	5e                   	pop    %esi
  800e5e:	5f                   	pop    %edi
  800e5f:	5d                   	pop    %ebp
  800e60:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e61:	83 ec 0c             	sub    $0xc,%esp
  800e64:	50                   	push   %eax
  800e65:	6a 09                	push   $0x9
  800e67:	68 28 29 80 00       	push   $0x802928
  800e6c:	6a 43                	push   $0x43
  800e6e:	68 45 29 80 00       	push   $0x802945
  800e73:	e8 e0 12 00 00       	call   802158 <_panic>

00800e78 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e81:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e91:	89 df                	mov    %ebx,%edi
  800e93:	89 de                	mov    %ebx,%esi
  800e95:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e97:	85 c0                	test   %eax,%eax
  800e99:	7f 08                	jg     800ea3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9e:	5b                   	pop    %ebx
  800e9f:	5e                   	pop    %esi
  800ea0:	5f                   	pop    %edi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	50                   	push   %eax
  800ea7:	6a 0a                	push   $0xa
  800ea9:	68 28 29 80 00       	push   $0x802928
  800eae:	6a 43                	push   $0x43
  800eb0:	68 45 29 80 00       	push   $0x802945
  800eb5:	e8 9e 12 00 00       	call   802158 <_panic>

00800eba <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eba:	55                   	push   %ebp
  800ebb:	89 e5                	mov    %esp,%ebp
  800ebd:	57                   	push   %edi
  800ebe:	56                   	push   %esi
  800ebf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ecb:	be 00 00 00 00       	mov    $0x0,%esi
  800ed0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed8:	5b                   	pop    %ebx
  800ed9:	5e                   	pop    %esi
  800eda:	5f                   	pop    %edi
  800edb:	5d                   	pop    %ebp
  800edc:	c3                   	ret    

00800edd <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
  800ee3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eeb:	8b 55 08             	mov    0x8(%ebp),%edx
  800eee:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef3:	89 cb                	mov    %ecx,%ebx
  800ef5:	89 cf                	mov    %ecx,%edi
  800ef7:	89 ce                	mov    %ecx,%esi
  800ef9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efb:	85 c0                	test   %eax,%eax
  800efd:	7f 08                	jg     800f07 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f07:	83 ec 0c             	sub    $0xc,%esp
  800f0a:	50                   	push   %eax
  800f0b:	6a 0d                	push   $0xd
  800f0d:	68 28 29 80 00       	push   $0x802928
  800f12:	6a 43                	push   $0x43
  800f14:	68 45 29 80 00       	push   $0x802945
  800f19:	e8 3a 12 00 00       	call   802158 <_panic>

00800f1e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f1e:	55                   	push   %ebp
  800f1f:	89 e5                	mov    %esp,%ebp
  800f21:	57                   	push   %edi
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f24:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f29:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f34:	89 df                	mov    %ebx,%edi
  800f36:	89 de                	mov    %ebx,%esi
  800f38:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5f                   	pop    %edi
  800f3d:	5d                   	pop    %ebp
  800f3e:	c3                   	ret    

00800f3f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	57                   	push   %edi
  800f43:	56                   	push   %esi
  800f44:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f45:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f52:	89 cb                	mov    %ecx,%ebx
  800f54:	89 cf                	mov    %ecx,%edi
  800f56:	89 ce                	mov    %ecx,%esi
  800f58:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f5a:	5b                   	pop    %ebx
  800f5b:	5e                   	pop    %esi
  800f5c:	5f                   	pop    %edi
  800f5d:	5d                   	pop    %ebp
  800f5e:	c3                   	ret    

00800f5f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
  800f62:	57                   	push   %edi
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f65:	ba 00 00 00 00       	mov    $0x0,%edx
  800f6a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6f:	89 d1                	mov    %edx,%ecx
  800f71:	89 d3                	mov    %edx,%ebx
  800f73:	89 d7                	mov    %edx,%edi
  800f75:	89 d6                	mov    %edx,%esi
  800f77:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5f                   	pop    %edi
  800f7c:	5d                   	pop    %ebp
  800f7d:	c3                   	ret    

00800f7e <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f7e:	55                   	push   %ebp
  800f7f:	89 e5                	mov    %esp,%ebp
  800f81:	57                   	push   %edi
  800f82:	56                   	push   %esi
  800f83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f84:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8f:	b8 11 00 00 00       	mov    $0x11,%eax
  800f94:	89 df                	mov    %ebx,%edi
  800f96:	89 de                	mov    %ebx,%esi
  800f98:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5f                   	pop    %edi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    

00800f9f <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f9f:	55                   	push   %ebp
  800fa0:	89 e5                	mov    %esp,%ebp
  800fa2:	57                   	push   %edi
  800fa3:	56                   	push   %esi
  800fa4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800faa:	8b 55 08             	mov    0x8(%ebp),%edx
  800fad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb0:	b8 12 00 00 00       	mov    $0x12,%eax
  800fb5:	89 df                	mov    %ebx,%edi
  800fb7:	89 de                	mov    %ebx,%esi
  800fb9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fbb:	5b                   	pop    %ebx
  800fbc:	5e                   	pop    %esi
  800fbd:	5f                   	pop    %edi
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	57                   	push   %edi
  800fc4:	56                   	push   %esi
  800fc5:	53                   	push   %ebx
  800fc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd4:	b8 13 00 00 00       	mov    $0x13,%eax
  800fd9:	89 df                	mov    %ebx,%edi
  800fdb:	89 de                	mov    %ebx,%esi
  800fdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdf:	85 c0                	test   %eax,%eax
  800fe1:	7f 08                	jg     800feb <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800feb:	83 ec 0c             	sub    $0xc,%esp
  800fee:	50                   	push   %eax
  800fef:	6a 13                	push   $0x13
  800ff1:	68 28 29 80 00       	push   $0x802928
  800ff6:	6a 43                	push   $0x43
  800ff8:	68 45 29 80 00       	push   $0x802945
  800ffd:	e8 56 11 00 00       	call   802158 <_panic>

00801002 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	05 00 00 00 30       	add    $0x30000000,%eax
  80100d:	c1 e8 0c             	shr    $0xc,%eax
}
  801010:	5d                   	pop    %ebp
  801011:	c3                   	ret    

00801012 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80101d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801022:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801031:	89 c2                	mov    %eax,%edx
  801033:	c1 ea 16             	shr    $0x16,%edx
  801036:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80103d:	f6 c2 01             	test   $0x1,%dl
  801040:	74 2d                	je     80106f <fd_alloc+0x46>
  801042:	89 c2                	mov    %eax,%edx
  801044:	c1 ea 0c             	shr    $0xc,%edx
  801047:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80104e:	f6 c2 01             	test   $0x1,%dl
  801051:	74 1c                	je     80106f <fd_alloc+0x46>
  801053:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801058:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80105d:	75 d2                	jne    801031 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801068:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80106d:	eb 0a                	jmp    801079 <fd_alloc+0x50>
			*fd_store = fd;
  80106f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801072:	89 01                	mov    %eax,(%ecx)
			return 0;
  801074:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801081:	83 f8 1f             	cmp    $0x1f,%eax
  801084:	77 30                	ja     8010b6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801086:	c1 e0 0c             	shl    $0xc,%eax
  801089:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80108e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801094:	f6 c2 01             	test   $0x1,%dl
  801097:	74 24                	je     8010bd <fd_lookup+0x42>
  801099:	89 c2                	mov    %eax,%edx
  80109b:	c1 ea 0c             	shr    $0xc,%edx
  80109e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a5:	f6 c2 01             	test   $0x1,%dl
  8010a8:	74 1a                	je     8010c4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ad:	89 02                	mov    %eax,(%edx)
	return 0;
  8010af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    
		return -E_INVAL;
  8010b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010bb:	eb f7                	jmp    8010b4 <fd_lookup+0x39>
		return -E_INVAL;
  8010bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c2:	eb f0                	jmp    8010b4 <fd_lookup+0x39>
  8010c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c9:	eb e9                	jmp    8010b4 <fd_lookup+0x39>

008010cb <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010cb:	55                   	push   %ebp
  8010cc:	89 e5                	mov    %esp,%ebp
  8010ce:	83 ec 08             	sub    $0x8,%esp
  8010d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d9:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010de:	39 08                	cmp    %ecx,(%eax)
  8010e0:	74 38                	je     80111a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010e2:	83 c2 01             	add    $0x1,%edx
  8010e5:	8b 04 95 d0 29 80 00 	mov    0x8029d0(,%edx,4),%eax
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	75 ee                	jne    8010de <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010f0:	a1 08 40 80 00       	mov    0x804008,%eax
  8010f5:	8b 40 48             	mov    0x48(%eax),%eax
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	51                   	push   %ecx
  8010fc:	50                   	push   %eax
  8010fd:	68 54 29 80 00       	push   $0x802954
  801102:	e8 d5 f0 ff ff       	call   8001dc <cprintf>
	*dev = 0;
  801107:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801110:	83 c4 10             	add    $0x10,%esp
  801113:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801118:	c9                   	leave  
  801119:	c3                   	ret    
			*dev = devtab[i];
  80111a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80111f:	b8 00 00 00 00       	mov    $0x0,%eax
  801124:	eb f2                	jmp    801118 <dev_lookup+0x4d>

00801126 <fd_close>:
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	57                   	push   %edi
  80112a:	56                   	push   %esi
  80112b:	53                   	push   %ebx
  80112c:	83 ec 24             	sub    $0x24,%esp
  80112f:	8b 75 08             	mov    0x8(%ebp),%esi
  801132:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801135:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801138:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801139:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80113f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801142:	50                   	push   %eax
  801143:	e8 33 ff ff ff       	call   80107b <fd_lookup>
  801148:	89 c3                	mov    %eax,%ebx
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	85 c0                	test   %eax,%eax
  80114f:	78 05                	js     801156 <fd_close+0x30>
	    || fd != fd2)
  801151:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801154:	74 16                	je     80116c <fd_close+0x46>
		return (must_exist ? r : 0);
  801156:	89 f8                	mov    %edi,%eax
  801158:	84 c0                	test   %al,%al
  80115a:	b8 00 00 00 00       	mov    $0x0,%eax
  80115f:	0f 44 d8             	cmove  %eax,%ebx
}
  801162:	89 d8                	mov    %ebx,%eax
  801164:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80116c:	83 ec 08             	sub    $0x8,%esp
  80116f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801172:	50                   	push   %eax
  801173:	ff 36                	pushl  (%esi)
  801175:	e8 51 ff ff ff       	call   8010cb <dev_lookup>
  80117a:	89 c3                	mov    %eax,%ebx
  80117c:	83 c4 10             	add    $0x10,%esp
  80117f:	85 c0                	test   %eax,%eax
  801181:	78 1a                	js     80119d <fd_close+0x77>
		if (dev->dev_close)
  801183:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801186:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801189:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80118e:	85 c0                	test   %eax,%eax
  801190:	74 0b                	je     80119d <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  801192:	83 ec 0c             	sub    $0xc,%esp
  801195:	56                   	push   %esi
  801196:	ff d0                	call   *%eax
  801198:	89 c3                	mov    %eax,%ebx
  80119a:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	56                   	push   %esi
  8011a1:	6a 00                	push   $0x0
  8011a3:	e8 0a fc ff ff       	call   800db2 <sys_page_unmap>
	return r;
  8011a8:	83 c4 10             	add    $0x10,%esp
  8011ab:	eb b5                	jmp    801162 <fd_close+0x3c>

008011ad <close>:

int
close(int fdnum)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011b6:	50                   	push   %eax
  8011b7:	ff 75 08             	pushl  0x8(%ebp)
  8011ba:	e8 bc fe ff ff       	call   80107b <fd_lookup>
  8011bf:	83 c4 10             	add    $0x10,%esp
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	79 02                	jns    8011c8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011c6:	c9                   	leave  
  8011c7:	c3                   	ret    
		return fd_close(fd, 1);
  8011c8:	83 ec 08             	sub    $0x8,%esp
  8011cb:	6a 01                	push   $0x1
  8011cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8011d0:	e8 51 ff ff ff       	call   801126 <fd_close>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	eb ec                	jmp    8011c6 <close+0x19>

008011da <close_all>:

void
close_all(void)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	53                   	push   %ebx
  8011de:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011e1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011e6:	83 ec 0c             	sub    $0xc,%esp
  8011e9:	53                   	push   %ebx
  8011ea:	e8 be ff ff ff       	call   8011ad <close>
	for (i = 0; i < MAXFD; i++)
  8011ef:	83 c3 01             	add    $0x1,%ebx
  8011f2:	83 c4 10             	add    $0x10,%esp
  8011f5:	83 fb 20             	cmp    $0x20,%ebx
  8011f8:	75 ec                	jne    8011e6 <close_all+0xc>
}
  8011fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011fd:	c9                   	leave  
  8011fe:	c3                   	ret    

008011ff <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	57                   	push   %edi
  801203:	56                   	push   %esi
  801204:	53                   	push   %ebx
  801205:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801208:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80120b:	50                   	push   %eax
  80120c:	ff 75 08             	pushl  0x8(%ebp)
  80120f:	e8 67 fe ff ff       	call   80107b <fd_lookup>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	0f 88 81 00 00 00    	js     8012a2 <dup+0xa3>
		return r;
	close(newfdnum);
  801221:	83 ec 0c             	sub    $0xc,%esp
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 81 ff ff ff       	call   8011ad <close>

	newfd = INDEX2FD(newfdnum);
  80122c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80122f:	c1 e6 0c             	shl    $0xc,%esi
  801232:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801238:	83 c4 04             	add    $0x4,%esp
  80123b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80123e:	e8 cf fd ff ff       	call   801012 <fd2data>
  801243:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801245:	89 34 24             	mov    %esi,(%esp)
  801248:	e8 c5 fd ff ff       	call   801012 <fd2data>
  80124d:	83 c4 10             	add    $0x10,%esp
  801250:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801252:	89 d8                	mov    %ebx,%eax
  801254:	c1 e8 16             	shr    $0x16,%eax
  801257:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80125e:	a8 01                	test   $0x1,%al
  801260:	74 11                	je     801273 <dup+0x74>
  801262:	89 d8                	mov    %ebx,%eax
  801264:	c1 e8 0c             	shr    $0xc,%eax
  801267:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80126e:	f6 c2 01             	test   $0x1,%dl
  801271:	75 39                	jne    8012ac <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801273:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801276:	89 d0                	mov    %edx,%eax
  801278:	c1 e8 0c             	shr    $0xc,%eax
  80127b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801282:	83 ec 0c             	sub    $0xc,%esp
  801285:	25 07 0e 00 00       	and    $0xe07,%eax
  80128a:	50                   	push   %eax
  80128b:	56                   	push   %esi
  80128c:	6a 00                	push   $0x0
  80128e:	52                   	push   %edx
  80128f:	6a 00                	push   $0x0
  801291:	e8 da fa ff ff       	call   800d70 <sys_page_map>
  801296:	89 c3                	mov    %eax,%ebx
  801298:	83 c4 20             	add    $0x20,%esp
  80129b:	85 c0                	test   %eax,%eax
  80129d:	78 31                	js     8012d0 <dup+0xd1>
		goto err;

	return newfdnum;
  80129f:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012a2:	89 d8                	mov    %ebx,%eax
  8012a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012a7:	5b                   	pop    %ebx
  8012a8:	5e                   	pop    %esi
  8012a9:	5f                   	pop    %edi
  8012aa:	5d                   	pop    %ebp
  8012ab:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012ac:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b3:	83 ec 0c             	sub    $0xc,%esp
  8012b6:	25 07 0e 00 00       	and    $0xe07,%eax
  8012bb:	50                   	push   %eax
  8012bc:	57                   	push   %edi
  8012bd:	6a 00                	push   $0x0
  8012bf:	53                   	push   %ebx
  8012c0:	6a 00                	push   $0x0
  8012c2:	e8 a9 fa ff ff       	call   800d70 <sys_page_map>
  8012c7:	89 c3                	mov    %eax,%ebx
  8012c9:	83 c4 20             	add    $0x20,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	79 a3                	jns    801273 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012d0:	83 ec 08             	sub    $0x8,%esp
  8012d3:	56                   	push   %esi
  8012d4:	6a 00                	push   $0x0
  8012d6:	e8 d7 fa ff ff       	call   800db2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	57                   	push   %edi
  8012df:	6a 00                	push   $0x0
  8012e1:	e8 cc fa ff ff       	call   800db2 <sys_page_unmap>
	return r;
  8012e6:	83 c4 10             	add    $0x10,%esp
  8012e9:	eb b7                	jmp    8012a2 <dup+0xa3>

008012eb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012eb:	55                   	push   %ebp
  8012ec:	89 e5                	mov    %esp,%ebp
  8012ee:	53                   	push   %ebx
  8012ef:	83 ec 1c             	sub    $0x1c,%esp
  8012f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	53                   	push   %ebx
  8012fa:	e8 7c fd ff ff       	call   80107b <fd_lookup>
  8012ff:	83 c4 10             	add    $0x10,%esp
  801302:	85 c0                	test   %eax,%eax
  801304:	78 3f                	js     801345 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801306:	83 ec 08             	sub    $0x8,%esp
  801309:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801310:	ff 30                	pushl  (%eax)
  801312:	e8 b4 fd ff ff       	call   8010cb <dev_lookup>
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	85 c0                	test   %eax,%eax
  80131c:	78 27                	js     801345 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80131e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801321:	8b 42 08             	mov    0x8(%edx),%eax
  801324:	83 e0 03             	and    $0x3,%eax
  801327:	83 f8 01             	cmp    $0x1,%eax
  80132a:	74 1e                	je     80134a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80132c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132f:	8b 40 08             	mov    0x8(%eax),%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 35                	je     80136b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801336:	83 ec 04             	sub    $0x4,%esp
  801339:	ff 75 10             	pushl  0x10(%ebp)
  80133c:	ff 75 0c             	pushl  0xc(%ebp)
  80133f:	52                   	push   %edx
  801340:	ff d0                	call   *%eax
  801342:	83 c4 10             	add    $0x10,%esp
}
  801345:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801348:	c9                   	leave  
  801349:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80134a:	a1 08 40 80 00       	mov    0x804008,%eax
  80134f:	8b 40 48             	mov    0x48(%eax),%eax
  801352:	83 ec 04             	sub    $0x4,%esp
  801355:	53                   	push   %ebx
  801356:	50                   	push   %eax
  801357:	68 95 29 80 00       	push   $0x802995
  80135c:	e8 7b ee ff ff       	call   8001dc <cprintf>
		return -E_INVAL;
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801369:	eb da                	jmp    801345 <read+0x5a>
		return -E_NOT_SUPP;
  80136b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801370:	eb d3                	jmp    801345 <read+0x5a>

00801372 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	57                   	push   %edi
  801376:	56                   	push   %esi
  801377:	53                   	push   %ebx
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80137e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801381:	bb 00 00 00 00       	mov    $0x0,%ebx
  801386:	39 f3                	cmp    %esi,%ebx
  801388:	73 23                	jae    8013ad <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80138a:	83 ec 04             	sub    $0x4,%esp
  80138d:	89 f0                	mov    %esi,%eax
  80138f:	29 d8                	sub    %ebx,%eax
  801391:	50                   	push   %eax
  801392:	89 d8                	mov    %ebx,%eax
  801394:	03 45 0c             	add    0xc(%ebp),%eax
  801397:	50                   	push   %eax
  801398:	57                   	push   %edi
  801399:	e8 4d ff ff ff       	call   8012eb <read>
		if (m < 0)
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	78 06                	js     8013ab <readn+0x39>
			return m;
		if (m == 0)
  8013a5:	74 06                	je     8013ad <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013a7:	01 c3                	add    %eax,%ebx
  8013a9:	eb db                	jmp    801386 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ab:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013ad:	89 d8                	mov    %ebx,%eax
  8013af:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013b2:	5b                   	pop    %ebx
  8013b3:	5e                   	pop    %esi
  8013b4:	5f                   	pop    %edi
  8013b5:	5d                   	pop    %ebp
  8013b6:	c3                   	ret    

008013b7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 1c             	sub    $0x1c,%esp
  8013be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	53                   	push   %ebx
  8013c6:	e8 b0 fc ff ff       	call   80107b <fd_lookup>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 3a                	js     80140c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dc:	ff 30                	pushl  (%eax)
  8013de:	e8 e8 fc ff ff       	call   8010cb <dev_lookup>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 22                	js     80140c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ed:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013f1:	74 1e                	je     801411 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013f6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013f9:	85 d2                	test   %edx,%edx
  8013fb:	74 35                	je     801432 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013fd:	83 ec 04             	sub    $0x4,%esp
  801400:	ff 75 10             	pushl  0x10(%ebp)
  801403:	ff 75 0c             	pushl  0xc(%ebp)
  801406:	50                   	push   %eax
  801407:	ff d2                	call   *%edx
  801409:	83 c4 10             	add    $0x10,%esp
}
  80140c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80140f:	c9                   	leave  
  801410:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801411:	a1 08 40 80 00       	mov    0x804008,%eax
  801416:	8b 40 48             	mov    0x48(%eax),%eax
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	53                   	push   %ebx
  80141d:	50                   	push   %eax
  80141e:	68 b1 29 80 00       	push   $0x8029b1
  801423:	e8 b4 ed ff ff       	call   8001dc <cprintf>
		return -E_INVAL;
  801428:	83 c4 10             	add    $0x10,%esp
  80142b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801430:	eb da                	jmp    80140c <write+0x55>
		return -E_NOT_SUPP;
  801432:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801437:	eb d3                	jmp    80140c <write+0x55>

00801439 <seek>:

int
seek(int fdnum, off_t offset)
{
  801439:	55                   	push   %ebp
  80143a:	89 e5                	mov    %esp,%ebp
  80143c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80143f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801442:	50                   	push   %eax
  801443:	ff 75 08             	pushl  0x8(%ebp)
  801446:	e8 30 fc ff ff       	call   80107b <fd_lookup>
  80144b:	83 c4 10             	add    $0x10,%esp
  80144e:	85 c0                	test   %eax,%eax
  801450:	78 0e                	js     801460 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801452:	8b 55 0c             	mov    0xc(%ebp),%edx
  801455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801458:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80145b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801460:	c9                   	leave  
  801461:	c3                   	ret    

00801462 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801462:	55                   	push   %ebp
  801463:	89 e5                	mov    %esp,%ebp
  801465:	53                   	push   %ebx
  801466:	83 ec 1c             	sub    $0x1c,%esp
  801469:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146f:	50                   	push   %eax
  801470:	53                   	push   %ebx
  801471:	e8 05 fc ff ff       	call   80107b <fd_lookup>
  801476:	83 c4 10             	add    $0x10,%esp
  801479:	85 c0                	test   %eax,%eax
  80147b:	78 37                	js     8014b4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147d:	83 ec 08             	sub    $0x8,%esp
  801480:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801483:	50                   	push   %eax
  801484:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801487:	ff 30                	pushl  (%eax)
  801489:	e8 3d fc ff ff       	call   8010cb <dev_lookup>
  80148e:	83 c4 10             	add    $0x10,%esp
  801491:	85 c0                	test   %eax,%eax
  801493:	78 1f                	js     8014b4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801495:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801498:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149c:	74 1b                	je     8014b9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80149e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a1:	8b 52 18             	mov    0x18(%edx),%edx
  8014a4:	85 d2                	test   %edx,%edx
  8014a6:	74 32                	je     8014da <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014a8:	83 ec 08             	sub    $0x8,%esp
  8014ab:	ff 75 0c             	pushl  0xc(%ebp)
  8014ae:	50                   	push   %eax
  8014af:	ff d2                	call   *%edx
  8014b1:	83 c4 10             	add    $0x10,%esp
}
  8014b4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b7:	c9                   	leave  
  8014b8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014b9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014be:	8b 40 48             	mov    0x48(%eax),%eax
  8014c1:	83 ec 04             	sub    $0x4,%esp
  8014c4:	53                   	push   %ebx
  8014c5:	50                   	push   %eax
  8014c6:	68 74 29 80 00       	push   $0x802974
  8014cb:	e8 0c ed ff ff       	call   8001dc <cprintf>
		return -E_INVAL;
  8014d0:	83 c4 10             	add    $0x10,%esp
  8014d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d8:	eb da                	jmp    8014b4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014df:	eb d3                	jmp    8014b4 <ftruncate+0x52>

008014e1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	53                   	push   %ebx
  8014e5:	83 ec 1c             	sub    $0x1c,%esp
  8014e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014ee:	50                   	push   %eax
  8014ef:	ff 75 08             	pushl  0x8(%ebp)
  8014f2:	e8 84 fb ff ff       	call   80107b <fd_lookup>
  8014f7:	83 c4 10             	add    $0x10,%esp
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	78 4b                	js     801549 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014fe:	83 ec 08             	sub    $0x8,%esp
  801501:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801504:	50                   	push   %eax
  801505:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801508:	ff 30                	pushl  (%eax)
  80150a:	e8 bc fb ff ff       	call   8010cb <dev_lookup>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	85 c0                	test   %eax,%eax
  801514:	78 33                	js     801549 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801516:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801519:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80151d:	74 2f                	je     80154e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80151f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801522:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801529:	00 00 00 
	stat->st_isdir = 0;
  80152c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801533:	00 00 00 
	stat->st_dev = dev;
  801536:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80153c:	83 ec 08             	sub    $0x8,%esp
  80153f:	53                   	push   %ebx
  801540:	ff 75 f0             	pushl  -0x10(%ebp)
  801543:	ff 50 14             	call   *0x14(%eax)
  801546:	83 c4 10             	add    $0x10,%esp
}
  801549:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154c:	c9                   	leave  
  80154d:	c3                   	ret    
		return -E_NOT_SUPP;
  80154e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801553:	eb f4                	jmp    801549 <fstat+0x68>

00801555 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	56                   	push   %esi
  801559:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80155a:	83 ec 08             	sub    $0x8,%esp
  80155d:	6a 00                	push   $0x0
  80155f:	ff 75 08             	pushl  0x8(%ebp)
  801562:	e8 22 02 00 00       	call   801789 <open>
  801567:	89 c3                	mov    %eax,%ebx
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 1b                	js     80158b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	ff 75 0c             	pushl  0xc(%ebp)
  801576:	50                   	push   %eax
  801577:	e8 65 ff ff ff       	call   8014e1 <fstat>
  80157c:	89 c6                	mov    %eax,%esi
	close(fd);
  80157e:	89 1c 24             	mov    %ebx,(%esp)
  801581:	e8 27 fc ff ff       	call   8011ad <close>
	return r;
  801586:	83 c4 10             	add    $0x10,%esp
  801589:	89 f3                	mov    %esi,%ebx
}
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801590:	5b                   	pop    %ebx
  801591:	5e                   	pop    %esi
  801592:	5d                   	pop    %ebp
  801593:	c3                   	ret    

00801594 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801594:	55                   	push   %ebp
  801595:	89 e5                	mov    %esp,%ebp
  801597:	56                   	push   %esi
  801598:	53                   	push   %ebx
  801599:	89 c6                	mov    %eax,%esi
  80159b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80159d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015a4:	74 27                	je     8015cd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015a6:	6a 07                	push   $0x7
  8015a8:	68 00 50 80 00       	push   $0x805000
  8015ad:	56                   	push   %esi
  8015ae:	ff 35 00 40 80 00    	pushl  0x804000
  8015b4:	e8 69 0c 00 00       	call   802222 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015b9:	83 c4 0c             	add    $0xc,%esp
  8015bc:	6a 00                	push   $0x0
  8015be:	53                   	push   %ebx
  8015bf:	6a 00                	push   $0x0
  8015c1:	e8 f3 0b 00 00       	call   8021b9 <ipc_recv>
}
  8015c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c9:	5b                   	pop    %ebx
  8015ca:	5e                   	pop    %esi
  8015cb:	5d                   	pop    %ebp
  8015cc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015cd:	83 ec 0c             	sub    $0xc,%esp
  8015d0:	6a 01                	push   $0x1
  8015d2:	e8 a3 0c 00 00       	call   80227a <ipc_find_env>
  8015d7:	a3 00 40 80 00       	mov    %eax,0x804000
  8015dc:	83 c4 10             	add    $0x10,%esp
  8015df:	eb c5                	jmp    8015a6 <fsipc+0x12>

008015e1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015e1:	55                   	push   %ebp
  8015e2:	89 e5                	mov    %esp,%ebp
  8015e4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801604:	e8 8b ff ff ff       	call   801594 <fsipc>
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <devfile_flush>:
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801611:	8b 45 08             	mov    0x8(%ebp),%eax
  801614:	8b 40 0c             	mov    0xc(%eax),%eax
  801617:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80161c:	ba 00 00 00 00       	mov    $0x0,%edx
  801621:	b8 06 00 00 00       	mov    $0x6,%eax
  801626:	e8 69 ff ff ff       	call   801594 <fsipc>
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <devfile_stat>:
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
  801630:	53                   	push   %ebx
  801631:	83 ec 04             	sub    $0x4,%esp
  801634:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801637:	8b 45 08             	mov    0x8(%ebp),%eax
  80163a:	8b 40 0c             	mov    0xc(%eax),%eax
  80163d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801642:	ba 00 00 00 00       	mov    $0x0,%edx
  801647:	b8 05 00 00 00       	mov    $0x5,%eax
  80164c:	e8 43 ff ff ff       	call   801594 <fsipc>
  801651:	85 c0                	test   %eax,%eax
  801653:	78 2c                	js     801681 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801655:	83 ec 08             	sub    $0x8,%esp
  801658:	68 00 50 80 00       	push   $0x805000
  80165d:	53                   	push   %ebx
  80165e:	e8 d8 f2 ff ff       	call   80093b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801663:	a1 80 50 80 00       	mov    0x805080,%eax
  801668:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80166e:	a1 84 50 80 00       	mov    0x805084,%eax
  801673:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801681:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <devfile_write>:
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
  80168a:	83 ec 08             	sub    $0x8,%esp
  80168d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8b 40 0c             	mov    0xc(%eax),%eax
  801696:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  80169b:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016a1:	53                   	push   %ebx
  8016a2:	ff 75 0c             	pushl  0xc(%ebp)
  8016a5:	68 08 50 80 00       	push   $0x805008
  8016aa:	e8 7c f4 ff ff       	call   800b2b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016af:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016b9:	e8 d6 fe ff ff       	call   801594 <fsipc>
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	78 0b                	js     8016d0 <devfile_write+0x4a>
	assert(r <= n);
  8016c5:	39 d8                	cmp    %ebx,%eax
  8016c7:	77 0c                	ja     8016d5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016c9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016ce:	7f 1e                	jg     8016ee <devfile_write+0x68>
}
  8016d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    
	assert(r <= n);
  8016d5:	68 e4 29 80 00       	push   $0x8029e4
  8016da:	68 eb 29 80 00       	push   $0x8029eb
  8016df:	68 98 00 00 00       	push   $0x98
  8016e4:	68 00 2a 80 00       	push   $0x802a00
  8016e9:	e8 6a 0a 00 00       	call   802158 <_panic>
	assert(r <= PGSIZE);
  8016ee:	68 0b 2a 80 00       	push   $0x802a0b
  8016f3:	68 eb 29 80 00       	push   $0x8029eb
  8016f8:	68 99 00 00 00       	push   $0x99
  8016fd:	68 00 2a 80 00       	push   $0x802a00
  801702:	e8 51 0a 00 00       	call   802158 <_panic>

00801707 <devfile_read>:
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	56                   	push   %esi
  80170b:	53                   	push   %ebx
  80170c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80170f:	8b 45 08             	mov    0x8(%ebp),%eax
  801712:	8b 40 0c             	mov    0xc(%eax),%eax
  801715:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80171a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801720:	ba 00 00 00 00       	mov    $0x0,%edx
  801725:	b8 03 00 00 00       	mov    $0x3,%eax
  80172a:	e8 65 fe ff ff       	call   801594 <fsipc>
  80172f:	89 c3                	mov    %eax,%ebx
  801731:	85 c0                	test   %eax,%eax
  801733:	78 1f                	js     801754 <devfile_read+0x4d>
	assert(r <= n);
  801735:	39 f0                	cmp    %esi,%eax
  801737:	77 24                	ja     80175d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801739:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80173e:	7f 33                	jg     801773 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801740:	83 ec 04             	sub    $0x4,%esp
  801743:	50                   	push   %eax
  801744:	68 00 50 80 00       	push   $0x805000
  801749:	ff 75 0c             	pushl  0xc(%ebp)
  80174c:	e8 78 f3 ff ff       	call   800ac9 <memmove>
	return r;
  801751:	83 c4 10             	add    $0x10,%esp
}
  801754:	89 d8                	mov    %ebx,%eax
  801756:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801759:	5b                   	pop    %ebx
  80175a:	5e                   	pop    %esi
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    
	assert(r <= n);
  80175d:	68 e4 29 80 00       	push   $0x8029e4
  801762:	68 eb 29 80 00       	push   $0x8029eb
  801767:	6a 7c                	push   $0x7c
  801769:	68 00 2a 80 00       	push   $0x802a00
  80176e:	e8 e5 09 00 00       	call   802158 <_panic>
	assert(r <= PGSIZE);
  801773:	68 0b 2a 80 00       	push   $0x802a0b
  801778:	68 eb 29 80 00       	push   $0x8029eb
  80177d:	6a 7d                	push   $0x7d
  80177f:	68 00 2a 80 00       	push   $0x802a00
  801784:	e8 cf 09 00 00       	call   802158 <_panic>

00801789 <open>:
{
  801789:	55                   	push   %ebp
  80178a:	89 e5                	mov    %esp,%ebp
  80178c:	56                   	push   %esi
  80178d:	53                   	push   %ebx
  80178e:	83 ec 1c             	sub    $0x1c,%esp
  801791:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801794:	56                   	push   %esi
  801795:	e8 68 f1 ff ff       	call   800902 <strlen>
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017a2:	7f 6c                	jg     801810 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017a4:	83 ec 0c             	sub    $0xc,%esp
  8017a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017aa:	50                   	push   %eax
  8017ab:	e8 79 f8 ff ff       	call   801029 <fd_alloc>
  8017b0:	89 c3                	mov    %eax,%ebx
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 3c                	js     8017f5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	56                   	push   %esi
  8017bd:	68 00 50 80 00       	push   $0x805000
  8017c2:	e8 74 f1 ff ff       	call   80093b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ca:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d7:	e8 b8 fd ff ff       	call   801594 <fsipc>
  8017dc:	89 c3                	mov    %eax,%ebx
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	85 c0                	test   %eax,%eax
  8017e3:	78 19                	js     8017fe <open+0x75>
	return fd2num(fd);
  8017e5:	83 ec 0c             	sub    $0xc,%esp
  8017e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017eb:	e8 12 f8 ff ff       	call   801002 <fd2num>
  8017f0:	89 c3                	mov    %eax,%ebx
  8017f2:	83 c4 10             	add    $0x10,%esp
}
  8017f5:	89 d8                	mov    %ebx,%eax
  8017f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
		fd_close(fd, 0);
  8017fe:	83 ec 08             	sub    $0x8,%esp
  801801:	6a 00                	push   $0x0
  801803:	ff 75 f4             	pushl  -0xc(%ebp)
  801806:	e8 1b f9 ff ff       	call   801126 <fd_close>
		return r;
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	eb e5                	jmp    8017f5 <open+0x6c>
		return -E_BAD_PATH;
  801810:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801815:	eb de                	jmp    8017f5 <open+0x6c>

00801817 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80181d:	ba 00 00 00 00       	mov    $0x0,%edx
  801822:	b8 08 00 00 00       	mov    $0x8,%eax
  801827:	e8 68 fd ff ff       	call   801594 <fsipc>
}
  80182c:	c9                   	leave  
  80182d:	c3                   	ret    

0080182e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80182e:	55                   	push   %ebp
  80182f:	89 e5                	mov    %esp,%ebp
  801831:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801834:	68 17 2a 80 00       	push   $0x802a17
  801839:	ff 75 0c             	pushl  0xc(%ebp)
  80183c:	e8 fa f0 ff ff       	call   80093b <strcpy>
	return 0;
}
  801841:	b8 00 00 00 00       	mov    $0x0,%eax
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <devsock_close>:
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
  80184b:	53                   	push   %ebx
  80184c:	83 ec 10             	sub    $0x10,%esp
  80184f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801852:	53                   	push   %ebx
  801853:	e8 5d 0a 00 00       	call   8022b5 <pageref>
  801858:	83 c4 10             	add    $0x10,%esp
		return 0;
  80185b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801860:	83 f8 01             	cmp    $0x1,%eax
  801863:	74 07                	je     80186c <devsock_close+0x24>
}
  801865:	89 d0                	mov    %edx,%eax
  801867:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186a:	c9                   	leave  
  80186b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80186c:	83 ec 0c             	sub    $0xc,%esp
  80186f:	ff 73 0c             	pushl  0xc(%ebx)
  801872:	e8 b9 02 00 00       	call   801b30 <nsipc_close>
  801877:	89 c2                	mov    %eax,%edx
  801879:	83 c4 10             	add    $0x10,%esp
  80187c:	eb e7                	jmp    801865 <devsock_close+0x1d>

0080187e <devsock_write>:
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801884:	6a 00                	push   $0x0
  801886:	ff 75 10             	pushl  0x10(%ebp)
  801889:	ff 75 0c             	pushl  0xc(%ebp)
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	ff 70 0c             	pushl  0xc(%eax)
  801892:	e8 76 03 00 00       	call   801c0d <nsipc_send>
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    

00801899 <devsock_read>:
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80189f:	6a 00                	push   $0x0
  8018a1:	ff 75 10             	pushl  0x10(%ebp)
  8018a4:	ff 75 0c             	pushl  0xc(%ebp)
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	ff 70 0c             	pushl  0xc(%eax)
  8018ad:	e8 ef 02 00 00       	call   801ba1 <nsipc_recv>
}
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <fd2sockid>:
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ba:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018bd:	52                   	push   %edx
  8018be:	50                   	push   %eax
  8018bf:	e8 b7 f7 ff ff       	call   80107b <fd_lookup>
  8018c4:	83 c4 10             	add    $0x10,%esp
  8018c7:	85 c0                	test   %eax,%eax
  8018c9:	78 10                	js     8018db <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ce:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018d4:	39 08                	cmp    %ecx,(%eax)
  8018d6:	75 05                	jne    8018dd <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018d8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018db:	c9                   	leave  
  8018dc:	c3                   	ret    
		return -E_NOT_SUPP;
  8018dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e2:	eb f7                	jmp    8018db <fd2sockid+0x27>

008018e4 <alloc_sockfd>:
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	56                   	push   %esi
  8018e8:	53                   	push   %ebx
  8018e9:	83 ec 1c             	sub    $0x1c,%esp
  8018ec:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018ee:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018f1:	50                   	push   %eax
  8018f2:	e8 32 f7 ff ff       	call   801029 <fd_alloc>
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	78 43                	js     801943 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801900:	83 ec 04             	sub    $0x4,%esp
  801903:	68 07 04 00 00       	push   $0x407
  801908:	ff 75 f4             	pushl  -0xc(%ebp)
  80190b:	6a 00                	push   $0x0
  80190d:	e8 1b f4 ff ff       	call   800d2d <sys_page_alloc>
  801912:	89 c3                	mov    %eax,%ebx
  801914:	83 c4 10             	add    $0x10,%esp
  801917:	85 c0                	test   %eax,%eax
  801919:	78 28                	js     801943 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801924:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801926:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801929:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801930:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801933:	83 ec 0c             	sub    $0xc,%esp
  801936:	50                   	push   %eax
  801937:	e8 c6 f6 ff ff       	call   801002 <fd2num>
  80193c:	89 c3                	mov    %eax,%ebx
  80193e:	83 c4 10             	add    $0x10,%esp
  801941:	eb 0c                	jmp    80194f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801943:	83 ec 0c             	sub    $0xc,%esp
  801946:	56                   	push   %esi
  801947:	e8 e4 01 00 00       	call   801b30 <nsipc_close>
		return r;
  80194c:	83 c4 10             	add    $0x10,%esp
}
  80194f:	89 d8                	mov    %ebx,%eax
  801951:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801954:	5b                   	pop    %ebx
  801955:	5e                   	pop    %esi
  801956:	5d                   	pop    %ebp
  801957:	c3                   	ret    

00801958 <accept>:
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	e8 4e ff ff ff       	call   8018b4 <fd2sockid>
  801966:	85 c0                	test   %eax,%eax
  801968:	78 1b                	js     801985 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80196a:	83 ec 04             	sub    $0x4,%esp
  80196d:	ff 75 10             	pushl  0x10(%ebp)
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	50                   	push   %eax
  801974:	e8 0e 01 00 00       	call   801a87 <nsipc_accept>
  801979:	83 c4 10             	add    $0x10,%esp
  80197c:	85 c0                	test   %eax,%eax
  80197e:	78 05                	js     801985 <accept+0x2d>
	return alloc_sockfd(r);
  801980:	e8 5f ff ff ff       	call   8018e4 <alloc_sockfd>
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <bind>:
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
  80198a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	e8 1f ff ff ff       	call   8018b4 <fd2sockid>
  801995:	85 c0                	test   %eax,%eax
  801997:	78 12                	js     8019ab <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801999:	83 ec 04             	sub    $0x4,%esp
  80199c:	ff 75 10             	pushl  0x10(%ebp)
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	50                   	push   %eax
  8019a3:	e8 31 01 00 00       	call   801ad9 <nsipc_bind>
  8019a8:	83 c4 10             	add    $0x10,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <shutdown>:
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b6:	e8 f9 fe ff ff       	call   8018b4 <fd2sockid>
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 0f                	js     8019ce <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019bf:	83 ec 08             	sub    $0x8,%esp
  8019c2:	ff 75 0c             	pushl  0xc(%ebp)
  8019c5:	50                   	push   %eax
  8019c6:	e8 43 01 00 00       	call   801b0e <nsipc_shutdown>
  8019cb:	83 c4 10             	add    $0x10,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <connect>:
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	e8 d6 fe ff ff       	call   8018b4 <fd2sockid>
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 12                	js     8019f4 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019e2:	83 ec 04             	sub    $0x4,%esp
  8019e5:	ff 75 10             	pushl  0x10(%ebp)
  8019e8:	ff 75 0c             	pushl  0xc(%ebp)
  8019eb:	50                   	push   %eax
  8019ec:	e8 59 01 00 00       	call   801b4a <nsipc_connect>
  8019f1:	83 c4 10             	add    $0x10,%esp
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <listen>:
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ff:	e8 b0 fe ff ff       	call   8018b4 <fd2sockid>
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 0f                	js     801a17 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	ff 75 0c             	pushl  0xc(%ebp)
  801a0e:	50                   	push   %eax
  801a0f:	e8 6b 01 00 00       	call   801b7f <nsipc_listen>
  801a14:	83 c4 10             	add    $0x10,%esp
}
  801a17:	c9                   	leave  
  801a18:	c3                   	ret    

00801a19 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a19:	55                   	push   %ebp
  801a1a:	89 e5                	mov    %esp,%ebp
  801a1c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a1f:	ff 75 10             	pushl  0x10(%ebp)
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	e8 3e 02 00 00       	call   801c6b <nsipc_socket>
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	85 c0                	test   %eax,%eax
  801a32:	78 05                	js     801a39 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a34:	e8 ab fe ff ff       	call   8018e4 <alloc_sockfd>
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
  801a3e:	53                   	push   %ebx
  801a3f:	83 ec 04             	sub    $0x4,%esp
  801a42:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a44:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a4b:	74 26                	je     801a73 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a4d:	6a 07                	push   $0x7
  801a4f:	68 00 60 80 00       	push   $0x806000
  801a54:	53                   	push   %ebx
  801a55:	ff 35 04 40 80 00    	pushl  0x804004
  801a5b:	e8 c2 07 00 00       	call   802222 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a60:	83 c4 0c             	add    $0xc,%esp
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	e8 4b 07 00 00       	call   8021b9 <ipc_recv>
}
  801a6e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a73:	83 ec 0c             	sub    $0xc,%esp
  801a76:	6a 02                	push   $0x2
  801a78:	e8 fd 07 00 00       	call   80227a <ipc_find_env>
  801a7d:	a3 04 40 80 00       	mov    %eax,0x804004
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	eb c6                	jmp    801a4d <nsipc+0x12>

00801a87 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a97:	8b 06                	mov    (%esi),%eax
  801a99:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801aa3:	e8 93 ff ff ff       	call   801a3b <nsipc>
  801aa8:	89 c3                	mov    %eax,%ebx
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	79 09                	jns    801ab7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aae:	89 d8                	mov    %ebx,%eax
  801ab0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab3:	5b                   	pop    %ebx
  801ab4:	5e                   	pop    %esi
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ab7:	83 ec 04             	sub    $0x4,%esp
  801aba:	ff 35 10 60 80 00    	pushl  0x806010
  801ac0:	68 00 60 80 00       	push   $0x806000
  801ac5:	ff 75 0c             	pushl  0xc(%ebp)
  801ac8:	e8 fc ef ff ff       	call   800ac9 <memmove>
		*addrlen = ret->ret_addrlen;
  801acd:	a1 10 60 80 00       	mov    0x806010,%eax
  801ad2:	89 06                	mov    %eax,(%esi)
  801ad4:	83 c4 10             	add    $0x10,%esp
	return r;
  801ad7:	eb d5                	jmp    801aae <nsipc_accept+0x27>

00801ad9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
  801adc:	53                   	push   %ebx
  801add:	83 ec 08             	sub    $0x8,%esp
  801ae0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aeb:	53                   	push   %ebx
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	68 04 60 80 00       	push   $0x806004
  801af4:	e8 d0 ef ff ff       	call   800ac9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801af9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aff:	b8 02 00 00 00       	mov    $0x2,%eax
  801b04:	e8 32 ff ff ff       	call   801a3b <nsipc>
}
  801b09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b0c:	c9                   	leave  
  801b0d:	c3                   	ret    

00801b0e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b0e:	55                   	push   %ebp
  801b0f:	89 e5                	mov    %esp,%ebp
  801b11:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b1f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b24:	b8 03 00 00 00       	mov    $0x3,%eax
  801b29:	e8 0d ff ff ff       	call   801a3b <nsipc>
}
  801b2e:	c9                   	leave  
  801b2f:	c3                   	ret    

00801b30 <nsipc_close>:

int
nsipc_close(int s)
{
  801b30:	55                   	push   %ebp
  801b31:	89 e5                	mov    %esp,%ebp
  801b33:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b36:	8b 45 08             	mov    0x8(%ebp),%eax
  801b39:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b3e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b43:	e8 f3 fe ff ff       	call   801a3b <nsipc>
}
  801b48:	c9                   	leave  
  801b49:	c3                   	ret    

00801b4a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
  801b4d:	53                   	push   %ebx
  801b4e:	83 ec 08             	sub    $0x8,%esp
  801b51:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b5c:	53                   	push   %ebx
  801b5d:	ff 75 0c             	pushl  0xc(%ebp)
  801b60:	68 04 60 80 00       	push   $0x806004
  801b65:	e8 5f ef ff ff       	call   800ac9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b6a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b70:	b8 05 00 00 00       	mov    $0x5,%eax
  801b75:	e8 c1 fe ff ff       	call   801a3b <nsipc>
}
  801b7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b90:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b95:	b8 06 00 00 00       	mov    $0x6,%eax
  801b9a:	e8 9c fe ff ff       	call   801a3b <nsipc>
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	56                   	push   %esi
  801ba5:	53                   	push   %ebx
  801ba6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bb1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bba:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bbf:	b8 07 00 00 00       	mov    $0x7,%eax
  801bc4:	e8 72 fe ff ff       	call   801a3b <nsipc>
  801bc9:	89 c3                	mov    %eax,%ebx
  801bcb:	85 c0                	test   %eax,%eax
  801bcd:	78 1f                	js     801bee <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bcf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801bd4:	7f 21                	jg     801bf7 <nsipc_recv+0x56>
  801bd6:	39 c6                	cmp    %eax,%esi
  801bd8:	7c 1d                	jl     801bf7 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bda:	83 ec 04             	sub    $0x4,%esp
  801bdd:	50                   	push   %eax
  801bde:	68 00 60 80 00       	push   $0x806000
  801be3:	ff 75 0c             	pushl  0xc(%ebp)
  801be6:	e8 de ee ff ff       	call   800ac9 <memmove>
  801beb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bee:	89 d8                	mov    %ebx,%eax
  801bf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bf3:	5b                   	pop    %ebx
  801bf4:	5e                   	pop    %esi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bf7:	68 23 2a 80 00       	push   $0x802a23
  801bfc:	68 eb 29 80 00       	push   $0x8029eb
  801c01:	6a 62                	push   $0x62
  801c03:	68 38 2a 80 00       	push   $0x802a38
  801c08:	e8 4b 05 00 00       	call   802158 <_panic>

00801c0d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	53                   	push   %ebx
  801c11:	83 ec 04             	sub    $0x4,%esp
  801c14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c1f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c25:	7f 2e                	jg     801c55 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c27:	83 ec 04             	sub    $0x4,%esp
  801c2a:	53                   	push   %ebx
  801c2b:	ff 75 0c             	pushl  0xc(%ebp)
  801c2e:	68 0c 60 80 00       	push   $0x80600c
  801c33:	e8 91 ee ff ff       	call   800ac9 <memmove>
	nsipcbuf.send.req_size = size;
  801c38:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c3e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c41:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c46:	b8 08 00 00 00       	mov    $0x8,%eax
  801c4b:	e8 eb fd ff ff       	call   801a3b <nsipc>
}
  801c50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    
	assert(size < 1600);
  801c55:	68 44 2a 80 00       	push   $0x802a44
  801c5a:	68 eb 29 80 00       	push   $0x8029eb
  801c5f:	6a 6d                	push   $0x6d
  801c61:	68 38 2a 80 00       	push   $0x802a38
  801c66:	e8 ed 04 00 00       	call   802158 <_panic>

00801c6b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c7c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c81:	8b 45 10             	mov    0x10(%ebp),%eax
  801c84:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c89:	b8 09 00 00 00       	mov    $0x9,%eax
  801c8e:	e8 a8 fd ff ff       	call   801a3b <nsipc>
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
  801c98:	56                   	push   %esi
  801c99:	53                   	push   %ebx
  801c9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c9d:	83 ec 0c             	sub    $0xc,%esp
  801ca0:	ff 75 08             	pushl  0x8(%ebp)
  801ca3:	e8 6a f3 ff ff       	call   801012 <fd2data>
  801ca8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801caa:	83 c4 08             	add    $0x8,%esp
  801cad:	68 50 2a 80 00       	push   $0x802a50
  801cb2:	53                   	push   %ebx
  801cb3:	e8 83 ec ff ff       	call   80093b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cb8:	8b 46 04             	mov    0x4(%esi),%eax
  801cbb:	2b 06                	sub    (%esi),%eax
  801cbd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cc3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cca:	00 00 00 
	stat->st_dev = &devpipe;
  801ccd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801cd4:	30 80 00 
	return 0;
}
  801cd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    

00801ce3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	53                   	push   %ebx
  801ce7:	83 ec 0c             	sub    $0xc,%esp
  801cea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ced:	53                   	push   %ebx
  801cee:	6a 00                	push   $0x0
  801cf0:	e8 bd f0 ff ff       	call   800db2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cf5:	89 1c 24             	mov    %ebx,(%esp)
  801cf8:	e8 15 f3 ff ff       	call   801012 <fd2data>
  801cfd:	83 c4 08             	add    $0x8,%esp
  801d00:	50                   	push   %eax
  801d01:	6a 00                	push   $0x0
  801d03:	e8 aa f0 ff ff       	call   800db2 <sys_page_unmap>
}
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <_pipeisclosed>:
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
  801d10:	57                   	push   %edi
  801d11:	56                   	push   %esi
  801d12:	53                   	push   %ebx
  801d13:	83 ec 1c             	sub    $0x1c,%esp
  801d16:	89 c7                	mov    %eax,%edi
  801d18:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d1a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d1f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	57                   	push   %edi
  801d26:	e8 8a 05 00 00       	call   8022b5 <pageref>
  801d2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d2e:	89 34 24             	mov    %esi,(%esp)
  801d31:	e8 7f 05 00 00       	call   8022b5 <pageref>
		nn = thisenv->env_runs;
  801d36:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d3c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d3f:	83 c4 10             	add    $0x10,%esp
  801d42:	39 cb                	cmp    %ecx,%ebx
  801d44:	74 1b                	je     801d61 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d46:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d49:	75 cf                	jne    801d1a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d4b:	8b 42 58             	mov    0x58(%edx),%eax
  801d4e:	6a 01                	push   $0x1
  801d50:	50                   	push   %eax
  801d51:	53                   	push   %ebx
  801d52:	68 57 2a 80 00       	push   $0x802a57
  801d57:	e8 80 e4 ff ff       	call   8001dc <cprintf>
  801d5c:	83 c4 10             	add    $0x10,%esp
  801d5f:	eb b9                	jmp    801d1a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d61:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d64:	0f 94 c0             	sete   %al
  801d67:	0f b6 c0             	movzbl %al,%eax
}
  801d6a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d6d:	5b                   	pop    %ebx
  801d6e:	5e                   	pop    %esi
  801d6f:	5f                   	pop    %edi
  801d70:	5d                   	pop    %ebp
  801d71:	c3                   	ret    

00801d72 <devpipe_write>:
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	57                   	push   %edi
  801d76:	56                   	push   %esi
  801d77:	53                   	push   %ebx
  801d78:	83 ec 28             	sub    $0x28,%esp
  801d7b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d7e:	56                   	push   %esi
  801d7f:	e8 8e f2 ff ff       	call   801012 <fd2data>
  801d84:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d86:	83 c4 10             	add    $0x10,%esp
  801d89:	bf 00 00 00 00       	mov    $0x0,%edi
  801d8e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d91:	74 4f                	je     801de2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d93:	8b 43 04             	mov    0x4(%ebx),%eax
  801d96:	8b 0b                	mov    (%ebx),%ecx
  801d98:	8d 51 20             	lea    0x20(%ecx),%edx
  801d9b:	39 d0                	cmp    %edx,%eax
  801d9d:	72 14                	jb     801db3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d9f:	89 da                	mov    %ebx,%edx
  801da1:	89 f0                	mov    %esi,%eax
  801da3:	e8 65 ff ff ff       	call   801d0d <_pipeisclosed>
  801da8:	85 c0                	test   %eax,%eax
  801daa:	75 3b                	jne    801de7 <devpipe_write+0x75>
			sys_yield();
  801dac:	e8 5d ef ff ff       	call   800d0e <sys_yield>
  801db1:	eb e0                	jmp    801d93 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801db3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801db6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dba:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dbd:	89 c2                	mov    %eax,%edx
  801dbf:	c1 fa 1f             	sar    $0x1f,%edx
  801dc2:	89 d1                	mov    %edx,%ecx
  801dc4:	c1 e9 1b             	shr    $0x1b,%ecx
  801dc7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dca:	83 e2 1f             	and    $0x1f,%edx
  801dcd:	29 ca                	sub    %ecx,%edx
  801dcf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801dd3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801dd7:	83 c0 01             	add    $0x1,%eax
  801dda:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ddd:	83 c7 01             	add    $0x1,%edi
  801de0:	eb ac                	jmp    801d8e <devpipe_write+0x1c>
	return i;
  801de2:	8b 45 10             	mov    0x10(%ebp),%eax
  801de5:	eb 05                	jmp    801dec <devpipe_write+0x7a>
				return 0;
  801de7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801def:	5b                   	pop    %ebx
  801df0:	5e                   	pop    %esi
  801df1:	5f                   	pop    %edi
  801df2:	5d                   	pop    %ebp
  801df3:	c3                   	ret    

00801df4 <devpipe_read>:
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	57                   	push   %edi
  801df8:	56                   	push   %esi
  801df9:	53                   	push   %ebx
  801dfa:	83 ec 18             	sub    $0x18,%esp
  801dfd:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e00:	57                   	push   %edi
  801e01:	e8 0c f2 ff ff       	call   801012 <fd2data>
  801e06:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e08:	83 c4 10             	add    $0x10,%esp
  801e0b:	be 00 00 00 00       	mov    $0x0,%esi
  801e10:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e13:	75 14                	jne    801e29 <devpipe_read+0x35>
	return i;
  801e15:	8b 45 10             	mov    0x10(%ebp),%eax
  801e18:	eb 02                	jmp    801e1c <devpipe_read+0x28>
				return i;
  801e1a:	89 f0                	mov    %esi,%eax
}
  801e1c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1f:	5b                   	pop    %ebx
  801e20:	5e                   	pop    %esi
  801e21:	5f                   	pop    %edi
  801e22:	5d                   	pop    %ebp
  801e23:	c3                   	ret    
			sys_yield();
  801e24:	e8 e5 ee ff ff       	call   800d0e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e29:	8b 03                	mov    (%ebx),%eax
  801e2b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e2e:	75 18                	jne    801e48 <devpipe_read+0x54>
			if (i > 0)
  801e30:	85 f6                	test   %esi,%esi
  801e32:	75 e6                	jne    801e1a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e34:	89 da                	mov    %ebx,%edx
  801e36:	89 f8                	mov    %edi,%eax
  801e38:	e8 d0 fe ff ff       	call   801d0d <_pipeisclosed>
  801e3d:	85 c0                	test   %eax,%eax
  801e3f:	74 e3                	je     801e24 <devpipe_read+0x30>
				return 0;
  801e41:	b8 00 00 00 00       	mov    $0x0,%eax
  801e46:	eb d4                	jmp    801e1c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e48:	99                   	cltd   
  801e49:	c1 ea 1b             	shr    $0x1b,%edx
  801e4c:	01 d0                	add    %edx,%eax
  801e4e:	83 e0 1f             	and    $0x1f,%eax
  801e51:	29 d0                	sub    %edx,%eax
  801e53:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e5b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e5e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e61:	83 c6 01             	add    $0x1,%esi
  801e64:	eb aa                	jmp    801e10 <devpipe_read+0x1c>

00801e66 <pipe>:
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	56                   	push   %esi
  801e6a:	53                   	push   %ebx
  801e6b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e6e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e71:	50                   	push   %eax
  801e72:	e8 b2 f1 ff ff       	call   801029 <fd_alloc>
  801e77:	89 c3                	mov    %eax,%ebx
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	0f 88 23 01 00 00    	js     801fa7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e84:	83 ec 04             	sub    $0x4,%esp
  801e87:	68 07 04 00 00       	push   $0x407
  801e8c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8f:	6a 00                	push   $0x0
  801e91:	e8 97 ee ff ff       	call   800d2d <sys_page_alloc>
  801e96:	89 c3                	mov    %eax,%ebx
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	85 c0                	test   %eax,%eax
  801e9d:	0f 88 04 01 00 00    	js     801fa7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ea3:	83 ec 0c             	sub    $0xc,%esp
  801ea6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ea9:	50                   	push   %eax
  801eaa:	e8 7a f1 ff ff       	call   801029 <fd_alloc>
  801eaf:	89 c3                	mov    %eax,%ebx
  801eb1:	83 c4 10             	add    $0x10,%esp
  801eb4:	85 c0                	test   %eax,%eax
  801eb6:	0f 88 db 00 00 00    	js     801f97 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebc:	83 ec 04             	sub    $0x4,%esp
  801ebf:	68 07 04 00 00       	push   $0x407
  801ec4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec7:	6a 00                	push   $0x0
  801ec9:	e8 5f ee ff ff       	call   800d2d <sys_page_alloc>
  801ece:	89 c3                	mov    %eax,%ebx
  801ed0:	83 c4 10             	add    $0x10,%esp
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	0f 88 bc 00 00 00    	js     801f97 <pipe+0x131>
	va = fd2data(fd0);
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee1:	e8 2c f1 ff ff       	call   801012 <fd2data>
  801ee6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee8:	83 c4 0c             	add    $0xc,%esp
  801eeb:	68 07 04 00 00       	push   $0x407
  801ef0:	50                   	push   %eax
  801ef1:	6a 00                	push   $0x0
  801ef3:	e8 35 ee ff ff       	call   800d2d <sys_page_alloc>
  801ef8:	89 c3                	mov    %eax,%ebx
  801efa:	83 c4 10             	add    $0x10,%esp
  801efd:	85 c0                	test   %eax,%eax
  801eff:	0f 88 82 00 00 00    	js     801f87 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0b:	e8 02 f1 ff ff       	call   801012 <fd2data>
  801f10:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f17:	50                   	push   %eax
  801f18:	6a 00                	push   $0x0
  801f1a:	56                   	push   %esi
  801f1b:	6a 00                	push   $0x0
  801f1d:	e8 4e ee ff ff       	call   800d70 <sys_page_map>
  801f22:	89 c3                	mov    %eax,%ebx
  801f24:	83 c4 20             	add    $0x20,%esp
  801f27:	85 c0                	test   %eax,%eax
  801f29:	78 4e                	js     801f79 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f2b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f30:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f33:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f38:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f3f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f42:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f47:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	ff 75 f4             	pushl  -0xc(%ebp)
  801f54:	e8 a9 f0 ff ff       	call   801002 <fd2num>
  801f59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f5c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f5e:	83 c4 04             	add    $0x4,%esp
  801f61:	ff 75 f0             	pushl  -0x10(%ebp)
  801f64:	e8 99 f0 ff ff       	call   801002 <fd2num>
  801f69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f6f:	83 c4 10             	add    $0x10,%esp
  801f72:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f77:	eb 2e                	jmp    801fa7 <pipe+0x141>
	sys_page_unmap(0, va);
  801f79:	83 ec 08             	sub    $0x8,%esp
  801f7c:	56                   	push   %esi
  801f7d:	6a 00                	push   $0x0
  801f7f:	e8 2e ee ff ff       	call   800db2 <sys_page_unmap>
  801f84:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f87:	83 ec 08             	sub    $0x8,%esp
  801f8a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 1e ee ff ff       	call   800db2 <sys_page_unmap>
  801f94:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f97:	83 ec 08             	sub    $0x8,%esp
  801f9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9d:	6a 00                	push   $0x0
  801f9f:	e8 0e ee ff ff       	call   800db2 <sys_page_unmap>
  801fa4:	83 c4 10             	add    $0x10,%esp
}
  801fa7:	89 d8                	mov    %ebx,%eax
  801fa9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fac:	5b                   	pop    %ebx
  801fad:	5e                   	pop    %esi
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    

00801fb0 <pipeisclosed>:
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fb9:	50                   	push   %eax
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	e8 b9 f0 ff ff       	call   80107b <fd_lookup>
  801fc2:	83 c4 10             	add    $0x10,%esp
  801fc5:	85 c0                	test   %eax,%eax
  801fc7:	78 18                	js     801fe1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fc9:	83 ec 0c             	sub    $0xc,%esp
  801fcc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fcf:	e8 3e f0 ff ff       	call   801012 <fd2data>
	return _pipeisclosed(fd, p);
  801fd4:	89 c2                	mov    %eax,%edx
  801fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd9:	e8 2f fd ff ff       	call   801d0d <_pipeisclosed>
  801fde:	83 c4 10             	add    $0x10,%esp
}
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801fe3:	b8 00 00 00 00       	mov    $0x0,%eax
  801fe8:	c3                   	ret    

00801fe9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fe9:	55                   	push   %ebp
  801fea:	89 e5                	mov    %esp,%ebp
  801fec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fef:	68 6f 2a 80 00       	push   $0x802a6f
  801ff4:	ff 75 0c             	pushl  0xc(%ebp)
  801ff7:	e8 3f e9 ff ff       	call   80093b <strcpy>
	return 0;
}
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	c9                   	leave  
  802002:	c3                   	ret    

00802003 <devcons_write>:
{
  802003:	55                   	push   %ebp
  802004:	89 e5                	mov    %esp,%ebp
  802006:	57                   	push   %edi
  802007:	56                   	push   %esi
  802008:	53                   	push   %ebx
  802009:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80200f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802014:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80201a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80201d:	73 31                	jae    802050 <devcons_write+0x4d>
		m = n - tot;
  80201f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802022:	29 f3                	sub    %esi,%ebx
  802024:	83 fb 7f             	cmp    $0x7f,%ebx
  802027:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80202c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	53                   	push   %ebx
  802033:	89 f0                	mov    %esi,%eax
  802035:	03 45 0c             	add    0xc(%ebp),%eax
  802038:	50                   	push   %eax
  802039:	57                   	push   %edi
  80203a:	e8 8a ea ff ff       	call   800ac9 <memmove>
		sys_cputs(buf, m);
  80203f:	83 c4 08             	add    $0x8,%esp
  802042:	53                   	push   %ebx
  802043:	57                   	push   %edi
  802044:	e8 28 ec ff ff       	call   800c71 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802049:	01 de                	add    %ebx,%esi
  80204b:	83 c4 10             	add    $0x10,%esp
  80204e:	eb ca                	jmp    80201a <devcons_write+0x17>
}
  802050:	89 f0                	mov    %esi,%eax
  802052:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802055:	5b                   	pop    %ebx
  802056:	5e                   	pop    %esi
  802057:	5f                   	pop    %edi
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <devcons_read>:
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 08             	sub    $0x8,%esp
  802060:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802065:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802069:	74 21                	je     80208c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80206b:	e8 1f ec ff ff       	call   800c8f <sys_cgetc>
  802070:	85 c0                	test   %eax,%eax
  802072:	75 07                	jne    80207b <devcons_read+0x21>
		sys_yield();
  802074:	e8 95 ec ff ff       	call   800d0e <sys_yield>
  802079:	eb f0                	jmp    80206b <devcons_read+0x11>
	if (c < 0)
  80207b:	78 0f                	js     80208c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80207d:	83 f8 04             	cmp    $0x4,%eax
  802080:	74 0c                	je     80208e <devcons_read+0x34>
	*(char*)vbuf = c;
  802082:	8b 55 0c             	mov    0xc(%ebp),%edx
  802085:	88 02                	mov    %al,(%edx)
	return 1;
  802087:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    
		return 0;
  80208e:	b8 00 00 00 00       	mov    $0x0,%eax
  802093:	eb f7                	jmp    80208c <devcons_read+0x32>

00802095 <cputchar>:
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020a1:	6a 01                	push   $0x1
  8020a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020a6:	50                   	push   %eax
  8020a7:	e8 c5 eb ff ff       	call   800c71 <sys_cputs>
}
  8020ac:	83 c4 10             	add    $0x10,%esp
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <getchar>:
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020b7:	6a 01                	push   $0x1
  8020b9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020bc:	50                   	push   %eax
  8020bd:	6a 00                	push   $0x0
  8020bf:	e8 27 f2 ff ff       	call   8012eb <read>
	if (r < 0)
  8020c4:	83 c4 10             	add    $0x10,%esp
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	78 06                	js     8020d1 <getchar+0x20>
	if (r < 1)
  8020cb:	74 06                	je     8020d3 <getchar+0x22>
	return c;
  8020cd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020d1:	c9                   	leave  
  8020d2:	c3                   	ret    
		return -E_EOF;
  8020d3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020d8:	eb f7                	jmp    8020d1 <getchar+0x20>

008020da <iscons>:
{
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020e3:	50                   	push   %eax
  8020e4:	ff 75 08             	pushl  0x8(%ebp)
  8020e7:	e8 8f ef ff ff       	call   80107b <fd_lookup>
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	85 c0                	test   %eax,%eax
  8020f1:	78 11                	js     802104 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f6:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020fc:	39 10                	cmp    %edx,(%eax)
  8020fe:	0f 94 c0             	sete   %al
  802101:	0f b6 c0             	movzbl %al,%eax
}
  802104:	c9                   	leave  
  802105:	c3                   	ret    

00802106 <opencons>:
{
  802106:	55                   	push   %ebp
  802107:	89 e5                	mov    %esp,%ebp
  802109:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80210c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210f:	50                   	push   %eax
  802110:	e8 14 ef ff ff       	call   801029 <fd_alloc>
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	85 c0                	test   %eax,%eax
  80211a:	78 3a                	js     802156 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80211c:	83 ec 04             	sub    $0x4,%esp
  80211f:	68 07 04 00 00       	push   $0x407
  802124:	ff 75 f4             	pushl  -0xc(%ebp)
  802127:	6a 00                	push   $0x0
  802129:	e8 ff eb ff ff       	call   800d2d <sys_page_alloc>
  80212e:	83 c4 10             	add    $0x10,%esp
  802131:	85 c0                	test   %eax,%eax
  802133:	78 21                	js     802156 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802138:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80213e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802143:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80214a:	83 ec 0c             	sub    $0xc,%esp
  80214d:	50                   	push   %eax
  80214e:	e8 af ee ff ff       	call   801002 <fd2num>
  802153:	83 c4 10             	add    $0x10,%esp
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    

00802158 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802158:	55                   	push   %ebp
  802159:	89 e5                	mov    %esp,%ebp
  80215b:	56                   	push   %esi
  80215c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80215d:	a1 08 40 80 00       	mov    0x804008,%eax
  802162:	8b 40 48             	mov    0x48(%eax),%eax
  802165:	83 ec 04             	sub    $0x4,%esp
  802168:	68 a0 2a 80 00       	push   $0x802aa0
  80216d:	50                   	push   %eax
  80216e:	68 98 25 80 00       	push   $0x802598
  802173:	e8 64 e0 ff ff       	call   8001dc <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802178:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80217b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802181:	e8 69 eb ff ff       	call   800cef <sys_getenvid>
  802186:	83 c4 04             	add    $0x4,%esp
  802189:	ff 75 0c             	pushl  0xc(%ebp)
  80218c:	ff 75 08             	pushl  0x8(%ebp)
  80218f:	56                   	push   %esi
  802190:	50                   	push   %eax
  802191:	68 7c 2a 80 00       	push   $0x802a7c
  802196:	e8 41 e0 ff ff       	call   8001dc <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80219b:	83 c4 18             	add    $0x18,%esp
  80219e:	53                   	push   %ebx
  80219f:	ff 75 10             	pushl  0x10(%ebp)
  8021a2:	e8 e4 df ff ff       	call   80018b <vcprintf>
	cprintf("\n");
  8021a7:	c7 04 24 5c 25 80 00 	movl   $0x80255c,(%esp)
  8021ae:	e8 29 e0 ff ff       	call   8001dc <cprintf>
  8021b3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021b6:	cc                   	int3   
  8021b7:	eb fd                	jmp    8021b6 <_panic+0x5e>

008021b9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021b9:	55                   	push   %ebp
  8021ba:	89 e5                	mov    %esp,%ebp
  8021bc:	56                   	push   %esi
  8021bd:	53                   	push   %ebx
  8021be:	8b 75 08             	mov    0x8(%ebp),%esi
  8021c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  8021c7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021c9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021ce:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021d1:	83 ec 0c             	sub    $0xc,%esp
  8021d4:	50                   	push   %eax
  8021d5:	e8 03 ed ff ff       	call   800edd <sys_ipc_recv>
	if(ret < 0){
  8021da:	83 c4 10             	add    $0x10,%esp
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	78 2b                	js     80220c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021e1:	85 f6                	test   %esi,%esi
  8021e3:	74 0a                	je     8021ef <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021e5:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ea:	8b 40 74             	mov    0x74(%eax),%eax
  8021ed:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021ef:	85 db                	test   %ebx,%ebx
  8021f1:	74 0a                	je     8021fd <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021f3:	a1 08 40 80 00       	mov    0x804008,%eax
  8021f8:	8b 40 78             	mov    0x78(%eax),%eax
  8021fb:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021fd:	a1 08 40 80 00       	mov    0x804008,%eax
  802202:	8b 40 70             	mov    0x70(%eax),%eax
}
  802205:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802208:	5b                   	pop    %ebx
  802209:	5e                   	pop    %esi
  80220a:	5d                   	pop    %ebp
  80220b:	c3                   	ret    
		if(from_env_store)
  80220c:	85 f6                	test   %esi,%esi
  80220e:	74 06                	je     802216 <ipc_recv+0x5d>
			*from_env_store = 0;
  802210:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802216:	85 db                	test   %ebx,%ebx
  802218:	74 eb                	je     802205 <ipc_recv+0x4c>
			*perm_store = 0;
  80221a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802220:	eb e3                	jmp    802205 <ipc_recv+0x4c>

00802222 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	57                   	push   %edi
  802226:	56                   	push   %esi
  802227:	53                   	push   %ebx
  802228:	83 ec 0c             	sub    $0xc,%esp
  80222b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80222e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802231:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802234:	85 db                	test   %ebx,%ebx
  802236:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80223b:	0f 44 d8             	cmove  %eax,%ebx
  80223e:	eb 05                	jmp    802245 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802240:	e8 c9 ea ff ff       	call   800d0e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802245:	ff 75 14             	pushl  0x14(%ebp)
  802248:	53                   	push   %ebx
  802249:	56                   	push   %esi
  80224a:	57                   	push   %edi
  80224b:	e8 6a ec ff ff       	call   800eba <sys_ipc_try_send>
  802250:	83 c4 10             	add    $0x10,%esp
  802253:	85 c0                	test   %eax,%eax
  802255:	74 1b                	je     802272 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802257:	79 e7                	jns    802240 <ipc_send+0x1e>
  802259:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80225c:	74 e2                	je     802240 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80225e:	83 ec 04             	sub    $0x4,%esp
  802261:	68 a7 2a 80 00       	push   $0x802aa7
  802266:	6a 4a                	push   $0x4a
  802268:	68 bc 2a 80 00       	push   $0x802abc
  80226d:	e8 e6 fe ff ff       	call   802158 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802275:	5b                   	pop    %ebx
  802276:	5e                   	pop    %esi
  802277:	5f                   	pop    %edi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    

0080227a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80227a:	55                   	push   %ebp
  80227b:	89 e5                	mov    %esp,%ebp
  80227d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802280:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802285:	89 c2                	mov    %eax,%edx
  802287:	c1 e2 07             	shl    $0x7,%edx
  80228a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  802290:	8b 52 50             	mov    0x50(%edx),%edx
  802293:	39 ca                	cmp    %ecx,%edx
  802295:	74 11                	je     8022a8 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802297:	83 c0 01             	add    $0x1,%eax
  80229a:	3d 00 04 00 00       	cmp    $0x400,%eax
  80229f:	75 e4                	jne    802285 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a6:	eb 0b                	jmp    8022b3 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022a8:	c1 e0 07             	shl    $0x7,%eax
  8022ab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022b0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022b3:	5d                   	pop    %ebp
  8022b4:	c3                   	ret    

008022b5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022bb:	89 d0                	mov    %edx,%eax
  8022bd:	c1 e8 16             	shr    $0x16,%eax
  8022c0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022c7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022cc:	f6 c1 01             	test   $0x1,%cl
  8022cf:	74 1d                	je     8022ee <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022d1:	c1 ea 0c             	shr    $0xc,%edx
  8022d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022db:	f6 c2 01             	test   $0x1,%dl
  8022de:	74 0e                	je     8022ee <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022e0:	c1 ea 0c             	shr    $0xc,%edx
  8022e3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022ea:	ef 
  8022eb:	0f b7 c0             	movzwl %ax,%eax
}
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    

008022f0 <__udivdi3>:
  8022f0:	55                   	push   %ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 1c             	sub    $0x1c,%esp
  8022f7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022fb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  802303:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802307:	85 d2                	test   %edx,%edx
  802309:	75 4d                	jne    802358 <__udivdi3+0x68>
  80230b:	39 f3                	cmp    %esi,%ebx
  80230d:	76 19                	jbe    802328 <__udivdi3+0x38>
  80230f:	31 ff                	xor    %edi,%edi
  802311:	89 e8                	mov    %ebp,%eax
  802313:	89 f2                	mov    %esi,%edx
  802315:	f7 f3                	div    %ebx
  802317:	89 fa                	mov    %edi,%edx
  802319:	83 c4 1c             	add    $0x1c,%esp
  80231c:	5b                   	pop    %ebx
  80231d:	5e                   	pop    %esi
  80231e:	5f                   	pop    %edi
  80231f:	5d                   	pop    %ebp
  802320:	c3                   	ret    
  802321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802328:	89 d9                	mov    %ebx,%ecx
  80232a:	85 db                	test   %ebx,%ebx
  80232c:	75 0b                	jne    802339 <__udivdi3+0x49>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	31 d2                	xor    %edx,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 c1                	mov    %eax,%ecx
  802339:	31 d2                	xor    %edx,%edx
  80233b:	89 f0                	mov    %esi,%eax
  80233d:	f7 f1                	div    %ecx
  80233f:	89 c6                	mov    %eax,%esi
  802341:	89 e8                	mov    %ebp,%eax
  802343:	89 f7                	mov    %esi,%edi
  802345:	f7 f1                	div    %ecx
  802347:	89 fa                	mov    %edi,%edx
  802349:	83 c4 1c             	add    $0x1c,%esp
  80234c:	5b                   	pop    %ebx
  80234d:	5e                   	pop    %esi
  80234e:	5f                   	pop    %edi
  80234f:	5d                   	pop    %ebp
  802350:	c3                   	ret    
  802351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802358:	39 f2                	cmp    %esi,%edx
  80235a:	77 1c                	ja     802378 <__udivdi3+0x88>
  80235c:	0f bd fa             	bsr    %edx,%edi
  80235f:	83 f7 1f             	xor    $0x1f,%edi
  802362:	75 2c                	jne    802390 <__udivdi3+0xa0>
  802364:	39 f2                	cmp    %esi,%edx
  802366:	72 06                	jb     80236e <__udivdi3+0x7e>
  802368:	31 c0                	xor    %eax,%eax
  80236a:	39 eb                	cmp    %ebp,%ebx
  80236c:	77 a9                	ja     802317 <__udivdi3+0x27>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	eb a2                	jmp    802317 <__udivdi3+0x27>
  802375:	8d 76 00             	lea    0x0(%esi),%esi
  802378:	31 ff                	xor    %edi,%edi
  80237a:	31 c0                	xor    %eax,%eax
  80237c:	89 fa                	mov    %edi,%edx
  80237e:	83 c4 1c             	add    $0x1c,%esp
  802381:	5b                   	pop    %ebx
  802382:	5e                   	pop    %esi
  802383:	5f                   	pop    %edi
  802384:	5d                   	pop    %ebp
  802385:	c3                   	ret    
  802386:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80238d:	8d 76 00             	lea    0x0(%esi),%esi
  802390:	89 f9                	mov    %edi,%ecx
  802392:	b8 20 00 00 00       	mov    $0x20,%eax
  802397:	29 f8                	sub    %edi,%eax
  802399:	d3 e2                	shl    %cl,%edx
  80239b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80239f:	89 c1                	mov    %eax,%ecx
  8023a1:	89 da                	mov    %ebx,%edx
  8023a3:	d3 ea                	shr    %cl,%edx
  8023a5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023a9:	09 d1                	or     %edx,%ecx
  8023ab:	89 f2                	mov    %esi,%edx
  8023ad:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023b1:	89 f9                	mov    %edi,%ecx
  8023b3:	d3 e3                	shl    %cl,%ebx
  8023b5:	89 c1                	mov    %eax,%ecx
  8023b7:	d3 ea                	shr    %cl,%edx
  8023b9:	89 f9                	mov    %edi,%ecx
  8023bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023bf:	89 eb                	mov    %ebp,%ebx
  8023c1:	d3 e6                	shl    %cl,%esi
  8023c3:	89 c1                	mov    %eax,%ecx
  8023c5:	d3 eb                	shr    %cl,%ebx
  8023c7:	09 de                	or     %ebx,%esi
  8023c9:	89 f0                	mov    %esi,%eax
  8023cb:	f7 74 24 08          	divl   0x8(%esp)
  8023cf:	89 d6                	mov    %edx,%esi
  8023d1:	89 c3                	mov    %eax,%ebx
  8023d3:	f7 64 24 0c          	mull   0xc(%esp)
  8023d7:	39 d6                	cmp    %edx,%esi
  8023d9:	72 15                	jb     8023f0 <__udivdi3+0x100>
  8023db:	89 f9                	mov    %edi,%ecx
  8023dd:	d3 e5                	shl    %cl,%ebp
  8023df:	39 c5                	cmp    %eax,%ebp
  8023e1:	73 04                	jae    8023e7 <__udivdi3+0xf7>
  8023e3:	39 d6                	cmp    %edx,%esi
  8023e5:	74 09                	je     8023f0 <__udivdi3+0x100>
  8023e7:	89 d8                	mov    %ebx,%eax
  8023e9:	31 ff                	xor    %edi,%edi
  8023eb:	e9 27 ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023f0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023f3:	31 ff                	xor    %edi,%edi
  8023f5:	e9 1d ff ff ff       	jmp    802317 <__udivdi3+0x27>
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	66 90                	xchg   %ax,%ax
  8023fe:	66 90                	xchg   %ax,%ax

00802400 <__umoddi3>:
  802400:	55                   	push   %ebp
  802401:	57                   	push   %edi
  802402:	56                   	push   %esi
  802403:	53                   	push   %ebx
  802404:	83 ec 1c             	sub    $0x1c,%esp
  802407:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80240b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80240f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802413:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802417:	89 da                	mov    %ebx,%edx
  802419:	85 c0                	test   %eax,%eax
  80241b:	75 43                	jne    802460 <__umoddi3+0x60>
  80241d:	39 df                	cmp    %ebx,%edi
  80241f:	76 17                	jbe    802438 <__umoddi3+0x38>
  802421:	89 f0                	mov    %esi,%eax
  802423:	f7 f7                	div    %edi
  802425:	89 d0                	mov    %edx,%eax
  802427:	31 d2                	xor    %edx,%edx
  802429:	83 c4 1c             	add    $0x1c,%esp
  80242c:	5b                   	pop    %ebx
  80242d:	5e                   	pop    %esi
  80242e:	5f                   	pop    %edi
  80242f:	5d                   	pop    %ebp
  802430:	c3                   	ret    
  802431:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802438:	89 fd                	mov    %edi,%ebp
  80243a:	85 ff                	test   %edi,%edi
  80243c:	75 0b                	jne    802449 <__umoddi3+0x49>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	31 d2                	xor    %edx,%edx
  802445:	f7 f7                	div    %edi
  802447:	89 c5                	mov    %eax,%ebp
  802449:	89 d8                	mov    %ebx,%eax
  80244b:	31 d2                	xor    %edx,%edx
  80244d:	f7 f5                	div    %ebp
  80244f:	89 f0                	mov    %esi,%eax
  802451:	f7 f5                	div    %ebp
  802453:	89 d0                	mov    %edx,%eax
  802455:	eb d0                	jmp    802427 <__umoddi3+0x27>
  802457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245e:	66 90                	xchg   %ax,%ax
  802460:	89 f1                	mov    %esi,%ecx
  802462:	39 d8                	cmp    %ebx,%eax
  802464:	76 0a                	jbe    802470 <__umoddi3+0x70>
  802466:	89 f0                	mov    %esi,%eax
  802468:	83 c4 1c             	add    $0x1c,%esp
  80246b:	5b                   	pop    %ebx
  80246c:	5e                   	pop    %esi
  80246d:	5f                   	pop    %edi
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    
  802470:	0f bd e8             	bsr    %eax,%ebp
  802473:	83 f5 1f             	xor    $0x1f,%ebp
  802476:	75 20                	jne    802498 <__umoddi3+0x98>
  802478:	39 d8                	cmp    %ebx,%eax
  80247a:	0f 82 b0 00 00 00    	jb     802530 <__umoddi3+0x130>
  802480:	39 f7                	cmp    %esi,%edi
  802482:	0f 86 a8 00 00 00    	jbe    802530 <__umoddi3+0x130>
  802488:	89 c8                	mov    %ecx,%eax
  80248a:	83 c4 1c             	add    $0x1c,%esp
  80248d:	5b                   	pop    %ebx
  80248e:	5e                   	pop    %esi
  80248f:	5f                   	pop    %edi
  802490:	5d                   	pop    %ebp
  802491:	c3                   	ret    
  802492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	ba 20 00 00 00       	mov    $0x20,%edx
  80249f:	29 ea                	sub    %ebp,%edx
  8024a1:	d3 e0                	shl    %cl,%eax
  8024a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a7:	89 d1                	mov    %edx,%ecx
  8024a9:	89 f8                	mov    %edi,%eax
  8024ab:	d3 e8                	shr    %cl,%eax
  8024ad:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024b1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024b5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024b9:	09 c1                	or     %eax,%ecx
  8024bb:	89 d8                	mov    %ebx,%eax
  8024bd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024c1:	89 e9                	mov    %ebp,%ecx
  8024c3:	d3 e7                	shl    %cl,%edi
  8024c5:	89 d1                	mov    %edx,%ecx
  8024c7:	d3 e8                	shr    %cl,%eax
  8024c9:	89 e9                	mov    %ebp,%ecx
  8024cb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024cf:	d3 e3                	shl    %cl,%ebx
  8024d1:	89 c7                	mov    %eax,%edi
  8024d3:	89 d1                	mov    %edx,%ecx
  8024d5:	89 f0                	mov    %esi,%eax
  8024d7:	d3 e8                	shr    %cl,%eax
  8024d9:	89 e9                	mov    %ebp,%ecx
  8024db:	89 fa                	mov    %edi,%edx
  8024dd:	d3 e6                	shl    %cl,%esi
  8024df:	09 d8                	or     %ebx,%eax
  8024e1:	f7 74 24 08          	divl   0x8(%esp)
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	89 f3                	mov    %esi,%ebx
  8024e9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ed:	89 c6                	mov    %eax,%esi
  8024ef:	89 d7                	mov    %edx,%edi
  8024f1:	39 d1                	cmp    %edx,%ecx
  8024f3:	72 06                	jb     8024fb <__umoddi3+0xfb>
  8024f5:	75 10                	jne    802507 <__umoddi3+0x107>
  8024f7:	39 c3                	cmp    %eax,%ebx
  8024f9:	73 0c                	jae    802507 <__umoddi3+0x107>
  8024fb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024ff:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802503:	89 d7                	mov    %edx,%edi
  802505:	89 c6                	mov    %eax,%esi
  802507:	89 ca                	mov    %ecx,%edx
  802509:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80250e:	29 f3                	sub    %esi,%ebx
  802510:	19 fa                	sbb    %edi,%edx
  802512:	89 d0                	mov    %edx,%eax
  802514:	d3 e0                	shl    %cl,%eax
  802516:	89 e9                	mov    %ebp,%ecx
  802518:	d3 eb                	shr    %cl,%ebx
  80251a:	d3 ea                	shr    %cl,%edx
  80251c:	09 d8                	or     %ebx,%eax
  80251e:	83 c4 1c             	add    $0x1c,%esp
  802521:	5b                   	pop    %ebx
  802522:	5e                   	pop    %esi
  802523:	5f                   	pop    %edi
  802524:	5d                   	pop    %ebp
  802525:	c3                   	ret    
  802526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	89 da                	mov    %ebx,%edx
  802532:	29 fe                	sub    %edi,%esi
  802534:	19 c2                	sbb    %eax,%edx
  802536:	89 f1                	mov    %esi,%ecx
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	e9 4b ff ff ff       	jmp    80248a <__umoddi3+0x8a>
