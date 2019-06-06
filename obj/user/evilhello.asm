
obj/user/evilhello.debug:     file format elf32-i386


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

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	// try to print the kernel entry point as a string!  mua ha ha!
	sys_cputs((char*)0xf010000c, 100);
  800039:	6a 64                	push   $0x64
  80003b:	68 0c 00 10 f0       	push   $0xf010000c
  800040:	e8 3c 0c 00 00       	call   800c81 <sys_cputs>
}
  800045:	83 c4 10             	add    $0x10,%esp
  800048:	c9                   	leave  
  800049:	c3                   	ret    

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
  80005d:	e8 9d 0c 00 00       	call   800cff <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000c1:	a1 08 40 80 00       	mov    0x804008,%eax
  8000c6:	8b 40 48             	mov    0x48(%eax),%eax
  8000c9:	83 ec 08             	sub    $0x8,%esp
  8000cc:	50                   	push   %eax
  8000cd:	68 60 25 80 00       	push   $0x802560
  8000d2:	e8 15 01 00 00       	call   8001ec <cprintf>
	cprintf("before umain\n");
  8000d7:	c7 04 24 7e 25 80 00 	movl   $0x80257e,(%esp)
  8000de:	e8 09 01 00 00       	call   8001ec <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e3:	83 c4 08             	add    $0x8,%esp
  8000e6:	ff 75 0c             	pushl  0xc(%ebp)
  8000e9:	ff 75 08             	pushl  0x8(%ebp)
  8000ec:	e8 42 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000f1:	c7 04 24 8c 25 80 00 	movl   $0x80258c,(%esp)
  8000f8:	e8 ef 00 00 00       	call   8001ec <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  8000fd:	a1 08 40 80 00       	mov    0x804008,%eax
  800102:	8b 40 48             	mov    0x48(%eax),%eax
  800105:	83 c4 08             	add    $0x8,%esp
  800108:	50                   	push   %eax
  800109:	68 99 25 80 00       	push   $0x802599
  80010e:	e8 d9 00 00 00       	call   8001ec <cprintf>
	// exit gracefully
	exit();
  800113:	e8 0b 00 00 00       	call   800123 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5f                   	pop    %edi
  800121:	5d                   	pop    %ebp
  800122:	c3                   	ret    

00800123 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800123:	55                   	push   %ebp
  800124:	89 e5                	mov    %esp,%ebp
  800126:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800129:	a1 08 40 80 00       	mov    0x804008,%eax
  80012e:	8b 40 48             	mov    0x48(%eax),%eax
  800131:	68 c4 25 80 00       	push   $0x8025c4
  800136:	50                   	push   %eax
  800137:	68 b8 25 80 00       	push   $0x8025b8
  80013c:	e8 ab 00 00 00       	call   8001ec <cprintf>
	close_all();
  800141:	e8 a4 10 00 00       	call   8011ea <close_all>
	sys_env_destroy(0);
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 6c 0b 00 00       	call   800cbe <sys_env_destroy>
}
  800152:	83 c4 10             	add    $0x10,%esp
  800155:	c9                   	leave  
  800156:	c3                   	ret    

00800157 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	53                   	push   %ebx
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800161:	8b 13                	mov    (%ebx),%edx
  800163:	8d 42 01             	lea    0x1(%edx),%eax
  800166:	89 03                	mov    %eax,(%ebx)
  800168:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80016f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800174:	74 09                	je     80017f <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800176:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80017d:	c9                   	leave  
  80017e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	68 ff 00 00 00       	push   $0xff
  800187:	8d 43 08             	lea    0x8(%ebx),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 f1 0a 00 00       	call   800c81 <sys_cputs>
		b->idx = 0;
  800190:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	eb db                	jmp    800176 <putch+0x1f>

0080019b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ab:	00 00 00 
	b.cnt = 0;
  8001ae:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b5:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001b8:	ff 75 0c             	pushl  0xc(%ebp)
  8001bb:	ff 75 08             	pushl  0x8(%ebp)
  8001be:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c4:	50                   	push   %eax
  8001c5:	68 57 01 80 00       	push   $0x800157
  8001ca:	e8 4a 01 00 00       	call   800319 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001cf:	83 c4 08             	add    $0x8,%esp
  8001d2:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001d8:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001de:	50                   	push   %eax
  8001df:	e8 9d 0a 00 00       	call   800c81 <sys_cputs>

	return b.cnt;
}
  8001e4:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ea:	c9                   	leave  
  8001eb:	c3                   	ret    

008001ec <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f5:	50                   	push   %eax
  8001f6:	ff 75 08             	pushl  0x8(%ebp)
  8001f9:	e8 9d ff ff ff       	call   80019b <vcprintf>
	va_end(ap);

	return cnt;
}
  8001fe:	c9                   	leave  
  8001ff:	c3                   	ret    

00800200 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	57                   	push   %edi
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	83 ec 1c             	sub    $0x1c,%esp
  800209:	89 c6                	mov    %eax,%esi
  80020b:	89 d7                	mov    %edx,%edi
  80020d:	8b 45 08             	mov    0x8(%ebp),%eax
  800210:	8b 55 0c             	mov    0xc(%ebp),%edx
  800213:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800216:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800219:	8b 45 10             	mov    0x10(%ebp),%eax
  80021c:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  80021f:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800223:	74 2c                	je     800251 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800225:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800228:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80022f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800232:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800235:	39 c2                	cmp    %eax,%edx
  800237:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80023a:	73 43                	jae    80027f <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80023c:	83 eb 01             	sub    $0x1,%ebx
  80023f:	85 db                	test   %ebx,%ebx
  800241:	7e 6c                	jle    8002af <printnum+0xaf>
				putch(padc, putdat);
  800243:	83 ec 08             	sub    $0x8,%esp
  800246:	57                   	push   %edi
  800247:	ff 75 18             	pushl  0x18(%ebp)
  80024a:	ff d6                	call   *%esi
  80024c:	83 c4 10             	add    $0x10,%esp
  80024f:	eb eb                	jmp    80023c <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800251:	83 ec 0c             	sub    $0xc,%esp
  800254:	6a 20                	push   $0x20
  800256:	6a 00                	push   $0x0
  800258:	50                   	push   %eax
  800259:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025c:	ff 75 e0             	pushl  -0x20(%ebp)
  80025f:	89 fa                	mov    %edi,%edx
  800261:	89 f0                	mov    %esi,%eax
  800263:	e8 98 ff ff ff       	call   800200 <printnum>
		while (--width > 0)
  800268:	83 c4 20             	add    $0x20,%esp
  80026b:	83 eb 01             	sub    $0x1,%ebx
  80026e:	85 db                	test   %ebx,%ebx
  800270:	7e 65                	jle    8002d7 <printnum+0xd7>
			putch(padc, putdat);
  800272:	83 ec 08             	sub    $0x8,%esp
  800275:	57                   	push   %edi
  800276:	6a 20                	push   $0x20
  800278:	ff d6                	call   *%esi
  80027a:	83 c4 10             	add    $0x10,%esp
  80027d:	eb ec                	jmp    80026b <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80027f:	83 ec 0c             	sub    $0xc,%esp
  800282:	ff 75 18             	pushl  0x18(%ebp)
  800285:	83 eb 01             	sub    $0x1,%ebx
  800288:	53                   	push   %ebx
  800289:	50                   	push   %eax
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	ff 75 dc             	pushl  -0x24(%ebp)
  800290:	ff 75 d8             	pushl  -0x28(%ebp)
  800293:	ff 75 e4             	pushl  -0x1c(%ebp)
  800296:	ff 75 e0             	pushl  -0x20(%ebp)
  800299:	e8 62 20 00 00       	call   802300 <__udivdi3>
  80029e:	83 c4 18             	add    $0x18,%esp
  8002a1:	52                   	push   %edx
  8002a2:	50                   	push   %eax
  8002a3:	89 fa                	mov    %edi,%edx
  8002a5:	89 f0                	mov    %esi,%eax
  8002a7:	e8 54 ff ff ff       	call   800200 <printnum>
  8002ac:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002af:	83 ec 08             	sub    $0x8,%esp
  8002b2:	57                   	push   %edi
  8002b3:	83 ec 04             	sub    $0x4,%esp
  8002b6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002b9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002bc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002bf:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c2:	e8 49 21 00 00       	call   802410 <__umoddi3>
  8002c7:	83 c4 14             	add    $0x14,%esp
  8002ca:	0f be 80 c9 25 80 00 	movsbl 0x8025c9(%eax),%eax
  8002d1:	50                   	push   %eax
  8002d2:	ff d6                	call   *%esi
  8002d4:	83 c4 10             	add    $0x10,%esp
	}
}
  8002d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002da:	5b                   	pop    %ebx
  8002db:	5e                   	pop    %esi
  8002dc:	5f                   	pop    %edi
  8002dd:	5d                   	pop    %ebp
  8002de:	c3                   	ret    

008002df <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e5:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002e9:	8b 10                	mov    (%eax),%edx
  8002eb:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ee:	73 0a                	jae    8002fa <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f3:	89 08                	mov    %ecx,(%eax)
  8002f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f8:	88 02                	mov    %al,(%edx)
}
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    

008002fc <printfmt>:
{
  8002fc:	55                   	push   %ebp
  8002fd:	89 e5                	mov    %esp,%ebp
  8002ff:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800302:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800305:	50                   	push   %eax
  800306:	ff 75 10             	pushl  0x10(%ebp)
  800309:	ff 75 0c             	pushl  0xc(%ebp)
  80030c:	ff 75 08             	pushl  0x8(%ebp)
  80030f:	e8 05 00 00 00       	call   800319 <vprintfmt>
}
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <vprintfmt>:
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	57                   	push   %edi
  80031d:	56                   	push   %esi
  80031e:	53                   	push   %ebx
  80031f:	83 ec 3c             	sub    $0x3c,%esp
  800322:	8b 75 08             	mov    0x8(%ebp),%esi
  800325:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800328:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032b:	e9 32 04 00 00       	jmp    800762 <vprintfmt+0x449>
		padc = ' ';
  800330:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800334:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80033b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800342:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800349:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800350:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800357:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035c:	8d 47 01             	lea    0x1(%edi),%eax
  80035f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800362:	0f b6 17             	movzbl (%edi),%edx
  800365:	8d 42 dd             	lea    -0x23(%edx),%eax
  800368:	3c 55                	cmp    $0x55,%al
  80036a:	0f 87 12 05 00 00    	ja     800882 <vprintfmt+0x569>
  800370:	0f b6 c0             	movzbl %al,%eax
  800373:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  80037a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037d:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800381:	eb d9                	jmp    80035c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800386:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80038a:	eb d0                	jmp    80035c <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038c:	0f b6 d2             	movzbl %dl,%edx
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800392:	b8 00 00 00 00       	mov    $0x0,%eax
  800397:	89 75 08             	mov    %esi,0x8(%ebp)
  80039a:	eb 03                	jmp    80039f <vprintfmt+0x86>
  80039c:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80039f:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a2:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003a6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a9:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003ac:	83 fe 09             	cmp    $0x9,%esi
  8003af:	76 eb                	jbe    80039c <vprintfmt+0x83>
  8003b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8003b7:	eb 14                	jmp    8003cd <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003bc:	8b 00                	mov    (%eax),%eax
  8003be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 40 04             	lea    0x4(%eax),%eax
  8003c7:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d1:	79 89                	jns    80035c <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003d9:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e0:	e9 77 ff ff ff       	jmp    80035c <vprintfmt+0x43>
  8003e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e8:	85 c0                	test   %eax,%eax
  8003ea:	0f 48 c1             	cmovs  %ecx,%eax
  8003ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f3:	e9 64 ff ff ff       	jmp    80035c <vprintfmt+0x43>
  8003f8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003fb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800402:	e9 55 ff ff ff       	jmp    80035c <vprintfmt+0x43>
			lflag++;
  800407:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80040e:	e9 49 ff ff ff       	jmp    80035c <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800413:	8b 45 14             	mov    0x14(%ebp),%eax
  800416:	8d 78 04             	lea    0x4(%eax),%edi
  800419:	83 ec 08             	sub    $0x8,%esp
  80041c:	53                   	push   %ebx
  80041d:	ff 30                	pushl  (%eax)
  80041f:	ff d6                	call   *%esi
			break;
  800421:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800424:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800427:	e9 33 03 00 00       	jmp    80075f <vprintfmt+0x446>
			err = va_arg(ap, int);
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	8d 78 04             	lea    0x4(%eax),%edi
  800432:	8b 00                	mov    (%eax),%eax
  800434:	99                   	cltd   
  800435:	31 d0                	xor    %edx,%eax
  800437:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800439:	83 f8 11             	cmp    $0x11,%eax
  80043c:	7f 23                	jg     800461 <vprintfmt+0x148>
  80043e:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  800445:	85 d2                	test   %edx,%edx
  800447:	74 18                	je     800461 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800449:	52                   	push   %edx
  80044a:	68 1d 2a 80 00       	push   $0x802a1d
  80044f:	53                   	push   %ebx
  800450:	56                   	push   %esi
  800451:	e8 a6 fe ff ff       	call   8002fc <printfmt>
  800456:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800459:	89 7d 14             	mov    %edi,0x14(%ebp)
  80045c:	e9 fe 02 00 00       	jmp    80075f <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800461:	50                   	push   %eax
  800462:	68 e1 25 80 00       	push   $0x8025e1
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 8e fe ff ff       	call   8002fc <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800474:	e9 e6 02 00 00       	jmp    80075f <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	83 c0 04             	add    $0x4,%eax
  80047f:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800487:	85 c9                	test   %ecx,%ecx
  800489:	b8 da 25 80 00       	mov    $0x8025da,%eax
  80048e:	0f 45 c1             	cmovne %ecx,%eax
  800491:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800494:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800498:	7e 06                	jle    8004a0 <vprintfmt+0x187>
  80049a:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80049e:	75 0d                	jne    8004ad <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a0:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a3:	89 c7                	mov    %eax,%edi
  8004a5:	03 45 e0             	add    -0x20(%ebp),%eax
  8004a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004ab:	eb 53                	jmp    800500 <vprintfmt+0x1e7>
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b3:	50                   	push   %eax
  8004b4:	e8 71 04 00 00       	call   80092a <strnlen>
  8004b9:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004bc:	29 c1                	sub    %eax,%ecx
  8004be:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c1:	83 c4 10             	add    $0x10,%esp
  8004c4:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004c6:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004cd:	eb 0f                	jmp    8004de <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004cf:	83 ec 08             	sub    $0x8,%esp
  8004d2:	53                   	push   %ebx
  8004d3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d8:	83 ef 01             	sub    $0x1,%edi
  8004db:	83 c4 10             	add    $0x10,%esp
  8004de:	85 ff                	test   %edi,%edi
  8004e0:	7f ed                	jg     8004cf <vprintfmt+0x1b6>
  8004e2:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004e5:	85 c9                	test   %ecx,%ecx
  8004e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ec:	0f 49 c1             	cmovns %ecx,%eax
  8004ef:	29 c1                	sub    %eax,%ecx
  8004f1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f4:	eb aa                	jmp    8004a0 <vprintfmt+0x187>
					putch(ch, putdat);
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	53                   	push   %ebx
  8004fa:	52                   	push   %edx
  8004fb:	ff d6                	call   *%esi
  8004fd:	83 c4 10             	add    $0x10,%esp
  800500:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800503:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800505:	83 c7 01             	add    $0x1,%edi
  800508:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80050c:	0f be d0             	movsbl %al,%edx
  80050f:	85 d2                	test   %edx,%edx
  800511:	74 4b                	je     80055e <vprintfmt+0x245>
  800513:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800517:	78 06                	js     80051f <vprintfmt+0x206>
  800519:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80051d:	78 1e                	js     80053d <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  80051f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800523:	74 d1                	je     8004f6 <vprintfmt+0x1dd>
  800525:	0f be c0             	movsbl %al,%eax
  800528:	83 e8 20             	sub    $0x20,%eax
  80052b:	83 f8 5e             	cmp    $0x5e,%eax
  80052e:	76 c6                	jbe    8004f6 <vprintfmt+0x1dd>
					putch('?', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	6a 3f                	push   $0x3f
  800536:	ff d6                	call   *%esi
  800538:	83 c4 10             	add    $0x10,%esp
  80053b:	eb c3                	jmp    800500 <vprintfmt+0x1e7>
  80053d:	89 cf                	mov    %ecx,%edi
  80053f:	eb 0e                	jmp    80054f <vprintfmt+0x236>
				putch(' ', putdat);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	53                   	push   %ebx
  800545:	6a 20                	push   $0x20
  800547:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800549:	83 ef 01             	sub    $0x1,%edi
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	85 ff                	test   %edi,%edi
  800551:	7f ee                	jg     800541 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800553:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800556:	89 45 14             	mov    %eax,0x14(%ebp)
  800559:	e9 01 02 00 00       	jmp    80075f <vprintfmt+0x446>
  80055e:	89 cf                	mov    %ecx,%edi
  800560:	eb ed                	jmp    80054f <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800562:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800565:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80056c:	e9 eb fd ff ff       	jmp    80035c <vprintfmt+0x43>
	if (lflag >= 2)
  800571:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800575:	7f 21                	jg     800598 <vprintfmt+0x27f>
	else if (lflag)
  800577:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80057b:	74 68                	je     8005e5 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800585:	89 c1                	mov    %eax,%ecx
  800587:	c1 f9 1f             	sar    $0x1f,%ecx
  80058a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 04             	lea    0x4(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	eb 17                	jmp    8005af <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800598:	8b 45 14             	mov    0x14(%ebp),%eax
  80059b:	8b 50 04             	mov    0x4(%eax),%edx
  80059e:	8b 00                	mov    (%eax),%eax
  8005a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8d 40 08             	lea    0x8(%eax),%eax
  8005ac:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005af:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005bb:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005bf:	78 3f                	js     800600 <vprintfmt+0x2e7>
			base = 10;
  8005c1:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005c6:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005ca:	0f 84 71 01 00 00    	je     800741 <vprintfmt+0x428>
				putch('+', putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	53                   	push   %ebx
  8005d4:	6a 2b                	push   $0x2b
  8005d6:	ff d6                	call   *%esi
  8005d8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005db:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e0:	e9 5c 01 00 00       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ed:	89 c1                	mov    %eax,%ecx
  8005ef:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8d 40 04             	lea    0x4(%eax),%eax
  8005fb:	89 45 14             	mov    %eax,0x14(%ebp)
  8005fe:	eb af                	jmp    8005af <vprintfmt+0x296>
				putch('-', putdat);
  800600:	83 ec 08             	sub    $0x8,%esp
  800603:	53                   	push   %ebx
  800604:	6a 2d                	push   $0x2d
  800606:	ff d6                	call   *%esi
				num = -(long long) num;
  800608:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80060e:	f7 d8                	neg    %eax
  800610:	83 d2 00             	adc    $0x0,%edx
  800613:	f7 da                	neg    %edx
  800615:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800618:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80061e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800623:	e9 19 01 00 00       	jmp    800741 <vprintfmt+0x428>
	if (lflag >= 2)
  800628:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80062c:	7f 29                	jg     800657 <vprintfmt+0x33e>
	else if (lflag)
  80062e:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800632:	74 44                	je     800678 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	ba 00 00 00 00       	mov    $0x0,%edx
  80063e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800641:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80064d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800652:	e9 ea 00 00 00       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800657:	8b 45 14             	mov    0x14(%ebp),%eax
  80065a:	8b 50 04             	mov    0x4(%eax),%edx
  80065d:	8b 00                	mov    (%eax),%eax
  80065f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800662:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800665:	8b 45 14             	mov    0x14(%ebp),%eax
  800668:	8d 40 08             	lea    0x8(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80066e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800673:	e9 c9 00 00 00       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800678:	8b 45 14             	mov    0x14(%ebp),%eax
  80067b:	8b 00                	mov    (%eax),%eax
  80067d:	ba 00 00 00 00       	mov    $0x0,%edx
  800682:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800685:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8d 40 04             	lea    0x4(%eax),%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800691:	b8 0a 00 00 00       	mov    $0xa,%eax
  800696:	e9 a6 00 00 00       	jmp    800741 <vprintfmt+0x428>
			putch('0', putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 30                	push   $0x30
  8006a1:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a3:	83 c4 10             	add    $0x10,%esp
  8006a6:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006aa:	7f 26                	jg     8006d2 <vprintfmt+0x3b9>
	else if (lflag)
  8006ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b0:	74 3e                	je     8006f0 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c5:	8d 40 04             	lea    0x4(%eax),%eax
  8006c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d0:	eb 6f                	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d5:	8b 50 04             	mov    0x4(%eax),%edx
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 40 08             	lea    0x8(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006e9:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ee:	eb 51                	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800700:	8b 45 14             	mov    0x14(%ebp),%eax
  800703:	8d 40 04             	lea    0x4(%eax),%eax
  800706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800709:	b8 08 00 00 00       	mov    $0x8,%eax
  80070e:	eb 31                	jmp    800741 <vprintfmt+0x428>
			putch('0', putdat);
  800710:	83 ec 08             	sub    $0x8,%esp
  800713:	53                   	push   %ebx
  800714:	6a 30                	push   $0x30
  800716:	ff d6                	call   *%esi
			putch('x', putdat);
  800718:	83 c4 08             	add    $0x8,%esp
  80071b:	53                   	push   %ebx
  80071c:	6a 78                	push   $0x78
  80071e:	ff d6                	call   *%esi
			num = (unsigned long long)
  800720:	8b 45 14             	mov    0x14(%ebp),%eax
  800723:	8b 00                	mov    (%eax),%eax
  800725:	ba 00 00 00 00       	mov    $0x0,%edx
  80072a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072d:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800730:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800733:	8b 45 14             	mov    0x14(%ebp),%eax
  800736:	8d 40 04             	lea    0x4(%eax),%eax
  800739:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800741:	83 ec 0c             	sub    $0xc,%esp
  800744:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800748:	52                   	push   %edx
  800749:	ff 75 e0             	pushl  -0x20(%ebp)
  80074c:	50                   	push   %eax
  80074d:	ff 75 dc             	pushl  -0x24(%ebp)
  800750:	ff 75 d8             	pushl  -0x28(%ebp)
  800753:	89 da                	mov    %ebx,%edx
  800755:	89 f0                	mov    %esi,%eax
  800757:	e8 a4 fa ff ff       	call   800200 <printnum>
			break;
  80075c:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80075f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800762:	83 c7 01             	add    $0x1,%edi
  800765:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800769:	83 f8 25             	cmp    $0x25,%eax
  80076c:	0f 84 be fb ff ff    	je     800330 <vprintfmt+0x17>
			if (ch == '\0')
  800772:	85 c0                	test   %eax,%eax
  800774:	0f 84 28 01 00 00    	je     8008a2 <vprintfmt+0x589>
			putch(ch, putdat);
  80077a:	83 ec 08             	sub    $0x8,%esp
  80077d:	53                   	push   %ebx
  80077e:	50                   	push   %eax
  80077f:	ff d6                	call   *%esi
  800781:	83 c4 10             	add    $0x10,%esp
  800784:	eb dc                	jmp    800762 <vprintfmt+0x449>
	if (lflag >= 2)
  800786:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078a:	7f 26                	jg     8007b2 <vprintfmt+0x499>
	else if (lflag)
  80078c:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800790:	74 41                	je     8007d3 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800792:	8b 45 14             	mov    0x14(%ebp),%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	ba 00 00 00 00       	mov    $0x0,%edx
  80079c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8d 40 04             	lea    0x4(%eax),%eax
  8007a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b0:	eb 8f                	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b5:	8b 50 04             	mov    0x4(%eax),%edx
  8007b8:	8b 00                	mov    (%eax),%eax
  8007ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	8d 40 08             	lea    0x8(%eax),%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007c9:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ce:	e9 6e ff ff ff       	jmp    800741 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	8b 00                	mov    (%eax),%eax
  8007d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8007dd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e6:	8d 40 04             	lea    0x4(%eax),%eax
  8007e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f1:	e9 4b ff ff ff       	jmp    800741 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f9:	83 c0 04             	add    $0x4,%eax
  8007fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800802:	8b 00                	mov    (%eax),%eax
  800804:	85 c0                	test   %eax,%eax
  800806:	74 14                	je     80081c <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800808:	8b 13                	mov    (%ebx),%edx
  80080a:	83 fa 7f             	cmp    $0x7f,%edx
  80080d:	7f 37                	jg     800846 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80080f:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800811:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800814:	89 45 14             	mov    %eax,0x14(%ebp)
  800817:	e9 43 ff ff ff       	jmp    80075f <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80081c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800821:	bf fd 26 80 00       	mov    $0x8026fd,%edi
							putch(ch, putdat);
  800826:	83 ec 08             	sub    $0x8,%esp
  800829:	53                   	push   %ebx
  80082a:	50                   	push   %eax
  80082b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80082d:	83 c7 01             	add    $0x1,%edi
  800830:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800834:	83 c4 10             	add    $0x10,%esp
  800837:	85 c0                	test   %eax,%eax
  800839:	75 eb                	jne    800826 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80083b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	e9 19 ff ff ff       	jmp    80075f <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800846:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800848:	b8 0a 00 00 00       	mov    $0xa,%eax
  80084d:	bf 35 27 80 00       	mov    $0x802735,%edi
							putch(ch, putdat);
  800852:	83 ec 08             	sub    $0x8,%esp
  800855:	53                   	push   %ebx
  800856:	50                   	push   %eax
  800857:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800859:	83 c7 01             	add    $0x1,%edi
  80085c:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800860:	83 c4 10             	add    $0x10,%esp
  800863:	85 c0                	test   %eax,%eax
  800865:	75 eb                	jne    800852 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800867:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086a:	89 45 14             	mov    %eax,0x14(%ebp)
  80086d:	e9 ed fe ff ff       	jmp    80075f <vprintfmt+0x446>
			putch(ch, putdat);
  800872:	83 ec 08             	sub    $0x8,%esp
  800875:	53                   	push   %ebx
  800876:	6a 25                	push   $0x25
  800878:	ff d6                	call   *%esi
			break;
  80087a:	83 c4 10             	add    $0x10,%esp
  80087d:	e9 dd fe ff ff       	jmp    80075f <vprintfmt+0x446>
			putch('%', putdat);
  800882:	83 ec 08             	sub    $0x8,%esp
  800885:	53                   	push   %ebx
  800886:	6a 25                	push   $0x25
  800888:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	89 f8                	mov    %edi,%eax
  80088f:	eb 03                	jmp    800894 <vprintfmt+0x57b>
  800891:	83 e8 01             	sub    $0x1,%eax
  800894:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800898:	75 f7                	jne    800891 <vprintfmt+0x578>
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	e9 bd fe ff ff       	jmp    80075f <vprintfmt+0x446>
}
  8008a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a5:	5b                   	pop    %ebx
  8008a6:	5e                   	pop    %esi
  8008a7:	5f                   	pop    %edi
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	83 ec 18             	sub    $0x18,%esp
  8008b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b3:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b9:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008bd:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c7:	85 c0                	test   %eax,%eax
  8008c9:	74 26                	je     8008f1 <vsnprintf+0x47>
  8008cb:	85 d2                	test   %edx,%edx
  8008cd:	7e 22                	jle    8008f1 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cf:	ff 75 14             	pushl  0x14(%ebp)
  8008d2:	ff 75 10             	pushl  0x10(%ebp)
  8008d5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d8:	50                   	push   %eax
  8008d9:	68 df 02 80 00       	push   $0x8002df
  8008de:	e8 36 fa ff ff       	call   800319 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e6:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ec:	83 c4 10             	add    $0x10,%esp
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    
		return -E_INVAL;
  8008f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f6:	eb f7                	jmp    8008ef <vsnprintf+0x45>

008008f8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008fe:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800901:	50                   	push   %eax
  800902:	ff 75 10             	pushl  0x10(%ebp)
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	ff 75 08             	pushl  0x8(%ebp)
  80090b:	e8 9a ff ff ff       	call   8008aa <vsnprintf>
	va_end(ap);

	return rc;
}
  800910:	c9                   	leave  
  800911:	c3                   	ret    

00800912 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800912:	55                   	push   %ebp
  800913:	89 e5                	mov    %esp,%ebp
  800915:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800918:	b8 00 00 00 00       	mov    $0x0,%eax
  80091d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800921:	74 05                	je     800928 <strlen+0x16>
		n++;
  800923:	83 c0 01             	add    $0x1,%eax
  800926:	eb f5                	jmp    80091d <strlen+0xb>
	return n;
}
  800928:	5d                   	pop    %ebp
  800929:	c3                   	ret    

0080092a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800930:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800933:	ba 00 00 00 00       	mov    $0x0,%edx
  800938:	39 c2                	cmp    %eax,%edx
  80093a:	74 0d                	je     800949 <strnlen+0x1f>
  80093c:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800940:	74 05                	je     800947 <strnlen+0x1d>
		n++;
  800942:	83 c2 01             	add    $0x1,%edx
  800945:	eb f1                	jmp    800938 <strnlen+0xe>
  800947:	89 d0                	mov    %edx,%eax
	return n;
}
  800949:	5d                   	pop    %ebp
  80094a:	c3                   	ret    

0080094b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094b:	55                   	push   %ebp
  80094c:	89 e5                	mov    %esp,%ebp
  80094e:	53                   	push   %ebx
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800955:	ba 00 00 00 00       	mov    $0x0,%edx
  80095a:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80095e:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800961:	83 c2 01             	add    $0x1,%edx
  800964:	84 c9                	test   %cl,%cl
  800966:	75 f2                	jne    80095a <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800968:	5b                   	pop    %ebx
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	53                   	push   %ebx
  80096f:	83 ec 10             	sub    $0x10,%esp
  800972:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800975:	53                   	push   %ebx
  800976:	e8 97 ff ff ff       	call   800912 <strlen>
  80097b:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	01 d8                	add    %ebx,%eax
  800983:	50                   	push   %eax
  800984:	e8 c2 ff ff ff       	call   80094b <strcpy>
	return dst;
}
  800989:	89 d8                	mov    %ebx,%eax
  80098b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80098e:	c9                   	leave  
  80098f:	c3                   	ret    

00800990 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099b:	89 c6                	mov    %eax,%esi
  80099d:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a0:	89 c2                	mov    %eax,%edx
  8009a2:	39 f2                	cmp    %esi,%edx
  8009a4:	74 11                	je     8009b7 <strncpy+0x27>
		*dst++ = *src;
  8009a6:	83 c2 01             	add    $0x1,%edx
  8009a9:	0f b6 19             	movzbl (%ecx),%ebx
  8009ac:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009af:	80 fb 01             	cmp    $0x1,%bl
  8009b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b5:	eb eb                	jmp    8009a2 <strncpy+0x12>
	}
	return ret;
}
  8009b7:	5b                   	pop    %ebx
  8009b8:	5e                   	pop    %esi
  8009b9:	5d                   	pop    %ebp
  8009ba:	c3                   	ret    

008009bb <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bb:	55                   	push   %ebp
  8009bc:	89 e5                	mov    %esp,%ebp
  8009be:	56                   	push   %esi
  8009bf:	53                   	push   %ebx
  8009c0:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8009c9:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cb:	85 d2                	test   %edx,%edx
  8009cd:	74 21                	je     8009f0 <strlcpy+0x35>
  8009cf:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d3:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d5:	39 c2                	cmp    %eax,%edx
  8009d7:	74 14                	je     8009ed <strlcpy+0x32>
  8009d9:	0f b6 19             	movzbl (%ecx),%ebx
  8009dc:	84 db                	test   %bl,%bl
  8009de:	74 0b                	je     8009eb <strlcpy+0x30>
			*dst++ = *src++;
  8009e0:	83 c1 01             	add    $0x1,%ecx
  8009e3:	83 c2 01             	add    $0x1,%edx
  8009e6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009e9:	eb ea                	jmp    8009d5 <strlcpy+0x1a>
  8009eb:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009ed:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f0:	29 f0                	sub    %esi,%eax
}
  8009f2:	5b                   	pop    %ebx
  8009f3:	5e                   	pop    %esi
  8009f4:	5d                   	pop    %ebp
  8009f5:	c3                   	ret    

008009f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ff:	0f b6 01             	movzbl (%ecx),%eax
  800a02:	84 c0                	test   %al,%al
  800a04:	74 0c                	je     800a12 <strcmp+0x1c>
  800a06:	3a 02                	cmp    (%edx),%al
  800a08:	75 08                	jne    800a12 <strcmp+0x1c>
		p++, q++;
  800a0a:	83 c1 01             	add    $0x1,%ecx
  800a0d:	83 c2 01             	add    $0x1,%edx
  800a10:	eb ed                	jmp    8009ff <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a12:	0f b6 c0             	movzbl %al,%eax
  800a15:	0f b6 12             	movzbl (%edx),%edx
  800a18:	29 d0                	sub    %edx,%eax
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	53                   	push   %ebx
  800a20:	8b 45 08             	mov    0x8(%ebp),%eax
  800a23:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a26:	89 c3                	mov    %eax,%ebx
  800a28:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a2b:	eb 06                	jmp    800a33 <strncmp+0x17>
		n--, p++, q++;
  800a2d:	83 c0 01             	add    $0x1,%eax
  800a30:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a33:	39 d8                	cmp    %ebx,%eax
  800a35:	74 16                	je     800a4d <strncmp+0x31>
  800a37:	0f b6 08             	movzbl (%eax),%ecx
  800a3a:	84 c9                	test   %cl,%cl
  800a3c:	74 04                	je     800a42 <strncmp+0x26>
  800a3e:	3a 0a                	cmp    (%edx),%cl
  800a40:	74 eb                	je     800a2d <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a42:	0f b6 00             	movzbl (%eax),%eax
  800a45:	0f b6 12             	movzbl (%edx),%edx
  800a48:	29 d0                	sub    %edx,%eax
}
  800a4a:	5b                   	pop    %ebx
  800a4b:	5d                   	pop    %ebp
  800a4c:	c3                   	ret    
		return 0;
  800a4d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a52:	eb f6                	jmp    800a4a <strncmp+0x2e>

00800a54 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5a:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a5e:	0f b6 10             	movzbl (%eax),%edx
  800a61:	84 d2                	test   %dl,%dl
  800a63:	74 09                	je     800a6e <strchr+0x1a>
		if (*s == c)
  800a65:	38 ca                	cmp    %cl,%dl
  800a67:	74 0a                	je     800a73 <strchr+0x1f>
	for (; *s; s++)
  800a69:	83 c0 01             	add    $0x1,%eax
  800a6c:	eb f0                	jmp    800a5e <strchr+0xa>
			return (char *) s;
	return 0;
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a7f:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a82:	38 ca                	cmp    %cl,%dl
  800a84:	74 09                	je     800a8f <strfind+0x1a>
  800a86:	84 d2                	test   %dl,%dl
  800a88:	74 05                	je     800a8f <strfind+0x1a>
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	eb f0                	jmp    800a7f <strfind+0xa>
			break;
	return (char *) s;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	57                   	push   %edi
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a9d:	85 c9                	test   %ecx,%ecx
  800a9f:	74 31                	je     800ad2 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa1:	89 f8                	mov    %edi,%eax
  800aa3:	09 c8                	or     %ecx,%eax
  800aa5:	a8 03                	test   $0x3,%al
  800aa7:	75 23                	jne    800acc <memset+0x3b>
		c &= 0xFF;
  800aa9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aad:	89 d3                	mov    %edx,%ebx
  800aaf:	c1 e3 08             	shl    $0x8,%ebx
  800ab2:	89 d0                	mov    %edx,%eax
  800ab4:	c1 e0 18             	shl    $0x18,%eax
  800ab7:	89 d6                	mov    %edx,%esi
  800ab9:	c1 e6 10             	shl    $0x10,%esi
  800abc:	09 f0                	or     %esi,%eax
  800abe:	09 c2                	or     %eax,%edx
  800ac0:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac5:	89 d0                	mov    %edx,%eax
  800ac7:	fc                   	cld    
  800ac8:	f3 ab                	rep stos %eax,%es:(%edi)
  800aca:	eb 06                	jmp    800ad2 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800acc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acf:	fc                   	cld    
  800ad0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad2:	89 f8                	mov    %edi,%eax
  800ad4:	5b                   	pop    %ebx
  800ad5:	5e                   	pop    %esi
  800ad6:	5f                   	pop    %edi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	57                   	push   %edi
  800add:	56                   	push   %esi
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ae7:	39 c6                	cmp    %eax,%esi
  800ae9:	73 32                	jae    800b1d <memmove+0x44>
  800aeb:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800aee:	39 c2                	cmp    %eax,%edx
  800af0:	76 2b                	jbe    800b1d <memmove+0x44>
		s += n;
		d += n;
  800af2:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af5:	89 fe                	mov    %edi,%esi
  800af7:	09 ce                	or     %ecx,%esi
  800af9:	09 d6                	or     %edx,%esi
  800afb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b01:	75 0e                	jne    800b11 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b03:	83 ef 04             	sub    $0x4,%edi
  800b06:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b09:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b0c:	fd                   	std    
  800b0d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b0f:	eb 09                	jmp    800b1a <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b11:	83 ef 01             	sub    $0x1,%edi
  800b14:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b17:	fd                   	std    
  800b18:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1a:	fc                   	cld    
  800b1b:	eb 1a                	jmp    800b37 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b1d:	89 c2                	mov    %eax,%edx
  800b1f:	09 ca                	or     %ecx,%edx
  800b21:	09 f2                	or     %esi,%edx
  800b23:	f6 c2 03             	test   $0x3,%dl
  800b26:	75 0a                	jne    800b32 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b28:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2b:	89 c7                	mov    %eax,%edi
  800b2d:	fc                   	cld    
  800b2e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b30:	eb 05                	jmp    800b37 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b32:	89 c7                	mov    %eax,%edi
  800b34:	fc                   	cld    
  800b35:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b37:	5e                   	pop    %esi
  800b38:	5f                   	pop    %edi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b41:	ff 75 10             	pushl  0x10(%ebp)
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	ff 75 08             	pushl  0x8(%ebp)
  800b4a:	e8 8a ff ff ff       	call   800ad9 <memmove>
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	56                   	push   %esi
  800b55:	53                   	push   %ebx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b5c:	89 c6                	mov    %eax,%esi
  800b5e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b61:	39 f0                	cmp    %esi,%eax
  800b63:	74 1c                	je     800b81 <memcmp+0x30>
		if (*s1 != *s2)
  800b65:	0f b6 08             	movzbl (%eax),%ecx
  800b68:	0f b6 1a             	movzbl (%edx),%ebx
  800b6b:	38 d9                	cmp    %bl,%cl
  800b6d:	75 08                	jne    800b77 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b6f:	83 c0 01             	add    $0x1,%eax
  800b72:	83 c2 01             	add    $0x1,%edx
  800b75:	eb ea                	jmp    800b61 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b77:	0f b6 c1             	movzbl %cl,%eax
  800b7a:	0f b6 db             	movzbl %bl,%ebx
  800b7d:	29 d8                	sub    %ebx,%eax
  800b7f:	eb 05                	jmp    800b86 <memcmp+0x35>
	}

	return 0;
  800b81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b86:	5b                   	pop    %ebx
  800b87:	5e                   	pop    %esi
  800b88:	5d                   	pop    %ebp
  800b89:	c3                   	ret    

00800b8a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b93:	89 c2                	mov    %eax,%edx
  800b95:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b98:	39 d0                	cmp    %edx,%eax
  800b9a:	73 09                	jae    800ba5 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b9c:	38 08                	cmp    %cl,(%eax)
  800b9e:	74 05                	je     800ba5 <memfind+0x1b>
	for (; s < ends; s++)
  800ba0:	83 c0 01             	add    $0x1,%eax
  800ba3:	eb f3                	jmp    800b98 <memfind+0xe>
			break;
	return (void *) s;
}
  800ba5:	5d                   	pop    %ebp
  800ba6:	c3                   	ret    

00800ba7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	57                   	push   %edi
  800bab:	56                   	push   %esi
  800bac:	53                   	push   %ebx
  800bad:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb3:	eb 03                	jmp    800bb8 <strtol+0x11>
		s++;
  800bb5:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bb8:	0f b6 01             	movzbl (%ecx),%eax
  800bbb:	3c 20                	cmp    $0x20,%al
  800bbd:	74 f6                	je     800bb5 <strtol+0xe>
  800bbf:	3c 09                	cmp    $0x9,%al
  800bc1:	74 f2                	je     800bb5 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc3:	3c 2b                	cmp    $0x2b,%al
  800bc5:	74 2a                	je     800bf1 <strtol+0x4a>
	int neg = 0;
  800bc7:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bcc:	3c 2d                	cmp    $0x2d,%al
  800bce:	74 2b                	je     800bfb <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd0:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bd6:	75 0f                	jne    800be7 <strtol+0x40>
  800bd8:	80 39 30             	cmpb   $0x30,(%ecx)
  800bdb:	74 28                	je     800c05 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bdd:	85 db                	test   %ebx,%ebx
  800bdf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be4:	0f 44 d8             	cmove  %eax,%ebx
  800be7:	b8 00 00 00 00       	mov    $0x0,%eax
  800bec:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bef:	eb 50                	jmp    800c41 <strtol+0x9a>
		s++;
  800bf1:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf4:	bf 00 00 00 00       	mov    $0x0,%edi
  800bf9:	eb d5                	jmp    800bd0 <strtol+0x29>
		s++, neg = 1;
  800bfb:	83 c1 01             	add    $0x1,%ecx
  800bfe:	bf 01 00 00 00       	mov    $0x1,%edi
  800c03:	eb cb                	jmp    800bd0 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c05:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c09:	74 0e                	je     800c19 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c0b:	85 db                	test   %ebx,%ebx
  800c0d:	75 d8                	jne    800be7 <strtol+0x40>
		s++, base = 8;
  800c0f:	83 c1 01             	add    $0x1,%ecx
  800c12:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c17:	eb ce                	jmp    800be7 <strtol+0x40>
		s += 2, base = 16;
  800c19:	83 c1 02             	add    $0x2,%ecx
  800c1c:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c21:	eb c4                	jmp    800be7 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c23:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c26:	89 f3                	mov    %esi,%ebx
  800c28:	80 fb 19             	cmp    $0x19,%bl
  800c2b:	77 29                	ja     800c56 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c2d:	0f be d2             	movsbl %dl,%edx
  800c30:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c33:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c36:	7d 30                	jge    800c68 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c38:	83 c1 01             	add    $0x1,%ecx
  800c3b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c3f:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c41:	0f b6 11             	movzbl (%ecx),%edx
  800c44:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c47:	89 f3                	mov    %esi,%ebx
  800c49:	80 fb 09             	cmp    $0x9,%bl
  800c4c:	77 d5                	ja     800c23 <strtol+0x7c>
			dig = *s - '0';
  800c4e:	0f be d2             	movsbl %dl,%edx
  800c51:	83 ea 30             	sub    $0x30,%edx
  800c54:	eb dd                	jmp    800c33 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c56:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c59:	89 f3                	mov    %esi,%ebx
  800c5b:	80 fb 19             	cmp    $0x19,%bl
  800c5e:	77 08                	ja     800c68 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c60:	0f be d2             	movsbl %dl,%edx
  800c63:	83 ea 37             	sub    $0x37,%edx
  800c66:	eb cb                	jmp    800c33 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6c:	74 05                	je     800c73 <strtol+0xcc>
		*endptr = (char *) s;
  800c6e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c71:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c73:	89 c2                	mov    %eax,%edx
  800c75:	f7 da                	neg    %edx
  800c77:	85 ff                	test   %edi,%edi
  800c79:	0f 45 c2             	cmovne %edx,%eax
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c87:	b8 00 00 00 00       	mov    $0x0,%eax
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	89 c3                	mov    %eax,%ebx
  800c94:	89 c7                	mov    %eax,%edi
  800c96:	89 c6                	mov    %eax,%esi
  800c98:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9a:	5b                   	pop    %ebx
  800c9b:	5e                   	pop    %esi
  800c9c:	5f                   	pop    %edi
  800c9d:	5d                   	pop    %ebp
  800c9e:	c3                   	ret    

00800c9f <sys_cgetc>:

int
sys_cgetc(void)
{
  800c9f:	55                   	push   %ebp
  800ca0:	89 e5                	mov    %esp,%ebp
  800ca2:	57                   	push   %edi
  800ca3:	56                   	push   %esi
  800ca4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  800caa:	b8 01 00 00 00       	mov    $0x1,%eax
  800caf:	89 d1                	mov    %edx,%ecx
  800cb1:	89 d3                	mov    %edx,%ebx
  800cb3:	89 d7                	mov    %edx,%edi
  800cb5:	89 d6                	mov    %edx,%esi
  800cb7:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    

00800cbe <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	57                   	push   %edi
  800cc2:	56                   	push   %esi
  800cc3:	53                   	push   %ebx
  800cc4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd4:	89 cb                	mov    %ecx,%ebx
  800cd6:	89 cf                	mov    %ecx,%edi
  800cd8:	89 ce                	mov    %ecx,%esi
  800cda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	7f 08                	jg     800ce8 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ce8:	83 ec 0c             	sub    $0xc,%esp
  800ceb:	50                   	push   %eax
  800cec:	6a 03                	push   $0x3
  800cee:	68 48 29 80 00       	push   $0x802948
  800cf3:	6a 43                	push   $0x43
  800cf5:	68 65 29 80 00       	push   $0x802965
  800cfa:	e8 69 14 00 00       	call   802168 <_panic>

00800cff <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
  800d02:	57                   	push   %edi
  800d03:	56                   	push   %esi
  800d04:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d05:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0a:	b8 02 00 00 00       	mov    $0x2,%eax
  800d0f:	89 d1                	mov    %edx,%ecx
  800d11:	89 d3                	mov    %edx,%ebx
  800d13:	89 d7                	mov    %edx,%edi
  800d15:	89 d6                	mov    %edx,%esi
  800d17:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d19:	5b                   	pop    %ebx
  800d1a:	5e                   	pop    %esi
  800d1b:	5f                   	pop    %edi
  800d1c:	5d                   	pop    %ebp
  800d1d:	c3                   	ret    

00800d1e <sys_yield>:

void
sys_yield(void)
{
  800d1e:	55                   	push   %ebp
  800d1f:	89 e5                	mov    %esp,%ebp
  800d21:	57                   	push   %edi
  800d22:	56                   	push   %esi
  800d23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d24:	ba 00 00 00 00       	mov    $0x0,%edx
  800d29:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d2e:	89 d1                	mov    %edx,%ecx
  800d30:	89 d3                	mov    %edx,%ebx
  800d32:	89 d7                	mov    %edx,%edi
  800d34:	89 d6                	mov    %edx,%esi
  800d36:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	57                   	push   %edi
  800d41:	56                   	push   %esi
  800d42:	53                   	push   %ebx
  800d43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d46:	be 00 00 00 00       	mov    $0x0,%esi
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d51:	b8 04 00 00 00       	mov    $0x4,%eax
  800d56:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d59:	89 f7                	mov    %esi,%edi
  800d5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5d:	85 c0                	test   %eax,%eax
  800d5f:	7f 08                	jg     800d69 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	50                   	push   %eax
  800d6d:	6a 04                	push   $0x4
  800d6f:	68 48 29 80 00       	push   $0x802948
  800d74:	6a 43                	push   $0x43
  800d76:	68 65 29 80 00       	push   $0x802965
  800d7b:	e8 e8 13 00 00       	call   802168 <_panic>

00800d80 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	57                   	push   %edi
  800d84:	56                   	push   %esi
  800d85:	53                   	push   %ebx
  800d86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d89:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8f:	b8 05 00 00 00       	mov    $0x5,%eax
  800d94:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d97:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9f:	85 c0                	test   %eax,%eax
  800da1:	7f 08                	jg     800dab <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dab:	83 ec 0c             	sub    $0xc,%esp
  800dae:	50                   	push   %eax
  800daf:	6a 05                	push   $0x5
  800db1:	68 48 29 80 00       	push   $0x802948
  800db6:	6a 43                	push   $0x43
  800db8:	68 65 29 80 00       	push   $0x802965
  800dbd:	e8 a6 13 00 00       	call   802168 <_panic>

00800dc2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc2:	55                   	push   %ebp
  800dc3:	89 e5                	mov    %esp,%ebp
  800dc5:	57                   	push   %edi
  800dc6:	56                   	push   %esi
  800dc7:	53                   	push   %ebx
  800dc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd6:	b8 06 00 00 00       	mov    $0x6,%eax
  800ddb:	89 df                	mov    %ebx,%edi
  800ddd:	89 de                	mov    %ebx,%esi
  800ddf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de1:	85 c0                	test   %eax,%eax
  800de3:	7f 08                	jg     800ded <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de8:	5b                   	pop    %ebx
  800de9:	5e                   	pop    %esi
  800dea:	5f                   	pop    %edi
  800deb:	5d                   	pop    %ebp
  800dec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ded:	83 ec 0c             	sub    $0xc,%esp
  800df0:	50                   	push   %eax
  800df1:	6a 06                	push   $0x6
  800df3:	68 48 29 80 00       	push   $0x802948
  800df8:	6a 43                	push   $0x43
  800dfa:	68 65 29 80 00       	push   $0x802965
  800dff:	e8 64 13 00 00       	call   802168 <_panic>

00800e04 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	57                   	push   %edi
  800e08:	56                   	push   %esi
  800e09:	53                   	push   %ebx
  800e0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e12:	8b 55 08             	mov    0x8(%ebp),%edx
  800e15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e18:	b8 08 00 00 00       	mov    $0x8,%eax
  800e1d:	89 df                	mov    %ebx,%edi
  800e1f:	89 de                	mov    %ebx,%esi
  800e21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e23:	85 c0                	test   %eax,%eax
  800e25:	7f 08                	jg     800e2f <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e2f:	83 ec 0c             	sub    $0xc,%esp
  800e32:	50                   	push   %eax
  800e33:	6a 08                	push   $0x8
  800e35:	68 48 29 80 00       	push   $0x802948
  800e3a:	6a 43                	push   $0x43
  800e3c:	68 65 29 80 00       	push   $0x802965
  800e41:	e8 22 13 00 00       	call   802168 <_panic>

00800e46 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	57                   	push   %edi
  800e4a:	56                   	push   %esi
  800e4b:	53                   	push   %ebx
  800e4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e54:	8b 55 08             	mov    0x8(%ebp),%edx
  800e57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5a:	b8 09 00 00 00       	mov    $0x9,%eax
  800e5f:	89 df                	mov    %ebx,%edi
  800e61:	89 de                	mov    %ebx,%esi
  800e63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e65:	85 c0                	test   %eax,%eax
  800e67:	7f 08                	jg     800e71 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e6c:	5b                   	pop    %ebx
  800e6d:	5e                   	pop    %esi
  800e6e:	5f                   	pop    %edi
  800e6f:	5d                   	pop    %ebp
  800e70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e71:	83 ec 0c             	sub    $0xc,%esp
  800e74:	50                   	push   %eax
  800e75:	6a 09                	push   $0x9
  800e77:	68 48 29 80 00       	push   $0x802948
  800e7c:	6a 43                	push   $0x43
  800e7e:	68 65 29 80 00       	push   $0x802965
  800e83:	e8 e0 12 00 00       	call   802168 <_panic>

00800e88 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e91:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e9c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea1:	89 df                	mov    %ebx,%edi
  800ea3:	89 de                	mov    %ebx,%esi
  800ea5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea7:	85 c0                	test   %eax,%eax
  800ea9:	7f 08                	jg     800eb3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eae:	5b                   	pop    %ebx
  800eaf:	5e                   	pop    %esi
  800eb0:	5f                   	pop    %edi
  800eb1:	5d                   	pop    %ebp
  800eb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb3:	83 ec 0c             	sub    $0xc,%esp
  800eb6:	50                   	push   %eax
  800eb7:	6a 0a                	push   $0xa
  800eb9:	68 48 29 80 00       	push   $0x802948
  800ebe:	6a 43                	push   $0x43
  800ec0:	68 65 29 80 00       	push   $0x802965
  800ec5:	e8 9e 12 00 00       	call   802168 <_panic>

00800eca <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eca:	55                   	push   %ebp
  800ecb:	89 e5                	mov    %esp,%ebp
  800ecd:	57                   	push   %edi
  800ece:	56                   	push   %esi
  800ecf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed6:	b8 0c 00 00 00       	mov    $0xc,%eax
  800edb:	be 00 00 00 00       	mov    $0x0,%esi
  800ee0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ee6:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee8:	5b                   	pop    %ebx
  800ee9:	5e                   	pop    %esi
  800eea:	5f                   	pop    %edi
  800eeb:	5d                   	pop    %ebp
  800eec:	c3                   	ret    

00800eed <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ef6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800efb:	8b 55 08             	mov    0x8(%ebp),%edx
  800efe:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f03:	89 cb                	mov    %ecx,%ebx
  800f05:	89 cf                	mov    %ecx,%edi
  800f07:	89 ce                	mov    %ecx,%esi
  800f09:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0b:	85 c0                	test   %eax,%eax
  800f0d:	7f 08                	jg     800f17 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f12:	5b                   	pop    %ebx
  800f13:	5e                   	pop    %esi
  800f14:	5f                   	pop    %edi
  800f15:	5d                   	pop    %ebp
  800f16:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f17:	83 ec 0c             	sub    $0xc,%esp
  800f1a:	50                   	push   %eax
  800f1b:	6a 0d                	push   $0xd
  800f1d:	68 48 29 80 00       	push   $0x802948
  800f22:	6a 43                	push   $0x43
  800f24:	68 65 29 80 00       	push   $0x802965
  800f29:	e8 3a 12 00 00       	call   802168 <_panic>

00800f2e <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f2e:	55                   	push   %ebp
  800f2f:	89 e5                	mov    %esp,%ebp
  800f31:	57                   	push   %edi
  800f32:	56                   	push   %esi
  800f33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3f:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f44:	89 df                	mov    %ebx,%edi
  800f46:	89 de                	mov    %ebx,%esi
  800f48:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f62:	89 cb                	mov    %ecx,%ebx
  800f64:	89 cf                	mov    %ecx,%edi
  800f66:	89 ce                	mov    %ecx,%esi
  800f68:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6a:	5b                   	pop    %ebx
  800f6b:	5e                   	pop    %esi
  800f6c:	5f                   	pop    %edi
  800f6d:	5d                   	pop    %ebp
  800f6e:	c3                   	ret    

00800f6f <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f6f:	55                   	push   %ebp
  800f70:	89 e5                	mov    %esp,%ebp
  800f72:	57                   	push   %edi
  800f73:	56                   	push   %esi
  800f74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f75:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7a:	b8 10 00 00 00       	mov    $0x10,%eax
  800f7f:	89 d1                	mov    %edx,%ecx
  800f81:	89 d3                	mov    %edx,%ebx
  800f83:	89 d7                	mov    %edx,%edi
  800f85:	89 d6                	mov    %edx,%esi
  800f87:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f89:	5b                   	pop    %ebx
  800f8a:	5e                   	pop    %esi
  800f8b:	5f                   	pop    %edi
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	57                   	push   %edi
  800f92:	56                   	push   %esi
  800f93:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9f:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa4:	89 df                	mov    %ebx,%edi
  800fa6:	89 de                	mov    %ebx,%esi
  800fa8:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800faa:	5b                   	pop    %ebx
  800fab:	5e                   	pop    %esi
  800fac:	5f                   	pop    %edi
  800fad:	5d                   	pop    %ebp
  800fae:	c3                   	ret    

00800faf <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800faf:	55                   	push   %ebp
  800fb0:	89 e5                	mov    %esp,%ebp
  800fb2:	57                   	push   %edi
  800fb3:	56                   	push   %esi
  800fb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fba:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc0:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc5:	89 df                	mov    %ebx,%edi
  800fc7:	89 de                	mov    %ebx,%esi
  800fc9:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fcb:	5b                   	pop    %ebx
  800fcc:	5e                   	pop    %esi
  800fcd:	5f                   	pop    %edi
  800fce:	5d                   	pop    %ebp
  800fcf:	c3                   	ret    

00800fd0 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
  800fd6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fd9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fde:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe4:	b8 13 00 00 00       	mov    $0x13,%eax
  800fe9:	89 df                	mov    %ebx,%edi
  800feb:	89 de                	mov    %ebx,%esi
  800fed:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	7f 08                	jg     800ffb <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff6:	5b                   	pop    %ebx
  800ff7:	5e                   	pop    %esi
  800ff8:	5f                   	pop    %edi
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ffb:	83 ec 0c             	sub    $0xc,%esp
  800ffe:	50                   	push   %eax
  800fff:	6a 13                	push   $0x13
  801001:	68 48 29 80 00       	push   $0x802948
  801006:	6a 43                	push   $0x43
  801008:	68 65 29 80 00       	push   $0x802965
  80100d:	e8 56 11 00 00       	call   802168 <_panic>

00801012 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801012:	55                   	push   %ebp
  801013:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	05 00 00 00 30       	add    $0x30000000,%eax
  80101d:	c1 e8 0c             	shr    $0xc,%eax
}
  801020:	5d                   	pop    %ebp
  801021:	c3                   	ret    

00801022 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801022:	55                   	push   %ebp
  801023:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801025:	8b 45 08             	mov    0x8(%ebp),%eax
  801028:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80102d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801032:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801037:	5d                   	pop    %ebp
  801038:	c3                   	ret    

00801039 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801041:	89 c2                	mov    %eax,%edx
  801043:	c1 ea 16             	shr    $0x16,%edx
  801046:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80104d:	f6 c2 01             	test   $0x1,%dl
  801050:	74 2d                	je     80107f <fd_alloc+0x46>
  801052:	89 c2                	mov    %eax,%edx
  801054:	c1 ea 0c             	shr    $0xc,%edx
  801057:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80105e:	f6 c2 01             	test   $0x1,%dl
  801061:	74 1c                	je     80107f <fd_alloc+0x46>
  801063:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801068:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80106d:	75 d2                	jne    801041 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801078:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80107d:	eb 0a                	jmp    801089 <fd_alloc+0x50>
			*fd_store = fd;
  80107f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801082:	89 01                	mov    %eax,(%ecx)
			return 0;
  801084:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801089:	5d                   	pop    %ebp
  80108a:	c3                   	ret    

0080108b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80108b:	55                   	push   %ebp
  80108c:	89 e5                	mov    %esp,%ebp
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801091:	83 f8 1f             	cmp    $0x1f,%eax
  801094:	77 30                	ja     8010c6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801096:	c1 e0 0c             	shl    $0xc,%eax
  801099:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80109e:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010a4:	f6 c2 01             	test   $0x1,%dl
  8010a7:	74 24                	je     8010cd <fd_lookup+0x42>
  8010a9:	89 c2                	mov    %eax,%edx
  8010ab:	c1 ea 0c             	shr    $0xc,%edx
  8010ae:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b5:	f6 c2 01             	test   $0x1,%dl
  8010b8:	74 1a                	je     8010d4 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bd:	89 02                	mov    %eax,(%edx)
	return 0;
  8010bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    
		return -E_INVAL;
  8010c6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cb:	eb f7                	jmp    8010c4 <fd_lookup+0x39>
		return -E_INVAL;
  8010cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d2:	eb f0                	jmp    8010c4 <fd_lookup+0x39>
  8010d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d9:	eb e9                	jmp    8010c4 <fd_lookup+0x39>

008010db <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 08             	sub    $0x8,%esp
  8010e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8010e9:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010ee:	39 08                	cmp    %ecx,(%eax)
  8010f0:	74 38                	je     80112a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010f2:	83 c2 01             	add    $0x1,%edx
  8010f5:	8b 04 95 f0 29 80 00 	mov    0x8029f0(,%edx,4),%eax
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	75 ee                	jne    8010ee <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801100:	a1 08 40 80 00       	mov    0x804008,%eax
  801105:	8b 40 48             	mov    0x48(%eax),%eax
  801108:	83 ec 04             	sub    $0x4,%esp
  80110b:	51                   	push   %ecx
  80110c:	50                   	push   %eax
  80110d:	68 74 29 80 00       	push   $0x802974
  801112:	e8 d5 f0 ff ff       	call   8001ec <cprintf>
	*dev = 0;
  801117:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801120:	83 c4 10             	add    $0x10,%esp
  801123:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    
			*dev = devtab[i];
  80112a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80112f:	b8 00 00 00 00       	mov    $0x0,%eax
  801134:	eb f2                	jmp    801128 <dev_lookup+0x4d>

00801136 <fd_close>:
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	57                   	push   %edi
  80113a:	56                   	push   %esi
  80113b:	53                   	push   %ebx
  80113c:	83 ec 24             	sub    $0x24,%esp
  80113f:	8b 75 08             	mov    0x8(%ebp),%esi
  801142:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801145:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801148:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801149:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80114f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801152:	50                   	push   %eax
  801153:	e8 33 ff ff ff       	call   80108b <fd_lookup>
  801158:	89 c3                	mov    %eax,%ebx
  80115a:	83 c4 10             	add    $0x10,%esp
  80115d:	85 c0                	test   %eax,%eax
  80115f:	78 05                	js     801166 <fd_close+0x30>
	    || fd != fd2)
  801161:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801164:	74 16                	je     80117c <fd_close+0x46>
		return (must_exist ? r : 0);
  801166:	89 f8                	mov    %edi,%eax
  801168:	84 c0                	test   %al,%al
  80116a:	b8 00 00 00 00       	mov    $0x0,%eax
  80116f:	0f 44 d8             	cmove  %eax,%ebx
}
  801172:	89 d8                	mov    %ebx,%eax
  801174:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801177:	5b                   	pop    %ebx
  801178:	5e                   	pop    %esi
  801179:	5f                   	pop    %edi
  80117a:	5d                   	pop    %ebp
  80117b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801182:	50                   	push   %eax
  801183:	ff 36                	pushl  (%esi)
  801185:	e8 51 ff ff ff       	call   8010db <dev_lookup>
  80118a:	89 c3                	mov    %eax,%ebx
  80118c:	83 c4 10             	add    $0x10,%esp
  80118f:	85 c0                	test   %eax,%eax
  801191:	78 1a                	js     8011ad <fd_close+0x77>
		if (dev->dev_close)
  801193:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801196:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801199:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80119e:	85 c0                	test   %eax,%eax
  8011a0:	74 0b                	je     8011ad <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	56                   	push   %esi
  8011a6:	ff d0                	call   *%eax
  8011a8:	89 c3                	mov    %eax,%ebx
  8011aa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011ad:	83 ec 08             	sub    $0x8,%esp
  8011b0:	56                   	push   %esi
  8011b1:	6a 00                	push   $0x0
  8011b3:	e8 0a fc ff ff       	call   800dc2 <sys_page_unmap>
	return r;
  8011b8:	83 c4 10             	add    $0x10,%esp
  8011bb:	eb b5                	jmp    801172 <fd_close+0x3c>

008011bd <close>:

int
close(int fdnum)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011c3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c6:	50                   	push   %eax
  8011c7:	ff 75 08             	pushl  0x8(%ebp)
  8011ca:	e8 bc fe ff ff       	call   80108b <fd_lookup>
  8011cf:	83 c4 10             	add    $0x10,%esp
  8011d2:	85 c0                	test   %eax,%eax
  8011d4:	79 02                	jns    8011d8 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011d6:	c9                   	leave  
  8011d7:	c3                   	ret    
		return fd_close(fd, 1);
  8011d8:	83 ec 08             	sub    $0x8,%esp
  8011db:	6a 01                	push   $0x1
  8011dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e0:	e8 51 ff ff ff       	call   801136 <fd_close>
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	eb ec                	jmp    8011d6 <close+0x19>

008011ea <close_all>:

void
close_all(void)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	53                   	push   %ebx
  8011ee:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011f1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011f6:	83 ec 0c             	sub    $0xc,%esp
  8011f9:	53                   	push   %ebx
  8011fa:	e8 be ff ff ff       	call   8011bd <close>
	for (i = 0; i < MAXFD; i++)
  8011ff:	83 c3 01             	add    $0x1,%ebx
  801202:	83 c4 10             	add    $0x10,%esp
  801205:	83 fb 20             	cmp    $0x20,%ebx
  801208:	75 ec                	jne    8011f6 <close_all+0xc>
}
  80120a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	57                   	push   %edi
  801213:	56                   	push   %esi
  801214:	53                   	push   %ebx
  801215:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801218:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80121b:	50                   	push   %eax
  80121c:	ff 75 08             	pushl  0x8(%ebp)
  80121f:	e8 67 fe ff ff       	call   80108b <fd_lookup>
  801224:	89 c3                	mov    %eax,%ebx
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	0f 88 81 00 00 00    	js     8012b2 <dup+0xa3>
		return r;
	close(newfdnum);
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	ff 75 0c             	pushl  0xc(%ebp)
  801237:	e8 81 ff ff ff       	call   8011bd <close>

	newfd = INDEX2FD(newfdnum);
  80123c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80123f:	c1 e6 0c             	shl    $0xc,%esi
  801242:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801248:	83 c4 04             	add    $0x4,%esp
  80124b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80124e:	e8 cf fd ff ff       	call   801022 <fd2data>
  801253:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801255:	89 34 24             	mov    %esi,(%esp)
  801258:	e8 c5 fd ff ff       	call   801022 <fd2data>
  80125d:	83 c4 10             	add    $0x10,%esp
  801260:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801262:	89 d8                	mov    %ebx,%eax
  801264:	c1 e8 16             	shr    $0x16,%eax
  801267:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80126e:	a8 01                	test   $0x1,%al
  801270:	74 11                	je     801283 <dup+0x74>
  801272:	89 d8                	mov    %ebx,%eax
  801274:	c1 e8 0c             	shr    $0xc,%eax
  801277:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80127e:	f6 c2 01             	test   $0x1,%dl
  801281:	75 39                	jne    8012bc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801283:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801286:	89 d0                	mov    %edx,%eax
  801288:	c1 e8 0c             	shr    $0xc,%eax
  80128b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801292:	83 ec 0c             	sub    $0xc,%esp
  801295:	25 07 0e 00 00       	and    $0xe07,%eax
  80129a:	50                   	push   %eax
  80129b:	56                   	push   %esi
  80129c:	6a 00                	push   $0x0
  80129e:	52                   	push   %edx
  80129f:	6a 00                	push   $0x0
  8012a1:	e8 da fa ff ff       	call   800d80 <sys_page_map>
  8012a6:	89 c3                	mov    %eax,%ebx
  8012a8:	83 c4 20             	add    $0x20,%esp
  8012ab:	85 c0                	test   %eax,%eax
  8012ad:	78 31                	js     8012e0 <dup+0xd1>
		goto err;

	return newfdnum;
  8012af:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012b2:	89 d8                	mov    %ebx,%eax
  8012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012b7:	5b                   	pop    %ebx
  8012b8:	5e                   	pop    %esi
  8012b9:	5f                   	pop    %edi
  8012ba:	5d                   	pop    %ebp
  8012bb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012bc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	25 07 0e 00 00       	and    $0xe07,%eax
  8012cb:	50                   	push   %eax
  8012cc:	57                   	push   %edi
  8012cd:	6a 00                	push   $0x0
  8012cf:	53                   	push   %ebx
  8012d0:	6a 00                	push   $0x0
  8012d2:	e8 a9 fa ff ff       	call   800d80 <sys_page_map>
  8012d7:	89 c3                	mov    %eax,%ebx
  8012d9:	83 c4 20             	add    $0x20,%esp
  8012dc:	85 c0                	test   %eax,%eax
  8012de:	79 a3                	jns    801283 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012e0:	83 ec 08             	sub    $0x8,%esp
  8012e3:	56                   	push   %esi
  8012e4:	6a 00                	push   $0x0
  8012e6:	e8 d7 fa ff ff       	call   800dc2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012eb:	83 c4 08             	add    $0x8,%esp
  8012ee:	57                   	push   %edi
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 cc fa ff ff       	call   800dc2 <sys_page_unmap>
	return r;
  8012f6:	83 c4 10             	add    $0x10,%esp
  8012f9:	eb b7                	jmp    8012b2 <dup+0xa3>

008012fb <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	53                   	push   %ebx
  8012ff:	83 ec 1c             	sub    $0x1c,%esp
  801302:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801305:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801308:	50                   	push   %eax
  801309:	53                   	push   %ebx
  80130a:	e8 7c fd ff ff       	call   80108b <fd_lookup>
  80130f:	83 c4 10             	add    $0x10,%esp
  801312:	85 c0                	test   %eax,%eax
  801314:	78 3f                	js     801355 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801316:	83 ec 08             	sub    $0x8,%esp
  801319:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80131c:	50                   	push   %eax
  80131d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801320:	ff 30                	pushl  (%eax)
  801322:	e8 b4 fd ff ff       	call   8010db <dev_lookup>
  801327:	83 c4 10             	add    $0x10,%esp
  80132a:	85 c0                	test   %eax,%eax
  80132c:	78 27                	js     801355 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80132e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801331:	8b 42 08             	mov    0x8(%edx),%eax
  801334:	83 e0 03             	and    $0x3,%eax
  801337:	83 f8 01             	cmp    $0x1,%eax
  80133a:	74 1e                	je     80135a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80133c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133f:	8b 40 08             	mov    0x8(%eax),%eax
  801342:	85 c0                	test   %eax,%eax
  801344:	74 35                	je     80137b <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	ff 75 10             	pushl  0x10(%ebp)
  80134c:	ff 75 0c             	pushl  0xc(%ebp)
  80134f:	52                   	push   %edx
  801350:	ff d0                	call   *%eax
  801352:	83 c4 10             	add    $0x10,%esp
}
  801355:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801358:	c9                   	leave  
  801359:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80135a:	a1 08 40 80 00       	mov    0x804008,%eax
  80135f:	8b 40 48             	mov    0x48(%eax),%eax
  801362:	83 ec 04             	sub    $0x4,%esp
  801365:	53                   	push   %ebx
  801366:	50                   	push   %eax
  801367:	68 b5 29 80 00       	push   $0x8029b5
  80136c:	e8 7b ee ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801371:	83 c4 10             	add    $0x10,%esp
  801374:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801379:	eb da                	jmp    801355 <read+0x5a>
		return -E_NOT_SUPP;
  80137b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801380:	eb d3                	jmp    801355 <read+0x5a>

00801382 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801382:	55                   	push   %ebp
  801383:	89 e5                	mov    %esp,%ebp
  801385:	57                   	push   %edi
  801386:	56                   	push   %esi
  801387:	53                   	push   %ebx
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80138e:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801391:	bb 00 00 00 00       	mov    $0x0,%ebx
  801396:	39 f3                	cmp    %esi,%ebx
  801398:	73 23                	jae    8013bd <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	89 f0                	mov    %esi,%eax
  80139f:	29 d8                	sub    %ebx,%eax
  8013a1:	50                   	push   %eax
  8013a2:	89 d8                	mov    %ebx,%eax
  8013a4:	03 45 0c             	add    0xc(%ebp),%eax
  8013a7:	50                   	push   %eax
  8013a8:	57                   	push   %edi
  8013a9:	e8 4d ff ff ff       	call   8012fb <read>
		if (m < 0)
  8013ae:	83 c4 10             	add    $0x10,%esp
  8013b1:	85 c0                	test   %eax,%eax
  8013b3:	78 06                	js     8013bb <readn+0x39>
			return m;
		if (m == 0)
  8013b5:	74 06                	je     8013bd <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013b7:	01 c3                	add    %eax,%ebx
  8013b9:	eb db                	jmp    801396 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013bb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013bd:	89 d8                	mov    %ebx,%eax
  8013bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c2:	5b                   	pop    %ebx
  8013c3:	5e                   	pop    %esi
  8013c4:	5f                   	pop    %edi
  8013c5:	5d                   	pop    %ebp
  8013c6:	c3                   	ret    

008013c7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013c7:	55                   	push   %ebp
  8013c8:	89 e5                	mov    %esp,%ebp
  8013ca:	53                   	push   %ebx
  8013cb:	83 ec 1c             	sub    $0x1c,%esp
  8013ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d4:	50                   	push   %eax
  8013d5:	53                   	push   %ebx
  8013d6:	e8 b0 fc ff ff       	call   80108b <fd_lookup>
  8013db:	83 c4 10             	add    $0x10,%esp
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 3a                	js     80141c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e2:	83 ec 08             	sub    $0x8,%esp
  8013e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e8:	50                   	push   %eax
  8013e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ec:	ff 30                	pushl  (%eax)
  8013ee:	e8 e8 fc ff ff       	call   8010db <dev_lookup>
  8013f3:	83 c4 10             	add    $0x10,%esp
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 22                	js     80141c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013fd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801401:	74 1e                	je     801421 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801403:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801406:	8b 52 0c             	mov    0xc(%edx),%edx
  801409:	85 d2                	test   %edx,%edx
  80140b:	74 35                	je     801442 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80140d:	83 ec 04             	sub    $0x4,%esp
  801410:	ff 75 10             	pushl  0x10(%ebp)
  801413:	ff 75 0c             	pushl  0xc(%ebp)
  801416:	50                   	push   %eax
  801417:	ff d2                	call   *%edx
  801419:	83 c4 10             	add    $0x10,%esp
}
  80141c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80141f:	c9                   	leave  
  801420:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801421:	a1 08 40 80 00       	mov    0x804008,%eax
  801426:	8b 40 48             	mov    0x48(%eax),%eax
  801429:	83 ec 04             	sub    $0x4,%esp
  80142c:	53                   	push   %ebx
  80142d:	50                   	push   %eax
  80142e:	68 d1 29 80 00       	push   $0x8029d1
  801433:	e8 b4 ed ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  801438:	83 c4 10             	add    $0x10,%esp
  80143b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801440:	eb da                	jmp    80141c <write+0x55>
		return -E_NOT_SUPP;
  801442:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801447:	eb d3                	jmp    80141c <write+0x55>

00801449 <seek>:

int
seek(int fdnum, off_t offset)
{
  801449:	55                   	push   %ebp
  80144a:	89 e5                	mov    %esp,%ebp
  80144c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80144f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801452:	50                   	push   %eax
  801453:	ff 75 08             	pushl  0x8(%ebp)
  801456:	e8 30 fc ff ff       	call   80108b <fd_lookup>
  80145b:	83 c4 10             	add    $0x10,%esp
  80145e:	85 c0                	test   %eax,%eax
  801460:	78 0e                	js     801470 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801462:	8b 55 0c             	mov    0xc(%ebp),%edx
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80146b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801470:	c9                   	leave  
  801471:	c3                   	ret    

00801472 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801472:	55                   	push   %ebp
  801473:	89 e5                	mov    %esp,%ebp
  801475:	53                   	push   %ebx
  801476:	83 ec 1c             	sub    $0x1c,%esp
  801479:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80147c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147f:	50                   	push   %eax
  801480:	53                   	push   %ebx
  801481:	e8 05 fc ff ff       	call   80108b <fd_lookup>
  801486:	83 c4 10             	add    $0x10,%esp
  801489:	85 c0                	test   %eax,%eax
  80148b:	78 37                	js     8014c4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148d:	83 ec 08             	sub    $0x8,%esp
  801490:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801493:	50                   	push   %eax
  801494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801497:	ff 30                	pushl  (%eax)
  801499:	e8 3d fc ff ff       	call   8010db <dev_lookup>
  80149e:	83 c4 10             	add    $0x10,%esp
  8014a1:	85 c0                	test   %eax,%eax
  8014a3:	78 1f                	js     8014c4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014ac:	74 1b                	je     8014c9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b1:	8b 52 18             	mov    0x18(%edx),%edx
  8014b4:	85 d2                	test   %edx,%edx
  8014b6:	74 32                	je     8014ea <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	ff 75 0c             	pushl  0xc(%ebp)
  8014be:	50                   	push   %eax
  8014bf:	ff d2                	call   *%edx
  8014c1:	83 c4 10             	add    $0x10,%esp
}
  8014c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014c7:	c9                   	leave  
  8014c8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014c9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ce:	8b 40 48             	mov    0x48(%eax),%eax
  8014d1:	83 ec 04             	sub    $0x4,%esp
  8014d4:	53                   	push   %ebx
  8014d5:	50                   	push   %eax
  8014d6:	68 94 29 80 00       	push   $0x802994
  8014db:	e8 0c ed ff ff       	call   8001ec <cprintf>
		return -E_INVAL;
  8014e0:	83 c4 10             	add    $0x10,%esp
  8014e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014e8:	eb da                	jmp    8014c4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014ef:	eb d3                	jmp    8014c4 <ftruncate+0x52>

008014f1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	53                   	push   %ebx
  8014f5:	83 ec 1c             	sub    $0x1c,%esp
  8014f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fe:	50                   	push   %eax
  8014ff:	ff 75 08             	pushl  0x8(%ebp)
  801502:	e8 84 fb ff ff       	call   80108b <fd_lookup>
  801507:	83 c4 10             	add    $0x10,%esp
  80150a:	85 c0                	test   %eax,%eax
  80150c:	78 4b                	js     801559 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150e:	83 ec 08             	sub    $0x8,%esp
  801511:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801514:	50                   	push   %eax
  801515:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801518:	ff 30                	pushl  (%eax)
  80151a:	e8 bc fb ff ff       	call   8010db <dev_lookup>
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 33                	js     801559 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801529:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80152d:	74 2f                	je     80155e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80152f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801532:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801539:	00 00 00 
	stat->st_isdir = 0;
  80153c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801543:	00 00 00 
	stat->st_dev = dev;
  801546:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80154c:	83 ec 08             	sub    $0x8,%esp
  80154f:	53                   	push   %ebx
  801550:	ff 75 f0             	pushl  -0x10(%ebp)
  801553:	ff 50 14             	call   *0x14(%eax)
  801556:	83 c4 10             	add    $0x10,%esp
}
  801559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    
		return -E_NOT_SUPP;
  80155e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801563:	eb f4                	jmp    801559 <fstat+0x68>

00801565 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	56                   	push   %esi
  801569:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80156a:	83 ec 08             	sub    $0x8,%esp
  80156d:	6a 00                	push   $0x0
  80156f:	ff 75 08             	pushl  0x8(%ebp)
  801572:	e8 22 02 00 00       	call   801799 <open>
  801577:	89 c3                	mov    %eax,%ebx
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	85 c0                	test   %eax,%eax
  80157e:	78 1b                	js     80159b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801580:	83 ec 08             	sub    $0x8,%esp
  801583:	ff 75 0c             	pushl  0xc(%ebp)
  801586:	50                   	push   %eax
  801587:	e8 65 ff ff ff       	call   8014f1 <fstat>
  80158c:	89 c6                	mov    %eax,%esi
	close(fd);
  80158e:	89 1c 24             	mov    %ebx,(%esp)
  801591:	e8 27 fc ff ff       	call   8011bd <close>
	return r;
  801596:	83 c4 10             	add    $0x10,%esp
  801599:	89 f3                	mov    %esi,%ebx
}
  80159b:	89 d8                	mov    %ebx,%eax
  80159d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a0:	5b                   	pop    %ebx
  8015a1:	5e                   	pop    %esi
  8015a2:	5d                   	pop    %ebp
  8015a3:	c3                   	ret    

008015a4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
  8015a7:	56                   	push   %esi
  8015a8:	53                   	push   %ebx
  8015a9:	89 c6                	mov    %eax,%esi
  8015ab:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015ad:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b4:	74 27                	je     8015dd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015b6:	6a 07                	push   $0x7
  8015b8:	68 00 50 80 00       	push   $0x805000
  8015bd:	56                   	push   %esi
  8015be:	ff 35 00 40 80 00    	pushl  0x804000
  8015c4:	e8 69 0c 00 00       	call   802232 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015c9:	83 c4 0c             	add    $0xc,%esp
  8015cc:	6a 00                	push   $0x0
  8015ce:	53                   	push   %ebx
  8015cf:	6a 00                	push   $0x0
  8015d1:	e8 f3 0b 00 00       	call   8021c9 <ipc_recv>
}
  8015d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d9:	5b                   	pop    %ebx
  8015da:	5e                   	pop    %esi
  8015db:	5d                   	pop    %ebp
  8015dc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	6a 01                	push   $0x1
  8015e2:	e8 a3 0c 00 00       	call   80228a <ipc_find_env>
  8015e7:	a3 00 40 80 00       	mov    %eax,0x804000
  8015ec:	83 c4 10             	add    $0x10,%esp
  8015ef:	eb c5                	jmp    8015b6 <fsipc+0x12>

008015f1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015f1:	55                   	push   %ebp
  8015f2:	89 e5                	mov    %esp,%ebp
  8015f4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801602:	8b 45 0c             	mov    0xc(%ebp),%eax
  801605:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80160a:	ba 00 00 00 00       	mov    $0x0,%edx
  80160f:	b8 02 00 00 00       	mov    $0x2,%eax
  801614:	e8 8b ff ff ff       	call   8015a4 <fsipc>
}
  801619:	c9                   	leave  
  80161a:	c3                   	ret    

0080161b <devfile_flush>:
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8b 40 0c             	mov    0xc(%eax),%eax
  801627:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80162c:	ba 00 00 00 00       	mov    $0x0,%edx
  801631:	b8 06 00 00 00       	mov    $0x6,%eax
  801636:	e8 69 ff ff ff       	call   8015a4 <fsipc>
}
  80163b:	c9                   	leave  
  80163c:	c3                   	ret    

0080163d <devfile_stat>:
{
  80163d:	55                   	push   %ebp
  80163e:	89 e5                	mov    %esp,%ebp
  801640:	53                   	push   %ebx
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 40 0c             	mov    0xc(%eax),%eax
  80164d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801652:	ba 00 00 00 00       	mov    $0x0,%edx
  801657:	b8 05 00 00 00       	mov    $0x5,%eax
  80165c:	e8 43 ff ff ff       	call   8015a4 <fsipc>
  801661:	85 c0                	test   %eax,%eax
  801663:	78 2c                	js     801691 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801665:	83 ec 08             	sub    $0x8,%esp
  801668:	68 00 50 80 00       	push   $0x805000
  80166d:	53                   	push   %ebx
  80166e:	e8 d8 f2 ff ff       	call   80094b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801673:	a1 80 50 80 00       	mov    0x805080,%eax
  801678:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80167e:	a1 84 50 80 00       	mov    0x805084,%eax
  801683:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801689:	83 c4 10             	add    $0x10,%esp
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <devfile_write>:
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
  801699:	53                   	push   %ebx
  80169a:	83 ec 08             	sub    $0x8,%esp
  80169d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016ab:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016b1:	53                   	push   %ebx
  8016b2:	ff 75 0c             	pushl  0xc(%ebp)
  8016b5:	68 08 50 80 00       	push   $0x805008
  8016ba:	e8 7c f4 ff ff       	call   800b3b <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016c9:	e8 d6 fe ff ff       	call   8015a4 <fsipc>
  8016ce:	83 c4 10             	add    $0x10,%esp
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	78 0b                	js     8016e0 <devfile_write+0x4a>
	assert(r <= n);
  8016d5:	39 d8                	cmp    %ebx,%eax
  8016d7:	77 0c                	ja     8016e5 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016d9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016de:	7f 1e                	jg     8016fe <devfile_write+0x68>
}
  8016e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    
	assert(r <= n);
  8016e5:	68 04 2a 80 00       	push   $0x802a04
  8016ea:	68 0b 2a 80 00       	push   $0x802a0b
  8016ef:	68 98 00 00 00       	push   $0x98
  8016f4:	68 20 2a 80 00       	push   $0x802a20
  8016f9:	e8 6a 0a 00 00       	call   802168 <_panic>
	assert(r <= PGSIZE);
  8016fe:	68 2b 2a 80 00       	push   $0x802a2b
  801703:	68 0b 2a 80 00       	push   $0x802a0b
  801708:	68 99 00 00 00       	push   $0x99
  80170d:	68 20 2a 80 00       	push   $0x802a20
  801712:	e8 51 0a 00 00       	call   802168 <_panic>

00801717 <devfile_read>:
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	56                   	push   %esi
  80171b:	53                   	push   %ebx
  80171c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80171f:	8b 45 08             	mov    0x8(%ebp),%eax
  801722:	8b 40 0c             	mov    0xc(%eax),%eax
  801725:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80172a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801730:	ba 00 00 00 00       	mov    $0x0,%edx
  801735:	b8 03 00 00 00       	mov    $0x3,%eax
  80173a:	e8 65 fe ff ff       	call   8015a4 <fsipc>
  80173f:	89 c3                	mov    %eax,%ebx
  801741:	85 c0                	test   %eax,%eax
  801743:	78 1f                	js     801764 <devfile_read+0x4d>
	assert(r <= n);
  801745:	39 f0                	cmp    %esi,%eax
  801747:	77 24                	ja     80176d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801749:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80174e:	7f 33                	jg     801783 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	50                   	push   %eax
  801754:	68 00 50 80 00       	push   $0x805000
  801759:	ff 75 0c             	pushl  0xc(%ebp)
  80175c:	e8 78 f3 ff ff       	call   800ad9 <memmove>
	return r;
  801761:	83 c4 10             	add    $0x10,%esp
}
  801764:	89 d8                	mov    %ebx,%eax
  801766:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801769:	5b                   	pop    %ebx
  80176a:	5e                   	pop    %esi
  80176b:	5d                   	pop    %ebp
  80176c:	c3                   	ret    
	assert(r <= n);
  80176d:	68 04 2a 80 00       	push   $0x802a04
  801772:	68 0b 2a 80 00       	push   $0x802a0b
  801777:	6a 7c                	push   $0x7c
  801779:	68 20 2a 80 00       	push   $0x802a20
  80177e:	e8 e5 09 00 00       	call   802168 <_panic>
	assert(r <= PGSIZE);
  801783:	68 2b 2a 80 00       	push   $0x802a2b
  801788:	68 0b 2a 80 00       	push   $0x802a0b
  80178d:	6a 7d                	push   $0x7d
  80178f:	68 20 2a 80 00       	push   $0x802a20
  801794:	e8 cf 09 00 00       	call   802168 <_panic>

00801799 <open>:
{
  801799:	55                   	push   %ebp
  80179a:	89 e5                	mov    %esp,%ebp
  80179c:	56                   	push   %esi
  80179d:	53                   	push   %ebx
  80179e:	83 ec 1c             	sub    $0x1c,%esp
  8017a1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017a4:	56                   	push   %esi
  8017a5:	e8 68 f1 ff ff       	call   800912 <strlen>
  8017aa:	83 c4 10             	add    $0x10,%esp
  8017ad:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017b2:	7f 6c                	jg     801820 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017b4:	83 ec 0c             	sub    $0xc,%esp
  8017b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ba:	50                   	push   %eax
  8017bb:	e8 79 f8 ff ff       	call   801039 <fd_alloc>
  8017c0:	89 c3                	mov    %eax,%ebx
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 3c                	js     801805 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	56                   	push   %esi
  8017cd:	68 00 50 80 00       	push   $0x805000
  8017d2:	e8 74 f1 ff ff       	call   80094b <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017da:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017df:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e2:	b8 01 00 00 00       	mov    $0x1,%eax
  8017e7:	e8 b8 fd ff ff       	call   8015a4 <fsipc>
  8017ec:	89 c3                	mov    %eax,%ebx
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	78 19                	js     80180e <open+0x75>
	return fd2num(fd);
  8017f5:	83 ec 0c             	sub    $0xc,%esp
  8017f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fb:	e8 12 f8 ff ff       	call   801012 <fd2num>
  801800:	89 c3                	mov    %eax,%ebx
  801802:	83 c4 10             	add    $0x10,%esp
}
  801805:	89 d8                	mov    %ebx,%eax
  801807:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5d                   	pop    %ebp
  80180d:	c3                   	ret    
		fd_close(fd, 0);
  80180e:	83 ec 08             	sub    $0x8,%esp
  801811:	6a 00                	push   $0x0
  801813:	ff 75 f4             	pushl  -0xc(%ebp)
  801816:	e8 1b f9 ff ff       	call   801136 <fd_close>
		return r;
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	eb e5                	jmp    801805 <open+0x6c>
		return -E_BAD_PATH;
  801820:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801825:	eb de                	jmp    801805 <open+0x6c>

00801827 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801827:	55                   	push   %ebp
  801828:	89 e5                	mov    %esp,%ebp
  80182a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80182d:	ba 00 00 00 00       	mov    $0x0,%edx
  801832:	b8 08 00 00 00       	mov    $0x8,%eax
  801837:	e8 68 fd ff ff       	call   8015a4 <fsipc>
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801844:	68 37 2a 80 00       	push   $0x802a37
  801849:	ff 75 0c             	pushl  0xc(%ebp)
  80184c:	e8 fa f0 ff ff       	call   80094b <strcpy>
	return 0;
}
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <devsock_close>:
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	53                   	push   %ebx
  80185c:	83 ec 10             	sub    $0x10,%esp
  80185f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801862:	53                   	push   %ebx
  801863:	e8 5d 0a 00 00       	call   8022c5 <pageref>
  801868:	83 c4 10             	add    $0x10,%esp
		return 0;
  80186b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801870:	83 f8 01             	cmp    $0x1,%eax
  801873:	74 07                	je     80187c <devsock_close+0x24>
}
  801875:	89 d0                	mov    %edx,%eax
  801877:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  80187c:	83 ec 0c             	sub    $0xc,%esp
  80187f:	ff 73 0c             	pushl  0xc(%ebx)
  801882:	e8 b9 02 00 00       	call   801b40 <nsipc_close>
  801887:	89 c2                	mov    %eax,%edx
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	eb e7                	jmp    801875 <devsock_close+0x1d>

0080188e <devsock_write>:
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801894:	6a 00                	push   $0x0
  801896:	ff 75 10             	pushl  0x10(%ebp)
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	8b 45 08             	mov    0x8(%ebp),%eax
  80189f:	ff 70 0c             	pushl  0xc(%eax)
  8018a2:	e8 76 03 00 00       	call   801c1d <nsipc_send>
}
  8018a7:	c9                   	leave  
  8018a8:	c3                   	ret    

008018a9 <devsock_read>:
{
  8018a9:	55                   	push   %ebp
  8018aa:	89 e5                	mov    %esp,%ebp
  8018ac:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018af:	6a 00                	push   $0x0
  8018b1:	ff 75 10             	pushl  0x10(%ebp)
  8018b4:	ff 75 0c             	pushl  0xc(%ebp)
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	ff 70 0c             	pushl  0xc(%eax)
  8018bd:	e8 ef 02 00 00       	call   801bb1 <nsipc_recv>
}
  8018c2:	c9                   	leave  
  8018c3:	c3                   	ret    

008018c4 <fd2sockid>:
{
  8018c4:	55                   	push   %ebp
  8018c5:	89 e5                	mov    %esp,%ebp
  8018c7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ca:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018cd:	52                   	push   %edx
  8018ce:	50                   	push   %eax
  8018cf:	e8 b7 f7 ff ff       	call   80108b <fd_lookup>
  8018d4:	83 c4 10             	add    $0x10,%esp
  8018d7:	85 c0                	test   %eax,%eax
  8018d9:	78 10                	js     8018eb <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018de:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018e4:	39 08                	cmp    %ecx,(%eax)
  8018e6:	75 05                	jne    8018ed <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018e8:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018eb:	c9                   	leave  
  8018ec:	c3                   	ret    
		return -E_NOT_SUPP;
  8018ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f2:	eb f7                	jmp    8018eb <fd2sockid+0x27>

008018f4 <alloc_sockfd>:
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	56                   	push   %esi
  8018f8:	53                   	push   %ebx
  8018f9:	83 ec 1c             	sub    $0x1c,%esp
  8018fc:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801901:	50                   	push   %eax
  801902:	e8 32 f7 ff ff       	call   801039 <fd_alloc>
  801907:	89 c3                	mov    %eax,%ebx
  801909:	83 c4 10             	add    $0x10,%esp
  80190c:	85 c0                	test   %eax,%eax
  80190e:	78 43                	js     801953 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801910:	83 ec 04             	sub    $0x4,%esp
  801913:	68 07 04 00 00       	push   $0x407
  801918:	ff 75 f4             	pushl  -0xc(%ebp)
  80191b:	6a 00                	push   $0x0
  80191d:	e8 1b f4 ff ff       	call   800d3d <sys_page_alloc>
  801922:	89 c3                	mov    %eax,%ebx
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	85 c0                	test   %eax,%eax
  801929:	78 28                	js     801953 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801934:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801936:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801939:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801940:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801943:	83 ec 0c             	sub    $0xc,%esp
  801946:	50                   	push   %eax
  801947:	e8 c6 f6 ff ff       	call   801012 <fd2num>
  80194c:	89 c3                	mov    %eax,%ebx
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	eb 0c                	jmp    80195f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801953:	83 ec 0c             	sub    $0xc,%esp
  801956:	56                   	push   %esi
  801957:	e8 e4 01 00 00       	call   801b40 <nsipc_close>
		return r;
  80195c:	83 c4 10             	add    $0x10,%esp
}
  80195f:	89 d8                	mov    %ebx,%eax
  801961:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801964:	5b                   	pop    %ebx
  801965:	5e                   	pop    %esi
  801966:	5d                   	pop    %ebp
  801967:	c3                   	ret    

00801968 <accept>:
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	e8 4e ff ff ff       	call   8018c4 <fd2sockid>
  801976:	85 c0                	test   %eax,%eax
  801978:	78 1b                	js     801995 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80197a:	83 ec 04             	sub    $0x4,%esp
  80197d:	ff 75 10             	pushl  0x10(%ebp)
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	50                   	push   %eax
  801984:	e8 0e 01 00 00       	call   801a97 <nsipc_accept>
  801989:	83 c4 10             	add    $0x10,%esp
  80198c:	85 c0                	test   %eax,%eax
  80198e:	78 05                	js     801995 <accept+0x2d>
	return alloc_sockfd(r);
  801990:	e8 5f ff ff ff       	call   8018f4 <alloc_sockfd>
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <bind>:
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80199d:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a0:	e8 1f ff ff ff       	call   8018c4 <fd2sockid>
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	78 12                	js     8019bb <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019a9:	83 ec 04             	sub    $0x4,%esp
  8019ac:	ff 75 10             	pushl  0x10(%ebp)
  8019af:	ff 75 0c             	pushl  0xc(%ebp)
  8019b2:	50                   	push   %eax
  8019b3:	e8 31 01 00 00       	call   801ae9 <nsipc_bind>
  8019b8:	83 c4 10             	add    $0x10,%esp
}
  8019bb:	c9                   	leave  
  8019bc:	c3                   	ret    

008019bd <shutdown>:
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	e8 f9 fe ff ff       	call   8018c4 <fd2sockid>
  8019cb:	85 c0                	test   %eax,%eax
  8019cd:	78 0f                	js     8019de <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019cf:	83 ec 08             	sub    $0x8,%esp
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	50                   	push   %eax
  8019d6:	e8 43 01 00 00       	call   801b1e <nsipc_shutdown>
  8019db:	83 c4 10             	add    $0x10,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <connect>:
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	e8 d6 fe ff ff       	call   8018c4 <fd2sockid>
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 12                	js     801a04 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	ff 75 10             	pushl  0x10(%ebp)
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	50                   	push   %eax
  8019fc:	e8 59 01 00 00       	call   801b5a <nsipc_connect>
  801a01:	83 c4 10             	add    $0x10,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <listen>:
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	e8 b0 fe ff ff       	call   8018c4 <fd2sockid>
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 0f                	js     801a27 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	50                   	push   %eax
  801a1f:	e8 6b 01 00 00       	call   801b8f <nsipc_listen>
  801a24:	83 c4 10             	add    $0x10,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a2f:	ff 75 10             	pushl  0x10(%ebp)
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	ff 75 08             	pushl  0x8(%ebp)
  801a38:	e8 3e 02 00 00       	call   801c7b <nsipc_socket>
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 05                	js     801a49 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a44:	e8 ab fe ff ff       	call   8018f4 <alloc_sockfd>
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	53                   	push   %ebx
  801a4f:	83 ec 04             	sub    $0x4,%esp
  801a52:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a54:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a5b:	74 26                	je     801a83 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a5d:	6a 07                	push   $0x7
  801a5f:	68 00 60 80 00       	push   $0x806000
  801a64:	53                   	push   %ebx
  801a65:	ff 35 04 40 80 00    	pushl  0x804004
  801a6b:	e8 c2 07 00 00       	call   802232 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a70:	83 c4 0c             	add    $0xc,%esp
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	e8 4b 07 00 00       	call   8021c9 <ipc_recv>
}
  801a7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a83:	83 ec 0c             	sub    $0xc,%esp
  801a86:	6a 02                	push   $0x2
  801a88:	e8 fd 07 00 00       	call   80228a <ipc_find_env>
  801a8d:	a3 04 40 80 00       	mov    %eax,0x804004
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	eb c6                	jmp    801a5d <nsipc+0x12>

00801a97 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
  801a9a:	56                   	push   %esi
  801a9b:	53                   	push   %ebx
  801a9c:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801aa7:	8b 06                	mov    (%esi),%eax
  801aa9:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801aae:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab3:	e8 93 ff ff ff       	call   801a4b <nsipc>
  801ab8:	89 c3                	mov    %eax,%ebx
  801aba:	85 c0                	test   %eax,%eax
  801abc:	79 09                	jns    801ac7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801abe:	89 d8                	mov    %ebx,%eax
  801ac0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac3:	5b                   	pop    %ebx
  801ac4:	5e                   	pop    %esi
  801ac5:	5d                   	pop    %ebp
  801ac6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801ac7:	83 ec 04             	sub    $0x4,%esp
  801aca:	ff 35 10 60 80 00    	pushl  0x806010
  801ad0:	68 00 60 80 00       	push   $0x806000
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	e8 fc ef ff ff       	call   800ad9 <memmove>
		*addrlen = ret->ret_addrlen;
  801add:	a1 10 60 80 00       	mov    0x806010,%eax
  801ae2:	89 06                	mov    %eax,(%esi)
  801ae4:	83 c4 10             	add    $0x10,%esp
	return r;
  801ae7:	eb d5                	jmp    801abe <nsipc_accept+0x27>

00801ae9 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	53                   	push   %ebx
  801aed:	83 ec 08             	sub    $0x8,%esp
  801af0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801afb:	53                   	push   %ebx
  801afc:	ff 75 0c             	pushl  0xc(%ebp)
  801aff:	68 04 60 80 00       	push   $0x806004
  801b04:	e8 d0 ef ff ff       	call   800ad9 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b09:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b0f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b14:	e8 32 ff ff ff       	call   801a4b <nsipc>
}
  801b19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b24:	8b 45 08             	mov    0x8(%ebp),%eax
  801b27:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b2f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b34:	b8 03 00 00 00       	mov    $0x3,%eax
  801b39:	e8 0d ff ff ff       	call   801a4b <nsipc>
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <nsipc_close>:

int
nsipc_close(int s)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b4e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b53:	e8 f3 fe ff ff       	call   801a4b <nsipc>
}
  801b58:	c9                   	leave  
  801b59:	c3                   	ret    

00801b5a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b5a:	55                   	push   %ebp
  801b5b:	89 e5                	mov    %esp,%ebp
  801b5d:	53                   	push   %ebx
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b6c:	53                   	push   %ebx
  801b6d:	ff 75 0c             	pushl  0xc(%ebp)
  801b70:	68 04 60 80 00       	push   $0x806004
  801b75:	e8 5f ef ff ff       	call   800ad9 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b7a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b80:	b8 05 00 00 00       	mov    $0x5,%eax
  801b85:	e8 c1 fe ff ff       	call   801a4b <nsipc>
}
  801b8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8d:	c9                   	leave  
  801b8e:	c3                   	ret    

00801b8f <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
  801b92:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b95:	8b 45 08             	mov    0x8(%ebp),%eax
  801b98:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ba5:	b8 06 00 00 00       	mov    $0x6,%eax
  801baa:	e8 9c fe ff ff       	call   801a4b <nsipc>
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
  801bb4:	56                   	push   %esi
  801bb5:	53                   	push   %ebx
  801bb6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bc1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bc7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bca:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bcf:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd4:	e8 72 fe ff ff       	call   801a4b <nsipc>
  801bd9:	89 c3                	mov    %eax,%ebx
  801bdb:	85 c0                	test   %eax,%eax
  801bdd:	78 1f                	js     801bfe <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801bdf:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801be4:	7f 21                	jg     801c07 <nsipc_recv+0x56>
  801be6:	39 c6                	cmp    %eax,%esi
  801be8:	7c 1d                	jl     801c07 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bea:	83 ec 04             	sub    $0x4,%esp
  801bed:	50                   	push   %eax
  801bee:	68 00 60 80 00       	push   $0x806000
  801bf3:	ff 75 0c             	pushl  0xc(%ebp)
  801bf6:	e8 de ee ff ff       	call   800ad9 <memmove>
  801bfb:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801bfe:	89 d8                	mov    %ebx,%eax
  801c00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c07:	68 43 2a 80 00       	push   $0x802a43
  801c0c:	68 0b 2a 80 00       	push   $0x802a0b
  801c11:	6a 62                	push   $0x62
  801c13:	68 58 2a 80 00       	push   $0x802a58
  801c18:	e8 4b 05 00 00       	call   802168 <_panic>

00801c1d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	53                   	push   %ebx
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c27:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c2f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c35:	7f 2e                	jg     801c65 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c37:	83 ec 04             	sub    $0x4,%esp
  801c3a:	53                   	push   %ebx
  801c3b:	ff 75 0c             	pushl  0xc(%ebp)
  801c3e:	68 0c 60 80 00       	push   $0x80600c
  801c43:	e8 91 ee ff ff       	call   800ad9 <memmove>
	nsipcbuf.send.req_size = size;
  801c48:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c51:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c56:	b8 08 00 00 00       	mov    $0x8,%eax
  801c5b:	e8 eb fd ff ff       	call   801a4b <nsipc>
}
  801c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    
	assert(size < 1600);
  801c65:	68 64 2a 80 00       	push   $0x802a64
  801c6a:	68 0b 2a 80 00       	push   $0x802a0b
  801c6f:	6a 6d                	push   $0x6d
  801c71:	68 58 2a 80 00       	push   $0x802a58
  801c76:	e8 ed 04 00 00       	call   802168 <_panic>

00801c7b <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
  801c7e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c89:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c8c:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c91:	8b 45 10             	mov    0x10(%ebp),%eax
  801c94:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c99:	b8 09 00 00 00       	mov    $0x9,%eax
  801c9e:	e8 a8 fd ff ff       	call   801a4b <nsipc>
}
  801ca3:	c9                   	leave  
  801ca4:	c3                   	ret    

00801ca5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	56                   	push   %esi
  801ca9:	53                   	push   %ebx
  801caa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	ff 75 08             	pushl  0x8(%ebp)
  801cb3:	e8 6a f3 ff ff       	call   801022 <fd2data>
  801cb8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cba:	83 c4 08             	add    $0x8,%esp
  801cbd:	68 70 2a 80 00       	push   $0x802a70
  801cc2:	53                   	push   %ebx
  801cc3:	e8 83 ec ff ff       	call   80094b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cc8:	8b 46 04             	mov    0x4(%esi),%eax
  801ccb:	2b 06                	sub    (%esi),%eax
  801ccd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cd3:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cda:	00 00 00 
	stat->st_dev = &devpipe;
  801cdd:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ce4:	30 80 00 
	return 0;
}
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	53                   	push   %ebx
  801cf7:	83 ec 0c             	sub    $0xc,%esp
  801cfa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801cfd:	53                   	push   %ebx
  801cfe:	6a 00                	push   $0x0
  801d00:	e8 bd f0 ff ff       	call   800dc2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d05:	89 1c 24             	mov    %ebx,(%esp)
  801d08:	e8 15 f3 ff ff       	call   801022 <fd2data>
  801d0d:	83 c4 08             	add    $0x8,%esp
  801d10:	50                   	push   %eax
  801d11:	6a 00                	push   $0x0
  801d13:	e8 aa f0 ff ff       	call   800dc2 <sys_page_unmap>
}
  801d18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <_pipeisclosed>:
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	57                   	push   %edi
  801d21:	56                   	push   %esi
  801d22:	53                   	push   %ebx
  801d23:	83 ec 1c             	sub    $0x1c,%esp
  801d26:	89 c7                	mov    %eax,%edi
  801d28:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d2a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d2f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d32:	83 ec 0c             	sub    $0xc,%esp
  801d35:	57                   	push   %edi
  801d36:	e8 8a 05 00 00       	call   8022c5 <pageref>
  801d3b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d3e:	89 34 24             	mov    %esi,(%esp)
  801d41:	e8 7f 05 00 00       	call   8022c5 <pageref>
		nn = thisenv->env_runs;
  801d46:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d4c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d4f:	83 c4 10             	add    $0x10,%esp
  801d52:	39 cb                	cmp    %ecx,%ebx
  801d54:	74 1b                	je     801d71 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d56:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d59:	75 cf                	jne    801d2a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d5b:	8b 42 58             	mov    0x58(%edx),%eax
  801d5e:	6a 01                	push   $0x1
  801d60:	50                   	push   %eax
  801d61:	53                   	push   %ebx
  801d62:	68 77 2a 80 00       	push   $0x802a77
  801d67:	e8 80 e4 ff ff       	call   8001ec <cprintf>
  801d6c:	83 c4 10             	add    $0x10,%esp
  801d6f:	eb b9                	jmp    801d2a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d71:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d74:	0f 94 c0             	sete   %al
  801d77:	0f b6 c0             	movzbl %al,%eax
}
  801d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d7d:	5b                   	pop    %ebx
  801d7e:	5e                   	pop    %esi
  801d7f:	5f                   	pop    %edi
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    

00801d82 <devpipe_write>:
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	57                   	push   %edi
  801d86:	56                   	push   %esi
  801d87:	53                   	push   %ebx
  801d88:	83 ec 28             	sub    $0x28,%esp
  801d8b:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d8e:	56                   	push   %esi
  801d8f:	e8 8e f2 ff ff       	call   801022 <fd2data>
  801d94:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	bf 00 00 00 00       	mov    $0x0,%edi
  801d9e:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801da1:	74 4f                	je     801df2 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801da3:	8b 43 04             	mov    0x4(%ebx),%eax
  801da6:	8b 0b                	mov    (%ebx),%ecx
  801da8:	8d 51 20             	lea    0x20(%ecx),%edx
  801dab:	39 d0                	cmp    %edx,%eax
  801dad:	72 14                	jb     801dc3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801daf:	89 da                	mov    %ebx,%edx
  801db1:	89 f0                	mov    %esi,%eax
  801db3:	e8 65 ff ff ff       	call   801d1d <_pipeisclosed>
  801db8:	85 c0                	test   %eax,%eax
  801dba:	75 3b                	jne    801df7 <devpipe_write+0x75>
			sys_yield();
  801dbc:	e8 5d ef ff ff       	call   800d1e <sys_yield>
  801dc1:	eb e0                	jmp    801da3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dc6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dca:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dcd:	89 c2                	mov    %eax,%edx
  801dcf:	c1 fa 1f             	sar    $0x1f,%edx
  801dd2:	89 d1                	mov    %edx,%ecx
  801dd4:	c1 e9 1b             	shr    $0x1b,%ecx
  801dd7:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dda:	83 e2 1f             	and    $0x1f,%edx
  801ddd:	29 ca                	sub    %ecx,%edx
  801ddf:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801de3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801de7:	83 c0 01             	add    $0x1,%eax
  801dea:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ded:	83 c7 01             	add    $0x1,%edi
  801df0:	eb ac                	jmp    801d9e <devpipe_write+0x1c>
	return i;
  801df2:	8b 45 10             	mov    0x10(%ebp),%eax
  801df5:	eb 05                	jmp    801dfc <devpipe_write+0x7a>
				return 0;
  801df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5f                   	pop    %edi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    

00801e04 <devpipe_read>:
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
  801e07:	57                   	push   %edi
  801e08:	56                   	push   %esi
  801e09:	53                   	push   %ebx
  801e0a:	83 ec 18             	sub    $0x18,%esp
  801e0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e10:	57                   	push   %edi
  801e11:	e8 0c f2 ff ff       	call   801022 <fd2data>
  801e16:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e18:	83 c4 10             	add    $0x10,%esp
  801e1b:	be 00 00 00 00       	mov    $0x0,%esi
  801e20:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e23:	75 14                	jne    801e39 <devpipe_read+0x35>
	return i;
  801e25:	8b 45 10             	mov    0x10(%ebp),%eax
  801e28:	eb 02                	jmp    801e2c <devpipe_read+0x28>
				return i;
  801e2a:	89 f0                	mov    %esi,%eax
}
  801e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    
			sys_yield();
  801e34:	e8 e5 ee ff ff       	call   800d1e <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e39:	8b 03                	mov    (%ebx),%eax
  801e3b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e3e:	75 18                	jne    801e58 <devpipe_read+0x54>
			if (i > 0)
  801e40:	85 f6                	test   %esi,%esi
  801e42:	75 e6                	jne    801e2a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e44:	89 da                	mov    %ebx,%edx
  801e46:	89 f8                	mov    %edi,%eax
  801e48:	e8 d0 fe ff ff       	call   801d1d <_pipeisclosed>
  801e4d:	85 c0                	test   %eax,%eax
  801e4f:	74 e3                	je     801e34 <devpipe_read+0x30>
				return 0;
  801e51:	b8 00 00 00 00       	mov    $0x0,%eax
  801e56:	eb d4                	jmp    801e2c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e58:	99                   	cltd   
  801e59:	c1 ea 1b             	shr    $0x1b,%edx
  801e5c:	01 d0                	add    %edx,%eax
  801e5e:	83 e0 1f             	and    $0x1f,%eax
  801e61:	29 d0                	sub    %edx,%eax
  801e63:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e6b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e6e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e71:	83 c6 01             	add    $0x1,%esi
  801e74:	eb aa                	jmp    801e20 <devpipe_read+0x1c>

00801e76 <pipe>:
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
  801e79:	56                   	push   %esi
  801e7a:	53                   	push   %ebx
  801e7b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e81:	50                   	push   %eax
  801e82:	e8 b2 f1 ff ff       	call   801039 <fd_alloc>
  801e87:	89 c3                	mov    %eax,%ebx
  801e89:	83 c4 10             	add    $0x10,%esp
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	0f 88 23 01 00 00    	js     801fb7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e94:	83 ec 04             	sub    $0x4,%esp
  801e97:	68 07 04 00 00       	push   $0x407
  801e9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9f:	6a 00                	push   $0x0
  801ea1:	e8 97 ee ff ff       	call   800d3d <sys_page_alloc>
  801ea6:	89 c3                	mov    %eax,%ebx
  801ea8:	83 c4 10             	add    $0x10,%esp
  801eab:	85 c0                	test   %eax,%eax
  801ead:	0f 88 04 01 00 00    	js     801fb7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801eb3:	83 ec 0c             	sub    $0xc,%esp
  801eb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eb9:	50                   	push   %eax
  801eba:	e8 7a f1 ff ff       	call   801039 <fd_alloc>
  801ebf:	89 c3                	mov    %eax,%ebx
  801ec1:	83 c4 10             	add    $0x10,%esp
  801ec4:	85 c0                	test   %eax,%eax
  801ec6:	0f 88 db 00 00 00    	js     801fa7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ecc:	83 ec 04             	sub    $0x4,%esp
  801ecf:	68 07 04 00 00       	push   $0x407
  801ed4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ed7:	6a 00                	push   $0x0
  801ed9:	e8 5f ee ff ff       	call   800d3d <sys_page_alloc>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	83 c4 10             	add    $0x10,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	0f 88 bc 00 00 00    	js     801fa7 <pipe+0x131>
	va = fd2data(fd0);
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef1:	e8 2c f1 ff ff       	call   801022 <fd2data>
  801ef6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef8:	83 c4 0c             	add    $0xc,%esp
  801efb:	68 07 04 00 00       	push   $0x407
  801f00:	50                   	push   %eax
  801f01:	6a 00                	push   $0x0
  801f03:	e8 35 ee ff ff       	call   800d3d <sys_page_alloc>
  801f08:	89 c3                	mov    %eax,%ebx
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	0f 88 82 00 00 00    	js     801f97 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f15:	83 ec 0c             	sub    $0xc,%esp
  801f18:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1b:	e8 02 f1 ff ff       	call   801022 <fd2data>
  801f20:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f27:	50                   	push   %eax
  801f28:	6a 00                	push   $0x0
  801f2a:	56                   	push   %esi
  801f2b:	6a 00                	push   $0x0
  801f2d:	e8 4e ee ff ff       	call   800d80 <sys_page_map>
  801f32:	89 c3                	mov    %eax,%ebx
  801f34:	83 c4 20             	add    $0x20,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	78 4e                	js     801f89 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f3b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f43:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f48:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f4f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f52:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f57:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f5e:	83 ec 0c             	sub    $0xc,%esp
  801f61:	ff 75 f4             	pushl  -0xc(%ebp)
  801f64:	e8 a9 f0 ff ff       	call   801012 <fd2num>
  801f69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f6c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f6e:	83 c4 04             	add    $0x4,%esp
  801f71:	ff 75 f0             	pushl  -0x10(%ebp)
  801f74:	e8 99 f0 ff ff       	call   801012 <fd2num>
  801f79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f7c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f7f:	83 c4 10             	add    $0x10,%esp
  801f82:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f87:	eb 2e                	jmp    801fb7 <pipe+0x141>
	sys_page_unmap(0, va);
  801f89:	83 ec 08             	sub    $0x8,%esp
  801f8c:	56                   	push   %esi
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 2e ee ff ff       	call   800dc2 <sys_page_unmap>
  801f94:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f97:	83 ec 08             	sub    $0x8,%esp
  801f9a:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9d:	6a 00                	push   $0x0
  801f9f:	e8 1e ee ff ff       	call   800dc2 <sys_page_unmap>
  801fa4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fa7:	83 ec 08             	sub    $0x8,%esp
  801faa:	ff 75 f4             	pushl  -0xc(%ebp)
  801fad:	6a 00                	push   $0x0
  801faf:	e8 0e ee ff ff       	call   800dc2 <sys_page_unmap>
  801fb4:	83 c4 10             	add    $0x10,%esp
}
  801fb7:	89 d8                	mov    %ebx,%eax
  801fb9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fbc:	5b                   	pop    %ebx
  801fbd:	5e                   	pop    %esi
  801fbe:	5d                   	pop    %ebp
  801fbf:	c3                   	ret    

00801fc0 <pipeisclosed>:
{
  801fc0:	55                   	push   %ebp
  801fc1:	89 e5                	mov    %esp,%ebp
  801fc3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fc9:	50                   	push   %eax
  801fca:	ff 75 08             	pushl  0x8(%ebp)
  801fcd:	e8 b9 f0 ff ff       	call   80108b <fd_lookup>
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	85 c0                	test   %eax,%eax
  801fd7:	78 18                	js     801ff1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fd9:	83 ec 0c             	sub    $0xc,%esp
  801fdc:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdf:	e8 3e f0 ff ff       	call   801022 <fd2data>
	return _pipeisclosed(fd, p);
  801fe4:	89 c2                	mov    %eax,%edx
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	e8 2f fd ff ff       	call   801d1d <_pipeisclosed>
  801fee:	83 c4 10             	add    $0x10,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ff3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff8:	c3                   	ret    

00801ff9 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ff9:	55                   	push   %ebp
  801ffa:	89 e5                	mov    %esp,%ebp
  801ffc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fff:	68 8f 2a 80 00       	push   $0x802a8f
  802004:	ff 75 0c             	pushl  0xc(%ebp)
  802007:	e8 3f e9 ff ff       	call   80094b <strcpy>
	return 0;
}
  80200c:	b8 00 00 00 00       	mov    $0x0,%eax
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <devcons_write>:
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	57                   	push   %edi
  802017:	56                   	push   %esi
  802018:	53                   	push   %ebx
  802019:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80201f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802024:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80202a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80202d:	73 31                	jae    802060 <devcons_write+0x4d>
		m = n - tot;
  80202f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802032:	29 f3                	sub    %esi,%ebx
  802034:	83 fb 7f             	cmp    $0x7f,%ebx
  802037:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80203c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80203f:	83 ec 04             	sub    $0x4,%esp
  802042:	53                   	push   %ebx
  802043:	89 f0                	mov    %esi,%eax
  802045:	03 45 0c             	add    0xc(%ebp),%eax
  802048:	50                   	push   %eax
  802049:	57                   	push   %edi
  80204a:	e8 8a ea ff ff       	call   800ad9 <memmove>
		sys_cputs(buf, m);
  80204f:	83 c4 08             	add    $0x8,%esp
  802052:	53                   	push   %ebx
  802053:	57                   	push   %edi
  802054:	e8 28 ec ff ff       	call   800c81 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802059:	01 de                	add    %ebx,%esi
  80205b:	83 c4 10             	add    $0x10,%esp
  80205e:	eb ca                	jmp    80202a <devcons_write+0x17>
}
  802060:	89 f0                	mov    %esi,%eax
  802062:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802065:	5b                   	pop    %ebx
  802066:	5e                   	pop    %esi
  802067:	5f                   	pop    %edi
  802068:	5d                   	pop    %ebp
  802069:	c3                   	ret    

0080206a <devcons_read>:
{
  80206a:	55                   	push   %ebp
  80206b:	89 e5                	mov    %esp,%ebp
  80206d:	83 ec 08             	sub    $0x8,%esp
  802070:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802075:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802079:	74 21                	je     80209c <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80207b:	e8 1f ec ff ff       	call   800c9f <sys_cgetc>
  802080:	85 c0                	test   %eax,%eax
  802082:	75 07                	jne    80208b <devcons_read+0x21>
		sys_yield();
  802084:	e8 95 ec ff ff       	call   800d1e <sys_yield>
  802089:	eb f0                	jmp    80207b <devcons_read+0x11>
	if (c < 0)
  80208b:	78 0f                	js     80209c <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  80208d:	83 f8 04             	cmp    $0x4,%eax
  802090:	74 0c                	je     80209e <devcons_read+0x34>
	*(char*)vbuf = c;
  802092:	8b 55 0c             	mov    0xc(%ebp),%edx
  802095:	88 02                	mov    %al,(%edx)
	return 1;
  802097:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80209c:	c9                   	leave  
  80209d:	c3                   	ret    
		return 0;
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a3:	eb f7                	jmp    80209c <devcons_read+0x32>

008020a5 <cputchar>:
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ae:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020b1:	6a 01                	push   $0x1
  8020b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020b6:	50                   	push   %eax
  8020b7:	e8 c5 eb ff ff       	call   800c81 <sys_cputs>
}
  8020bc:	83 c4 10             	add    $0x10,%esp
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <getchar>:
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020c7:	6a 01                	push   $0x1
  8020c9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020cc:	50                   	push   %eax
  8020cd:	6a 00                	push   $0x0
  8020cf:	e8 27 f2 ff ff       	call   8012fb <read>
	if (r < 0)
  8020d4:	83 c4 10             	add    $0x10,%esp
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	78 06                	js     8020e1 <getchar+0x20>
	if (r < 1)
  8020db:	74 06                	je     8020e3 <getchar+0x22>
	return c;
  8020dd:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    
		return -E_EOF;
  8020e3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020e8:	eb f7                	jmp    8020e1 <getchar+0x20>

008020ea <iscons>:
{
  8020ea:	55                   	push   %ebp
  8020eb:	89 e5                	mov    %esp,%ebp
  8020ed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f3:	50                   	push   %eax
  8020f4:	ff 75 08             	pushl  0x8(%ebp)
  8020f7:	e8 8f ef ff ff       	call   80108b <fd_lookup>
  8020fc:	83 c4 10             	add    $0x10,%esp
  8020ff:	85 c0                	test   %eax,%eax
  802101:	78 11                	js     802114 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802103:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802106:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80210c:	39 10                	cmp    %edx,(%eax)
  80210e:	0f 94 c0             	sete   %al
  802111:	0f b6 c0             	movzbl %al,%eax
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <opencons>:
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80211c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80211f:	50                   	push   %eax
  802120:	e8 14 ef ff ff       	call   801039 <fd_alloc>
  802125:	83 c4 10             	add    $0x10,%esp
  802128:	85 c0                	test   %eax,%eax
  80212a:	78 3a                	js     802166 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80212c:	83 ec 04             	sub    $0x4,%esp
  80212f:	68 07 04 00 00       	push   $0x407
  802134:	ff 75 f4             	pushl  -0xc(%ebp)
  802137:	6a 00                	push   $0x0
  802139:	e8 ff eb ff ff       	call   800d3d <sys_page_alloc>
  80213e:	83 c4 10             	add    $0x10,%esp
  802141:	85 c0                	test   %eax,%eax
  802143:	78 21                	js     802166 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802145:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802148:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80214e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80215a:	83 ec 0c             	sub    $0xc,%esp
  80215d:	50                   	push   %eax
  80215e:	e8 af ee ff ff       	call   801012 <fd2num>
  802163:	83 c4 10             	add    $0x10,%esp
}
  802166:	c9                   	leave  
  802167:	c3                   	ret    

00802168 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802168:	55                   	push   %ebp
  802169:	89 e5                	mov    %esp,%ebp
  80216b:	56                   	push   %esi
  80216c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80216d:	a1 08 40 80 00       	mov    0x804008,%eax
  802172:	8b 40 48             	mov    0x48(%eax),%eax
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	68 c0 2a 80 00       	push   $0x802ac0
  80217d:	50                   	push   %eax
  80217e:	68 b8 25 80 00       	push   $0x8025b8
  802183:	e8 64 e0 ff ff       	call   8001ec <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802188:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80218b:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802191:	e8 69 eb ff ff       	call   800cff <sys_getenvid>
  802196:	83 c4 04             	add    $0x4,%esp
  802199:	ff 75 0c             	pushl  0xc(%ebp)
  80219c:	ff 75 08             	pushl  0x8(%ebp)
  80219f:	56                   	push   %esi
  8021a0:	50                   	push   %eax
  8021a1:	68 9c 2a 80 00       	push   $0x802a9c
  8021a6:	e8 41 e0 ff ff       	call   8001ec <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021ab:	83 c4 18             	add    $0x18,%esp
  8021ae:	53                   	push   %ebx
  8021af:	ff 75 10             	pushl  0x10(%ebp)
  8021b2:	e8 e4 df ff ff       	call   80019b <vcprintf>
	cprintf("\n");
  8021b7:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  8021be:	e8 29 e0 ff ff       	call   8001ec <cprintf>
  8021c3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021c6:	cc                   	int3   
  8021c7:	eb fd                	jmp    8021c6 <_panic+0x5e>

008021c9 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	56                   	push   %esi
  8021cd:	53                   	push   %ebx
  8021ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8021d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021d7:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021d9:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021de:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021e1:	83 ec 0c             	sub    $0xc,%esp
  8021e4:	50                   	push   %eax
  8021e5:	e8 03 ed ff ff       	call   800eed <sys_ipc_recv>
	if(ret < 0){
  8021ea:	83 c4 10             	add    $0x10,%esp
  8021ed:	85 c0                	test   %eax,%eax
  8021ef:	78 2b                	js     80221c <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021f1:	85 f6                	test   %esi,%esi
  8021f3:	74 0a                	je     8021ff <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021f5:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fa:	8b 40 74             	mov    0x74(%eax),%eax
  8021fd:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021ff:	85 db                	test   %ebx,%ebx
  802201:	74 0a                	je     80220d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802203:	a1 08 40 80 00       	mov    0x804008,%eax
  802208:	8b 40 78             	mov    0x78(%eax),%eax
  80220b:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  80220d:	a1 08 40 80 00       	mov    0x804008,%eax
  802212:	8b 40 70             	mov    0x70(%eax),%eax
}
  802215:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802218:	5b                   	pop    %ebx
  802219:	5e                   	pop    %esi
  80221a:	5d                   	pop    %ebp
  80221b:	c3                   	ret    
		if(from_env_store)
  80221c:	85 f6                	test   %esi,%esi
  80221e:	74 06                	je     802226 <ipc_recv+0x5d>
			*from_env_store = 0;
  802220:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802226:	85 db                	test   %ebx,%ebx
  802228:	74 eb                	je     802215 <ipc_recv+0x4c>
			*perm_store = 0;
  80222a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802230:	eb e3                	jmp    802215 <ipc_recv+0x4c>

00802232 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 0c             	sub    $0xc,%esp
  80223b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80223e:	8b 75 0c             	mov    0xc(%ebp),%esi
  802241:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802244:	85 db                	test   %ebx,%ebx
  802246:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80224b:	0f 44 d8             	cmove  %eax,%ebx
  80224e:	eb 05                	jmp    802255 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802250:	e8 c9 ea ff ff       	call   800d1e <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802255:	ff 75 14             	pushl  0x14(%ebp)
  802258:	53                   	push   %ebx
  802259:	56                   	push   %esi
  80225a:	57                   	push   %edi
  80225b:	e8 6a ec ff ff       	call   800eca <sys_ipc_try_send>
  802260:	83 c4 10             	add    $0x10,%esp
  802263:	85 c0                	test   %eax,%eax
  802265:	74 1b                	je     802282 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802267:	79 e7                	jns    802250 <ipc_send+0x1e>
  802269:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80226c:	74 e2                	je     802250 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80226e:	83 ec 04             	sub    $0x4,%esp
  802271:	68 c7 2a 80 00       	push   $0x802ac7
  802276:	6a 46                	push   $0x46
  802278:	68 dc 2a 80 00       	push   $0x802adc
  80227d:	e8 e6 fe ff ff       	call   802168 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802282:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802285:	5b                   	pop    %ebx
  802286:	5e                   	pop    %esi
  802287:	5f                   	pop    %edi
  802288:	5d                   	pop    %ebp
  802289:	c3                   	ret    

0080228a <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80228a:	55                   	push   %ebp
  80228b:	89 e5                	mov    %esp,%ebp
  80228d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802290:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802295:	89 c2                	mov    %eax,%edx
  802297:	c1 e2 07             	shl    $0x7,%edx
  80229a:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022a0:	8b 52 50             	mov    0x50(%edx),%edx
  8022a3:	39 ca                	cmp    %ecx,%edx
  8022a5:	74 11                	je     8022b8 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022a7:	83 c0 01             	add    $0x1,%eax
  8022aa:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022af:	75 e4                	jne    802295 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b6:	eb 0b                	jmp    8022c3 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022b8:	c1 e0 07             	shl    $0x7,%eax
  8022bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022c0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022c3:	5d                   	pop    %ebp
  8022c4:	c3                   	ret    

008022c5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022c5:	55                   	push   %ebp
  8022c6:	89 e5                	mov    %esp,%ebp
  8022c8:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022cb:	89 d0                	mov    %edx,%eax
  8022cd:	c1 e8 16             	shr    $0x16,%eax
  8022d0:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022d7:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022dc:	f6 c1 01             	test   $0x1,%cl
  8022df:	74 1d                	je     8022fe <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022e1:	c1 ea 0c             	shr    $0xc,%edx
  8022e4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022eb:	f6 c2 01             	test   $0x1,%dl
  8022ee:	74 0e                	je     8022fe <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022f0:	c1 ea 0c             	shr    $0xc,%edx
  8022f3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022fa:	ef 
  8022fb:	0f b7 c0             	movzwl %ax,%eax
}
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    

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
