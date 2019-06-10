
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 3c 0c 00 00       	call   800c7e <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	57                   	push   %edi
  80004b:	56                   	push   %esi
  80004c:	53                   	push   %ebx
  80004d:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800050:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800057:	00 00 00 
	envid_t find = sys_getenvid();
  80005a:	e8 9d 0c 00 00       	call   800cfc <sys_getenvid>
  80005f:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800065:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80006a:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80006f:	bf 01 00 00 00       	mov    $0x1,%edi
  800074:	eb 0b                	jmp    800081 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800076:	83 c2 01             	add    $0x1,%edx
  800079:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80007f:	74 21                	je     8000a2 <libmain+0x5b>
		if(envs[i].env_id == find)
  800081:	89 d1                	mov    %edx,%ecx
  800083:	c1 e1 07             	shl    $0x7,%ecx
  800086:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80008c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80008f:	39 c1                	cmp    %eax,%ecx
  800091:	75 e3                	jne    800076 <libmain+0x2f>
  800093:	89 d3                	mov    %edx,%ebx
  800095:	c1 e3 07             	shl    $0x7,%ebx
  800098:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80009e:	89 fe                	mov    %edi,%esi
  8000a0:	eb d4                	jmp    800076 <libmain+0x2f>
  8000a2:	89 f0                	mov    %esi,%eax
  8000a4:	84 c0                	test   %al,%al
  8000a6:	74 06                	je     8000ae <libmain+0x67>
  8000a8:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b2:	7e 0a                	jle    8000be <libmain+0x77>
		binaryname = argv[0];
  8000b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b7:	8b 00                	mov    (%eax),%eax
  8000b9:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000be:	a1 08 40 80 00       	mov    0x804008,%eax
  8000c3:	8b 40 48             	mov    0x48(%eax),%eax
  8000c6:	83 ec 08             	sub    $0x8,%esp
  8000c9:	50                   	push   %eax
  8000ca:	68 80 25 80 00       	push   $0x802580
  8000cf:	e8 15 01 00 00       	call   8001e9 <cprintf>
	cprintf("before umain\n");
  8000d4:	c7 04 24 9e 25 80 00 	movl   $0x80259e,(%esp)
  8000db:	e8 09 01 00 00       	call   8001e9 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e0:	83 c4 08             	add    $0x8,%esp
  8000e3:	ff 75 0c             	pushl  0xc(%ebp)
  8000e6:	ff 75 08             	pushl  0x8(%ebp)
  8000e9:	e8 45 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000ee:	c7 04 24 ac 25 80 00 	movl   $0x8025ac,(%esp)
  8000f5:	e8 ef 00 00 00       	call   8001e9 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000fa:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ff:	8b 40 48             	mov    0x48(%eax),%eax
  800102:	83 c4 08             	add    $0x8,%esp
  800105:	50                   	push   %eax
  800106:	68 b9 25 80 00       	push   $0x8025b9
  80010b:	e8 d9 00 00 00       	call   8001e9 <cprintf>
	// exit gracefully
	exit();
  800110:	e8 0b 00 00 00       	call   800120 <exit>
}
  800115:	83 c4 10             	add    $0x10,%esp
  800118:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011b:	5b                   	pop    %ebx
  80011c:	5e                   	pop    %esi
  80011d:	5f                   	pop    %edi
  80011e:	5d                   	pop    %ebp
  80011f:	c3                   	ret    

00800120 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
  800123:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800126:	a1 08 40 80 00       	mov    0x804008,%eax
  80012b:	8b 40 48             	mov    0x48(%eax),%eax
  80012e:	68 e4 25 80 00       	push   $0x8025e4
  800133:	50                   	push   %eax
  800134:	68 d8 25 80 00       	push   $0x8025d8
  800139:	e8 ab 00 00 00       	call   8001e9 <cprintf>
	close_all();
  80013e:	e8 c4 10 00 00       	call   801207 <close_all>
	sys_env_destroy(0);
  800143:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014a:	e8 6c 0b 00 00       	call   800cbb <sys_env_destroy>
}
  80014f:	83 c4 10             	add    $0x10,%esp
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	53                   	push   %ebx
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80015e:	8b 13                	mov    (%ebx),%edx
  800160:	8d 42 01             	lea    0x1(%edx),%eax
  800163:	89 03                	mov    %eax,(%ebx)
  800165:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800168:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800171:	74 09                	je     80017c <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800173:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800177:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017a:	c9                   	leave  
  80017b:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017c:	83 ec 08             	sub    $0x8,%esp
  80017f:	68 ff 00 00 00       	push   $0xff
  800184:	8d 43 08             	lea    0x8(%ebx),%eax
  800187:	50                   	push   %eax
  800188:	e8 f1 0a 00 00       	call   800c7e <sys_cputs>
		b->idx = 0;
  80018d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	eb db                	jmp    800173 <putch+0x1f>

00800198 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001a8:	00 00 00 
	b.cnt = 0;
  8001ab:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b5:	ff 75 0c             	pushl  0xc(%ebp)
  8001b8:	ff 75 08             	pushl  0x8(%ebp)
  8001bb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c1:	50                   	push   %eax
  8001c2:	68 54 01 80 00       	push   $0x800154
  8001c7:	e8 4a 01 00 00       	call   800316 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cc:	83 c4 08             	add    $0x8,%esp
  8001cf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d5:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001db:	50                   	push   %eax
  8001dc:	e8 9d 0a 00 00       	call   800c7e <sys_cputs>

	return b.cnt;
}
  8001e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001e7:	c9                   	leave  
  8001e8:	c3                   	ret    

008001e9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001e9:	55                   	push   %ebp
  8001ea:	89 e5                	mov    %esp,%ebp
  8001ec:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001ef:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f2:	50                   	push   %eax
  8001f3:	ff 75 08             	pushl  0x8(%ebp)
  8001f6:	e8 9d ff ff ff       	call   800198 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fb:	c9                   	leave  
  8001fc:	c3                   	ret    

008001fd <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001fd:	55                   	push   %ebp
  8001fe:	89 e5                	mov    %esp,%ebp
  800200:	57                   	push   %edi
  800201:	56                   	push   %esi
  800202:	53                   	push   %ebx
  800203:	83 ec 1c             	sub    $0x1c,%esp
  800206:	89 c6                	mov    %eax,%esi
  800208:	89 d7                	mov    %edx,%edi
  80020a:	8b 45 08             	mov    0x8(%ebp),%eax
  80020d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800210:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800213:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800216:	8b 45 10             	mov    0x10(%ebp),%eax
  800219:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80021c:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800220:	74 2c                	je     80024e <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800222:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800225:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80022c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80022f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800232:	39 c2                	cmp    %eax,%edx
  800234:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800237:	73 43                	jae    80027c <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800239:	83 eb 01             	sub    $0x1,%ebx
  80023c:	85 db                	test   %ebx,%ebx
  80023e:	7e 6c                	jle    8002ac <printnum+0xaf>
				putch(padc, putdat);
  800240:	83 ec 08             	sub    $0x8,%esp
  800243:	57                   	push   %edi
  800244:	ff 75 18             	pushl  0x18(%ebp)
  800247:	ff d6                	call   *%esi
  800249:	83 c4 10             	add    $0x10,%esp
  80024c:	eb eb                	jmp    800239 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	6a 20                	push   $0x20
  800253:	6a 00                	push   $0x0
  800255:	50                   	push   %eax
  800256:	ff 75 e4             	pushl  -0x1c(%ebp)
  800259:	ff 75 e0             	pushl  -0x20(%ebp)
  80025c:	89 fa                	mov    %edi,%edx
  80025e:	89 f0                	mov    %esi,%eax
  800260:	e8 98 ff ff ff       	call   8001fd <printnum>
		while (--width > 0)
  800265:	83 c4 20             	add    $0x20,%esp
  800268:	83 eb 01             	sub    $0x1,%ebx
  80026b:	85 db                	test   %ebx,%ebx
  80026d:	7e 65                	jle    8002d4 <printnum+0xd7>
			putch(padc, putdat);
  80026f:	83 ec 08             	sub    $0x8,%esp
  800272:	57                   	push   %edi
  800273:	6a 20                	push   $0x20
  800275:	ff d6                	call   *%esi
  800277:	83 c4 10             	add    $0x10,%esp
  80027a:	eb ec                	jmp    800268 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	ff 75 18             	pushl  0x18(%ebp)
  800282:	83 eb 01             	sub    $0x1,%ebx
  800285:	53                   	push   %ebx
  800286:	50                   	push   %eax
  800287:	83 ec 08             	sub    $0x8,%esp
  80028a:	ff 75 dc             	pushl  -0x24(%ebp)
  80028d:	ff 75 d8             	pushl  -0x28(%ebp)
  800290:	ff 75 e4             	pushl  -0x1c(%ebp)
  800293:	ff 75 e0             	pushl  -0x20(%ebp)
  800296:	e8 85 20 00 00       	call   802320 <__udivdi3>
  80029b:	83 c4 18             	add    $0x18,%esp
  80029e:	52                   	push   %edx
  80029f:	50                   	push   %eax
  8002a0:	89 fa                	mov    %edi,%edx
  8002a2:	89 f0                	mov    %esi,%eax
  8002a4:	e8 54 ff ff ff       	call   8001fd <printnum>
  8002a9:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002ac:	83 ec 08             	sub    $0x8,%esp
  8002af:	57                   	push   %edi
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8002bf:	e8 6c 21 00 00       	call   802430 <__umoddi3>
  8002c4:	83 c4 14             	add    $0x14,%esp
  8002c7:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
  8002ce:	50                   	push   %eax
  8002cf:	ff d6                	call   *%esi
  8002d1:	83 c4 10             	add    $0x10,%esp
	}
}
  8002d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d7:	5b                   	pop    %ebx
  8002d8:	5e                   	pop    %esi
  8002d9:	5f                   	pop    %edi
  8002da:	5d                   	pop    %ebp
  8002db:	c3                   	ret    

008002dc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e2:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	3b 50 04             	cmp    0x4(%eax),%edx
  8002eb:	73 0a                	jae    8002f7 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002ed:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f0:	89 08                	mov    %ecx,(%eax)
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	88 02                	mov    %al,(%edx)
}
  8002f7:	5d                   	pop    %ebp
  8002f8:	c3                   	ret    

008002f9 <printfmt>:
{
  8002f9:	55                   	push   %ebp
  8002fa:	89 e5                	mov    %esp,%ebp
  8002fc:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ff:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800302:	50                   	push   %eax
  800303:	ff 75 10             	pushl  0x10(%ebp)
  800306:	ff 75 0c             	pushl  0xc(%ebp)
  800309:	ff 75 08             	pushl  0x8(%ebp)
  80030c:	e8 05 00 00 00       	call   800316 <vprintfmt>
}
  800311:	83 c4 10             	add    $0x10,%esp
  800314:	c9                   	leave  
  800315:	c3                   	ret    

00800316 <vprintfmt>:
{
  800316:	55                   	push   %ebp
  800317:	89 e5                	mov    %esp,%ebp
  800319:	57                   	push   %edi
  80031a:	56                   	push   %esi
  80031b:	53                   	push   %ebx
  80031c:	83 ec 3c             	sub    $0x3c,%esp
  80031f:	8b 75 08             	mov    0x8(%ebp),%esi
  800322:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800325:	8b 7d 10             	mov    0x10(%ebp),%edi
  800328:	e9 32 04 00 00       	jmp    80075f <vprintfmt+0x449>
		padc = ' ';
  80032d:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800331:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800338:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80033f:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800346:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80034d:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800354:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800359:	8d 47 01             	lea    0x1(%edi),%eax
  80035c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035f:	0f b6 17             	movzbl (%edi),%edx
  800362:	8d 42 dd             	lea    -0x23(%edx),%eax
  800365:	3c 55                	cmp    $0x55,%al
  800367:	0f 87 12 05 00 00    	ja     80087f <vprintfmt+0x569>
  80036d:	0f b6 c0             	movzbl %al,%eax
  800370:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
  800377:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037a:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80037e:	eb d9                	jmp    800359 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800383:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800387:	eb d0                	jmp    800359 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800389:	0f b6 d2             	movzbl %dl,%edx
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80038f:	b8 00 00 00 00       	mov    $0x0,%eax
  800394:	89 75 08             	mov    %esi,0x8(%ebp)
  800397:	eb 03                	jmp    80039c <vprintfmt+0x86>
  800399:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039f:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a3:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a6:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003a9:	83 fe 09             	cmp    $0x9,%esi
  8003ac:	76 eb                	jbe    800399 <vprintfmt+0x83>
  8003ae:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b4:	eb 14                	jmp    8003ca <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8b 00                	mov    (%eax),%eax
  8003bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003be:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c1:	8d 40 04             	lea    0x4(%eax),%eax
  8003c4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ce:	79 89                	jns    800359 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d6:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003dd:	e9 77 ff ff ff       	jmp    800359 <vprintfmt+0x43>
  8003e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	0f 48 c1             	cmovs  %ecx,%eax
  8003ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f0:	e9 64 ff ff ff       	jmp    800359 <vprintfmt+0x43>
  8003f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ff:	e9 55 ff ff ff       	jmp    800359 <vprintfmt+0x43>
			lflag++;
  800404:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040b:	e9 49 ff ff ff       	jmp    800359 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800410:	8b 45 14             	mov    0x14(%ebp),%eax
  800413:	8d 78 04             	lea    0x4(%eax),%edi
  800416:	83 ec 08             	sub    $0x8,%esp
  800419:	53                   	push   %ebx
  80041a:	ff 30                	pushl  (%eax)
  80041c:	ff d6                	call   *%esi
			break;
  80041e:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800421:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800424:	e9 33 03 00 00       	jmp    80075c <vprintfmt+0x446>
			err = va_arg(ap, int);
  800429:	8b 45 14             	mov    0x14(%ebp),%eax
  80042c:	8d 78 04             	lea    0x4(%eax),%edi
  80042f:	8b 00                	mov    (%eax),%eax
  800431:	99                   	cltd   
  800432:	31 d0                	xor    %edx,%eax
  800434:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800436:	83 f8 11             	cmp    $0x11,%eax
  800439:	7f 23                	jg     80045e <vprintfmt+0x148>
  80043b:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800442:	85 d2                	test   %edx,%edx
  800444:	74 18                	je     80045e <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800446:	52                   	push   %edx
  800447:	68 3d 2a 80 00       	push   $0x802a3d
  80044c:	53                   	push   %ebx
  80044d:	56                   	push   %esi
  80044e:	e8 a6 fe ff ff       	call   8002f9 <printfmt>
  800453:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800456:	89 7d 14             	mov    %edi,0x14(%ebp)
  800459:	e9 fe 02 00 00       	jmp    80075c <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80045e:	50                   	push   %eax
  80045f:	68 01 26 80 00       	push   $0x802601
  800464:	53                   	push   %ebx
  800465:	56                   	push   %esi
  800466:	e8 8e fe ff ff       	call   8002f9 <printfmt>
  80046b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80046e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800471:	e9 e6 02 00 00       	jmp    80075c <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800476:	8b 45 14             	mov    0x14(%ebp),%eax
  800479:	83 c0 04             	add    $0x4,%eax
  80047c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80047f:	8b 45 14             	mov    0x14(%ebp),%eax
  800482:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800484:	85 c9                	test   %ecx,%ecx
  800486:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
  80048b:	0f 45 c1             	cmovne %ecx,%eax
  80048e:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800491:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800495:	7e 06                	jle    80049d <vprintfmt+0x187>
  800497:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80049b:	75 0d                	jne    8004aa <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a0:	89 c7                	mov    %eax,%edi
  8004a2:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a8:	eb 53                	jmp    8004fd <vprintfmt+0x1e7>
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b0:	50                   	push   %eax
  8004b1:	e8 71 04 00 00       	call   800927 <strnlen>
  8004b6:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004b9:	29 c1                	sub    %eax,%ecx
  8004bb:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004c3:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004ca:	eb 0f                	jmp    8004db <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	53                   	push   %ebx
  8004d0:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d3:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d5:	83 ef 01             	sub    $0x1,%edi
  8004d8:	83 c4 10             	add    $0x10,%esp
  8004db:	85 ff                	test   %edi,%edi
  8004dd:	7f ed                	jg     8004cc <vprintfmt+0x1b6>
  8004df:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004e2:	85 c9                	test   %ecx,%ecx
  8004e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004e9:	0f 49 c1             	cmovns %ecx,%eax
  8004ec:	29 c1                	sub    %eax,%ecx
  8004ee:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f1:	eb aa                	jmp    80049d <vprintfmt+0x187>
					putch(ch, putdat);
  8004f3:	83 ec 08             	sub    $0x8,%esp
  8004f6:	53                   	push   %ebx
  8004f7:	52                   	push   %edx
  8004f8:	ff d6                	call   *%esi
  8004fa:	83 c4 10             	add    $0x10,%esp
  8004fd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800500:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800502:	83 c7 01             	add    $0x1,%edi
  800505:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800509:	0f be d0             	movsbl %al,%edx
  80050c:	85 d2                	test   %edx,%edx
  80050e:	74 4b                	je     80055b <vprintfmt+0x245>
  800510:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800514:	78 06                	js     80051c <vprintfmt+0x206>
  800516:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051a:	78 1e                	js     80053a <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80051c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800520:	74 d1                	je     8004f3 <vprintfmt+0x1dd>
  800522:	0f be c0             	movsbl %al,%eax
  800525:	83 e8 20             	sub    $0x20,%eax
  800528:	83 f8 5e             	cmp    $0x5e,%eax
  80052b:	76 c6                	jbe    8004f3 <vprintfmt+0x1dd>
					putch('?', putdat);
  80052d:	83 ec 08             	sub    $0x8,%esp
  800530:	53                   	push   %ebx
  800531:	6a 3f                	push   $0x3f
  800533:	ff d6                	call   *%esi
  800535:	83 c4 10             	add    $0x10,%esp
  800538:	eb c3                	jmp    8004fd <vprintfmt+0x1e7>
  80053a:	89 cf                	mov    %ecx,%edi
  80053c:	eb 0e                	jmp    80054c <vprintfmt+0x236>
				putch(' ', putdat);
  80053e:	83 ec 08             	sub    $0x8,%esp
  800541:	53                   	push   %ebx
  800542:	6a 20                	push   $0x20
  800544:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800546:	83 ef 01             	sub    $0x1,%edi
  800549:	83 c4 10             	add    $0x10,%esp
  80054c:	85 ff                	test   %edi,%edi
  80054e:	7f ee                	jg     80053e <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800550:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800553:	89 45 14             	mov    %eax,0x14(%ebp)
  800556:	e9 01 02 00 00       	jmp    80075c <vprintfmt+0x446>
  80055b:	89 cf                	mov    %ecx,%edi
  80055d:	eb ed                	jmp    80054c <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80055f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800562:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800569:	e9 eb fd ff ff       	jmp    800359 <vprintfmt+0x43>
	if (lflag >= 2)
  80056e:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800572:	7f 21                	jg     800595 <vprintfmt+0x27f>
	else if (lflag)
  800574:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800578:	74 68                	je     8005e2 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80057a:	8b 45 14             	mov    0x14(%ebp),%eax
  80057d:	8b 00                	mov    (%eax),%eax
  80057f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800582:	89 c1                	mov    %eax,%ecx
  800584:	c1 f9 1f             	sar    $0x1f,%ecx
  800587:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80058a:	8b 45 14             	mov    0x14(%ebp),%eax
  80058d:	8d 40 04             	lea    0x4(%eax),%eax
  800590:	89 45 14             	mov    %eax,0x14(%ebp)
  800593:	eb 17                	jmp    8005ac <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	8b 50 04             	mov    0x4(%eax),%edx
  80059b:	8b 00                	mov    (%eax),%eax
  80059d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a6:	8d 40 08             	lea    0x8(%eax),%eax
  8005a9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005bc:	78 3f                	js     8005fd <vprintfmt+0x2e7>
			base = 10;
  8005be:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005c3:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005c7:	0f 84 71 01 00 00    	je     80073e <vprintfmt+0x428>
				putch('+', putdat);
  8005cd:	83 ec 08             	sub    $0x8,%esp
  8005d0:	53                   	push   %ebx
  8005d1:	6a 2b                	push   $0x2b
  8005d3:	ff d6                	call   *%esi
  8005d5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 5c 01 00 00       	jmp    80073e <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ea:	89 c1                	mov    %eax,%ecx
  8005ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8005ef:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8d 40 04             	lea    0x4(%eax),%eax
  8005f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fb:	eb af                	jmp    8005ac <vprintfmt+0x296>
				putch('-', putdat);
  8005fd:	83 ec 08             	sub    $0x8,%esp
  800600:	53                   	push   %ebx
  800601:	6a 2d                	push   $0x2d
  800603:	ff d6                	call   *%esi
				num = -(long long) num;
  800605:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800608:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80060b:	f7 d8                	neg    %eax
  80060d:	83 d2 00             	adc    $0x0,%edx
  800610:	f7 da                	neg    %edx
  800612:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800615:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800618:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800620:	e9 19 01 00 00       	jmp    80073e <vprintfmt+0x428>
	if (lflag >= 2)
  800625:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800629:	7f 29                	jg     800654 <vprintfmt+0x33e>
	else if (lflag)
  80062b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80062f:	74 44                	je     800675 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800631:	8b 45 14             	mov    0x14(%ebp),%eax
  800634:	8b 00                	mov    (%eax),%eax
  800636:	ba 00 00 00 00       	mov    $0x0,%edx
  80063b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8d 40 04             	lea    0x4(%eax),%eax
  800647:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80064f:	e9 ea 00 00 00       	jmp    80073e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800654:	8b 45 14             	mov    0x14(%ebp),%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8d 40 08             	lea    0x8(%eax),%eax
  800668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800670:	e9 c9 00 00 00       	jmp    80073e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800675:	8b 45 14             	mov    0x14(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	ba 00 00 00 00       	mov    $0x0,%edx
  80067f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800682:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800685:	8b 45 14             	mov    0x14(%ebp),%eax
  800688:	8d 40 04             	lea    0x4(%eax),%eax
  80068b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800693:	e9 a6 00 00 00       	jmp    80073e <vprintfmt+0x428>
			putch('0', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 30                	push   $0x30
  80069e:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006a7:	7f 26                	jg     8006cf <vprintfmt+0x3b9>
	else if (lflag)
  8006a9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ad:	74 3e                	je     8006ed <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006af:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c8:	b8 08 00 00 00       	mov    $0x8,%eax
  8006cd:	eb 6f                	jmp    80073e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d2:	8b 50 04             	mov    0x4(%eax),%edx
  8006d5:	8b 00                	mov    (%eax),%eax
  8006d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006da:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 40 08             	lea    0x8(%eax),%eax
  8006e3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e6:	b8 08 00 00 00       	mov    $0x8,%eax
  8006eb:	eb 51                	jmp    80073e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f0:	8b 00                	mov    (%eax),%eax
  8006f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 40 04             	lea    0x4(%eax),%eax
  800703:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800706:	b8 08 00 00 00       	mov    $0x8,%eax
  80070b:	eb 31                	jmp    80073e <vprintfmt+0x428>
			putch('0', putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 30                	push   $0x30
  800713:	ff d6                	call   *%esi
			putch('x', putdat);
  800715:	83 c4 08             	add    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	6a 78                	push   $0x78
  80071b:	ff d6                	call   *%esi
			num = (unsigned long long)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	ba 00 00 00 00       	mov    $0x0,%edx
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80072d:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800730:	8b 45 14             	mov    0x14(%ebp),%eax
  800733:	8d 40 04             	lea    0x4(%eax),%eax
  800736:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800739:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80073e:	83 ec 0c             	sub    $0xc,%esp
  800741:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800745:	52                   	push   %edx
  800746:	ff 75 e0             	pushl  -0x20(%ebp)
  800749:	50                   	push   %eax
  80074a:	ff 75 dc             	pushl  -0x24(%ebp)
  80074d:	ff 75 d8             	pushl  -0x28(%ebp)
  800750:	89 da                	mov    %ebx,%edx
  800752:	89 f0                	mov    %esi,%eax
  800754:	e8 a4 fa ff ff       	call   8001fd <printnum>
			break;
  800759:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80075c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80075f:	83 c7 01             	add    $0x1,%edi
  800762:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800766:	83 f8 25             	cmp    $0x25,%eax
  800769:	0f 84 be fb ff ff    	je     80032d <vprintfmt+0x17>
			if (ch == '\0')
  80076f:	85 c0                	test   %eax,%eax
  800771:	0f 84 28 01 00 00    	je     80089f <vprintfmt+0x589>
			putch(ch, putdat);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	53                   	push   %ebx
  80077b:	50                   	push   %eax
  80077c:	ff d6                	call   *%esi
  80077e:	83 c4 10             	add    $0x10,%esp
  800781:	eb dc                	jmp    80075f <vprintfmt+0x449>
	if (lflag >= 2)
  800783:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800787:	7f 26                	jg     8007af <vprintfmt+0x499>
	else if (lflag)
  800789:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80078d:	74 41                	je     8007d0 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	ba 00 00 00 00       	mov    $0x0,%edx
  800799:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8d 40 04             	lea    0x4(%eax),%eax
  8007a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a8:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ad:	eb 8f                	jmp    80073e <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007af:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b2:	8b 50 04             	mov    0x4(%eax),%edx
  8007b5:	8b 00                	mov    (%eax),%eax
  8007b7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ba:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	8d 40 08             	lea    0x8(%eax),%eax
  8007c3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007cb:	e9 6e ff ff ff       	jmp    80073e <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d3:	8b 00                	mov    (%eax),%eax
  8007d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8007da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e3:	8d 40 04             	lea    0x4(%eax),%eax
  8007e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ee:	e9 4b ff ff ff       	jmp    80073e <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f6:	83 c0 04             	add    $0x4,%eax
  8007f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	85 c0                	test   %eax,%eax
  800803:	74 14                	je     800819 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800805:	8b 13                	mov    (%ebx),%edx
  800807:	83 fa 7f             	cmp    $0x7f,%edx
  80080a:	7f 37                	jg     800843 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80080c:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80080e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800811:	89 45 14             	mov    %eax,0x14(%ebp)
  800814:	e9 43 ff ff ff       	jmp    80075c <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800819:	b8 0a 00 00 00       	mov    $0xa,%eax
  80081e:	bf 1d 27 80 00       	mov    $0x80271d,%edi
							putch(ch, putdat);
  800823:	83 ec 08             	sub    $0x8,%esp
  800826:	53                   	push   %ebx
  800827:	50                   	push   %eax
  800828:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80082a:	83 c7 01             	add    $0x1,%edi
  80082d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800831:	83 c4 10             	add    $0x10,%esp
  800834:	85 c0                	test   %eax,%eax
  800836:	75 eb                	jne    800823 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800838:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80083b:	89 45 14             	mov    %eax,0x14(%ebp)
  80083e:	e9 19 ff ff ff       	jmp    80075c <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800843:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800845:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084a:	bf 55 27 80 00       	mov    $0x802755,%edi
							putch(ch, putdat);
  80084f:	83 ec 08             	sub    $0x8,%esp
  800852:	53                   	push   %ebx
  800853:	50                   	push   %eax
  800854:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800856:	83 c7 01             	add    $0x1,%edi
  800859:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80085d:	83 c4 10             	add    $0x10,%esp
  800860:	85 c0                	test   %eax,%eax
  800862:	75 eb                	jne    80084f <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800864:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800867:	89 45 14             	mov    %eax,0x14(%ebp)
  80086a:	e9 ed fe ff ff       	jmp    80075c <vprintfmt+0x446>
			putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	53                   	push   %ebx
  800873:	6a 25                	push   $0x25
  800875:	ff d6                	call   *%esi
			break;
  800877:	83 c4 10             	add    $0x10,%esp
  80087a:	e9 dd fe ff ff       	jmp    80075c <vprintfmt+0x446>
			putch('%', putdat);
  80087f:	83 ec 08             	sub    $0x8,%esp
  800882:	53                   	push   %ebx
  800883:	6a 25                	push   $0x25
  800885:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	89 f8                	mov    %edi,%eax
  80088c:	eb 03                	jmp    800891 <vprintfmt+0x57b>
  80088e:	83 e8 01             	sub    $0x1,%eax
  800891:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800895:	75 f7                	jne    80088e <vprintfmt+0x578>
  800897:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089a:	e9 bd fe ff ff       	jmp    80075c <vprintfmt+0x446>
}
  80089f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a2:	5b                   	pop    %ebx
  8008a3:	5e                   	pop    %esi
  8008a4:	5f                   	pop    %edi
  8008a5:	5d                   	pop    %ebp
  8008a6:	c3                   	ret    

008008a7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a7:	55                   	push   %ebp
  8008a8:	89 e5                	mov    %esp,%ebp
  8008aa:	83 ec 18             	sub    $0x18,%esp
  8008ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008bd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c4:	85 c0                	test   %eax,%eax
  8008c6:	74 26                	je     8008ee <vsnprintf+0x47>
  8008c8:	85 d2                	test   %edx,%edx
  8008ca:	7e 22                	jle    8008ee <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cc:	ff 75 14             	pushl  0x14(%ebp)
  8008cf:	ff 75 10             	pushl  0x10(%ebp)
  8008d2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d5:	50                   	push   %eax
  8008d6:	68 dc 02 80 00       	push   $0x8002dc
  8008db:	e8 36 fa ff ff       	call   800316 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
}
  8008ec:	c9                   	leave  
  8008ed:	c3                   	ret    
		return -E_INVAL;
  8008ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f3:	eb f7                	jmp    8008ec <vsnprintf+0x45>

008008f5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008fe:	50                   	push   %eax
  8008ff:	ff 75 10             	pushl  0x10(%ebp)
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	ff 75 08             	pushl  0x8(%ebp)
  800908:	e8 9a ff ff ff       	call   8008a7 <vsnprintf>
	va_end(ap);

	return rc;
}
  80090d:	c9                   	leave  
  80090e:	c3                   	ret    

0080090f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800915:	b8 00 00 00 00       	mov    $0x0,%eax
  80091a:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80091e:	74 05                	je     800925 <strlen+0x16>
		n++;
  800920:	83 c0 01             	add    $0x1,%eax
  800923:	eb f5                	jmp    80091a <strlen+0xb>
	return n;
}
  800925:	5d                   	pop    %ebp
  800926:	c3                   	ret    

00800927 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800927:	55                   	push   %ebp
  800928:	89 e5                	mov    %esp,%ebp
  80092a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80092d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800930:	ba 00 00 00 00       	mov    $0x0,%edx
  800935:	39 c2                	cmp    %eax,%edx
  800937:	74 0d                	je     800946 <strnlen+0x1f>
  800939:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80093d:	74 05                	je     800944 <strnlen+0x1d>
		n++;
  80093f:	83 c2 01             	add    $0x1,%edx
  800942:	eb f1                	jmp    800935 <strnlen+0xe>
  800944:	89 d0                	mov    %edx,%eax
	return n;
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	53                   	push   %ebx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800952:	ba 00 00 00 00       	mov    $0x0,%edx
  800957:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095b:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80095e:	83 c2 01             	add    $0x1,%edx
  800961:	84 c9                	test   %cl,%cl
  800963:	75 f2                	jne    800957 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800965:	5b                   	pop    %ebx
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	53                   	push   %ebx
  80096c:	83 ec 10             	sub    $0x10,%esp
  80096f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800972:	53                   	push   %ebx
  800973:	e8 97 ff ff ff       	call   80090f <strlen>
  800978:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80097b:	ff 75 0c             	pushl  0xc(%ebp)
  80097e:	01 d8                	add    %ebx,%eax
  800980:	50                   	push   %eax
  800981:	e8 c2 ff ff ff       	call   800948 <strcpy>
	return dst;
}
  800986:	89 d8                	mov    %ebx,%eax
  800988:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    

0080098d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	56                   	push   %esi
  800991:	53                   	push   %ebx
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800998:	89 c6                	mov    %eax,%esi
  80099a:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099d:	89 c2                	mov    %eax,%edx
  80099f:	39 f2                	cmp    %esi,%edx
  8009a1:	74 11                	je     8009b4 <strncpy+0x27>
		*dst++ = *src;
  8009a3:	83 c2 01             	add    $0x1,%edx
  8009a6:	0f b6 19             	movzbl (%ecx),%ebx
  8009a9:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ac:	80 fb 01             	cmp    $0x1,%bl
  8009af:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b2:	eb eb                	jmp    80099f <strncpy+0x12>
	}
	return ret;
}
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c3:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c6:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c8:	85 d2                	test   %edx,%edx
  8009ca:	74 21                	je     8009ed <strlcpy+0x35>
  8009cc:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d0:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d2:	39 c2                	cmp    %eax,%edx
  8009d4:	74 14                	je     8009ea <strlcpy+0x32>
  8009d6:	0f b6 19             	movzbl (%ecx),%ebx
  8009d9:	84 db                	test   %bl,%bl
  8009db:	74 0b                	je     8009e8 <strlcpy+0x30>
			*dst++ = *src++;
  8009dd:	83 c1 01             	add    $0x1,%ecx
  8009e0:	83 c2 01             	add    $0x1,%edx
  8009e3:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e6:	eb ea                	jmp    8009d2 <strlcpy+0x1a>
  8009e8:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ea:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009ed:	29 f0                	sub    %esi,%eax
}
  8009ef:	5b                   	pop    %ebx
  8009f0:	5e                   	pop    %esi
  8009f1:	5d                   	pop    %ebp
  8009f2:	c3                   	ret    

008009f3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f3:	55                   	push   %ebp
  8009f4:	89 e5                	mov    %esp,%ebp
  8009f6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009fc:	0f b6 01             	movzbl (%ecx),%eax
  8009ff:	84 c0                	test   %al,%al
  800a01:	74 0c                	je     800a0f <strcmp+0x1c>
  800a03:	3a 02                	cmp    (%edx),%al
  800a05:	75 08                	jne    800a0f <strcmp+0x1c>
		p++, q++;
  800a07:	83 c1 01             	add    $0x1,%ecx
  800a0a:	83 c2 01             	add    $0x1,%edx
  800a0d:	eb ed                	jmp    8009fc <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a0f:	0f b6 c0             	movzbl %al,%eax
  800a12:	0f b6 12             	movzbl (%edx),%edx
  800a15:	29 d0                	sub    %edx,%eax
}
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	53                   	push   %ebx
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a23:	89 c3                	mov    %eax,%ebx
  800a25:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a28:	eb 06                	jmp    800a30 <strncmp+0x17>
		n--, p++, q++;
  800a2a:	83 c0 01             	add    $0x1,%eax
  800a2d:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a30:	39 d8                	cmp    %ebx,%eax
  800a32:	74 16                	je     800a4a <strncmp+0x31>
  800a34:	0f b6 08             	movzbl (%eax),%ecx
  800a37:	84 c9                	test   %cl,%cl
  800a39:	74 04                	je     800a3f <strncmp+0x26>
  800a3b:	3a 0a                	cmp    (%edx),%cl
  800a3d:	74 eb                	je     800a2a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a3f:	0f b6 00             	movzbl (%eax),%eax
  800a42:	0f b6 12             	movzbl (%edx),%edx
  800a45:	29 d0                	sub    %edx,%eax
}
  800a47:	5b                   	pop    %ebx
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    
		return 0;
  800a4a:	b8 00 00 00 00       	mov    $0x0,%eax
  800a4f:	eb f6                	jmp    800a47 <strncmp+0x2e>

00800a51 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5b:	0f b6 10             	movzbl (%eax),%edx
  800a5e:	84 d2                	test   %dl,%dl
  800a60:	74 09                	je     800a6b <strchr+0x1a>
		if (*s == c)
  800a62:	38 ca                	cmp    %cl,%dl
  800a64:	74 0a                	je     800a70 <strchr+0x1f>
	for (; *s; s++)
  800a66:	83 c0 01             	add    $0x1,%eax
  800a69:	eb f0                	jmp    800a5b <strchr+0xa>
			return (char *) s;
	return 0;
  800a6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a70:	5d                   	pop    %ebp
  800a71:	c3                   	ret    

00800a72 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a72:	55                   	push   %ebp
  800a73:	89 e5                	mov    %esp,%ebp
  800a75:	8b 45 08             	mov    0x8(%ebp),%eax
  800a78:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7c:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a7f:	38 ca                	cmp    %cl,%dl
  800a81:	74 09                	je     800a8c <strfind+0x1a>
  800a83:	84 d2                	test   %dl,%dl
  800a85:	74 05                	je     800a8c <strfind+0x1a>
	for (; *s; s++)
  800a87:	83 c0 01             	add    $0x1,%eax
  800a8a:	eb f0                	jmp    800a7c <strfind+0xa>
			break;
	return (char *) s;
}
  800a8c:	5d                   	pop    %ebp
  800a8d:	c3                   	ret    

00800a8e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	57                   	push   %edi
  800a92:	56                   	push   %esi
  800a93:	53                   	push   %ebx
  800a94:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a97:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9a:	85 c9                	test   %ecx,%ecx
  800a9c:	74 31                	je     800acf <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a9e:	89 f8                	mov    %edi,%eax
  800aa0:	09 c8                	or     %ecx,%eax
  800aa2:	a8 03                	test   $0x3,%al
  800aa4:	75 23                	jne    800ac9 <memset+0x3b>
		c &= 0xFF;
  800aa6:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aaa:	89 d3                	mov    %edx,%ebx
  800aac:	c1 e3 08             	shl    $0x8,%ebx
  800aaf:	89 d0                	mov    %edx,%eax
  800ab1:	c1 e0 18             	shl    $0x18,%eax
  800ab4:	89 d6                	mov    %edx,%esi
  800ab6:	c1 e6 10             	shl    $0x10,%esi
  800ab9:	09 f0                	or     %esi,%eax
  800abb:	09 c2                	or     %eax,%edx
  800abd:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800abf:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac2:	89 d0                	mov    %edx,%eax
  800ac4:	fc                   	cld    
  800ac5:	f3 ab                	rep stos %eax,%es:(%edi)
  800ac7:	eb 06                	jmp    800acf <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ac9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acc:	fc                   	cld    
  800acd:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800acf:	89 f8                	mov    %edi,%eax
  800ad1:	5b                   	pop    %ebx
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	57                   	push   %edi
  800ada:	56                   	push   %esi
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae4:	39 c6                	cmp    %eax,%esi
  800ae6:	73 32                	jae    800b1a <memmove+0x44>
  800ae8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aeb:	39 c2                	cmp    %eax,%edx
  800aed:	76 2b                	jbe    800b1a <memmove+0x44>
		s += n;
		d += n;
  800aef:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af2:	89 fe                	mov    %edi,%esi
  800af4:	09 ce                	or     %ecx,%esi
  800af6:	09 d6                	or     %edx,%esi
  800af8:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800afe:	75 0e                	jne    800b0e <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b00:	83 ef 04             	sub    $0x4,%edi
  800b03:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b06:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b09:	fd                   	std    
  800b0a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0c:	eb 09                	jmp    800b17 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b0e:	83 ef 01             	sub    $0x1,%edi
  800b11:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b14:	fd                   	std    
  800b15:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b17:	fc                   	cld    
  800b18:	eb 1a                	jmp    800b34 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1a:	89 c2                	mov    %eax,%edx
  800b1c:	09 ca                	or     %ecx,%edx
  800b1e:	09 f2                	or     %esi,%edx
  800b20:	f6 c2 03             	test   $0x3,%dl
  800b23:	75 0a                	jne    800b2f <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b25:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b28:	89 c7                	mov    %eax,%edi
  800b2a:	fc                   	cld    
  800b2b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b2d:	eb 05                	jmp    800b34 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b2f:	89 c7                	mov    %eax,%edi
  800b31:	fc                   	cld    
  800b32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b34:	5e                   	pop    %esi
  800b35:	5f                   	pop    %edi
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b3e:	ff 75 10             	pushl  0x10(%ebp)
  800b41:	ff 75 0c             	pushl  0xc(%ebp)
  800b44:	ff 75 08             	pushl  0x8(%ebp)
  800b47:	e8 8a ff ff ff       	call   800ad6 <memmove>
}
  800b4c:	c9                   	leave  
  800b4d:	c3                   	ret    

00800b4e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b4e:	55                   	push   %ebp
  800b4f:	89 e5                	mov    %esp,%ebp
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
  800b53:	8b 45 08             	mov    0x8(%ebp),%eax
  800b56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b59:	89 c6                	mov    %eax,%esi
  800b5b:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b5e:	39 f0                	cmp    %esi,%eax
  800b60:	74 1c                	je     800b7e <memcmp+0x30>
		if (*s1 != *s2)
  800b62:	0f b6 08             	movzbl (%eax),%ecx
  800b65:	0f b6 1a             	movzbl (%edx),%ebx
  800b68:	38 d9                	cmp    %bl,%cl
  800b6a:	75 08                	jne    800b74 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b6c:	83 c0 01             	add    $0x1,%eax
  800b6f:	83 c2 01             	add    $0x1,%edx
  800b72:	eb ea                	jmp    800b5e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b74:	0f b6 c1             	movzbl %cl,%eax
  800b77:	0f b6 db             	movzbl %bl,%ebx
  800b7a:	29 d8                	sub    %ebx,%eax
  800b7c:	eb 05                	jmp    800b83 <memcmp+0x35>
	}

	return 0;
  800b7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b90:	89 c2                	mov    %eax,%edx
  800b92:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b95:	39 d0                	cmp    %edx,%eax
  800b97:	73 09                	jae    800ba2 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b99:	38 08                	cmp    %cl,(%eax)
  800b9b:	74 05                	je     800ba2 <memfind+0x1b>
	for (; s < ends; s++)
  800b9d:	83 c0 01             	add    $0x1,%eax
  800ba0:	eb f3                	jmp    800b95 <memfind+0xe>
			break;
	return (void *) s;
}
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
  800ba7:	57                   	push   %edi
  800ba8:	56                   	push   %esi
  800ba9:	53                   	push   %ebx
  800baa:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bad:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb0:	eb 03                	jmp    800bb5 <strtol+0x11>
		s++;
  800bb2:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bb5:	0f b6 01             	movzbl (%ecx),%eax
  800bb8:	3c 20                	cmp    $0x20,%al
  800bba:	74 f6                	je     800bb2 <strtol+0xe>
  800bbc:	3c 09                	cmp    $0x9,%al
  800bbe:	74 f2                	je     800bb2 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc0:	3c 2b                	cmp    $0x2b,%al
  800bc2:	74 2a                	je     800bee <strtol+0x4a>
	int neg = 0;
  800bc4:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bc9:	3c 2d                	cmp    $0x2d,%al
  800bcb:	74 2b                	je     800bf8 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bcd:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd3:	75 0f                	jne    800be4 <strtol+0x40>
  800bd5:	80 39 30             	cmpb   $0x30,(%ecx)
  800bd8:	74 28                	je     800c02 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bda:	85 db                	test   %ebx,%ebx
  800bdc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be1:	0f 44 d8             	cmove  %eax,%ebx
  800be4:	b8 00 00 00 00       	mov    $0x0,%eax
  800be9:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bec:	eb 50                	jmp    800c3e <strtol+0x9a>
		s++;
  800bee:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf1:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf6:	eb d5                	jmp    800bcd <strtol+0x29>
		s++, neg = 1;
  800bf8:	83 c1 01             	add    $0x1,%ecx
  800bfb:	bf 01 00 00 00       	mov    $0x1,%edi
  800c00:	eb cb                	jmp    800bcd <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c02:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c06:	74 0e                	je     800c16 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c08:	85 db                	test   %ebx,%ebx
  800c0a:	75 d8                	jne    800be4 <strtol+0x40>
		s++, base = 8;
  800c0c:	83 c1 01             	add    $0x1,%ecx
  800c0f:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c14:	eb ce                	jmp    800be4 <strtol+0x40>
		s += 2, base = 16;
  800c16:	83 c1 02             	add    $0x2,%ecx
  800c19:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c1e:	eb c4                	jmp    800be4 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c20:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c23:	89 f3                	mov    %esi,%ebx
  800c25:	80 fb 19             	cmp    $0x19,%bl
  800c28:	77 29                	ja     800c53 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2a:	0f be d2             	movsbl %dl,%edx
  800c2d:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c30:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c33:	7d 30                	jge    800c65 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c35:	83 c1 01             	add    $0x1,%ecx
  800c38:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c3c:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c3e:	0f b6 11             	movzbl (%ecx),%edx
  800c41:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c44:	89 f3                	mov    %esi,%ebx
  800c46:	80 fb 09             	cmp    $0x9,%bl
  800c49:	77 d5                	ja     800c20 <strtol+0x7c>
			dig = *s - '0';
  800c4b:	0f be d2             	movsbl %dl,%edx
  800c4e:	83 ea 30             	sub    $0x30,%edx
  800c51:	eb dd                	jmp    800c30 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c53:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c56:	89 f3                	mov    %esi,%ebx
  800c58:	80 fb 19             	cmp    $0x19,%bl
  800c5b:	77 08                	ja     800c65 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c5d:	0f be d2             	movsbl %dl,%edx
  800c60:	83 ea 37             	sub    $0x37,%edx
  800c63:	eb cb                	jmp    800c30 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c65:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c69:	74 05                	je     800c70 <strtol+0xcc>
		*endptr = (char *) s;
  800c6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c6e:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c70:	89 c2                	mov    %eax,%edx
  800c72:	f7 da                	neg    %edx
  800c74:	85 ff                	test   %edi,%edi
  800c76:	0f 45 c2             	cmovne %edx,%eax
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c84:	b8 00 00 00 00       	mov    $0x0,%eax
  800c89:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c8f:	89 c3                	mov    %eax,%ebx
  800c91:	89 c7                	mov    %eax,%edi
  800c93:	89 c6                	mov    %eax,%esi
  800c95:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c97:	5b                   	pop    %ebx
  800c98:	5e                   	pop    %esi
  800c99:	5f                   	pop    %edi
  800c9a:	5d                   	pop    %ebp
  800c9b:	c3                   	ret    

00800c9c <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	57                   	push   %edi
  800ca0:	56                   	push   %esi
  800ca1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca7:	b8 01 00 00 00       	mov    $0x1,%eax
  800cac:	89 d1                	mov    %edx,%ecx
  800cae:	89 d3                	mov    %edx,%ebx
  800cb0:	89 d7                	mov    %edx,%edi
  800cb2:	89 d6                	mov    %edx,%esi
  800cb4:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5f                   	pop    %edi
  800cb9:	5d                   	pop    %ebp
  800cba:	c3                   	ret    

00800cbb <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbb:	55                   	push   %ebp
  800cbc:	89 e5                	mov    %esp,%ebp
  800cbe:	57                   	push   %edi
  800cbf:	56                   	push   %esi
  800cc0:	53                   	push   %ebx
  800cc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccc:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd1:	89 cb                	mov    %ecx,%ebx
  800cd3:	89 cf                	mov    %ecx,%edi
  800cd5:	89 ce                	mov    %ecx,%esi
  800cd7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cd9:	85 c0                	test   %eax,%eax
  800cdb:	7f 08                	jg     800ce5 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce0:	5b                   	pop    %ebx
  800ce1:	5e                   	pop    %esi
  800ce2:	5f                   	pop    %edi
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce5:	83 ec 0c             	sub    $0xc,%esp
  800ce8:	50                   	push   %eax
  800ce9:	6a 03                	push   $0x3
  800ceb:	68 68 29 80 00       	push   $0x802968
  800cf0:	6a 43                	push   $0x43
  800cf2:	68 85 29 80 00       	push   $0x802985
  800cf7:	e8 89 14 00 00       	call   802185 <_panic>

00800cfc <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
  800cff:	57                   	push   %edi
  800d00:	56                   	push   %esi
  800d01:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d02:	ba 00 00 00 00       	mov    $0x0,%edx
  800d07:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0c:	89 d1                	mov    %edx,%ecx
  800d0e:	89 d3                	mov    %edx,%ebx
  800d10:	89 d7                	mov    %edx,%edi
  800d12:	89 d6                	mov    %edx,%esi
  800d14:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <sys_yield>:

void
sys_yield(void)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d21:	ba 00 00 00 00       	mov    $0x0,%edx
  800d26:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2b:	89 d1                	mov    %edx,%ecx
  800d2d:	89 d3                	mov    %edx,%ebx
  800d2f:	89 d7                	mov    %edx,%edi
  800d31:	89 d6                	mov    %edx,%esi
  800d33:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    

00800d3a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3a:	55                   	push   %ebp
  800d3b:	89 e5                	mov    %esp,%ebp
  800d3d:	57                   	push   %edi
  800d3e:	56                   	push   %esi
  800d3f:	53                   	push   %ebx
  800d40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d43:	be 00 00 00 00       	mov    $0x0,%esi
  800d48:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4e:	b8 04 00 00 00       	mov    $0x4,%eax
  800d53:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d56:	89 f7                	mov    %esi,%edi
  800d58:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5a:	85 c0                	test   %eax,%eax
  800d5c:	7f 08                	jg     800d66 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d61:	5b                   	pop    %ebx
  800d62:	5e                   	pop    %esi
  800d63:	5f                   	pop    %edi
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d66:	83 ec 0c             	sub    $0xc,%esp
  800d69:	50                   	push   %eax
  800d6a:	6a 04                	push   $0x4
  800d6c:	68 68 29 80 00       	push   $0x802968
  800d71:	6a 43                	push   $0x43
  800d73:	68 85 29 80 00       	push   $0x802985
  800d78:	e8 08 14 00 00       	call   802185 <_panic>

00800d7d <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d86:	8b 55 08             	mov    0x8(%ebp),%edx
  800d89:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8c:	b8 05 00 00 00       	mov    $0x5,%eax
  800d91:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d94:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d97:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	7f 08                	jg     800da8 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da3:	5b                   	pop    %ebx
  800da4:	5e                   	pop    %esi
  800da5:	5f                   	pop    %edi
  800da6:	5d                   	pop    %ebp
  800da7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da8:	83 ec 0c             	sub    $0xc,%esp
  800dab:	50                   	push   %eax
  800dac:	6a 05                	push   $0x5
  800dae:	68 68 29 80 00       	push   $0x802968
  800db3:	6a 43                	push   $0x43
  800db5:	68 85 29 80 00       	push   $0x802985
  800dba:	e8 c6 13 00 00       	call   802185 <_panic>

00800dbf <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dbf:	55                   	push   %ebp
  800dc0:	89 e5                	mov    %esp,%ebp
  800dc2:	57                   	push   %edi
  800dc3:	56                   	push   %esi
  800dc4:	53                   	push   %ebx
  800dc5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	b8 06 00 00 00       	mov    $0x6,%eax
  800dd8:	89 df                	mov    %ebx,%edi
  800dda:	89 de                	mov    %ebx,%esi
  800ddc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	7f 08                	jg     800dea <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de5:	5b                   	pop    %ebx
  800de6:	5e                   	pop    %esi
  800de7:	5f                   	pop    %edi
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dea:	83 ec 0c             	sub    $0xc,%esp
  800ded:	50                   	push   %eax
  800dee:	6a 06                	push   $0x6
  800df0:	68 68 29 80 00       	push   $0x802968
  800df5:	6a 43                	push   $0x43
  800df7:	68 85 29 80 00       	push   $0x802985
  800dfc:	e8 84 13 00 00       	call   802185 <_panic>

00800e01 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
  800e07:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e15:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1a:	89 df                	mov    %ebx,%edi
  800e1c:	89 de                	mov    %ebx,%esi
  800e1e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e20:	85 c0                	test   %eax,%eax
  800e22:	7f 08                	jg     800e2c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e24:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e27:	5b                   	pop    %ebx
  800e28:	5e                   	pop    %esi
  800e29:	5f                   	pop    %edi
  800e2a:	5d                   	pop    %ebp
  800e2b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2c:	83 ec 0c             	sub    $0xc,%esp
  800e2f:	50                   	push   %eax
  800e30:	6a 08                	push   $0x8
  800e32:	68 68 29 80 00       	push   $0x802968
  800e37:	6a 43                	push   $0x43
  800e39:	68 85 29 80 00       	push   $0x802985
  800e3e:	e8 42 13 00 00       	call   802185 <_panic>

00800e43 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	57                   	push   %edi
  800e47:	56                   	push   %esi
  800e48:	53                   	push   %ebx
  800e49:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e51:	8b 55 08             	mov    0x8(%ebp),%edx
  800e54:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e57:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5c:	89 df                	mov    %ebx,%edi
  800e5e:	89 de                	mov    %ebx,%esi
  800e60:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e62:	85 c0                	test   %eax,%eax
  800e64:	7f 08                	jg     800e6e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e66:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e69:	5b                   	pop    %ebx
  800e6a:	5e                   	pop    %esi
  800e6b:	5f                   	pop    %edi
  800e6c:	5d                   	pop    %ebp
  800e6d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e6e:	83 ec 0c             	sub    $0xc,%esp
  800e71:	50                   	push   %eax
  800e72:	6a 09                	push   $0x9
  800e74:	68 68 29 80 00       	push   $0x802968
  800e79:	6a 43                	push   $0x43
  800e7b:	68 85 29 80 00       	push   $0x802985
  800e80:	e8 00 13 00 00       	call   802185 <_panic>

00800e85 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e85:	55                   	push   %ebp
  800e86:	89 e5                	mov    %esp,%ebp
  800e88:	57                   	push   %edi
  800e89:	56                   	push   %esi
  800e8a:	53                   	push   %ebx
  800e8b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e93:	8b 55 08             	mov    0x8(%ebp),%edx
  800e96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e99:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e9e:	89 df                	mov    %ebx,%edi
  800ea0:	89 de                	mov    %ebx,%esi
  800ea2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea4:	85 c0                	test   %eax,%eax
  800ea6:	7f 08                	jg     800eb0 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ea8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eab:	5b                   	pop    %ebx
  800eac:	5e                   	pop    %esi
  800ead:	5f                   	pop    %edi
  800eae:	5d                   	pop    %ebp
  800eaf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb0:	83 ec 0c             	sub    $0xc,%esp
  800eb3:	50                   	push   %eax
  800eb4:	6a 0a                	push   $0xa
  800eb6:	68 68 29 80 00       	push   $0x802968
  800ebb:	6a 43                	push   $0x43
  800ebd:	68 85 29 80 00       	push   $0x802985
  800ec2:	e8 be 12 00 00       	call   802185 <_panic>

00800ec7 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
  800eca:	57                   	push   %edi
  800ecb:	56                   	push   %esi
  800ecc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecd:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed3:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed8:	be 00 00 00 00       	mov    $0x0,%esi
  800edd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
  800ef0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef8:	8b 55 08             	mov    0x8(%ebp),%edx
  800efb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f00:	89 cb                	mov    %ecx,%ebx
  800f02:	89 cf                	mov    %ecx,%edi
  800f04:	89 ce                	mov    %ecx,%esi
  800f06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	7f 08                	jg     800f14 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f0f:	5b                   	pop    %ebx
  800f10:	5e                   	pop    %esi
  800f11:	5f                   	pop    %edi
  800f12:	5d                   	pop    %ebp
  800f13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f14:	83 ec 0c             	sub    $0xc,%esp
  800f17:	50                   	push   %eax
  800f18:	6a 0d                	push   $0xd
  800f1a:	68 68 29 80 00       	push   $0x802968
  800f1f:	6a 43                	push   $0x43
  800f21:	68 85 29 80 00       	push   $0x802985
  800f26:	e8 5a 12 00 00       	call   802185 <_panic>

00800f2b <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f31:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f36:	8b 55 08             	mov    0x8(%ebp),%edx
  800f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3c:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f41:	89 df                	mov    %ebx,%edi
  800f43:	89 de                	mov    %ebx,%esi
  800f45:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f47:	5b                   	pop    %ebx
  800f48:	5e                   	pop    %esi
  800f49:	5f                   	pop    %edi
  800f4a:	5d                   	pop    %ebp
  800f4b:	c3                   	ret    

00800f4c <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	57                   	push   %edi
  800f50:	56                   	push   %esi
  800f51:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f57:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5a:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f5f:	89 cb                	mov    %ecx,%ebx
  800f61:	89 cf                	mov    %ecx,%edi
  800f63:	89 ce                	mov    %ecx,%esi
  800f65:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f67:	5b                   	pop    %ebx
  800f68:	5e                   	pop    %esi
  800f69:	5f                   	pop    %edi
  800f6a:	5d                   	pop    %ebp
  800f6b:	c3                   	ret    

00800f6c <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	57                   	push   %edi
  800f70:	56                   	push   %esi
  800f71:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f72:	ba 00 00 00 00       	mov    $0x0,%edx
  800f77:	b8 10 00 00 00       	mov    $0x10,%eax
  800f7c:	89 d1                	mov    %edx,%ecx
  800f7e:	89 d3                	mov    %edx,%ebx
  800f80:	89 d7                	mov    %edx,%edi
  800f82:	89 d6                	mov    %edx,%esi
  800f84:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f86:	5b                   	pop    %ebx
  800f87:	5e                   	pop    %esi
  800f88:	5f                   	pop    %edi
  800f89:	5d                   	pop    %ebp
  800f8a:	c3                   	ret    

00800f8b <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f8b:	55                   	push   %ebp
  800f8c:	89 e5                	mov    %esp,%ebp
  800f8e:	57                   	push   %edi
  800f8f:	56                   	push   %esi
  800f90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f96:	8b 55 08             	mov    0x8(%ebp),%edx
  800f99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9c:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa1:	89 df                	mov    %ebx,%edi
  800fa3:	89 de                	mov    %ebx,%esi
  800fa5:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fa7:	5b                   	pop    %ebx
  800fa8:	5e                   	pop    %esi
  800fa9:	5f                   	pop    %edi
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	57                   	push   %edi
  800fb0:	56                   	push   %esi
  800fb1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800fba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fbd:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc2:	89 df                	mov    %ebx,%edi
  800fc4:	89 de                	mov    %ebx,%esi
  800fc6:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fc8:	5b                   	pop    %ebx
  800fc9:	5e                   	pop    %esi
  800fca:	5f                   	pop    %edi
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
  800fd0:	57                   	push   %edi
  800fd1:	56                   	push   %esi
  800fd2:	53                   	push   %ebx
  800fd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fdb:	8b 55 08             	mov    0x8(%ebp),%edx
  800fde:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe1:	b8 13 00 00 00       	mov    $0x13,%eax
  800fe6:	89 df                	mov    %ebx,%edi
  800fe8:	89 de                	mov    %ebx,%esi
  800fea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	7f 08                	jg     800ff8 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	50                   	push   %eax
  800ffc:	6a 13                	push   $0x13
  800ffe:	68 68 29 80 00       	push   $0x802968
  801003:	6a 43                	push   $0x43
  801005:	68 85 29 80 00       	push   $0x802985
  80100a:	e8 76 11 00 00       	call   802185 <_panic>

0080100f <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80100f:	55                   	push   %ebp
  801010:	89 e5                	mov    %esp,%ebp
  801012:	57                   	push   %edi
  801013:	56                   	push   %esi
  801014:	53                   	push   %ebx
	asm volatile("int %1\n"
  801015:	b9 00 00 00 00       	mov    $0x0,%ecx
  80101a:	8b 55 08             	mov    0x8(%ebp),%edx
  80101d:	b8 14 00 00 00       	mov    $0x14,%eax
  801022:	89 cb                	mov    %ecx,%ebx
  801024:	89 cf                	mov    %ecx,%edi
  801026:	89 ce                	mov    %ecx,%esi
  801028:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  80102a:	5b                   	pop    %ebx
  80102b:	5e                   	pop    %esi
  80102c:	5f                   	pop    %edi
  80102d:	5d                   	pop    %ebp
  80102e:	c3                   	ret    

0080102f <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80102f:	55                   	push   %ebp
  801030:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	05 00 00 00 30       	add    $0x30000000,%eax
  80103a:	c1 e8 0c             	shr    $0xc,%eax
}
  80103d:	5d                   	pop    %ebp
  80103e:	c3                   	ret    

0080103f <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80104a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80104f:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801054:	5d                   	pop    %ebp
  801055:	c3                   	ret    

00801056 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801056:	55                   	push   %ebp
  801057:	89 e5                	mov    %esp,%ebp
  801059:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80105e:	89 c2                	mov    %eax,%edx
  801060:	c1 ea 16             	shr    $0x16,%edx
  801063:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80106a:	f6 c2 01             	test   $0x1,%dl
  80106d:	74 2d                	je     80109c <fd_alloc+0x46>
  80106f:	89 c2                	mov    %eax,%edx
  801071:	c1 ea 0c             	shr    $0xc,%edx
  801074:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80107b:	f6 c2 01             	test   $0x1,%dl
  80107e:	74 1c                	je     80109c <fd_alloc+0x46>
  801080:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801085:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80108a:	75 d2                	jne    80105e <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80108c:	8b 45 08             	mov    0x8(%ebp),%eax
  80108f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801095:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80109a:	eb 0a                	jmp    8010a6 <fd_alloc+0x50>
			*fd_store = fd;
  80109c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80109f:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010ae:	83 f8 1f             	cmp    $0x1f,%eax
  8010b1:	77 30                	ja     8010e3 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010b3:	c1 e0 0c             	shl    $0xc,%eax
  8010b6:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010bb:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010c1:	f6 c2 01             	test   $0x1,%dl
  8010c4:	74 24                	je     8010ea <fd_lookup+0x42>
  8010c6:	89 c2                	mov    %eax,%edx
  8010c8:	c1 ea 0c             	shr    $0xc,%edx
  8010cb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d2:	f6 c2 01             	test   $0x1,%dl
  8010d5:	74 1a                	je     8010f1 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010da:	89 02                	mov    %eax,(%edx)
	return 0;
  8010dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e1:	5d                   	pop    %ebp
  8010e2:	c3                   	ret    
		return -E_INVAL;
  8010e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010e8:	eb f7                	jmp    8010e1 <fd_lookup+0x39>
		return -E_INVAL;
  8010ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ef:	eb f0                	jmp    8010e1 <fd_lookup+0x39>
  8010f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f6:	eb e9                	jmp    8010e1 <fd_lookup+0x39>

008010f8 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801101:	ba 00 00 00 00       	mov    $0x0,%edx
  801106:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80110b:	39 08                	cmp    %ecx,(%eax)
  80110d:	74 38                	je     801147 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80110f:	83 c2 01             	add    $0x1,%edx
  801112:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  801119:	85 c0                	test   %eax,%eax
  80111b:	75 ee                	jne    80110b <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80111d:	a1 08 40 80 00       	mov    0x804008,%eax
  801122:	8b 40 48             	mov    0x48(%eax),%eax
  801125:	83 ec 04             	sub    $0x4,%esp
  801128:	51                   	push   %ecx
  801129:	50                   	push   %eax
  80112a:	68 94 29 80 00       	push   $0x802994
  80112f:	e8 b5 f0 ff ff       	call   8001e9 <cprintf>
	*dev = 0;
  801134:	8b 45 0c             	mov    0xc(%ebp),%eax
  801137:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80113d:	83 c4 10             	add    $0x10,%esp
  801140:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801145:	c9                   	leave  
  801146:	c3                   	ret    
			*dev = devtab[i];
  801147:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80114c:	b8 00 00 00 00       	mov    $0x0,%eax
  801151:	eb f2                	jmp    801145 <dev_lookup+0x4d>

00801153 <fd_close>:
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	57                   	push   %edi
  801157:	56                   	push   %esi
  801158:	53                   	push   %ebx
  801159:	83 ec 24             	sub    $0x24,%esp
  80115c:	8b 75 08             	mov    0x8(%ebp),%esi
  80115f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801162:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801165:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801166:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80116c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80116f:	50                   	push   %eax
  801170:	e8 33 ff ff ff       	call   8010a8 <fd_lookup>
  801175:	89 c3                	mov    %eax,%ebx
  801177:	83 c4 10             	add    $0x10,%esp
  80117a:	85 c0                	test   %eax,%eax
  80117c:	78 05                	js     801183 <fd_close+0x30>
	    || fd != fd2)
  80117e:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801181:	74 16                	je     801199 <fd_close+0x46>
		return (must_exist ? r : 0);
  801183:	89 f8                	mov    %edi,%eax
  801185:	84 c0                	test   %al,%al
  801187:	b8 00 00 00 00       	mov    $0x0,%eax
  80118c:	0f 44 d8             	cmove  %eax,%ebx
}
  80118f:	89 d8                	mov    %ebx,%eax
  801191:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801194:	5b                   	pop    %ebx
  801195:	5e                   	pop    %esi
  801196:	5f                   	pop    %edi
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801199:	83 ec 08             	sub    $0x8,%esp
  80119c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80119f:	50                   	push   %eax
  8011a0:	ff 36                	pushl  (%esi)
  8011a2:	e8 51 ff ff ff       	call   8010f8 <dev_lookup>
  8011a7:	89 c3                	mov    %eax,%ebx
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 1a                	js     8011ca <fd_close+0x77>
		if (dev->dev_close)
  8011b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011b3:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011b6:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	74 0b                	je     8011ca <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011bf:	83 ec 0c             	sub    $0xc,%esp
  8011c2:	56                   	push   %esi
  8011c3:	ff d0                	call   *%eax
  8011c5:	89 c3                	mov    %eax,%ebx
  8011c7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ca:	83 ec 08             	sub    $0x8,%esp
  8011cd:	56                   	push   %esi
  8011ce:	6a 00                	push   $0x0
  8011d0:	e8 ea fb ff ff       	call   800dbf <sys_page_unmap>
	return r;
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	eb b5                	jmp    80118f <fd_close+0x3c>

008011da <close>:

int
close(int fdnum)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011e3:	50                   	push   %eax
  8011e4:	ff 75 08             	pushl  0x8(%ebp)
  8011e7:	e8 bc fe ff ff       	call   8010a8 <fd_lookup>
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	79 02                	jns    8011f5 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011f3:	c9                   	leave  
  8011f4:	c3                   	ret    
		return fd_close(fd, 1);
  8011f5:	83 ec 08             	sub    $0x8,%esp
  8011f8:	6a 01                	push   $0x1
  8011fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8011fd:	e8 51 ff ff ff       	call   801153 <fd_close>
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	eb ec                	jmp    8011f3 <close+0x19>

00801207 <close_all>:

void
close_all(void)
{
  801207:	55                   	push   %ebp
  801208:	89 e5                	mov    %esp,%ebp
  80120a:	53                   	push   %ebx
  80120b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80120e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801213:	83 ec 0c             	sub    $0xc,%esp
  801216:	53                   	push   %ebx
  801217:	e8 be ff ff ff       	call   8011da <close>
	for (i = 0; i < MAXFD; i++)
  80121c:	83 c3 01             	add    $0x1,%ebx
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	83 fb 20             	cmp    $0x20,%ebx
  801225:	75 ec                	jne    801213 <close_all+0xc>
}
  801227:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    

0080122c <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801235:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801238:	50                   	push   %eax
  801239:	ff 75 08             	pushl  0x8(%ebp)
  80123c:	e8 67 fe ff ff       	call   8010a8 <fd_lookup>
  801241:	89 c3                	mov    %eax,%ebx
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	0f 88 81 00 00 00    	js     8012cf <dup+0xa3>
		return r;
	close(newfdnum);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 0c             	pushl  0xc(%ebp)
  801254:	e8 81 ff ff ff       	call   8011da <close>

	newfd = INDEX2FD(newfdnum);
  801259:	8b 75 0c             	mov    0xc(%ebp),%esi
  80125c:	c1 e6 0c             	shl    $0xc,%esi
  80125f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801265:	83 c4 04             	add    $0x4,%esp
  801268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80126b:	e8 cf fd ff ff       	call   80103f <fd2data>
  801270:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801272:	89 34 24             	mov    %esi,(%esp)
  801275:	e8 c5 fd ff ff       	call   80103f <fd2data>
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80127f:	89 d8                	mov    %ebx,%eax
  801281:	c1 e8 16             	shr    $0x16,%eax
  801284:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80128b:	a8 01                	test   $0x1,%al
  80128d:	74 11                	je     8012a0 <dup+0x74>
  80128f:	89 d8                	mov    %ebx,%eax
  801291:	c1 e8 0c             	shr    $0xc,%eax
  801294:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80129b:	f6 c2 01             	test   $0x1,%dl
  80129e:	75 39                	jne    8012d9 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012a0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	c1 e8 0c             	shr    $0xc,%eax
  8012a8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	25 07 0e 00 00       	and    $0xe07,%eax
  8012b7:	50                   	push   %eax
  8012b8:	56                   	push   %esi
  8012b9:	6a 00                	push   $0x0
  8012bb:	52                   	push   %edx
  8012bc:	6a 00                	push   $0x0
  8012be:	e8 ba fa ff ff       	call   800d7d <sys_page_map>
  8012c3:	89 c3                	mov    %eax,%ebx
  8012c5:	83 c4 20             	add    $0x20,%esp
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	78 31                	js     8012fd <dup+0xd1>
		goto err;

	return newfdnum;
  8012cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012cf:	89 d8                	mov    %ebx,%eax
  8012d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d4:	5b                   	pop    %ebx
  8012d5:	5e                   	pop    %esi
  8012d6:	5f                   	pop    %edi
  8012d7:	5d                   	pop    %ebp
  8012d8:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012d9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e0:	83 ec 0c             	sub    $0xc,%esp
  8012e3:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e8:	50                   	push   %eax
  8012e9:	57                   	push   %edi
  8012ea:	6a 00                	push   $0x0
  8012ec:	53                   	push   %ebx
  8012ed:	6a 00                	push   $0x0
  8012ef:	e8 89 fa ff ff       	call   800d7d <sys_page_map>
  8012f4:	89 c3                	mov    %eax,%ebx
  8012f6:	83 c4 20             	add    $0x20,%esp
  8012f9:	85 c0                	test   %eax,%eax
  8012fb:	79 a3                	jns    8012a0 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012fd:	83 ec 08             	sub    $0x8,%esp
  801300:	56                   	push   %esi
  801301:	6a 00                	push   $0x0
  801303:	e8 b7 fa ff ff       	call   800dbf <sys_page_unmap>
	sys_page_unmap(0, nva);
  801308:	83 c4 08             	add    $0x8,%esp
  80130b:	57                   	push   %edi
  80130c:	6a 00                	push   $0x0
  80130e:	e8 ac fa ff ff       	call   800dbf <sys_page_unmap>
	return r;
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	eb b7                	jmp    8012cf <dup+0xa3>

00801318 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	53                   	push   %ebx
  80131c:	83 ec 1c             	sub    $0x1c,%esp
  80131f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801322:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801325:	50                   	push   %eax
  801326:	53                   	push   %ebx
  801327:	e8 7c fd ff ff       	call   8010a8 <fd_lookup>
  80132c:	83 c4 10             	add    $0x10,%esp
  80132f:	85 c0                	test   %eax,%eax
  801331:	78 3f                	js     801372 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801333:	83 ec 08             	sub    $0x8,%esp
  801336:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133d:	ff 30                	pushl  (%eax)
  80133f:	e8 b4 fd ff ff       	call   8010f8 <dev_lookup>
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	85 c0                	test   %eax,%eax
  801349:	78 27                	js     801372 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80134b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80134e:	8b 42 08             	mov    0x8(%edx),%eax
  801351:	83 e0 03             	and    $0x3,%eax
  801354:	83 f8 01             	cmp    $0x1,%eax
  801357:	74 1e                	je     801377 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80135c:	8b 40 08             	mov    0x8(%eax),%eax
  80135f:	85 c0                	test   %eax,%eax
  801361:	74 35                	je     801398 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801363:	83 ec 04             	sub    $0x4,%esp
  801366:	ff 75 10             	pushl  0x10(%ebp)
  801369:	ff 75 0c             	pushl  0xc(%ebp)
  80136c:	52                   	push   %edx
  80136d:	ff d0                	call   *%eax
  80136f:	83 c4 10             	add    $0x10,%esp
}
  801372:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801375:	c9                   	leave  
  801376:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801377:	a1 08 40 80 00       	mov    0x804008,%eax
  80137c:	8b 40 48             	mov    0x48(%eax),%eax
  80137f:	83 ec 04             	sub    $0x4,%esp
  801382:	53                   	push   %ebx
  801383:	50                   	push   %eax
  801384:	68 d5 29 80 00       	push   $0x8029d5
  801389:	e8 5b ee ff ff       	call   8001e9 <cprintf>
		return -E_INVAL;
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801396:	eb da                	jmp    801372 <read+0x5a>
		return -E_NOT_SUPP;
  801398:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139d:	eb d3                	jmp    801372 <read+0x5a>

0080139f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	57                   	push   %edi
  8013a3:	56                   	push   %esi
  8013a4:	53                   	push   %ebx
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013ab:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013b3:	39 f3                	cmp    %esi,%ebx
  8013b5:	73 23                	jae    8013da <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013b7:	83 ec 04             	sub    $0x4,%esp
  8013ba:	89 f0                	mov    %esi,%eax
  8013bc:	29 d8                	sub    %ebx,%eax
  8013be:	50                   	push   %eax
  8013bf:	89 d8                	mov    %ebx,%eax
  8013c1:	03 45 0c             	add    0xc(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	57                   	push   %edi
  8013c6:	e8 4d ff ff ff       	call   801318 <read>
		if (m < 0)
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 06                	js     8013d8 <readn+0x39>
			return m;
		if (m == 0)
  8013d2:	74 06                	je     8013da <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013d4:	01 c3                	add    %eax,%ebx
  8013d6:	eb db                	jmp    8013b3 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013d8:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013da:	89 d8                	mov    %ebx,%eax
  8013dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013df:	5b                   	pop    %ebx
  8013e0:	5e                   	pop    %esi
  8013e1:	5f                   	pop    %edi
  8013e2:	5d                   	pop    %ebp
  8013e3:	c3                   	ret    

008013e4 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	53                   	push   %ebx
  8013e8:	83 ec 1c             	sub    $0x1c,%esp
  8013eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ee:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f1:	50                   	push   %eax
  8013f2:	53                   	push   %ebx
  8013f3:	e8 b0 fc ff ff       	call   8010a8 <fd_lookup>
  8013f8:	83 c4 10             	add    $0x10,%esp
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	78 3a                	js     801439 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ff:	83 ec 08             	sub    $0x8,%esp
  801402:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801405:	50                   	push   %eax
  801406:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801409:	ff 30                	pushl  (%eax)
  80140b:	e8 e8 fc ff ff       	call   8010f8 <dev_lookup>
  801410:	83 c4 10             	add    $0x10,%esp
  801413:	85 c0                	test   %eax,%eax
  801415:	78 22                	js     801439 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80141e:	74 1e                	je     80143e <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801420:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801423:	8b 52 0c             	mov    0xc(%edx),%edx
  801426:	85 d2                	test   %edx,%edx
  801428:	74 35                	je     80145f <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80142a:	83 ec 04             	sub    $0x4,%esp
  80142d:	ff 75 10             	pushl  0x10(%ebp)
  801430:	ff 75 0c             	pushl  0xc(%ebp)
  801433:	50                   	push   %eax
  801434:	ff d2                	call   *%edx
  801436:	83 c4 10             	add    $0x10,%esp
}
  801439:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80143c:	c9                   	leave  
  80143d:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80143e:	a1 08 40 80 00       	mov    0x804008,%eax
  801443:	8b 40 48             	mov    0x48(%eax),%eax
  801446:	83 ec 04             	sub    $0x4,%esp
  801449:	53                   	push   %ebx
  80144a:	50                   	push   %eax
  80144b:	68 f1 29 80 00       	push   $0x8029f1
  801450:	e8 94 ed ff ff       	call   8001e9 <cprintf>
		return -E_INVAL;
  801455:	83 c4 10             	add    $0x10,%esp
  801458:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80145d:	eb da                	jmp    801439 <write+0x55>
		return -E_NOT_SUPP;
  80145f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801464:	eb d3                	jmp    801439 <write+0x55>

00801466 <seek>:

int
seek(int fdnum, off_t offset)
{
  801466:	55                   	push   %ebp
  801467:	89 e5                	mov    %esp,%ebp
  801469:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80146c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80146f:	50                   	push   %eax
  801470:	ff 75 08             	pushl  0x8(%ebp)
  801473:	e8 30 fc ff ff       	call   8010a8 <fd_lookup>
  801478:	83 c4 10             	add    $0x10,%esp
  80147b:	85 c0                	test   %eax,%eax
  80147d:	78 0e                	js     80148d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80147f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801485:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801488:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80148d:	c9                   	leave  
  80148e:	c3                   	ret    

0080148f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80148f:	55                   	push   %ebp
  801490:	89 e5                	mov    %esp,%ebp
  801492:	53                   	push   %ebx
  801493:	83 ec 1c             	sub    $0x1c,%esp
  801496:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801499:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80149c:	50                   	push   %eax
  80149d:	53                   	push   %ebx
  80149e:	e8 05 fc ff ff       	call   8010a8 <fd_lookup>
  8014a3:	83 c4 10             	add    $0x10,%esp
  8014a6:	85 c0                	test   %eax,%eax
  8014a8:	78 37                	js     8014e1 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014aa:	83 ec 08             	sub    $0x8,%esp
  8014ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b0:	50                   	push   %eax
  8014b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b4:	ff 30                	pushl  (%eax)
  8014b6:	e8 3d fc ff ff       	call   8010f8 <dev_lookup>
  8014bb:	83 c4 10             	add    $0x10,%esp
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 1f                	js     8014e1 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c5:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014c9:	74 1b                	je     8014e6 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014ce:	8b 52 18             	mov    0x18(%edx),%edx
  8014d1:	85 d2                	test   %edx,%edx
  8014d3:	74 32                	je     801507 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014d5:	83 ec 08             	sub    $0x8,%esp
  8014d8:	ff 75 0c             	pushl  0xc(%ebp)
  8014db:	50                   	push   %eax
  8014dc:	ff d2                	call   *%edx
  8014de:	83 c4 10             	add    $0x10,%esp
}
  8014e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014e4:	c9                   	leave  
  8014e5:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014e6:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014eb:	8b 40 48             	mov    0x48(%eax),%eax
  8014ee:	83 ec 04             	sub    $0x4,%esp
  8014f1:	53                   	push   %ebx
  8014f2:	50                   	push   %eax
  8014f3:	68 b4 29 80 00       	push   $0x8029b4
  8014f8:	e8 ec ec ff ff       	call   8001e9 <cprintf>
		return -E_INVAL;
  8014fd:	83 c4 10             	add    $0x10,%esp
  801500:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801505:	eb da                	jmp    8014e1 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801507:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150c:	eb d3                	jmp    8014e1 <ftruncate+0x52>

0080150e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	53                   	push   %ebx
  801512:	83 ec 1c             	sub    $0x1c,%esp
  801515:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801518:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151b:	50                   	push   %eax
  80151c:	ff 75 08             	pushl  0x8(%ebp)
  80151f:	e8 84 fb ff ff       	call   8010a8 <fd_lookup>
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 4b                	js     801576 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801531:	50                   	push   %eax
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801535:	ff 30                	pushl  (%eax)
  801537:	e8 bc fb ff ff       	call   8010f8 <dev_lookup>
  80153c:	83 c4 10             	add    $0x10,%esp
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 33                	js     801576 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801543:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801546:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80154a:	74 2f                	je     80157b <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80154c:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80154f:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801556:	00 00 00 
	stat->st_isdir = 0;
  801559:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801560:	00 00 00 
	stat->st_dev = dev;
  801563:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	53                   	push   %ebx
  80156d:	ff 75 f0             	pushl  -0x10(%ebp)
  801570:	ff 50 14             	call   *0x14(%eax)
  801573:	83 c4 10             	add    $0x10,%esp
}
  801576:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801579:	c9                   	leave  
  80157a:	c3                   	ret    
		return -E_NOT_SUPP;
  80157b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801580:	eb f4                	jmp    801576 <fstat+0x68>

00801582 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801582:	55                   	push   %ebp
  801583:	89 e5                	mov    %esp,%ebp
  801585:	56                   	push   %esi
  801586:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801587:	83 ec 08             	sub    $0x8,%esp
  80158a:	6a 00                	push   $0x0
  80158c:	ff 75 08             	pushl  0x8(%ebp)
  80158f:	e8 22 02 00 00       	call   8017b6 <open>
  801594:	89 c3                	mov    %eax,%ebx
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	85 c0                	test   %eax,%eax
  80159b:	78 1b                	js     8015b8 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80159d:	83 ec 08             	sub    $0x8,%esp
  8015a0:	ff 75 0c             	pushl  0xc(%ebp)
  8015a3:	50                   	push   %eax
  8015a4:	e8 65 ff ff ff       	call   80150e <fstat>
  8015a9:	89 c6                	mov    %eax,%esi
	close(fd);
  8015ab:	89 1c 24             	mov    %ebx,(%esp)
  8015ae:	e8 27 fc ff ff       	call   8011da <close>
	return r;
  8015b3:	83 c4 10             	add    $0x10,%esp
  8015b6:	89 f3                	mov    %esi,%ebx
}
  8015b8:	89 d8                	mov    %ebx,%eax
  8015ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bd:	5b                   	pop    %ebx
  8015be:	5e                   	pop    %esi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    

008015c1 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	56                   	push   %esi
  8015c5:	53                   	push   %ebx
  8015c6:	89 c6                	mov    %eax,%esi
  8015c8:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ca:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015d1:	74 27                	je     8015fa <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015d3:	6a 07                	push   $0x7
  8015d5:	68 00 50 80 00       	push   $0x805000
  8015da:	56                   	push   %esi
  8015db:	ff 35 00 40 80 00    	pushl  0x804000
  8015e1:	e8 69 0c 00 00       	call   80224f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015e6:	83 c4 0c             	add    $0xc,%esp
  8015e9:	6a 00                	push   $0x0
  8015eb:	53                   	push   %ebx
  8015ec:	6a 00                	push   $0x0
  8015ee:	e8 f3 0b 00 00       	call   8021e6 <ipc_recv>
}
  8015f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f6:	5b                   	pop    %ebx
  8015f7:	5e                   	pop    %esi
  8015f8:	5d                   	pop    %ebp
  8015f9:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015fa:	83 ec 0c             	sub    $0xc,%esp
  8015fd:	6a 01                	push   $0x1
  8015ff:	e8 a3 0c 00 00       	call   8022a7 <ipc_find_env>
  801604:	a3 00 40 80 00       	mov    %eax,0x804000
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	eb c5                	jmp    8015d3 <fsipc+0x12>

0080160e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80160e:	55                   	push   %ebp
  80160f:	89 e5                	mov    %esp,%ebp
  801611:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	8b 40 0c             	mov    0xc(%eax),%eax
  80161a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80161f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801622:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	b8 02 00 00 00       	mov    $0x2,%eax
  801631:	e8 8b ff ff ff       	call   8015c1 <fsipc>
}
  801636:	c9                   	leave  
  801637:	c3                   	ret    

00801638 <devfile_flush>:
{
  801638:	55                   	push   %ebp
  801639:	89 e5                	mov    %esp,%ebp
  80163b:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80163e:	8b 45 08             	mov    0x8(%ebp),%eax
  801641:	8b 40 0c             	mov    0xc(%eax),%eax
  801644:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801649:	ba 00 00 00 00       	mov    $0x0,%edx
  80164e:	b8 06 00 00 00       	mov    $0x6,%eax
  801653:	e8 69 ff ff ff       	call   8015c1 <fsipc>
}
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <devfile_stat>:
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
  80165d:	53                   	push   %ebx
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801664:	8b 45 08             	mov    0x8(%ebp),%eax
  801667:	8b 40 0c             	mov    0xc(%eax),%eax
  80166a:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80166f:	ba 00 00 00 00       	mov    $0x0,%edx
  801674:	b8 05 00 00 00       	mov    $0x5,%eax
  801679:	e8 43 ff ff ff       	call   8015c1 <fsipc>
  80167e:	85 c0                	test   %eax,%eax
  801680:	78 2c                	js     8016ae <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801682:	83 ec 08             	sub    $0x8,%esp
  801685:	68 00 50 80 00       	push   $0x805000
  80168a:	53                   	push   %ebx
  80168b:	e8 b8 f2 ff ff       	call   800948 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801690:	a1 80 50 80 00       	mov    0x805080,%eax
  801695:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80169b:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a0:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b1:	c9                   	leave  
  8016b2:	c3                   	ret    

008016b3 <devfile_write>:
{
  8016b3:	55                   	push   %ebp
  8016b4:	89 e5                	mov    %esp,%ebp
  8016b6:	53                   	push   %ebx
  8016b7:	83 ec 08             	sub    $0x8,%esp
  8016ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016c8:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016ce:	53                   	push   %ebx
  8016cf:	ff 75 0c             	pushl  0xc(%ebp)
  8016d2:	68 08 50 80 00       	push   $0x805008
  8016d7:	e8 5c f4 ff ff       	call   800b38 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e1:	b8 04 00 00 00       	mov    $0x4,%eax
  8016e6:	e8 d6 fe ff ff       	call   8015c1 <fsipc>
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	85 c0                	test   %eax,%eax
  8016f0:	78 0b                	js     8016fd <devfile_write+0x4a>
	assert(r <= n);
  8016f2:	39 d8                	cmp    %ebx,%eax
  8016f4:	77 0c                	ja     801702 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016f6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016fb:	7f 1e                	jg     80171b <devfile_write+0x68>
}
  8016fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801700:	c9                   	leave  
  801701:	c3                   	ret    
	assert(r <= n);
  801702:	68 24 2a 80 00       	push   $0x802a24
  801707:	68 2b 2a 80 00       	push   $0x802a2b
  80170c:	68 98 00 00 00       	push   $0x98
  801711:	68 40 2a 80 00       	push   $0x802a40
  801716:	e8 6a 0a 00 00       	call   802185 <_panic>
	assert(r <= PGSIZE);
  80171b:	68 4b 2a 80 00       	push   $0x802a4b
  801720:	68 2b 2a 80 00       	push   $0x802a2b
  801725:	68 99 00 00 00       	push   $0x99
  80172a:	68 40 2a 80 00       	push   $0x802a40
  80172f:	e8 51 0a 00 00       	call   802185 <_panic>

00801734 <devfile_read>:
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80173c:	8b 45 08             	mov    0x8(%ebp),%eax
  80173f:	8b 40 0c             	mov    0xc(%eax),%eax
  801742:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801747:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80174d:	ba 00 00 00 00       	mov    $0x0,%edx
  801752:	b8 03 00 00 00       	mov    $0x3,%eax
  801757:	e8 65 fe ff ff       	call   8015c1 <fsipc>
  80175c:	89 c3                	mov    %eax,%ebx
  80175e:	85 c0                	test   %eax,%eax
  801760:	78 1f                	js     801781 <devfile_read+0x4d>
	assert(r <= n);
  801762:	39 f0                	cmp    %esi,%eax
  801764:	77 24                	ja     80178a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801766:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80176b:	7f 33                	jg     8017a0 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80176d:	83 ec 04             	sub    $0x4,%esp
  801770:	50                   	push   %eax
  801771:	68 00 50 80 00       	push   $0x805000
  801776:	ff 75 0c             	pushl  0xc(%ebp)
  801779:	e8 58 f3 ff ff       	call   800ad6 <memmove>
	return r;
  80177e:	83 c4 10             	add    $0x10,%esp
}
  801781:	89 d8                	mov    %ebx,%eax
  801783:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801786:	5b                   	pop    %ebx
  801787:	5e                   	pop    %esi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    
	assert(r <= n);
  80178a:	68 24 2a 80 00       	push   $0x802a24
  80178f:	68 2b 2a 80 00       	push   $0x802a2b
  801794:	6a 7c                	push   $0x7c
  801796:	68 40 2a 80 00       	push   $0x802a40
  80179b:	e8 e5 09 00 00       	call   802185 <_panic>
	assert(r <= PGSIZE);
  8017a0:	68 4b 2a 80 00       	push   $0x802a4b
  8017a5:	68 2b 2a 80 00       	push   $0x802a2b
  8017aa:	6a 7d                	push   $0x7d
  8017ac:	68 40 2a 80 00       	push   $0x802a40
  8017b1:	e8 cf 09 00 00       	call   802185 <_panic>

008017b6 <open>:
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 1c             	sub    $0x1c,%esp
  8017be:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c1:	56                   	push   %esi
  8017c2:	e8 48 f1 ff ff       	call   80090f <strlen>
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017cf:	7f 6c                	jg     80183d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d1:	83 ec 0c             	sub    $0xc,%esp
  8017d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d7:	50                   	push   %eax
  8017d8:	e8 79 f8 ff ff       	call   801056 <fd_alloc>
  8017dd:	89 c3                	mov    %eax,%ebx
  8017df:	83 c4 10             	add    $0x10,%esp
  8017e2:	85 c0                	test   %eax,%eax
  8017e4:	78 3c                	js     801822 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017e6:	83 ec 08             	sub    $0x8,%esp
  8017e9:	56                   	push   %esi
  8017ea:	68 00 50 80 00       	push   $0x805000
  8017ef:	e8 54 f1 ff ff       	call   800948 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ff:	b8 01 00 00 00       	mov    $0x1,%eax
  801804:	e8 b8 fd ff ff       	call   8015c1 <fsipc>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 19                	js     80182b <open+0x75>
	return fd2num(fd);
  801812:	83 ec 0c             	sub    $0xc,%esp
  801815:	ff 75 f4             	pushl  -0xc(%ebp)
  801818:	e8 12 f8 ff ff       	call   80102f <fd2num>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	83 c4 10             	add    $0x10,%esp
}
  801822:	89 d8                	mov    %ebx,%eax
  801824:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801827:	5b                   	pop    %ebx
  801828:	5e                   	pop    %esi
  801829:	5d                   	pop    %ebp
  80182a:	c3                   	ret    
		fd_close(fd, 0);
  80182b:	83 ec 08             	sub    $0x8,%esp
  80182e:	6a 00                	push   $0x0
  801830:	ff 75 f4             	pushl  -0xc(%ebp)
  801833:	e8 1b f9 ff ff       	call   801153 <fd_close>
		return r;
  801838:	83 c4 10             	add    $0x10,%esp
  80183b:	eb e5                	jmp    801822 <open+0x6c>
		return -E_BAD_PATH;
  80183d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801842:	eb de                	jmp    801822 <open+0x6c>

00801844 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80184a:	ba 00 00 00 00       	mov    $0x0,%edx
  80184f:	b8 08 00 00 00       	mov    $0x8,%eax
  801854:	e8 68 fd ff ff       	call   8015c1 <fsipc>
}
  801859:	c9                   	leave  
  80185a:	c3                   	ret    

0080185b <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801861:	68 57 2a 80 00       	push   $0x802a57
  801866:	ff 75 0c             	pushl  0xc(%ebp)
  801869:	e8 da f0 ff ff       	call   800948 <strcpy>
	return 0;
}
  80186e:	b8 00 00 00 00       	mov    $0x0,%eax
  801873:	c9                   	leave  
  801874:	c3                   	ret    

00801875 <devsock_close>:
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	53                   	push   %ebx
  801879:	83 ec 10             	sub    $0x10,%esp
  80187c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80187f:	53                   	push   %ebx
  801880:	e8 5d 0a 00 00       	call   8022e2 <pageref>
  801885:	83 c4 10             	add    $0x10,%esp
		return 0;
  801888:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80188d:	83 f8 01             	cmp    $0x1,%eax
  801890:	74 07                	je     801899 <devsock_close+0x24>
}
  801892:	89 d0                	mov    %edx,%eax
  801894:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801897:	c9                   	leave  
  801898:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801899:	83 ec 0c             	sub    $0xc,%esp
  80189c:	ff 73 0c             	pushl  0xc(%ebx)
  80189f:	e8 b9 02 00 00       	call   801b5d <nsipc_close>
  8018a4:	89 c2                	mov    %eax,%edx
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	eb e7                	jmp    801892 <devsock_close+0x1d>

008018ab <devsock_write>:
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b1:	6a 00                	push   $0x0
  8018b3:	ff 75 10             	pushl  0x10(%ebp)
  8018b6:	ff 75 0c             	pushl  0xc(%ebp)
  8018b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bc:	ff 70 0c             	pushl  0xc(%eax)
  8018bf:	e8 76 03 00 00       	call   801c3a <nsipc_send>
}
  8018c4:	c9                   	leave  
  8018c5:	c3                   	ret    

008018c6 <devsock_read>:
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	ff 75 10             	pushl  0x10(%ebp)
  8018d1:	ff 75 0c             	pushl  0xc(%ebp)
  8018d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d7:	ff 70 0c             	pushl  0xc(%eax)
  8018da:	e8 ef 02 00 00       	call   801bce <nsipc_recv>
}
  8018df:	c9                   	leave  
  8018e0:	c3                   	ret    

008018e1 <fd2sockid>:
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018e7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018ea:	52                   	push   %edx
  8018eb:	50                   	push   %eax
  8018ec:	e8 b7 f7 ff ff       	call   8010a8 <fd_lookup>
  8018f1:	83 c4 10             	add    $0x10,%esp
  8018f4:	85 c0                	test   %eax,%eax
  8018f6:	78 10                	js     801908 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018fb:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801901:	39 08                	cmp    %ecx,(%eax)
  801903:	75 05                	jne    80190a <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801905:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801908:	c9                   	leave  
  801909:	c3                   	ret    
		return -E_NOT_SUPP;
  80190a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80190f:	eb f7                	jmp    801908 <fd2sockid+0x27>

00801911 <alloc_sockfd>:
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	83 ec 1c             	sub    $0x1c,%esp
  801919:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80191b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80191e:	50                   	push   %eax
  80191f:	e8 32 f7 ff ff       	call   801056 <fd_alloc>
  801924:	89 c3                	mov    %eax,%ebx
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	85 c0                	test   %eax,%eax
  80192b:	78 43                	js     801970 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80192d:	83 ec 04             	sub    $0x4,%esp
  801930:	68 07 04 00 00       	push   $0x407
  801935:	ff 75 f4             	pushl  -0xc(%ebp)
  801938:	6a 00                	push   $0x0
  80193a:	e8 fb f3 ff ff       	call   800d3a <sys_page_alloc>
  80193f:	89 c3                	mov    %eax,%ebx
  801941:	83 c4 10             	add    $0x10,%esp
  801944:	85 c0                	test   %eax,%eax
  801946:	78 28                	js     801970 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801948:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80194b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801951:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801956:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80195d:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	50                   	push   %eax
  801964:	e8 c6 f6 ff ff       	call   80102f <fd2num>
  801969:	89 c3                	mov    %eax,%ebx
  80196b:	83 c4 10             	add    $0x10,%esp
  80196e:	eb 0c                	jmp    80197c <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	56                   	push   %esi
  801974:	e8 e4 01 00 00       	call   801b5d <nsipc_close>
		return r;
  801979:	83 c4 10             	add    $0x10,%esp
}
  80197c:	89 d8                	mov    %ebx,%eax
  80197e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801981:	5b                   	pop    %ebx
  801982:	5e                   	pop    %esi
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <accept>:
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80198b:	8b 45 08             	mov    0x8(%ebp),%eax
  80198e:	e8 4e ff ff ff       	call   8018e1 <fd2sockid>
  801993:	85 c0                	test   %eax,%eax
  801995:	78 1b                	js     8019b2 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801997:	83 ec 04             	sub    $0x4,%esp
  80199a:	ff 75 10             	pushl  0x10(%ebp)
  80199d:	ff 75 0c             	pushl  0xc(%ebp)
  8019a0:	50                   	push   %eax
  8019a1:	e8 0e 01 00 00       	call   801ab4 <nsipc_accept>
  8019a6:	83 c4 10             	add    $0x10,%esp
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 05                	js     8019b2 <accept+0x2d>
	return alloc_sockfd(r);
  8019ad:	e8 5f ff ff ff       	call   801911 <alloc_sockfd>
}
  8019b2:	c9                   	leave  
  8019b3:	c3                   	ret    

008019b4 <bind>:
{
  8019b4:	55                   	push   %ebp
  8019b5:	89 e5                	mov    %esp,%ebp
  8019b7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	e8 1f ff ff ff       	call   8018e1 <fd2sockid>
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 12                	js     8019d8 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019c6:	83 ec 04             	sub    $0x4,%esp
  8019c9:	ff 75 10             	pushl  0x10(%ebp)
  8019cc:	ff 75 0c             	pushl  0xc(%ebp)
  8019cf:	50                   	push   %eax
  8019d0:	e8 31 01 00 00       	call   801b06 <nsipc_bind>
  8019d5:	83 c4 10             	add    $0x10,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <shutdown>:
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e3:	e8 f9 fe ff ff       	call   8018e1 <fd2sockid>
  8019e8:	85 c0                	test   %eax,%eax
  8019ea:	78 0f                	js     8019fb <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ec:	83 ec 08             	sub    $0x8,%esp
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	50                   	push   %eax
  8019f3:	e8 43 01 00 00       	call   801b3b <nsipc_shutdown>
  8019f8:	83 c4 10             	add    $0x10,%esp
}
  8019fb:	c9                   	leave  
  8019fc:	c3                   	ret    

008019fd <connect>:
{
  8019fd:	55                   	push   %ebp
  8019fe:	89 e5                	mov    %esp,%ebp
  801a00:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a03:	8b 45 08             	mov    0x8(%ebp),%eax
  801a06:	e8 d6 fe ff ff       	call   8018e1 <fd2sockid>
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 12                	js     801a21 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a0f:	83 ec 04             	sub    $0x4,%esp
  801a12:	ff 75 10             	pushl  0x10(%ebp)
  801a15:	ff 75 0c             	pushl  0xc(%ebp)
  801a18:	50                   	push   %eax
  801a19:	e8 59 01 00 00       	call   801b77 <nsipc_connect>
  801a1e:	83 c4 10             	add    $0x10,%esp
}
  801a21:	c9                   	leave  
  801a22:	c3                   	ret    

00801a23 <listen>:
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
  801a26:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	e8 b0 fe ff ff       	call   8018e1 <fd2sockid>
  801a31:	85 c0                	test   %eax,%eax
  801a33:	78 0f                	js     801a44 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a35:	83 ec 08             	sub    $0x8,%esp
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	50                   	push   %eax
  801a3c:	e8 6b 01 00 00       	call   801bac <nsipc_listen>
  801a41:	83 c4 10             	add    $0x10,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
  801a49:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a4c:	ff 75 10             	pushl  0x10(%ebp)
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	e8 3e 02 00 00       	call   801c98 <nsipc_socket>
  801a5a:	83 c4 10             	add    $0x10,%esp
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 05                	js     801a66 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a61:	e8 ab fe ff ff       	call   801911 <alloc_sockfd>
}
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 04             	sub    $0x4,%esp
  801a6f:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a71:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a78:	74 26                	je     801aa0 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a7a:	6a 07                	push   $0x7
  801a7c:	68 00 60 80 00       	push   $0x806000
  801a81:	53                   	push   %ebx
  801a82:	ff 35 04 40 80 00    	pushl  0x804004
  801a88:	e8 c2 07 00 00       	call   80224f <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a8d:	83 c4 0c             	add    $0xc,%esp
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	e8 4b 07 00 00       	call   8021e6 <ipc_recv>
}
  801a9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aa0:	83 ec 0c             	sub    $0xc,%esp
  801aa3:	6a 02                	push   $0x2
  801aa5:	e8 fd 07 00 00       	call   8022a7 <ipc_find_env>
  801aaa:	a3 04 40 80 00       	mov    %eax,0x804004
  801aaf:	83 c4 10             	add    $0x10,%esp
  801ab2:	eb c6                	jmp    801a7a <nsipc+0x12>

00801ab4 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
  801ab7:	56                   	push   %esi
  801ab8:	53                   	push   %ebx
  801ab9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801abc:	8b 45 08             	mov    0x8(%ebp),%eax
  801abf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ac4:	8b 06                	mov    (%esi),%eax
  801ac6:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801acb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad0:	e8 93 ff ff ff       	call   801a68 <nsipc>
  801ad5:	89 c3                	mov    %eax,%ebx
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	79 09                	jns    801ae4 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801adb:	89 d8                	mov    %ebx,%eax
  801add:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae0:	5b                   	pop    %ebx
  801ae1:	5e                   	pop    %esi
  801ae2:	5d                   	pop    %ebp
  801ae3:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ae4:	83 ec 04             	sub    $0x4,%esp
  801ae7:	ff 35 10 60 80 00    	pushl  0x806010
  801aed:	68 00 60 80 00       	push   $0x806000
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	e8 dc ef ff ff       	call   800ad6 <memmove>
		*addrlen = ret->ret_addrlen;
  801afa:	a1 10 60 80 00       	mov    0x806010,%eax
  801aff:	89 06                	mov    %eax,(%esi)
  801b01:	83 c4 10             	add    $0x10,%esp
	return r;
  801b04:	eb d5                	jmp    801adb <nsipc_accept+0x27>

00801b06 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	53                   	push   %ebx
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b18:	53                   	push   %ebx
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	68 04 60 80 00       	push   $0x806004
  801b21:	e8 b0 ef ff ff       	call   800ad6 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b26:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b2c:	b8 02 00 00 00       	mov    $0x2,%eax
  801b31:	e8 32 ff ff ff       	call   801a68 <nsipc>
}
  801b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b51:	b8 03 00 00 00       	mov    $0x3,%eax
  801b56:	e8 0d ff ff ff       	call   801a68 <nsipc>
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <nsipc_close>:

int
nsipc_close(int s)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b63:	8b 45 08             	mov    0x8(%ebp),%eax
  801b66:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b6b:	b8 04 00 00 00       	mov    $0x4,%eax
  801b70:	e8 f3 fe ff ff       	call   801a68 <nsipc>
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
  801b7a:	53                   	push   %ebx
  801b7b:	83 ec 08             	sub    $0x8,%esp
  801b7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b81:	8b 45 08             	mov    0x8(%ebp),%eax
  801b84:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b89:	53                   	push   %ebx
  801b8a:	ff 75 0c             	pushl  0xc(%ebp)
  801b8d:	68 04 60 80 00       	push   $0x806004
  801b92:	e8 3f ef ff ff       	call   800ad6 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b97:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b9d:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba2:	e8 c1 fe ff ff       	call   801a68 <nsipc>
}
  801ba7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bbd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc2:	b8 06 00 00 00       	mov    $0x6,%eax
  801bc7:	e8 9c fe ff ff       	call   801a68 <nsipc>
}
  801bcc:	c9                   	leave  
  801bcd:	c3                   	ret    

00801bce <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bce:	55                   	push   %ebp
  801bcf:	89 e5                	mov    %esp,%ebp
  801bd1:	56                   	push   %esi
  801bd2:	53                   	push   %ebx
  801bd3:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bde:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801be4:	8b 45 14             	mov    0x14(%ebp),%eax
  801be7:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bec:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf1:	e8 72 fe ff ff       	call   801a68 <nsipc>
  801bf6:	89 c3                	mov    %eax,%ebx
  801bf8:	85 c0                	test   %eax,%eax
  801bfa:	78 1f                	js     801c1b <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bfc:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c01:	7f 21                	jg     801c24 <nsipc_recv+0x56>
  801c03:	39 c6                	cmp    %eax,%esi
  801c05:	7c 1d                	jl     801c24 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c07:	83 ec 04             	sub    $0x4,%esp
  801c0a:	50                   	push   %eax
  801c0b:	68 00 60 80 00       	push   $0x806000
  801c10:	ff 75 0c             	pushl  0xc(%ebp)
  801c13:	e8 be ee ff ff       	call   800ad6 <memmove>
  801c18:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c1b:	89 d8                	mov    %ebx,%eax
  801c1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5d                   	pop    %ebp
  801c23:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c24:	68 63 2a 80 00       	push   $0x802a63
  801c29:	68 2b 2a 80 00       	push   $0x802a2b
  801c2e:	6a 62                	push   $0x62
  801c30:	68 78 2a 80 00       	push   $0x802a78
  801c35:	e8 4b 05 00 00       	call   802185 <_panic>

00801c3a <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 04             	sub    $0x4,%esp
  801c41:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c4c:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c52:	7f 2e                	jg     801c82 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c54:	83 ec 04             	sub    $0x4,%esp
  801c57:	53                   	push   %ebx
  801c58:	ff 75 0c             	pushl  0xc(%ebp)
  801c5b:	68 0c 60 80 00       	push   $0x80600c
  801c60:	e8 71 ee ff ff       	call   800ad6 <memmove>
	nsipcbuf.send.req_size = size;
  801c65:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c6e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c73:	b8 08 00 00 00       	mov    $0x8,%eax
  801c78:	e8 eb fd ff ff       	call   801a68 <nsipc>
}
  801c7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    
	assert(size < 1600);
  801c82:	68 84 2a 80 00       	push   $0x802a84
  801c87:	68 2b 2a 80 00       	push   $0x802a2b
  801c8c:	6a 6d                	push   $0x6d
  801c8e:	68 78 2a 80 00       	push   $0x802a78
  801c93:	e8 ed 04 00 00       	call   802185 <_panic>

00801c98 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
  801c9b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca9:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cae:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cb6:	b8 09 00 00 00       	mov    $0x9,%eax
  801cbb:	e8 a8 fd ff ff       	call   801a68 <nsipc>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	56                   	push   %esi
  801cc6:	53                   	push   %ebx
  801cc7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cca:	83 ec 0c             	sub    $0xc,%esp
  801ccd:	ff 75 08             	pushl  0x8(%ebp)
  801cd0:	e8 6a f3 ff ff       	call   80103f <fd2data>
  801cd5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cd7:	83 c4 08             	add    $0x8,%esp
  801cda:	68 90 2a 80 00       	push   $0x802a90
  801cdf:	53                   	push   %ebx
  801ce0:	e8 63 ec ff ff       	call   800948 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ce5:	8b 46 04             	mov    0x4(%esi),%eax
  801ce8:	2b 06                	sub    (%esi),%eax
  801cea:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cf0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cf7:	00 00 00 
	stat->st_dev = &devpipe;
  801cfa:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d01:	30 80 00 
	return 0;
}
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
  801d09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5e                   	pop    %esi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    

00801d10 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
  801d13:	53                   	push   %ebx
  801d14:	83 ec 0c             	sub    $0xc,%esp
  801d17:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d1a:	53                   	push   %ebx
  801d1b:	6a 00                	push   $0x0
  801d1d:	e8 9d f0 ff ff       	call   800dbf <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d22:	89 1c 24             	mov    %ebx,(%esp)
  801d25:	e8 15 f3 ff ff       	call   80103f <fd2data>
  801d2a:	83 c4 08             	add    $0x8,%esp
  801d2d:	50                   	push   %eax
  801d2e:	6a 00                	push   $0x0
  801d30:	e8 8a f0 ff ff       	call   800dbf <sys_page_unmap>
}
  801d35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <_pipeisclosed>:
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	57                   	push   %edi
  801d3e:	56                   	push   %esi
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 1c             	sub    $0x1c,%esp
  801d43:	89 c7                	mov    %eax,%edi
  801d45:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d47:	a1 08 40 80 00       	mov    0x804008,%eax
  801d4c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d4f:	83 ec 0c             	sub    $0xc,%esp
  801d52:	57                   	push   %edi
  801d53:	e8 8a 05 00 00       	call   8022e2 <pageref>
  801d58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d5b:	89 34 24             	mov    %esi,(%esp)
  801d5e:	e8 7f 05 00 00       	call   8022e2 <pageref>
		nn = thisenv->env_runs;
  801d63:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d69:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	39 cb                	cmp    %ecx,%ebx
  801d71:	74 1b                	je     801d8e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d73:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d76:	75 cf                	jne    801d47 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d78:	8b 42 58             	mov    0x58(%edx),%eax
  801d7b:	6a 01                	push   $0x1
  801d7d:	50                   	push   %eax
  801d7e:	53                   	push   %ebx
  801d7f:	68 97 2a 80 00       	push   $0x802a97
  801d84:	e8 60 e4 ff ff       	call   8001e9 <cprintf>
  801d89:	83 c4 10             	add    $0x10,%esp
  801d8c:	eb b9                	jmp    801d47 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d8e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d91:	0f 94 c0             	sete   %al
  801d94:	0f b6 c0             	movzbl %al,%eax
}
  801d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5f                   	pop    %edi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    

00801d9f <devpipe_write>:
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	57                   	push   %edi
  801da3:	56                   	push   %esi
  801da4:	53                   	push   %ebx
  801da5:	83 ec 28             	sub    $0x28,%esp
  801da8:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dab:	56                   	push   %esi
  801dac:	e8 8e f2 ff ff       	call   80103f <fd2data>
  801db1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	bf 00 00 00 00       	mov    $0x0,%edi
  801dbb:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dbe:	74 4f                	je     801e0f <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc0:	8b 43 04             	mov    0x4(%ebx),%eax
  801dc3:	8b 0b                	mov    (%ebx),%ecx
  801dc5:	8d 51 20             	lea    0x20(%ecx),%edx
  801dc8:	39 d0                	cmp    %edx,%eax
  801dca:	72 14                	jb     801de0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dcc:	89 da                	mov    %ebx,%edx
  801dce:	89 f0                	mov    %esi,%eax
  801dd0:	e8 65 ff ff ff       	call   801d3a <_pipeisclosed>
  801dd5:	85 c0                	test   %eax,%eax
  801dd7:	75 3b                	jne    801e14 <devpipe_write+0x75>
			sys_yield();
  801dd9:	e8 3d ef ff ff       	call   800d1b <sys_yield>
  801dde:	eb e0                	jmp    801dc0 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801de3:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801de7:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dea:	89 c2                	mov    %eax,%edx
  801dec:	c1 fa 1f             	sar    $0x1f,%edx
  801def:	89 d1                	mov    %edx,%ecx
  801df1:	c1 e9 1b             	shr    $0x1b,%ecx
  801df4:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801df7:	83 e2 1f             	and    $0x1f,%edx
  801dfa:	29 ca                	sub    %ecx,%edx
  801dfc:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e00:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e04:	83 c0 01             	add    $0x1,%eax
  801e07:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e0a:	83 c7 01             	add    $0x1,%edi
  801e0d:	eb ac                	jmp    801dbb <devpipe_write+0x1c>
	return i;
  801e0f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e12:	eb 05                	jmp    801e19 <devpipe_write+0x7a>
				return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e1c:	5b                   	pop    %ebx
  801e1d:	5e                   	pop    %esi
  801e1e:	5f                   	pop    %edi
  801e1f:	5d                   	pop    %ebp
  801e20:	c3                   	ret    

00801e21 <devpipe_read>:
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	57                   	push   %edi
  801e25:	56                   	push   %esi
  801e26:	53                   	push   %ebx
  801e27:	83 ec 18             	sub    $0x18,%esp
  801e2a:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e2d:	57                   	push   %edi
  801e2e:	e8 0c f2 ff ff       	call   80103f <fd2data>
  801e33:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	be 00 00 00 00       	mov    $0x0,%esi
  801e3d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e40:	75 14                	jne    801e56 <devpipe_read+0x35>
	return i;
  801e42:	8b 45 10             	mov    0x10(%ebp),%eax
  801e45:	eb 02                	jmp    801e49 <devpipe_read+0x28>
				return i;
  801e47:	89 f0                	mov    %esi,%eax
}
  801e49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4c:	5b                   	pop    %ebx
  801e4d:	5e                   	pop    %esi
  801e4e:	5f                   	pop    %edi
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    
			sys_yield();
  801e51:	e8 c5 ee ff ff       	call   800d1b <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e56:	8b 03                	mov    (%ebx),%eax
  801e58:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e5b:	75 18                	jne    801e75 <devpipe_read+0x54>
			if (i > 0)
  801e5d:	85 f6                	test   %esi,%esi
  801e5f:	75 e6                	jne    801e47 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e61:	89 da                	mov    %ebx,%edx
  801e63:	89 f8                	mov    %edi,%eax
  801e65:	e8 d0 fe ff ff       	call   801d3a <_pipeisclosed>
  801e6a:	85 c0                	test   %eax,%eax
  801e6c:	74 e3                	je     801e51 <devpipe_read+0x30>
				return 0;
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
  801e73:	eb d4                	jmp    801e49 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e75:	99                   	cltd   
  801e76:	c1 ea 1b             	shr    $0x1b,%edx
  801e79:	01 d0                	add    %edx,%eax
  801e7b:	83 e0 1f             	and    $0x1f,%eax
  801e7e:	29 d0                	sub    %edx,%eax
  801e80:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e88:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e8b:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e8e:	83 c6 01             	add    $0x1,%esi
  801e91:	eb aa                	jmp    801e3d <devpipe_read+0x1c>

00801e93 <pipe>:
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	56                   	push   %esi
  801e97:	53                   	push   %ebx
  801e98:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e9b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e9e:	50                   	push   %eax
  801e9f:	e8 b2 f1 ff ff       	call   801056 <fd_alloc>
  801ea4:	89 c3                	mov    %eax,%ebx
  801ea6:	83 c4 10             	add    $0x10,%esp
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	0f 88 23 01 00 00    	js     801fd4 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb1:	83 ec 04             	sub    $0x4,%esp
  801eb4:	68 07 04 00 00       	push   $0x407
  801eb9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ebc:	6a 00                	push   $0x0
  801ebe:	e8 77 ee ff ff       	call   800d3a <sys_page_alloc>
  801ec3:	89 c3                	mov    %eax,%ebx
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	0f 88 04 01 00 00    	js     801fd4 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ed6:	50                   	push   %eax
  801ed7:	e8 7a f1 ff ff       	call   801056 <fd_alloc>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	83 c4 10             	add    $0x10,%esp
  801ee1:	85 c0                	test   %eax,%eax
  801ee3:	0f 88 db 00 00 00    	js     801fc4 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee9:	83 ec 04             	sub    $0x4,%esp
  801eec:	68 07 04 00 00       	push   $0x407
  801ef1:	ff 75 f0             	pushl  -0x10(%ebp)
  801ef4:	6a 00                	push   $0x0
  801ef6:	e8 3f ee ff ff       	call   800d3a <sys_page_alloc>
  801efb:	89 c3                	mov    %eax,%ebx
  801efd:	83 c4 10             	add    $0x10,%esp
  801f00:	85 c0                	test   %eax,%eax
  801f02:	0f 88 bc 00 00 00    	js     801fc4 <pipe+0x131>
	va = fd2data(fd0);
  801f08:	83 ec 0c             	sub    $0xc,%esp
  801f0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0e:	e8 2c f1 ff ff       	call   80103f <fd2data>
  801f13:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f15:	83 c4 0c             	add    $0xc,%esp
  801f18:	68 07 04 00 00       	push   $0x407
  801f1d:	50                   	push   %eax
  801f1e:	6a 00                	push   $0x0
  801f20:	e8 15 ee ff ff       	call   800d3a <sys_page_alloc>
  801f25:	89 c3                	mov    %eax,%ebx
  801f27:	83 c4 10             	add    $0x10,%esp
  801f2a:	85 c0                	test   %eax,%eax
  801f2c:	0f 88 82 00 00 00    	js     801fb4 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f32:	83 ec 0c             	sub    $0xc,%esp
  801f35:	ff 75 f0             	pushl  -0x10(%ebp)
  801f38:	e8 02 f1 ff ff       	call   80103f <fd2data>
  801f3d:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f44:	50                   	push   %eax
  801f45:	6a 00                	push   $0x0
  801f47:	56                   	push   %esi
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 2e ee ff ff       	call   800d7d <sys_page_map>
  801f4f:	89 c3                	mov    %eax,%ebx
  801f51:	83 c4 20             	add    $0x20,%esp
  801f54:	85 c0                	test   %eax,%eax
  801f56:	78 4e                	js     801fa6 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f58:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f5d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f60:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f62:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f65:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f6c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f6f:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f74:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f81:	e8 a9 f0 ff ff       	call   80102f <fd2num>
  801f86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f89:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f8b:	83 c4 04             	add    $0x4,%esp
  801f8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f91:	e8 99 f0 ff ff       	call   80102f <fd2num>
  801f96:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f99:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fa4:	eb 2e                	jmp    801fd4 <pipe+0x141>
	sys_page_unmap(0, va);
  801fa6:	83 ec 08             	sub    $0x8,%esp
  801fa9:	56                   	push   %esi
  801faa:	6a 00                	push   $0x0
  801fac:	e8 0e ee ff ff       	call   800dbf <sys_page_unmap>
  801fb1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fb4:	83 ec 08             	sub    $0x8,%esp
  801fb7:	ff 75 f0             	pushl  -0x10(%ebp)
  801fba:	6a 00                	push   $0x0
  801fbc:	e8 fe ed ff ff       	call   800dbf <sys_page_unmap>
  801fc1:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fc4:	83 ec 08             	sub    $0x8,%esp
  801fc7:	ff 75 f4             	pushl  -0xc(%ebp)
  801fca:	6a 00                	push   $0x0
  801fcc:	e8 ee ed ff ff       	call   800dbf <sys_page_unmap>
  801fd1:	83 c4 10             	add    $0x10,%esp
}
  801fd4:	89 d8                	mov    %ebx,%eax
  801fd6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fd9:	5b                   	pop    %ebx
  801fda:	5e                   	pop    %esi
  801fdb:	5d                   	pop    %ebp
  801fdc:	c3                   	ret    

00801fdd <pipeisclosed>:
{
  801fdd:	55                   	push   %ebp
  801fde:	89 e5                	mov    %esp,%ebp
  801fe0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fe3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe6:	50                   	push   %eax
  801fe7:	ff 75 08             	pushl  0x8(%ebp)
  801fea:	e8 b9 f0 ff ff       	call   8010a8 <fd_lookup>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	78 18                	js     80200e <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ff6:	83 ec 0c             	sub    $0xc,%esp
  801ff9:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffc:	e8 3e f0 ff ff       	call   80103f <fd2data>
	return _pipeisclosed(fd, p);
  802001:	89 c2                	mov    %eax,%edx
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	e8 2f fd ff ff       	call   801d3a <_pipeisclosed>
  80200b:	83 c4 10             	add    $0x10,%esp
}
  80200e:	c9                   	leave  
  80200f:	c3                   	ret    

00802010 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	c3                   	ret    

00802016 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80201c:	68 af 2a 80 00       	push   $0x802aaf
  802021:	ff 75 0c             	pushl  0xc(%ebp)
  802024:	e8 1f e9 ff ff       	call   800948 <strcpy>
	return 0;
}
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	c9                   	leave  
  80202f:	c3                   	ret    

00802030 <devcons_write>:
{
  802030:	55                   	push   %ebp
  802031:	89 e5                	mov    %esp,%ebp
  802033:	57                   	push   %edi
  802034:	56                   	push   %esi
  802035:	53                   	push   %ebx
  802036:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80203c:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802041:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802047:	3b 75 10             	cmp    0x10(%ebp),%esi
  80204a:	73 31                	jae    80207d <devcons_write+0x4d>
		m = n - tot;
  80204c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80204f:	29 f3                	sub    %esi,%ebx
  802051:	83 fb 7f             	cmp    $0x7f,%ebx
  802054:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802059:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	53                   	push   %ebx
  802060:	89 f0                	mov    %esi,%eax
  802062:	03 45 0c             	add    0xc(%ebp),%eax
  802065:	50                   	push   %eax
  802066:	57                   	push   %edi
  802067:	e8 6a ea ff ff       	call   800ad6 <memmove>
		sys_cputs(buf, m);
  80206c:	83 c4 08             	add    $0x8,%esp
  80206f:	53                   	push   %ebx
  802070:	57                   	push   %edi
  802071:	e8 08 ec ff ff       	call   800c7e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802076:	01 de                	add    %ebx,%esi
  802078:	83 c4 10             	add    $0x10,%esp
  80207b:	eb ca                	jmp    802047 <devcons_write+0x17>
}
  80207d:	89 f0                	mov    %esi,%eax
  80207f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802082:	5b                   	pop    %ebx
  802083:	5e                   	pop    %esi
  802084:	5f                   	pop    %edi
  802085:	5d                   	pop    %ebp
  802086:	c3                   	ret    

00802087 <devcons_read>:
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 08             	sub    $0x8,%esp
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802092:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802096:	74 21                	je     8020b9 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802098:	e8 ff eb ff ff       	call   800c9c <sys_cgetc>
  80209d:	85 c0                	test   %eax,%eax
  80209f:	75 07                	jne    8020a8 <devcons_read+0x21>
		sys_yield();
  8020a1:	e8 75 ec ff ff       	call   800d1b <sys_yield>
  8020a6:	eb f0                	jmp    802098 <devcons_read+0x11>
	if (c < 0)
  8020a8:	78 0f                	js     8020b9 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020aa:	83 f8 04             	cmp    $0x4,%eax
  8020ad:	74 0c                	je     8020bb <devcons_read+0x34>
	*(char*)vbuf = c;
  8020af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b2:	88 02                	mov    %al,(%edx)
	return 1;
  8020b4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    
		return 0;
  8020bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c0:	eb f7                	jmp    8020b9 <devcons_read+0x32>

008020c2 <cputchar>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cb:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020ce:	6a 01                	push   $0x1
  8020d0:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d3:	50                   	push   %eax
  8020d4:	e8 a5 eb ff ff       	call   800c7e <sys_cputs>
}
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	c9                   	leave  
  8020dd:	c3                   	ret    

008020de <getchar>:
{
  8020de:	55                   	push   %ebp
  8020df:	89 e5                	mov    %esp,%ebp
  8020e1:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020e4:	6a 01                	push   $0x1
  8020e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e9:	50                   	push   %eax
  8020ea:	6a 00                	push   $0x0
  8020ec:	e8 27 f2 ff ff       	call   801318 <read>
	if (r < 0)
  8020f1:	83 c4 10             	add    $0x10,%esp
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	78 06                	js     8020fe <getchar+0x20>
	if (r < 1)
  8020f8:	74 06                	je     802100 <getchar+0x22>
	return c;
  8020fa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020fe:	c9                   	leave  
  8020ff:	c3                   	ret    
		return -E_EOF;
  802100:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802105:	eb f7                	jmp    8020fe <getchar+0x20>

00802107 <iscons>:
{
  802107:	55                   	push   %ebp
  802108:	89 e5                	mov    %esp,%ebp
  80210a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80210d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802110:	50                   	push   %eax
  802111:	ff 75 08             	pushl  0x8(%ebp)
  802114:	e8 8f ef ff ff       	call   8010a8 <fd_lookup>
  802119:	83 c4 10             	add    $0x10,%esp
  80211c:	85 c0                	test   %eax,%eax
  80211e:	78 11                	js     802131 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802123:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802129:	39 10                	cmp    %edx,(%eax)
  80212b:	0f 94 c0             	sete   %al
  80212e:	0f b6 c0             	movzbl %al,%eax
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    

00802133 <opencons>:
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802139:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213c:	50                   	push   %eax
  80213d:	e8 14 ef ff ff       	call   801056 <fd_alloc>
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	85 c0                	test   %eax,%eax
  802147:	78 3a                	js     802183 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802149:	83 ec 04             	sub    $0x4,%esp
  80214c:	68 07 04 00 00       	push   $0x407
  802151:	ff 75 f4             	pushl  -0xc(%ebp)
  802154:	6a 00                	push   $0x0
  802156:	e8 df eb ff ff       	call   800d3a <sys_page_alloc>
  80215b:	83 c4 10             	add    $0x10,%esp
  80215e:	85 c0                	test   %eax,%eax
  802160:	78 21                	js     802183 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802162:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802165:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80216b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80216d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802170:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	50                   	push   %eax
  80217b:	e8 af ee ff ff       	call   80102f <fd2num>
  802180:	83 c4 10             	add    $0x10,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	56                   	push   %esi
  802189:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80218a:	a1 08 40 80 00       	mov    0x804008,%eax
  80218f:	8b 40 48             	mov    0x48(%eax),%eax
  802192:	83 ec 04             	sub    $0x4,%esp
  802195:	68 e0 2a 80 00       	push   $0x802ae0
  80219a:	50                   	push   %eax
  80219b:	68 d8 25 80 00       	push   $0x8025d8
  8021a0:	e8 44 e0 ff ff       	call   8001e9 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021a5:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021a8:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021ae:	e8 49 eb ff ff       	call   800cfc <sys_getenvid>
  8021b3:	83 c4 04             	add    $0x4,%esp
  8021b6:	ff 75 0c             	pushl  0xc(%ebp)
  8021b9:	ff 75 08             	pushl  0x8(%ebp)
  8021bc:	56                   	push   %esi
  8021bd:	50                   	push   %eax
  8021be:	68 bc 2a 80 00       	push   $0x802abc
  8021c3:	e8 21 e0 ff ff       	call   8001e9 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021c8:	83 c4 18             	add    $0x18,%esp
  8021cb:	53                   	push   %ebx
  8021cc:	ff 75 10             	pushl  0x10(%ebp)
  8021cf:	e8 c4 df ff ff       	call   800198 <vcprintf>
	cprintf("\n");
  8021d4:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8021db:	e8 09 e0 ff ff       	call   8001e9 <cprintf>
  8021e0:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021e3:	cc                   	int3   
  8021e4:	eb fd                	jmp    8021e3 <_panic+0x5e>

008021e6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021e6:	55                   	push   %ebp
  8021e7:	89 e5                	mov    %esp,%ebp
  8021e9:	56                   	push   %esi
  8021ea:	53                   	push   %ebx
  8021eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8021ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021f4:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021f6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021fb:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021fe:	83 ec 0c             	sub    $0xc,%esp
  802201:	50                   	push   %eax
  802202:	e8 e3 ec ff ff       	call   800eea <sys_ipc_recv>
	if(ret < 0){
  802207:	83 c4 10             	add    $0x10,%esp
  80220a:	85 c0                	test   %eax,%eax
  80220c:	78 2b                	js     802239 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80220e:	85 f6                	test   %esi,%esi
  802210:	74 0a                	je     80221c <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802212:	a1 08 40 80 00       	mov    0x804008,%eax
  802217:	8b 40 74             	mov    0x74(%eax),%eax
  80221a:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80221c:	85 db                	test   %ebx,%ebx
  80221e:	74 0a                	je     80222a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802220:	a1 08 40 80 00       	mov    0x804008,%eax
  802225:	8b 40 78             	mov    0x78(%eax),%eax
  802228:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80222a:	a1 08 40 80 00       	mov    0x804008,%eax
  80222f:	8b 40 70             	mov    0x70(%eax),%eax
}
  802232:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802235:	5b                   	pop    %ebx
  802236:	5e                   	pop    %esi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    
		if(from_env_store)
  802239:	85 f6                	test   %esi,%esi
  80223b:	74 06                	je     802243 <ipc_recv+0x5d>
			*from_env_store = 0;
  80223d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802243:	85 db                	test   %ebx,%ebx
  802245:	74 eb                	je     802232 <ipc_recv+0x4c>
			*perm_store = 0;
  802247:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80224d:	eb e3                	jmp    802232 <ipc_recv+0x4c>

0080224f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80224f:	55                   	push   %ebp
  802250:	89 e5                	mov    %esp,%ebp
  802252:	57                   	push   %edi
  802253:	56                   	push   %esi
  802254:	53                   	push   %ebx
  802255:	83 ec 0c             	sub    $0xc,%esp
  802258:	8b 7d 08             	mov    0x8(%ebp),%edi
  80225b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80225e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802261:	85 db                	test   %ebx,%ebx
  802263:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802268:	0f 44 d8             	cmove  %eax,%ebx
  80226b:	eb 05                	jmp    802272 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80226d:	e8 a9 ea ff ff       	call   800d1b <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802272:	ff 75 14             	pushl  0x14(%ebp)
  802275:	53                   	push   %ebx
  802276:	56                   	push   %esi
  802277:	57                   	push   %edi
  802278:	e8 4a ec ff ff       	call   800ec7 <sys_ipc_try_send>
  80227d:	83 c4 10             	add    $0x10,%esp
  802280:	85 c0                	test   %eax,%eax
  802282:	74 1b                	je     80229f <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802284:	79 e7                	jns    80226d <ipc_send+0x1e>
  802286:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802289:	74 e2                	je     80226d <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80228b:	83 ec 04             	sub    $0x4,%esp
  80228e:	68 e7 2a 80 00       	push   $0x802ae7
  802293:	6a 46                	push   $0x46
  802295:	68 fc 2a 80 00       	push   $0x802afc
  80229a:	e8 e6 fe ff ff       	call   802185 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80229f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a2:	5b                   	pop    %ebx
  8022a3:	5e                   	pop    %esi
  8022a4:	5f                   	pop    %edi
  8022a5:	5d                   	pop    %ebp
  8022a6:	c3                   	ret    

008022a7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022ad:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b2:	89 c2                	mov    %eax,%edx
  8022b4:	c1 e2 07             	shl    $0x7,%edx
  8022b7:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022bd:	8b 52 50             	mov    0x50(%edx),%edx
  8022c0:	39 ca                	cmp    %ecx,%edx
  8022c2:	74 11                	je     8022d5 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022c4:	83 c0 01             	add    $0x1,%eax
  8022c7:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022cc:	75 e4                	jne    8022b2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d3:	eb 0b                	jmp    8022e0 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022d5:	c1 e0 07             	shl    $0x7,%eax
  8022d8:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022dd:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022e0:	5d                   	pop    %ebp
  8022e1:	c3                   	ret    

008022e2 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e2:	55                   	push   %ebp
  8022e3:	89 e5                	mov    %esp,%ebp
  8022e5:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022e8:	89 d0                	mov    %edx,%eax
  8022ea:	c1 e8 16             	shr    $0x16,%eax
  8022ed:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022f4:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022f9:	f6 c1 01             	test   $0x1,%cl
  8022fc:	74 1d                	je     80231b <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022fe:	c1 ea 0c             	shr    $0xc,%edx
  802301:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802308:	f6 c2 01             	test   $0x1,%dl
  80230b:	74 0e                	je     80231b <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80230d:	c1 ea 0c             	shr    $0xc,%edx
  802310:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802317:	ef 
  802318:	0f b7 c0             	movzwl %ax,%eax
}
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    
  80231d:	66 90                	xchg   %ax,%ax
  80231f:	90                   	nop

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
