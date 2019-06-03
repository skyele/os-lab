
obj/user/echo.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 1c             	sub    $0x1c,%esp
  80003c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
  800042:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800049:	83 ff 01             	cmp    $0x1,%edi
  80004c:	7f 07                	jg     800055 <umain+0x22>
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80004e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800053:	eb 60                	jmp    8000b5 <umain+0x82>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	68 a0 25 80 00       	push   $0x8025a0
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 da 09 00 00       	call   800a3f <strcmp>
  800065:	83 c4 10             	add    $0x10,%esp
	nflag = 0;
  800068:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80006f:	85 c0                	test   %eax,%eax
  800071:	75 db                	jne    80004e <umain+0x1b>
		argc--;
  800073:	83 ef 01             	sub    $0x1,%edi
		argv++;
  800076:	83 c6 04             	add    $0x4,%esi
		nflag = 1;
  800079:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800080:	eb cc                	jmp    80004e <umain+0x1b>
		if (i > 1)
			write(1, " ", 1);
  800082:	83 ec 04             	sub    $0x4,%esp
  800085:	6a 01                	push   $0x1
  800087:	68 a3 25 80 00       	push   $0x8025a3
  80008c:	6a 01                	push   $0x1
  80008e:	e8 7d 13 00 00       	call   801410 <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 ba 08 00 00       	call   80095b <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 61 13 00 00       	call   801410 <write>
	for (i = 1; i < argc; i++) {
  8000af:	83 c3 01             	add    $0x1,%ebx
  8000b2:	83 c4 10             	add    $0x10,%esp
  8000b5:	39 df                	cmp    %ebx,%edi
  8000b7:	7e 07                	jle    8000c0 <umain+0x8d>
		if (i > 1)
  8000b9:	83 fb 01             	cmp    $0x1,%ebx
  8000bc:	7f c4                	jg     800082 <umain+0x4f>
  8000be:	eb d6                	jmp    800096 <umain+0x63>
	}
	if (!nflag)
  8000c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000c4:	74 08                	je     8000ce <umain+0x9b>
		write(1, "\n", 1);
}
  8000c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    
		write(1, "\n", 1);
  8000ce:	83 ec 04             	sub    $0x4,%esp
  8000d1:	6a 01                	push   $0x1
  8000d3:	68 b0 25 80 00       	push   $0x8025b0
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 31 13 00 00       	call   801410 <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	57                   	push   %edi
  8000e8:	56                   	push   %esi
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000ed:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  8000f4:	00 00 00 
	envid_t find = sys_getenvid();
  8000f7:	e8 4c 0c 00 00       	call   800d48 <sys_getenvid>
  8000fc:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800102:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800107:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80010c:	bf 01 00 00 00       	mov    $0x1,%edi
  800111:	eb 0b                	jmp    80011e <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800113:	83 c2 01             	add    $0x1,%edx
  800116:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80011c:	74 21                	je     80013f <libmain+0x5b>
		if(envs[i].env_id == find)
  80011e:	89 d1                	mov    %edx,%ecx
  800120:	c1 e1 07             	shl    $0x7,%ecx
  800123:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800129:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012c:	39 c1                	cmp    %eax,%ecx
  80012e:	75 e3                	jne    800113 <libmain+0x2f>
  800130:	89 d3                	mov    %edx,%ebx
  800132:	c1 e3 07             	shl    $0x7,%ebx
  800135:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013b:	89 fe                	mov    %edi,%esi
  80013d:	eb d4                	jmp    800113 <libmain+0x2f>
  80013f:	89 f0                	mov    %esi,%eax
  800141:	84 c0                	test   %al,%al
  800143:	74 06                	je     80014b <libmain+0x67>
  800145:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80014f:	7e 0a                	jle    80015b <libmain+0x77>
		binaryname = argv[0];
  800151:	8b 45 0c             	mov    0xc(%ebp),%eax
  800154:	8b 00                	mov    (%eax),%eax
  800156:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	68 a5 25 80 00       	push   $0x8025a5
  800163:	e8 cd 00 00 00       	call   800235 <cprintf>
	// call user main routine
	umain(argc, argv);
  800168:	83 c4 08             	add    $0x8,%esp
  80016b:	ff 75 0c             	pushl  0xc(%ebp)
  80016e:	ff 75 08             	pushl  0x8(%ebp)
  800171:	e8 bd fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800176:	e8 0b 00 00 00       	call   800186 <exit>
}
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800181:	5b                   	pop    %ebx
  800182:	5e                   	pop    %esi
  800183:	5f                   	pop    %edi
  800184:	5d                   	pop    %ebp
  800185:	c3                   	ret    

00800186 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800186:	55                   	push   %ebp
  800187:	89 e5                	mov    %esp,%ebp
  800189:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80018c:	e8 a2 10 00 00       	call   801233 <close_all>
	sys_env_destroy(0);
  800191:	83 ec 0c             	sub    $0xc,%esp
  800194:	6a 00                	push   $0x0
  800196:	e8 6c 0b 00 00       	call   800d07 <sys_env_destroy>
}
  80019b:	83 c4 10             	add    $0x10,%esp
  80019e:	c9                   	leave  
  80019f:	c3                   	ret    

008001a0 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	53                   	push   %ebx
  8001a4:	83 ec 04             	sub    $0x4,%esp
  8001a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001aa:	8b 13                	mov    (%ebx),%edx
  8001ac:	8d 42 01             	lea    0x1(%edx),%eax
  8001af:	89 03                	mov    %eax,(%ebx)
  8001b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001b4:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001b8:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001bd:	74 09                	je     8001c8 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001bf:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001c6:	c9                   	leave  
  8001c7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	68 ff 00 00 00       	push   $0xff
  8001d0:	8d 43 08             	lea    0x8(%ebx),%eax
  8001d3:	50                   	push   %eax
  8001d4:	e8 f1 0a 00 00       	call   800cca <sys_cputs>
		b->idx = 0;
  8001d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001df:	83 c4 10             	add    $0x10,%esp
  8001e2:	eb db                	jmp    8001bf <putch+0x1f>

008001e4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001e4:	55                   	push   %ebp
  8001e5:	89 e5                	mov    %esp,%ebp
  8001e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001f4:	00 00 00 
	b.cnt = 0;
  8001f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001fe:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800201:	ff 75 0c             	pushl  0xc(%ebp)
  800204:	ff 75 08             	pushl  0x8(%ebp)
  800207:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80020d:	50                   	push   %eax
  80020e:	68 a0 01 80 00       	push   $0x8001a0
  800213:	e8 4a 01 00 00       	call   800362 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800218:	83 c4 08             	add    $0x8,%esp
  80021b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800221:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800227:	50                   	push   %eax
  800228:	e8 9d 0a 00 00       	call   800cca <sys_cputs>

	return b.cnt;
}
  80022d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800233:	c9                   	leave  
  800234:	c3                   	ret    

00800235 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80023b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80023e:	50                   	push   %eax
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 9d ff ff ff       	call   8001e4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800247:	c9                   	leave  
  800248:	c3                   	ret    

00800249 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	57                   	push   %edi
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	83 ec 1c             	sub    $0x1c,%esp
  800252:	89 c6                	mov    %eax,%esi
  800254:	89 d7                	mov    %edx,%edi
  800256:	8b 45 08             	mov    0x8(%ebp),%eax
  800259:	8b 55 0c             	mov    0xc(%ebp),%edx
  80025c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80025f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800262:	8b 45 10             	mov    0x10(%ebp),%eax
  800265:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800268:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80026c:	74 2c                	je     80029a <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80026e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800271:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800278:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80027b:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80027e:	39 c2                	cmp    %eax,%edx
  800280:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800283:	73 43                	jae    8002c8 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800285:	83 eb 01             	sub    $0x1,%ebx
  800288:	85 db                	test   %ebx,%ebx
  80028a:	7e 6c                	jle    8002f8 <printnum+0xaf>
				putch(padc, putdat);
  80028c:	83 ec 08             	sub    $0x8,%esp
  80028f:	57                   	push   %edi
  800290:	ff 75 18             	pushl  0x18(%ebp)
  800293:	ff d6                	call   *%esi
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	eb eb                	jmp    800285 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80029a:	83 ec 0c             	sub    $0xc,%esp
  80029d:	6a 20                	push   $0x20
  80029f:	6a 00                	push   $0x0
  8002a1:	50                   	push   %eax
  8002a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a8:	89 fa                	mov    %edi,%edx
  8002aa:	89 f0                	mov    %esi,%eax
  8002ac:	e8 98 ff ff ff       	call   800249 <printnum>
		while (--width > 0)
  8002b1:	83 c4 20             	add    $0x20,%esp
  8002b4:	83 eb 01             	sub    $0x1,%ebx
  8002b7:	85 db                	test   %ebx,%ebx
  8002b9:	7e 65                	jle    800320 <printnum+0xd7>
			putch(padc, putdat);
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	57                   	push   %edi
  8002bf:	6a 20                	push   $0x20
  8002c1:	ff d6                	call   *%esi
  8002c3:	83 c4 10             	add    $0x10,%esp
  8002c6:	eb ec                	jmp    8002b4 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  8002c8:	83 ec 0c             	sub    $0xc,%esp
  8002cb:	ff 75 18             	pushl  0x18(%ebp)
  8002ce:	83 eb 01             	sub    $0x1,%ebx
  8002d1:	53                   	push   %ebx
  8002d2:	50                   	push   %eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d9:	ff 75 d8             	pushl  -0x28(%ebp)
  8002dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002df:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e2:	e8 69 20 00 00       	call   802350 <__udivdi3>
  8002e7:	83 c4 18             	add    $0x18,%esp
  8002ea:	52                   	push   %edx
  8002eb:	50                   	push   %eax
  8002ec:	89 fa                	mov    %edi,%edx
  8002ee:	89 f0                	mov    %esi,%eax
  8002f0:	e8 54 ff ff ff       	call   800249 <printnum>
  8002f5:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002f8:	83 ec 08             	sub    $0x8,%esp
  8002fb:	57                   	push   %edi
  8002fc:	83 ec 04             	sub    $0x4,%esp
  8002ff:	ff 75 dc             	pushl  -0x24(%ebp)
  800302:	ff 75 d8             	pushl  -0x28(%ebp)
  800305:	ff 75 e4             	pushl  -0x1c(%ebp)
  800308:	ff 75 e0             	pushl  -0x20(%ebp)
  80030b:	e8 50 21 00 00       	call   802460 <__umoddi3>
  800310:	83 c4 14             	add    $0x14,%esp
  800313:	0f be 80 bc 25 80 00 	movsbl 0x8025bc(%eax),%eax
  80031a:	50                   	push   %eax
  80031b:	ff d6                	call   *%esi
  80031d:	83 c4 10             	add    $0x10,%esp
	}
}
  800320:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800323:	5b                   	pop    %ebx
  800324:	5e                   	pop    %esi
  800325:	5f                   	pop    %edi
  800326:	5d                   	pop    %ebp
  800327:	c3                   	ret    

00800328 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80032e:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800332:	8b 10                	mov    (%eax),%edx
  800334:	3b 50 04             	cmp    0x4(%eax),%edx
  800337:	73 0a                	jae    800343 <sprintputch+0x1b>
		*b->buf++ = ch;
  800339:	8d 4a 01             	lea    0x1(%edx),%ecx
  80033c:	89 08                	mov    %ecx,(%eax)
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	88 02                	mov    %al,(%edx)
}
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    

00800345 <printfmt>:
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80034b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80034e:	50                   	push   %eax
  80034f:	ff 75 10             	pushl  0x10(%ebp)
  800352:	ff 75 0c             	pushl  0xc(%ebp)
  800355:	ff 75 08             	pushl  0x8(%ebp)
  800358:	e8 05 00 00 00       	call   800362 <vprintfmt>
}
  80035d:	83 c4 10             	add    $0x10,%esp
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <vprintfmt>:
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	57                   	push   %edi
  800366:	56                   	push   %esi
  800367:	53                   	push   %ebx
  800368:	83 ec 3c             	sub    $0x3c,%esp
  80036b:	8b 75 08             	mov    0x8(%ebp),%esi
  80036e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800371:	8b 7d 10             	mov    0x10(%ebp),%edi
  800374:	e9 32 04 00 00       	jmp    8007ab <vprintfmt+0x449>
		padc = ' ';
  800379:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80037d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800384:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80038b:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800392:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800399:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003a0:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003a5:	8d 47 01             	lea    0x1(%edi),%eax
  8003a8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ab:	0f b6 17             	movzbl (%edi),%edx
  8003ae:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003b1:	3c 55                	cmp    $0x55,%al
  8003b3:	0f 87 12 05 00 00    	ja     8008cb <vprintfmt+0x569>
  8003b9:	0f b6 c0             	movzbl %al,%eax
  8003bc:	ff 24 85 a0 27 80 00 	jmp    *0x8027a0(,%eax,4)
  8003c3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003c6:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  8003ca:	eb d9                	jmp    8003a5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003cf:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  8003d3:	eb d0                	jmp    8003a5 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  8003d5:	0f b6 d2             	movzbl %dl,%edx
  8003d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  8003db:	b8 00 00 00 00       	mov    $0x0,%eax
  8003e0:	89 75 08             	mov    %esi,0x8(%ebp)
  8003e3:	eb 03                	jmp    8003e8 <vprintfmt+0x86>
  8003e5:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003e8:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003eb:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003ef:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003f2:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003f5:	83 fe 09             	cmp    $0x9,%esi
  8003f8:	76 eb                	jbe    8003e5 <vprintfmt+0x83>
  8003fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800400:	eb 14                	jmp    800416 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80040a:	8b 45 14             	mov    0x14(%ebp),%eax
  80040d:	8d 40 04             	lea    0x4(%eax),%eax
  800410:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800416:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80041a:	79 89                	jns    8003a5 <vprintfmt+0x43>
				width = precision, precision = -1;
  80041c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80041f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800422:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  800429:	e9 77 ff ff ff       	jmp    8003a5 <vprintfmt+0x43>
  80042e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800431:	85 c0                	test   %eax,%eax
  800433:	0f 48 c1             	cmovs  %ecx,%eax
  800436:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800439:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80043c:	e9 64 ff ff ff       	jmp    8003a5 <vprintfmt+0x43>
  800441:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800444:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80044b:	e9 55 ff ff ff       	jmp    8003a5 <vprintfmt+0x43>
			lflag++;
  800450:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800454:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800457:	e9 49 ff ff ff       	jmp    8003a5 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80045c:	8b 45 14             	mov    0x14(%ebp),%eax
  80045f:	8d 78 04             	lea    0x4(%eax),%edi
  800462:	83 ec 08             	sub    $0x8,%esp
  800465:	53                   	push   %ebx
  800466:	ff 30                	pushl  (%eax)
  800468:	ff d6                	call   *%esi
			break;
  80046a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80046d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800470:	e9 33 03 00 00       	jmp    8007a8 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800475:	8b 45 14             	mov    0x14(%ebp),%eax
  800478:	8d 78 04             	lea    0x4(%eax),%edi
  80047b:	8b 00                	mov    (%eax),%eax
  80047d:	99                   	cltd   
  80047e:	31 d0                	xor    %edx,%eax
  800480:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800482:	83 f8 10             	cmp    $0x10,%eax
  800485:	7f 23                	jg     8004aa <vprintfmt+0x148>
  800487:	8b 14 85 00 29 80 00 	mov    0x802900(,%eax,4),%edx
  80048e:	85 d2                	test   %edx,%edx
  800490:	74 18                	je     8004aa <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800492:	52                   	push   %edx
  800493:	68 19 2a 80 00       	push   $0x802a19
  800498:	53                   	push   %ebx
  800499:	56                   	push   %esi
  80049a:	e8 a6 fe ff ff       	call   800345 <printfmt>
  80049f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004a2:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004a5:	e9 fe 02 00 00       	jmp    8007a8 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004aa:	50                   	push   %eax
  8004ab:	68 d4 25 80 00       	push   $0x8025d4
  8004b0:	53                   	push   %ebx
  8004b1:	56                   	push   %esi
  8004b2:	e8 8e fe ff ff       	call   800345 <printfmt>
  8004b7:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004ba:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004bd:	e9 e6 02 00 00       	jmp    8007a8 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  8004c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c5:	83 c0 04             	add    $0x4,%eax
  8004c8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  8004d0:	85 c9                	test   %ecx,%ecx
  8004d2:	b8 cd 25 80 00       	mov    $0x8025cd,%eax
  8004d7:	0f 45 c1             	cmovne %ecx,%eax
  8004da:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  8004dd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e1:	7e 06                	jle    8004e9 <vprintfmt+0x187>
  8004e3:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004e7:	75 0d                	jne    8004f6 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ec:	89 c7                	mov    %eax,%edi
  8004ee:	03 45 e0             	add    -0x20(%ebp),%eax
  8004f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004f4:	eb 53                	jmp    800549 <vprintfmt+0x1e7>
  8004f6:	83 ec 08             	sub    $0x8,%esp
  8004f9:	ff 75 d8             	pushl  -0x28(%ebp)
  8004fc:	50                   	push   %eax
  8004fd:	e8 71 04 00 00       	call   800973 <strnlen>
  800502:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800505:	29 c1                	sub    %eax,%ecx
  800507:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80050a:	83 c4 10             	add    $0x10,%esp
  80050d:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  80050f:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800513:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800516:	eb 0f                	jmp    800527 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800518:	83 ec 08             	sub    $0x8,%esp
  80051b:	53                   	push   %ebx
  80051c:	ff 75 e0             	pushl  -0x20(%ebp)
  80051f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800521:	83 ef 01             	sub    $0x1,%edi
  800524:	83 c4 10             	add    $0x10,%esp
  800527:	85 ff                	test   %edi,%edi
  800529:	7f ed                	jg     800518 <vprintfmt+0x1b6>
  80052b:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80052e:	85 c9                	test   %ecx,%ecx
  800530:	b8 00 00 00 00       	mov    $0x0,%eax
  800535:	0f 49 c1             	cmovns %ecx,%eax
  800538:	29 c1                	sub    %eax,%ecx
  80053a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80053d:	eb aa                	jmp    8004e9 <vprintfmt+0x187>
					putch(ch, putdat);
  80053f:	83 ec 08             	sub    $0x8,%esp
  800542:	53                   	push   %ebx
  800543:	52                   	push   %edx
  800544:	ff d6                	call   *%esi
  800546:	83 c4 10             	add    $0x10,%esp
  800549:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80054c:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80054e:	83 c7 01             	add    $0x1,%edi
  800551:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800555:	0f be d0             	movsbl %al,%edx
  800558:	85 d2                	test   %edx,%edx
  80055a:	74 4b                	je     8005a7 <vprintfmt+0x245>
  80055c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800560:	78 06                	js     800568 <vprintfmt+0x206>
  800562:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800566:	78 1e                	js     800586 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800568:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80056c:	74 d1                	je     80053f <vprintfmt+0x1dd>
  80056e:	0f be c0             	movsbl %al,%eax
  800571:	83 e8 20             	sub    $0x20,%eax
  800574:	83 f8 5e             	cmp    $0x5e,%eax
  800577:	76 c6                	jbe    80053f <vprintfmt+0x1dd>
					putch('?', putdat);
  800579:	83 ec 08             	sub    $0x8,%esp
  80057c:	53                   	push   %ebx
  80057d:	6a 3f                	push   $0x3f
  80057f:	ff d6                	call   *%esi
  800581:	83 c4 10             	add    $0x10,%esp
  800584:	eb c3                	jmp    800549 <vprintfmt+0x1e7>
  800586:	89 cf                	mov    %ecx,%edi
  800588:	eb 0e                	jmp    800598 <vprintfmt+0x236>
				putch(' ', putdat);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	53                   	push   %ebx
  80058e:	6a 20                	push   $0x20
  800590:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800592:	83 ef 01             	sub    $0x1,%edi
  800595:	83 c4 10             	add    $0x10,%esp
  800598:	85 ff                	test   %edi,%edi
  80059a:	7f ee                	jg     80058a <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80059c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80059f:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a2:	e9 01 02 00 00       	jmp    8007a8 <vprintfmt+0x446>
  8005a7:	89 cf                	mov    %ecx,%edi
  8005a9:	eb ed                	jmp    800598 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005ae:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8005b5:	e9 eb fd ff ff       	jmp    8003a5 <vprintfmt+0x43>
	if (lflag >= 2)
  8005ba:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005be:	7f 21                	jg     8005e1 <vprintfmt+0x27f>
	else if (lflag)
  8005c0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005c4:	74 68                	je     80062e <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 00                	mov    (%eax),%eax
  8005cb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ce:	89 c1                	mov    %eax,%ecx
  8005d0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8d 40 04             	lea    0x4(%eax),%eax
  8005dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005df:	eb 17                	jmp    8005f8 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e4:	8b 50 04             	mov    0x4(%eax),%edx
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ec:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8d 40 08             	lea    0x8(%eax),%eax
  8005f5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005f8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800601:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800604:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800608:	78 3f                	js     800649 <vprintfmt+0x2e7>
			base = 10;
  80060a:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  80060f:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800613:	0f 84 71 01 00 00    	je     80078a <vprintfmt+0x428>
				putch('+', putdat);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	6a 2b                	push   $0x2b
  80061f:	ff d6                	call   *%esi
  800621:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800624:	b8 0a 00 00 00       	mov    $0xa,%eax
  800629:	e9 5c 01 00 00       	jmp    80078a <vprintfmt+0x428>
		return va_arg(*ap, int);
  80062e:	8b 45 14             	mov    0x14(%ebp),%eax
  800631:	8b 00                	mov    (%eax),%eax
  800633:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800636:	89 c1                	mov    %eax,%ecx
  800638:	c1 f9 1f             	sar    $0x1f,%ecx
  80063b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8d 40 04             	lea    0x4(%eax),%eax
  800644:	89 45 14             	mov    %eax,0x14(%ebp)
  800647:	eb af                	jmp    8005f8 <vprintfmt+0x296>
				putch('-', putdat);
  800649:	83 ec 08             	sub    $0x8,%esp
  80064c:	53                   	push   %ebx
  80064d:	6a 2d                	push   $0x2d
  80064f:	ff d6                	call   *%esi
				num = -(long long) num;
  800651:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800654:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800657:	f7 d8                	neg    %eax
  800659:	83 d2 00             	adc    $0x0,%edx
  80065c:	f7 da                	neg    %edx
  80065e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800661:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800664:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800667:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066c:	e9 19 01 00 00       	jmp    80078a <vprintfmt+0x428>
	if (lflag >= 2)
  800671:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800675:	7f 29                	jg     8006a0 <vprintfmt+0x33e>
	else if (lflag)
  800677:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80067b:	74 44                	je     8006c1 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80067d:	8b 45 14             	mov    0x14(%ebp),%eax
  800680:	8b 00                	mov    (%eax),%eax
  800682:	ba 00 00 00 00       	mov    $0x0,%edx
  800687:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068d:	8b 45 14             	mov    0x14(%ebp),%eax
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800696:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069b:	e9 ea 00 00 00       	jmp    80078a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ab:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	8d 40 08             	lea    0x8(%eax),%eax
  8006b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bc:	e9 c9 00 00 00       	jmp    80078a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 04             	lea    0x4(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006df:	e9 a6 00 00 00       	jmp    80078a <vprintfmt+0x428>
			putch('0', putdat);
  8006e4:	83 ec 08             	sub    $0x8,%esp
  8006e7:	53                   	push   %ebx
  8006e8:	6a 30                	push   $0x30
  8006ea:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006ec:	83 c4 10             	add    $0x10,%esp
  8006ef:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006f3:	7f 26                	jg     80071b <vprintfmt+0x3b9>
	else if (lflag)
  8006f5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006f9:	74 3e                	je     800739 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	ba 00 00 00 00       	mov    $0x0,%edx
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 04             	lea    0x4(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800714:	b8 08 00 00 00       	mov    $0x8,%eax
  800719:	eb 6f                	jmp    80078a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80071b:	8b 45 14             	mov    0x14(%ebp),%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800726:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800729:	8b 45 14             	mov    0x14(%ebp),%eax
  80072c:	8d 40 08             	lea    0x8(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800732:	b8 08 00 00 00       	mov    $0x8,%eax
  800737:	eb 51                	jmp    80078a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 00                	mov    (%eax),%eax
  80073e:	ba 00 00 00 00       	mov    $0x0,%edx
  800743:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800746:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 40 04             	lea    0x4(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800752:	b8 08 00 00 00       	mov    $0x8,%eax
  800757:	eb 31                	jmp    80078a <vprintfmt+0x428>
			putch('0', putdat);
  800759:	83 ec 08             	sub    $0x8,%esp
  80075c:	53                   	push   %ebx
  80075d:	6a 30                	push   $0x30
  80075f:	ff d6                	call   *%esi
			putch('x', putdat);
  800761:	83 c4 08             	add    $0x8,%esp
  800764:	53                   	push   %ebx
  800765:	6a 78                	push   $0x78
  800767:	ff d6                	call   *%esi
			num = (unsigned long long)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8b 00                	mov    (%eax),%eax
  80076e:	ba 00 00 00 00       	mov    $0x0,%edx
  800773:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800776:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800779:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8d 40 04             	lea    0x4(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800785:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80078a:	83 ec 0c             	sub    $0xc,%esp
  80078d:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800791:	52                   	push   %edx
  800792:	ff 75 e0             	pushl  -0x20(%ebp)
  800795:	50                   	push   %eax
  800796:	ff 75 dc             	pushl  -0x24(%ebp)
  800799:	ff 75 d8             	pushl  -0x28(%ebp)
  80079c:	89 da                	mov    %ebx,%edx
  80079e:	89 f0                	mov    %esi,%eax
  8007a0:	e8 a4 fa ff ff       	call   800249 <printnum>
			break;
  8007a5:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007a8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	83 c7 01             	add    $0x1,%edi
  8007ae:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8007b2:	83 f8 25             	cmp    $0x25,%eax
  8007b5:	0f 84 be fb ff ff    	je     800379 <vprintfmt+0x17>
			if (ch == '\0')
  8007bb:	85 c0                	test   %eax,%eax
  8007bd:	0f 84 28 01 00 00    	je     8008eb <vprintfmt+0x589>
			putch(ch, putdat);
  8007c3:	83 ec 08             	sub    $0x8,%esp
  8007c6:	53                   	push   %ebx
  8007c7:	50                   	push   %eax
  8007c8:	ff d6                	call   *%esi
  8007ca:	83 c4 10             	add    $0x10,%esp
  8007cd:	eb dc                	jmp    8007ab <vprintfmt+0x449>
	if (lflag >= 2)
  8007cf:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8007d3:	7f 26                	jg     8007fb <vprintfmt+0x499>
	else if (lflag)
  8007d5:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8007d9:	74 41                	je     80081c <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  8007db:	8b 45 14             	mov    0x14(%ebp),%eax
  8007de:	8b 00                	mov    (%eax),%eax
  8007e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ee:	8d 40 04             	lea    0x4(%eax),%eax
  8007f1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f9:	eb 8f                	jmp    80078a <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fe:	8b 50 04             	mov    0x4(%eax),%edx
  800801:	8b 00                	mov    (%eax),%eax
  800803:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800806:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8d 40 08             	lea    0x8(%eax),%eax
  80080f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800812:	b8 10 00 00 00       	mov    $0x10,%eax
  800817:	e9 6e ff ff ff       	jmp    80078a <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	8b 00                	mov    (%eax),%eax
  800821:	ba 00 00 00 00       	mov    $0x0,%edx
  800826:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800829:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8d 40 04             	lea    0x4(%eax),%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800835:	b8 10 00 00 00       	mov    $0x10,%eax
  80083a:	e9 4b ff ff ff       	jmp    80078a <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  80083f:	8b 45 14             	mov    0x14(%ebp),%eax
  800842:	83 c0 04             	add    $0x4,%eax
  800845:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800848:	8b 45 14             	mov    0x14(%ebp),%eax
  80084b:	8b 00                	mov    (%eax),%eax
  80084d:	85 c0                	test   %eax,%eax
  80084f:	74 14                	je     800865 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800851:	8b 13                	mov    (%ebx),%edx
  800853:	83 fa 7f             	cmp    $0x7f,%edx
  800856:	7f 37                	jg     80088f <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800858:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80085a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085d:	89 45 14             	mov    %eax,0x14(%ebp)
  800860:	e9 43 ff ff ff       	jmp    8007a8 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800865:	b8 0a 00 00 00       	mov    $0xa,%eax
  80086a:	bf f1 26 80 00       	mov    $0x8026f1,%edi
							putch(ch, putdat);
  80086f:	83 ec 08             	sub    $0x8,%esp
  800872:	53                   	push   %ebx
  800873:	50                   	push   %eax
  800874:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800876:	83 c7 01             	add    $0x1,%edi
  800879:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	85 c0                	test   %eax,%eax
  800882:	75 eb                	jne    80086f <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800884:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	e9 19 ff ff ff       	jmp    8007a8 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80088f:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800891:	b8 0a 00 00 00       	mov    $0xa,%eax
  800896:	bf 29 27 80 00       	mov    $0x802729,%edi
							putch(ch, putdat);
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	53                   	push   %ebx
  80089f:	50                   	push   %eax
  8008a0:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008a2:	83 c7 01             	add    $0x1,%edi
  8008a5:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	85 c0                	test   %eax,%eax
  8008ae:	75 eb                	jne    80089b <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8008b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	e9 ed fe ff ff       	jmp    8007a8 <vprintfmt+0x446>
			putch(ch, putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	6a 25                	push   $0x25
  8008c1:	ff d6                	call   *%esi
			break;
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	e9 dd fe ff ff       	jmp    8007a8 <vprintfmt+0x446>
			putch('%', putdat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	53                   	push   %ebx
  8008cf:	6a 25                	push   $0x25
  8008d1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	89 f8                	mov    %edi,%eax
  8008d8:	eb 03                	jmp    8008dd <vprintfmt+0x57b>
  8008da:	83 e8 01             	sub    $0x1,%eax
  8008dd:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008e1:	75 f7                	jne    8008da <vprintfmt+0x578>
  8008e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e6:	e9 bd fe ff ff       	jmp    8007a8 <vprintfmt+0x446>
}
  8008eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ee:	5b                   	pop    %ebx
  8008ef:	5e                   	pop    %esi
  8008f0:	5f                   	pop    %edi
  8008f1:	5d                   	pop    %ebp
  8008f2:	c3                   	ret    

008008f3 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	83 ec 18             	sub    $0x18,%esp
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800902:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800906:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800909:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800910:	85 c0                	test   %eax,%eax
  800912:	74 26                	je     80093a <vsnprintf+0x47>
  800914:	85 d2                	test   %edx,%edx
  800916:	7e 22                	jle    80093a <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800918:	ff 75 14             	pushl  0x14(%ebp)
  80091b:	ff 75 10             	pushl  0x10(%ebp)
  80091e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800921:	50                   	push   %eax
  800922:	68 28 03 80 00       	push   $0x800328
  800927:	e8 36 fa ff ff       	call   800362 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80092c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800932:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800935:	83 c4 10             	add    $0x10,%esp
}
  800938:	c9                   	leave  
  800939:	c3                   	ret    
		return -E_INVAL;
  80093a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80093f:	eb f7                	jmp    800938 <vsnprintf+0x45>

00800941 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800947:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80094a:	50                   	push   %eax
  80094b:	ff 75 10             	pushl  0x10(%ebp)
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	ff 75 08             	pushl  0x8(%ebp)
  800954:	e8 9a ff ff ff       	call   8008f3 <vsnprintf>
	va_end(ap);

	return rc;
}
  800959:	c9                   	leave  
  80095a:	c3                   	ret    

0080095b <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800961:	b8 00 00 00 00       	mov    $0x0,%eax
  800966:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80096a:	74 05                	je     800971 <strlen+0x16>
		n++;
  80096c:	83 c0 01             	add    $0x1,%eax
  80096f:	eb f5                	jmp    800966 <strlen+0xb>
	return n;
}
  800971:	5d                   	pop    %ebp
  800972:	c3                   	ret    

00800973 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800973:	55                   	push   %ebp
  800974:	89 e5                	mov    %esp,%ebp
  800976:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800979:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097c:	ba 00 00 00 00       	mov    $0x0,%edx
  800981:	39 c2                	cmp    %eax,%edx
  800983:	74 0d                	je     800992 <strnlen+0x1f>
  800985:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800989:	74 05                	je     800990 <strnlen+0x1d>
		n++;
  80098b:	83 c2 01             	add    $0x1,%edx
  80098e:	eb f1                	jmp    800981 <strnlen+0xe>
  800990:	89 d0                	mov    %edx,%eax
	return n;
}
  800992:	5d                   	pop    %ebp
  800993:	c3                   	ret    

00800994 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	53                   	push   %ebx
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80099e:	ba 00 00 00 00       	mov    $0x0,%edx
  8009a3:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009a7:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009aa:	83 c2 01             	add    $0x1,%edx
  8009ad:	84 c9                	test   %cl,%cl
  8009af:	75 f2                	jne    8009a3 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009b1:	5b                   	pop    %ebx
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	53                   	push   %ebx
  8009b8:	83 ec 10             	sub    $0x10,%esp
  8009bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009be:	53                   	push   %ebx
  8009bf:	e8 97 ff ff ff       	call   80095b <strlen>
  8009c4:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	01 d8                	add    %ebx,%eax
  8009cc:	50                   	push   %eax
  8009cd:	e8 c2 ff ff ff       	call   800994 <strcpy>
	return dst;
}
  8009d2:	89 d8                	mov    %ebx,%eax
  8009d4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009d7:	c9                   	leave  
  8009d8:	c3                   	ret    

008009d9 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d9:	55                   	push   %ebp
  8009da:	89 e5                	mov    %esp,%ebp
  8009dc:	56                   	push   %esi
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009e4:	89 c6                	mov    %eax,%esi
  8009e6:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e9:	89 c2                	mov    %eax,%edx
  8009eb:	39 f2                	cmp    %esi,%edx
  8009ed:	74 11                	je     800a00 <strncpy+0x27>
		*dst++ = *src;
  8009ef:	83 c2 01             	add    $0x1,%edx
  8009f2:	0f b6 19             	movzbl (%ecx),%ebx
  8009f5:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009f8:	80 fb 01             	cmp    $0x1,%bl
  8009fb:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009fe:	eb eb                	jmp    8009eb <strncpy+0x12>
	}
	return ret;
}
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	56                   	push   %esi
  800a08:	53                   	push   %ebx
  800a09:	8b 75 08             	mov    0x8(%ebp),%esi
  800a0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a0f:	8b 55 10             	mov    0x10(%ebp),%edx
  800a12:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a14:	85 d2                	test   %edx,%edx
  800a16:	74 21                	je     800a39 <strlcpy+0x35>
  800a18:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a1c:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a1e:	39 c2                	cmp    %eax,%edx
  800a20:	74 14                	je     800a36 <strlcpy+0x32>
  800a22:	0f b6 19             	movzbl (%ecx),%ebx
  800a25:	84 db                	test   %bl,%bl
  800a27:	74 0b                	je     800a34 <strlcpy+0x30>
			*dst++ = *src++;
  800a29:	83 c1 01             	add    $0x1,%ecx
  800a2c:	83 c2 01             	add    $0x1,%edx
  800a2f:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a32:	eb ea                	jmp    800a1e <strlcpy+0x1a>
  800a34:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a36:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a39:	29 f0                	sub    %esi,%eax
}
  800a3b:	5b                   	pop    %ebx
  800a3c:	5e                   	pop    %esi
  800a3d:	5d                   	pop    %ebp
  800a3e:	c3                   	ret    

00800a3f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a3f:	55                   	push   %ebp
  800a40:	89 e5                	mov    %esp,%ebp
  800a42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a45:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a48:	0f b6 01             	movzbl (%ecx),%eax
  800a4b:	84 c0                	test   %al,%al
  800a4d:	74 0c                	je     800a5b <strcmp+0x1c>
  800a4f:	3a 02                	cmp    (%edx),%al
  800a51:	75 08                	jne    800a5b <strcmp+0x1c>
		p++, q++;
  800a53:	83 c1 01             	add    $0x1,%ecx
  800a56:	83 c2 01             	add    $0x1,%edx
  800a59:	eb ed                	jmp    800a48 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a5b:	0f b6 c0             	movzbl %al,%eax
  800a5e:	0f b6 12             	movzbl (%edx),%edx
  800a61:	29 d0                	sub    %edx,%eax
}
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	53                   	push   %ebx
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a6f:	89 c3                	mov    %eax,%ebx
  800a71:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a74:	eb 06                	jmp    800a7c <strncmp+0x17>
		n--, p++, q++;
  800a76:	83 c0 01             	add    $0x1,%eax
  800a79:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a7c:	39 d8                	cmp    %ebx,%eax
  800a7e:	74 16                	je     800a96 <strncmp+0x31>
  800a80:	0f b6 08             	movzbl (%eax),%ecx
  800a83:	84 c9                	test   %cl,%cl
  800a85:	74 04                	je     800a8b <strncmp+0x26>
  800a87:	3a 0a                	cmp    (%edx),%cl
  800a89:	74 eb                	je     800a76 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a8b:	0f b6 00             	movzbl (%eax),%eax
  800a8e:	0f b6 12             	movzbl (%edx),%edx
  800a91:	29 d0                	sub    %edx,%eax
}
  800a93:	5b                   	pop    %ebx
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    
		return 0;
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	eb f6                	jmp    800a93 <strncmp+0x2e>

00800a9d <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa7:	0f b6 10             	movzbl (%eax),%edx
  800aaa:	84 d2                	test   %dl,%dl
  800aac:	74 09                	je     800ab7 <strchr+0x1a>
		if (*s == c)
  800aae:	38 ca                	cmp    %cl,%dl
  800ab0:	74 0a                	je     800abc <strchr+0x1f>
	for (; *s; s++)
  800ab2:	83 c0 01             	add    $0x1,%eax
  800ab5:	eb f0                	jmp    800aa7 <strchr+0xa>
			return (char *) s;
	return 0;
  800ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac8:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800acb:	38 ca                	cmp    %cl,%dl
  800acd:	74 09                	je     800ad8 <strfind+0x1a>
  800acf:	84 d2                	test   %dl,%dl
  800ad1:	74 05                	je     800ad8 <strfind+0x1a>
	for (; *s; s++)
  800ad3:	83 c0 01             	add    $0x1,%eax
  800ad6:	eb f0                	jmp    800ac8 <strfind+0xa>
			break;
	return (char *) s;
}
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	57                   	push   %edi
  800ade:	56                   	push   %esi
  800adf:	53                   	push   %ebx
  800ae0:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ae3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae6:	85 c9                	test   %ecx,%ecx
  800ae8:	74 31                	je     800b1b <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aea:	89 f8                	mov    %edi,%eax
  800aec:	09 c8                	or     %ecx,%eax
  800aee:	a8 03                	test   $0x3,%al
  800af0:	75 23                	jne    800b15 <memset+0x3b>
		c &= 0xFF;
  800af2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af6:	89 d3                	mov    %edx,%ebx
  800af8:	c1 e3 08             	shl    $0x8,%ebx
  800afb:	89 d0                	mov    %edx,%eax
  800afd:	c1 e0 18             	shl    $0x18,%eax
  800b00:	89 d6                	mov    %edx,%esi
  800b02:	c1 e6 10             	shl    $0x10,%esi
  800b05:	09 f0                	or     %esi,%eax
  800b07:	09 c2                	or     %eax,%edx
  800b09:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b0b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b0e:	89 d0                	mov    %edx,%eax
  800b10:	fc                   	cld    
  800b11:	f3 ab                	rep stos %eax,%es:(%edi)
  800b13:	eb 06                	jmp    800b1b <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b18:	fc                   	cld    
  800b19:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b1b:	89 f8                	mov    %edi,%eax
  800b1d:	5b                   	pop    %ebx
  800b1e:	5e                   	pop    %esi
  800b1f:	5f                   	pop    %edi
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	57                   	push   %edi
  800b26:	56                   	push   %esi
  800b27:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b30:	39 c6                	cmp    %eax,%esi
  800b32:	73 32                	jae    800b66 <memmove+0x44>
  800b34:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b37:	39 c2                	cmp    %eax,%edx
  800b39:	76 2b                	jbe    800b66 <memmove+0x44>
		s += n;
		d += n;
  800b3b:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3e:	89 fe                	mov    %edi,%esi
  800b40:	09 ce                	or     %ecx,%esi
  800b42:	09 d6                	or     %edx,%esi
  800b44:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b4a:	75 0e                	jne    800b5a <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b4c:	83 ef 04             	sub    $0x4,%edi
  800b4f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b52:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b55:	fd                   	std    
  800b56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b58:	eb 09                	jmp    800b63 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b5a:	83 ef 01             	sub    $0x1,%edi
  800b5d:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b60:	fd                   	std    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b63:	fc                   	cld    
  800b64:	eb 1a                	jmp    800b80 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b66:	89 c2                	mov    %eax,%edx
  800b68:	09 ca                	or     %ecx,%edx
  800b6a:	09 f2                	or     %esi,%edx
  800b6c:	f6 c2 03             	test   $0x3,%dl
  800b6f:	75 0a                	jne    800b7b <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b71:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b74:	89 c7                	mov    %eax,%edi
  800b76:	fc                   	cld    
  800b77:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b79:	eb 05                	jmp    800b80 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b7b:	89 c7                	mov    %eax,%edi
  800b7d:	fc                   	cld    
  800b7e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b80:	5e                   	pop    %esi
  800b81:	5f                   	pop    %edi
  800b82:	5d                   	pop    %ebp
  800b83:	c3                   	ret    

00800b84 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b84:	55                   	push   %ebp
  800b85:	89 e5                	mov    %esp,%ebp
  800b87:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b8a:	ff 75 10             	pushl  0x10(%ebp)
  800b8d:	ff 75 0c             	pushl  0xc(%ebp)
  800b90:	ff 75 08             	pushl  0x8(%ebp)
  800b93:	e8 8a ff ff ff       	call   800b22 <memmove>
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	56                   	push   %esi
  800b9e:	53                   	push   %ebx
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ba5:	89 c6                	mov    %eax,%esi
  800ba7:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800baa:	39 f0                	cmp    %esi,%eax
  800bac:	74 1c                	je     800bca <memcmp+0x30>
		if (*s1 != *s2)
  800bae:	0f b6 08             	movzbl (%eax),%ecx
  800bb1:	0f b6 1a             	movzbl (%edx),%ebx
  800bb4:	38 d9                	cmp    %bl,%cl
  800bb6:	75 08                	jne    800bc0 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800bb8:	83 c0 01             	add    $0x1,%eax
  800bbb:	83 c2 01             	add    $0x1,%edx
  800bbe:	eb ea                	jmp    800baa <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800bc0:	0f b6 c1             	movzbl %cl,%eax
  800bc3:	0f b6 db             	movzbl %bl,%ebx
  800bc6:	29 d8                	sub    %ebx,%eax
  800bc8:	eb 05                	jmp    800bcf <memcmp+0x35>
	}

	return 0;
  800bca:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bcf:	5b                   	pop    %ebx
  800bd0:	5e                   	pop    %esi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bdc:	89 c2                	mov    %eax,%edx
  800bde:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800be1:	39 d0                	cmp    %edx,%eax
  800be3:	73 09                	jae    800bee <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800be5:	38 08                	cmp    %cl,(%eax)
  800be7:	74 05                	je     800bee <memfind+0x1b>
	for (; s < ends; s++)
  800be9:	83 c0 01             	add    $0x1,%eax
  800bec:	eb f3                	jmp    800be1 <memfind+0xe>
			break;
	return (void *) s;
}
  800bee:	5d                   	pop    %ebp
  800bef:	c3                   	ret    

00800bf0 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	57                   	push   %edi
  800bf4:	56                   	push   %esi
  800bf5:	53                   	push   %ebx
  800bf6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bfc:	eb 03                	jmp    800c01 <strtol+0x11>
		s++;
  800bfe:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c01:	0f b6 01             	movzbl (%ecx),%eax
  800c04:	3c 20                	cmp    $0x20,%al
  800c06:	74 f6                	je     800bfe <strtol+0xe>
  800c08:	3c 09                	cmp    $0x9,%al
  800c0a:	74 f2                	je     800bfe <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c0c:	3c 2b                	cmp    $0x2b,%al
  800c0e:	74 2a                	je     800c3a <strtol+0x4a>
	int neg = 0;
  800c10:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c15:	3c 2d                	cmp    $0x2d,%al
  800c17:	74 2b                	je     800c44 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c19:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c1f:	75 0f                	jne    800c30 <strtol+0x40>
  800c21:	80 39 30             	cmpb   $0x30,(%ecx)
  800c24:	74 28                	je     800c4e <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c26:	85 db                	test   %ebx,%ebx
  800c28:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c2d:	0f 44 d8             	cmove  %eax,%ebx
  800c30:	b8 00 00 00 00       	mov    $0x0,%eax
  800c35:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c38:	eb 50                	jmp    800c8a <strtol+0x9a>
		s++;
  800c3a:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c3d:	bf 00 00 00 00       	mov    $0x0,%edi
  800c42:	eb d5                	jmp    800c19 <strtol+0x29>
		s++, neg = 1;
  800c44:	83 c1 01             	add    $0x1,%ecx
  800c47:	bf 01 00 00 00       	mov    $0x1,%edi
  800c4c:	eb cb                	jmp    800c19 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c4e:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c52:	74 0e                	je     800c62 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c54:	85 db                	test   %ebx,%ebx
  800c56:	75 d8                	jne    800c30 <strtol+0x40>
		s++, base = 8;
  800c58:	83 c1 01             	add    $0x1,%ecx
  800c5b:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c60:	eb ce                	jmp    800c30 <strtol+0x40>
		s += 2, base = 16;
  800c62:	83 c1 02             	add    $0x2,%ecx
  800c65:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c6a:	eb c4                	jmp    800c30 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c6c:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c6f:	89 f3                	mov    %esi,%ebx
  800c71:	80 fb 19             	cmp    $0x19,%bl
  800c74:	77 29                	ja     800c9f <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c76:	0f be d2             	movsbl %dl,%edx
  800c79:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c7c:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c7f:	7d 30                	jge    800cb1 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c81:	83 c1 01             	add    $0x1,%ecx
  800c84:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c88:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c8a:	0f b6 11             	movzbl (%ecx),%edx
  800c8d:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c90:	89 f3                	mov    %esi,%ebx
  800c92:	80 fb 09             	cmp    $0x9,%bl
  800c95:	77 d5                	ja     800c6c <strtol+0x7c>
			dig = *s - '0';
  800c97:	0f be d2             	movsbl %dl,%edx
  800c9a:	83 ea 30             	sub    $0x30,%edx
  800c9d:	eb dd                	jmp    800c7c <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c9f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ca2:	89 f3                	mov    %esi,%ebx
  800ca4:	80 fb 19             	cmp    $0x19,%bl
  800ca7:	77 08                	ja     800cb1 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800ca9:	0f be d2             	movsbl %dl,%edx
  800cac:	83 ea 37             	sub    $0x37,%edx
  800caf:	eb cb                	jmp    800c7c <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800cb1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cb5:	74 05                	je     800cbc <strtol+0xcc>
		*endptr = (char *) s;
  800cb7:	8b 75 0c             	mov    0xc(%ebp),%esi
  800cba:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800cbc:	89 c2                	mov    %eax,%edx
  800cbe:	f7 da                	neg    %edx
  800cc0:	85 ff                	test   %edi,%edi
  800cc2:	0f 45 c2             	cmovne %edx,%eax
}
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd0:	b8 00 00 00 00       	mov    $0x0,%eax
  800cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdb:	89 c3                	mov    %eax,%ebx
  800cdd:	89 c7                	mov    %eax,%edi
  800cdf:	89 c6                	mov    %eax,%esi
  800ce1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cee:	ba 00 00 00 00       	mov    $0x0,%edx
  800cf3:	b8 01 00 00 00       	mov    $0x1,%eax
  800cf8:	89 d1                	mov    %edx,%ecx
  800cfa:	89 d3                	mov    %edx,%ebx
  800cfc:	89 d7                	mov    %edx,%edi
  800cfe:	89 d6                	mov    %edx,%esi
  800d00:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d02:	5b                   	pop    %ebx
  800d03:	5e                   	pop    %esi
  800d04:	5f                   	pop    %edi
  800d05:	5d                   	pop    %ebp
  800d06:	c3                   	ret    

00800d07 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d07:	55                   	push   %ebp
  800d08:	89 e5                	mov    %esp,%ebp
  800d0a:	57                   	push   %edi
  800d0b:	56                   	push   %esi
  800d0c:	53                   	push   %ebx
  800d0d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d10:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	b8 03 00 00 00       	mov    $0x3,%eax
  800d1d:	89 cb                	mov    %ecx,%ebx
  800d1f:	89 cf                	mov    %ecx,%edi
  800d21:	89 ce                	mov    %ecx,%esi
  800d23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d25:	85 c0                	test   %eax,%eax
  800d27:	7f 08                	jg     800d31 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2c:	5b                   	pop    %ebx
  800d2d:	5e                   	pop    %esi
  800d2e:	5f                   	pop    %edi
  800d2f:	5d                   	pop    %ebp
  800d30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d31:	83 ec 0c             	sub    $0xc,%esp
  800d34:	50                   	push   %eax
  800d35:	6a 03                	push   $0x3
  800d37:	68 44 29 80 00       	push   $0x802944
  800d3c:	6a 43                	push   $0x43
  800d3e:	68 61 29 80 00       	push   $0x802961
  800d43:	e8 69 14 00 00       	call   8021b1 <_panic>

00800d48 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d4e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d53:	b8 02 00 00 00       	mov    $0x2,%eax
  800d58:	89 d1                	mov    %edx,%ecx
  800d5a:	89 d3                	mov    %edx,%ebx
  800d5c:	89 d7                	mov    %edx,%edi
  800d5e:	89 d6                	mov    %edx,%esi
  800d60:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d62:	5b                   	pop    %ebx
  800d63:	5e                   	pop    %esi
  800d64:	5f                   	pop    %edi
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_yield>:

void
sys_yield(void)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	57                   	push   %edi
  800d6b:	56                   	push   %esi
  800d6c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d72:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d77:	89 d1                	mov    %edx,%ecx
  800d79:	89 d3                	mov    %edx,%ebx
  800d7b:	89 d7                	mov    %edx,%edi
  800d7d:	89 d6                	mov    %edx,%esi
  800d7f:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d81:	5b                   	pop    %ebx
  800d82:	5e                   	pop    %esi
  800d83:	5f                   	pop    %edi
  800d84:	5d                   	pop    %ebp
  800d85:	c3                   	ret    

00800d86 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d86:	55                   	push   %ebp
  800d87:	89 e5                	mov    %esp,%ebp
  800d89:	57                   	push   %edi
  800d8a:	56                   	push   %esi
  800d8b:	53                   	push   %ebx
  800d8c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8f:	be 00 00 00 00       	mov    $0x0,%esi
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	b8 04 00 00 00       	mov    $0x4,%eax
  800d9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da2:	89 f7                	mov    %esi,%edi
  800da4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7f 08                	jg     800db2 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	6a 04                	push   $0x4
  800db8:	68 44 29 80 00       	push   $0x802944
  800dbd:	6a 43                	push   $0x43
  800dbf:	68 61 29 80 00       	push   $0x802961
  800dc4:	e8 e8 13 00 00       	call   8021b1 <_panic>

00800dc9 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd8:	b8 05 00 00 00       	mov    $0x5,%eax
  800ddd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800de0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800de3:	8b 75 18             	mov    0x18(%ebp),%esi
  800de6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de8:	85 c0                	test   %eax,%eax
  800dea:	7f 08                	jg     800df4 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800def:	5b                   	pop    %ebx
  800df0:	5e                   	pop    %esi
  800df1:	5f                   	pop    %edi
  800df2:	5d                   	pop    %ebp
  800df3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df4:	83 ec 0c             	sub    $0xc,%esp
  800df7:	50                   	push   %eax
  800df8:	6a 05                	push   $0x5
  800dfa:	68 44 29 80 00       	push   $0x802944
  800dff:	6a 43                	push   $0x43
  800e01:	68 61 29 80 00       	push   $0x802961
  800e06:	e8 a6 13 00 00       	call   8021b1 <_panic>

00800e0b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e0b:	55                   	push   %ebp
  800e0c:	89 e5                	mov    %esp,%ebp
  800e0e:	57                   	push   %edi
  800e0f:	56                   	push   %esi
  800e10:	53                   	push   %ebx
  800e11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e19:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	b8 06 00 00 00       	mov    $0x6,%eax
  800e24:	89 df                	mov    %ebx,%edi
  800e26:	89 de                	mov    %ebx,%esi
  800e28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2a:	85 c0                	test   %eax,%eax
  800e2c:	7f 08                	jg     800e36 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e31:	5b                   	pop    %ebx
  800e32:	5e                   	pop    %esi
  800e33:	5f                   	pop    %edi
  800e34:	5d                   	pop    %ebp
  800e35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e36:	83 ec 0c             	sub    $0xc,%esp
  800e39:	50                   	push   %eax
  800e3a:	6a 06                	push   $0x6
  800e3c:	68 44 29 80 00       	push   $0x802944
  800e41:	6a 43                	push   $0x43
  800e43:	68 61 29 80 00       	push   $0x802961
  800e48:	e8 64 13 00 00       	call   8021b1 <_panic>

00800e4d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	b8 08 00 00 00       	mov    $0x8,%eax
  800e66:	89 df                	mov    %ebx,%edi
  800e68:	89 de                	mov    %ebx,%esi
  800e6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6c:	85 c0                	test   %eax,%eax
  800e6e:	7f 08                	jg     800e78 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e78:	83 ec 0c             	sub    $0xc,%esp
  800e7b:	50                   	push   %eax
  800e7c:	6a 08                	push   $0x8
  800e7e:	68 44 29 80 00       	push   $0x802944
  800e83:	6a 43                	push   $0x43
  800e85:	68 61 29 80 00       	push   $0x802961
  800e8a:	e8 22 13 00 00       	call   8021b1 <_panic>

00800e8f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e8f:	55                   	push   %ebp
  800e90:	89 e5                	mov    %esp,%ebp
  800e92:	57                   	push   %edi
  800e93:	56                   	push   %esi
  800e94:	53                   	push   %ebx
  800e95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea3:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea8:	89 df                	mov    %ebx,%edi
  800eaa:	89 de                	mov    %ebx,%esi
  800eac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	7f 08                	jg     800eba <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5f                   	pop    %edi
  800eb8:	5d                   	pop    %ebp
  800eb9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	50                   	push   %eax
  800ebe:	6a 09                	push   $0x9
  800ec0:	68 44 29 80 00       	push   $0x802944
  800ec5:	6a 43                	push   $0x43
  800ec7:	68 61 29 80 00       	push   $0x802961
  800ecc:	e8 e0 12 00 00       	call   8021b1 <_panic>

00800ed1 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	57                   	push   %edi
  800ed5:	56                   	push   %esi
  800ed6:	53                   	push   %ebx
  800ed7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800edf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eea:	89 df                	mov    %ebx,%edi
  800eec:	89 de                	mov    %ebx,%esi
  800eee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef0:	85 c0                	test   %eax,%eax
  800ef2:	7f 08                	jg     800efc <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ef7:	5b                   	pop    %ebx
  800ef8:	5e                   	pop    %esi
  800ef9:	5f                   	pop    %edi
  800efa:	5d                   	pop    %ebp
  800efb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800efc:	83 ec 0c             	sub    $0xc,%esp
  800eff:	50                   	push   %eax
  800f00:	6a 0a                	push   $0xa
  800f02:	68 44 29 80 00       	push   $0x802944
  800f07:	6a 43                	push   $0x43
  800f09:	68 61 29 80 00       	push   $0x802961
  800f0e:	e8 9e 12 00 00       	call   8021b1 <_panic>

00800f13 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1f:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f24:	be 00 00 00 00       	mov    $0x0,%esi
  800f29:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f2c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f2f:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f31:	5b                   	pop    %ebx
  800f32:	5e                   	pop    %esi
  800f33:	5f                   	pop    %edi
  800f34:	5d                   	pop    %ebp
  800f35:	c3                   	ret    

00800f36 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f36:	55                   	push   %ebp
  800f37:	89 e5                	mov    %esp,%ebp
  800f39:	57                   	push   %edi
  800f3a:	56                   	push   %esi
  800f3b:	53                   	push   %ebx
  800f3c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f3f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f44:	8b 55 08             	mov    0x8(%ebp),%edx
  800f47:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f4c:	89 cb                	mov    %ecx,%ebx
  800f4e:	89 cf                	mov    %ecx,%edi
  800f50:	89 ce                	mov    %ecx,%esi
  800f52:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f54:	85 c0                	test   %eax,%eax
  800f56:	7f 08                	jg     800f60 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f58:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f60:	83 ec 0c             	sub    $0xc,%esp
  800f63:	50                   	push   %eax
  800f64:	6a 0d                	push   $0xd
  800f66:	68 44 29 80 00       	push   $0x802944
  800f6b:	6a 43                	push   $0x43
  800f6d:	68 61 29 80 00       	push   $0x802961
  800f72:	e8 3a 12 00 00       	call   8021b1 <_panic>

00800f77 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f77:	55                   	push   %ebp
  800f78:	89 e5                	mov    %esp,%ebp
  800f7a:	57                   	push   %edi
  800f7b:	56                   	push   %esi
  800f7c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f82:	8b 55 08             	mov    0x8(%ebp),%edx
  800f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f88:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f8d:	89 df                	mov    %ebx,%edi
  800f8f:	89 de                	mov    %ebx,%esi
  800f91:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fab:	89 cb                	mov    %ecx,%ebx
  800fad:	89 cf                	mov    %ecx,%edi
  800faf:	89 ce                	mov    %ecx,%esi
  800fb1:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800fb3:	5b                   	pop    %ebx
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    

00800fb8 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800fb8:	55                   	push   %ebp
  800fb9:	89 e5                	mov    %esp,%ebp
  800fbb:	57                   	push   %edi
  800fbc:	56                   	push   %esi
  800fbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc3:	b8 10 00 00 00       	mov    $0x10,%eax
  800fc8:	89 d1                	mov    %edx,%ecx
  800fca:	89 d3                	mov    %edx,%ebx
  800fcc:	89 d7                	mov    %edx,%edi
  800fce:	89 d6                	mov    %edx,%esi
  800fd0:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fd2:	5b                   	pop    %ebx
  800fd3:	5e                   	pop    %esi
  800fd4:	5f                   	pop    %edi
  800fd5:	5d                   	pop    %ebp
  800fd6:	c3                   	ret    

00800fd7 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	57                   	push   %edi
  800fdb:	56                   	push   %esi
  800fdc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 11 00 00 00       	mov    $0x11,%eax
  800fed:	89 df                	mov    %ebx,%edi
  800fef:	89 de                	mov    %ebx,%esi
  800ff1:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800ff3:	5b                   	pop    %ebx
  800ff4:	5e                   	pop    %esi
  800ff5:	5f                   	pop    %edi
  800ff6:	5d                   	pop    %ebp
  800ff7:	c3                   	ret    

00800ff8 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800ff8:	55                   	push   %ebp
  800ff9:	89 e5                	mov    %esp,%ebp
  800ffb:	57                   	push   %edi
  800ffc:	56                   	push   %esi
  800ffd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ffe:	bb 00 00 00 00       	mov    $0x0,%ebx
  801003:	8b 55 08             	mov    0x8(%ebp),%edx
  801006:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801009:	b8 12 00 00 00       	mov    $0x12,%eax
  80100e:	89 df                	mov    %ebx,%edi
  801010:	89 de                	mov    %ebx,%esi
  801012:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801014:	5b                   	pop    %ebx
  801015:	5e                   	pop    %esi
  801016:	5f                   	pop    %edi
  801017:	5d                   	pop    %ebp
  801018:	c3                   	ret    

00801019 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
  80101f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102d:	b8 13 00 00 00       	mov    $0x13,%eax
  801032:	89 df                	mov    %ebx,%edi
  801034:	89 de                	mov    %ebx,%esi
  801036:	cd 30                	int    $0x30
	if(check && ret > 0)
  801038:	85 c0                	test   %eax,%eax
  80103a:	7f 08                	jg     801044 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	50                   	push   %eax
  801048:	6a 13                	push   $0x13
  80104a:	68 44 29 80 00       	push   $0x802944
  80104f:	6a 43                	push   $0x43
  801051:	68 61 29 80 00       	push   $0x802961
  801056:	e8 56 11 00 00       	call   8021b1 <_panic>

0080105b <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	05 00 00 00 30       	add    $0x30000000,%eax
  801066:	c1 e8 0c             	shr    $0xc,%eax
}
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    

0080106b <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80106b:	55                   	push   %ebp
  80106c:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801076:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80107b:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801080:	5d                   	pop    %ebp
  801081:	c3                   	ret    

00801082 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80108a:	89 c2                	mov    %eax,%edx
  80108c:	c1 ea 16             	shr    $0x16,%edx
  80108f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801096:	f6 c2 01             	test   $0x1,%dl
  801099:	74 2d                	je     8010c8 <fd_alloc+0x46>
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	c1 ea 0c             	shr    $0xc,%edx
  8010a0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010a7:	f6 c2 01             	test   $0x1,%dl
  8010aa:	74 1c                	je     8010c8 <fd_alloc+0x46>
  8010ac:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010b1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010b6:	75 d2                	jne    80108a <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010c1:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010c6:	eb 0a                	jmp    8010d2 <fd_alloc+0x50>
			*fd_store = fd;
  8010c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cb:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d2:	5d                   	pop    %ebp
  8010d3:	c3                   	ret    

008010d4 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010da:	83 f8 1f             	cmp    $0x1f,%eax
  8010dd:	77 30                	ja     80110f <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010df:	c1 e0 0c             	shl    $0xc,%eax
  8010e2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010e7:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010ed:	f6 c2 01             	test   $0x1,%dl
  8010f0:	74 24                	je     801116 <fd_lookup+0x42>
  8010f2:	89 c2                	mov    %eax,%edx
  8010f4:	c1 ea 0c             	shr    $0xc,%edx
  8010f7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010fe:	f6 c2 01             	test   $0x1,%dl
  801101:	74 1a                	je     80111d <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801103:	8b 55 0c             	mov    0xc(%ebp),%edx
  801106:	89 02                	mov    %eax,(%edx)
	return 0;
  801108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110d:	5d                   	pop    %ebp
  80110e:	c3                   	ret    
		return -E_INVAL;
  80110f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801114:	eb f7                	jmp    80110d <fd_lookup+0x39>
		return -E_INVAL;
  801116:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111b:	eb f0                	jmp    80110d <fd_lookup+0x39>
  80111d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801122:	eb e9                	jmp    80110d <fd_lookup+0x39>

00801124 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80112d:	ba 00 00 00 00       	mov    $0x0,%edx
  801132:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801137:	39 08                	cmp    %ecx,(%eax)
  801139:	74 38                	je     801173 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80113b:	83 c2 01             	add    $0x1,%edx
  80113e:	8b 04 95 ec 29 80 00 	mov    0x8029ec(,%edx,4),%eax
  801145:	85 c0                	test   %eax,%eax
  801147:	75 ee                	jne    801137 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801149:	a1 08 40 80 00       	mov    0x804008,%eax
  80114e:	8b 40 48             	mov    0x48(%eax),%eax
  801151:	83 ec 04             	sub    $0x4,%esp
  801154:	51                   	push   %ecx
  801155:	50                   	push   %eax
  801156:	68 70 29 80 00       	push   $0x802970
  80115b:	e8 d5 f0 ff ff       	call   800235 <cprintf>
	*dev = 0;
  801160:	8b 45 0c             	mov    0xc(%ebp),%eax
  801163:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801169:	83 c4 10             	add    $0x10,%esp
  80116c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801171:	c9                   	leave  
  801172:	c3                   	ret    
			*dev = devtab[i];
  801173:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801176:	89 01                	mov    %eax,(%ecx)
			return 0;
  801178:	b8 00 00 00 00       	mov    $0x0,%eax
  80117d:	eb f2                	jmp    801171 <dev_lookup+0x4d>

0080117f <fd_close>:
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	57                   	push   %edi
  801183:	56                   	push   %esi
  801184:	53                   	push   %ebx
  801185:	83 ec 24             	sub    $0x24,%esp
  801188:	8b 75 08             	mov    0x8(%ebp),%esi
  80118b:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80118e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801191:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801192:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801198:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80119b:	50                   	push   %eax
  80119c:	e8 33 ff ff ff       	call   8010d4 <fd_lookup>
  8011a1:	89 c3                	mov    %eax,%ebx
  8011a3:	83 c4 10             	add    $0x10,%esp
  8011a6:	85 c0                	test   %eax,%eax
  8011a8:	78 05                	js     8011af <fd_close+0x30>
	    || fd != fd2)
  8011aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011ad:	74 16                	je     8011c5 <fd_close+0x46>
		return (must_exist ? r : 0);
  8011af:	89 f8                	mov    %edi,%eax
  8011b1:	84 c0                	test   %al,%al
  8011b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b8:	0f 44 d8             	cmove  %eax,%ebx
}
  8011bb:	89 d8                	mov    %ebx,%eax
  8011bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c0:	5b                   	pop    %ebx
  8011c1:	5e                   	pop    %esi
  8011c2:	5f                   	pop    %edi
  8011c3:	5d                   	pop    %ebp
  8011c4:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011c5:	83 ec 08             	sub    $0x8,%esp
  8011c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011cb:	50                   	push   %eax
  8011cc:	ff 36                	pushl  (%esi)
  8011ce:	e8 51 ff ff ff       	call   801124 <dev_lookup>
  8011d3:	89 c3                	mov    %eax,%ebx
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	78 1a                	js     8011f6 <fd_close+0x77>
		if (dev->dev_close)
  8011dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011df:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011e2:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011e7:	85 c0                	test   %eax,%eax
  8011e9:	74 0b                	je     8011f6 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011eb:	83 ec 0c             	sub    $0xc,%esp
  8011ee:	56                   	push   %esi
  8011ef:	ff d0                	call   *%eax
  8011f1:	89 c3                	mov    %eax,%ebx
  8011f3:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011f6:	83 ec 08             	sub    $0x8,%esp
  8011f9:	56                   	push   %esi
  8011fa:	6a 00                	push   $0x0
  8011fc:	e8 0a fc ff ff       	call   800e0b <sys_page_unmap>
	return r;
  801201:	83 c4 10             	add    $0x10,%esp
  801204:	eb b5                	jmp    8011bb <fd_close+0x3c>

00801206 <close>:

int
close(int fdnum)
{
  801206:	55                   	push   %ebp
  801207:	89 e5                	mov    %esp,%ebp
  801209:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80120c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80120f:	50                   	push   %eax
  801210:	ff 75 08             	pushl  0x8(%ebp)
  801213:	e8 bc fe ff ff       	call   8010d4 <fd_lookup>
  801218:	83 c4 10             	add    $0x10,%esp
  80121b:	85 c0                	test   %eax,%eax
  80121d:	79 02                	jns    801221 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  80121f:	c9                   	leave  
  801220:	c3                   	ret    
		return fd_close(fd, 1);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	6a 01                	push   $0x1
  801226:	ff 75 f4             	pushl  -0xc(%ebp)
  801229:	e8 51 ff ff ff       	call   80117f <fd_close>
  80122e:	83 c4 10             	add    $0x10,%esp
  801231:	eb ec                	jmp    80121f <close+0x19>

00801233 <close_all>:

void
close_all(void)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	53                   	push   %ebx
  801237:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80123a:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80123f:	83 ec 0c             	sub    $0xc,%esp
  801242:	53                   	push   %ebx
  801243:	e8 be ff ff ff       	call   801206 <close>
	for (i = 0; i < MAXFD; i++)
  801248:	83 c3 01             	add    $0x1,%ebx
  80124b:	83 c4 10             	add    $0x10,%esp
  80124e:	83 fb 20             	cmp    $0x20,%ebx
  801251:	75 ec                	jne    80123f <close_all+0xc>
}
  801253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801256:	c9                   	leave  
  801257:	c3                   	ret    

00801258 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801258:	55                   	push   %ebp
  801259:	89 e5                	mov    %esp,%ebp
  80125b:	57                   	push   %edi
  80125c:	56                   	push   %esi
  80125d:	53                   	push   %ebx
  80125e:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801261:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801264:	50                   	push   %eax
  801265:	ff 75 08             	pushl  0x8(%ebp)
  801268:	e8 67 fe ff ff       	call   8010d4 <fd_lookup>
  80126d:	89 c3                	mov    %eax,%ebx
  80126f:	83 c4 10             	add    $0x10,%esp
  801272:	85 c0                	test   %eax,%eax
  801274:	0f 88 81 00 00 00    	js     8012fb <dup+0xa3>
		return r;
	close(newfdnum);
  80127a:	83 ec 0c             	sub    $0xc,%esp
  80127d:	ff 75 0c             	pushl  0xc(%ebp)
  801280:	e8 81 ff ff ff       	call   801206 <close>

	newfd = INDEX2FD(newfdnum);
  801285:	8b 75 0c             	mov    0xc(%ebp),%esi
  801288:	c1 e6 0c             	shl    $0xc,%esi
  80128b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801291:	83 c4 04             	add    $0x4,%esp
  801294:	ff 75 e4             	pushl  -0x1c(%ebp)
  801297:	e8 cf fd ff ff       	call   80106b <fd2data>
  80129c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80129e:	89 34 24             	mov    %esi,(%esp)
  8012a1:	e8 c5 fd ff ff       	call   80106b <fd2data>
  8012a6:	83 c4 10             	add    $0x10,%esp
  8012a9:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012ab:	89 d8                	mov    %ebx,%eax
  8012ad:	c1 e8 16             	shr    $0x16,%eax
  8012b0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012b7:	a8 01                	test   $0x1,%al
  8012b9:	74 11                	je     8012cc <dup+0x74>
  8012bb:	89 d8                	mov    %ebx,%eax
  8012bd:	c1 e8 0c             	shr    $0xc,%eax
  8012c0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012c7:	f6 c2 01             	test   $0x1,%dl
  8012ca:	75 39                	jne    801305 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012cc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012cf:	89 d0                	mov    %edx,%eax
  8012d1:	c1 e8 0c             	shr    $0xc,%eax
  8012d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012db:	83 ec 0c             	sub    $0xc,%esp
  8012de:	25 07 0e 00 00       	and    $0xe07,%eax
  8012e3:	50                   	push   %eax
  8012e4:	56                   	push   %esi
  8012e5:	6a 00                	push   $0x0
  8012e7:	52                   	push   %edx
  8012e8:	6a 00                	push   $0x0
  8012ea:	e8 da fa ff ff       	call   800dc9 <sys_page_map>
  8012ef:	89 c3                	mov    %eax,%ebx
  8012f1:	83 c4 20             	add    $0x20,%esp
  8012f4:	85 c0                	test   %eax,%eax
  8012f6:	78 31                	js     801329 <dup+0xd1>
		goto err;

	return newfdnum;
  8012f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012fb:	89 d8                	mov    %ebx,%eax
  8012fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5f                   	pop    %edi
  801303:	5d                   	pop    %ebp
  801304:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801305:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80130c:	83 ec 0c             	sub    $0xc,%esp
  80130f:	25 07 0e 00 00       	and    $0xe07,%eax
  801314:	50                   	push   %eax
  801315:	57                   	push   %edi
  801316:	6a 00                	push   $0x0
  801318:	53                   	push   %ebx
  801319:	6a 00                	push   $0x0
  80131b:	e8 a9 fa ff ff       	call   800dc9 <sys_page_map>
  801320:	89 c3                	mov    %eax,%ebx
  801322:	83 c4 20             	add    $0x20,%esp
  801325:	85 c0                	test   %eax,%eax
  801327:	79 a3                	jns    8012cc <dup+0x74>
	sys_page_unmap(0, newfd);
  801329:	83 ec 08             	sub    $0x8,%esp
  80132c:	56                   	push   %esi
  80132d:	6a 00                	push   $0x0
  80132f:	e8 d7 fa ff ff       	call   800e0b <sys_page_unmap>
	sys_page_unmap(0, nva);
  801334:	83 c4 08             	add    $0x8,%esp
  801337:	57                   	push   %edi
  801338:	6a 00                	push   $0x0
  80133a:	e8 cc fa ff ff       	call   800e0b <sys_page_unmap>
	return r;
  80133f:	83 c4 10             	add    $0x10,%esp
  801342:	eb b7                	jmp    8012fb <dup+0xa3>

00801344 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801344:	55                   	push   %ebp
  801345:	89 e5                	mov    %esp,%ebp
  801347:	53                   	push   %ebx
  801348:	83 ec 1c             	sub    $0x1c,%esp
  80134b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80134e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801351:	50                   	push   %eax
  801352:	53                   	push   %ebx
  801353:	e8 7c fd ff ff       	call   8010d4 <fd_lookup>
  801358:	83 c4 10             	add    $0x10,%esp
  80135b:	85 c0                	test   %eax,%eax
  80135d:	78 3f                	js     80139e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80135f:	83 ec 08             	sub    $0x8,%esp
  801362:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801365:	50                   	push   %eax
  801366:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801369:	ff 30                	pushl  (%eax)
  80136b:	e8 b4 fd ff ff       	call   801124 <dev_lookup>
  801370:	83 c4 10             	add    $0x10,%esp
  801373:	85 c0                	test   %eax,%eax
  801375:	78 27                	js     80139e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801377:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80137a:	8b 42 08             	mov    0x8(%edx),%eax
  80137d:	83 e0 03             	and    $0x3,%eax
  801380:	83 f8 01             	cmp    $0x1,%eax
  801383:	74 1e                	je     8013a3 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801388:	8b 40 08             	mov    0x8(%eax),%eax
  80138b:	85 c0                	test   %eax,%eax
  80138d:	74 35                	je     8013c4 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80138f:	83 ec 04             	sub    $0x4,%esp
  801392:	ff 75 10             	pushl  0x10(%ebp)
  801395:	ff 75 0c             	pushl  0xc(%ebp)
  801398:	52                   	push   %edx
  801399:	ff d0                	call   *%eax
  80139b:	83 c4 10             	add    $0x10,%esp
}
  80139e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a1:	c9                   	leave  
  8013a2:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013a3:	a1 08 40 80 00       	mov    0x804008,%eax
  8013a8:	8b 40 48             	mov    0x48(%eax),%eax
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	53                   	push   %ebx
  8013af:	50                   	push   %eax
  8013b0:	68 b1 29 80 00       	push   $0x8029b1
  8013b5:	e8 7b ee ff ff       	call   800235 <cprintf>
		return -E_INVAL;
  8013ba:	83 c4 10             	add    $0x10,%esp
  8013bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c2:	eb da                	jmp    80139e <read+0x5a>
		return -E_NOT_SUPP;
  8013c4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c9:	eb d3                	jmp    80139e <read+0x5a>

008013cb <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	57                   	push   %edi
  8013cf:	56                   	push   %esi
  8013d0:	53                   	push   %ebx
  8013d1:	83 ec 0c             	sub    $0xc,%esp
  8013d4:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013d7:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013df:	39 f3                	cmp    %esi,%ebx
  8013e1:	73 23                	jae    801406 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013e3:	83 ec 04             	sub    $0x4,%esp
  8013e6:	89 f0                	mov    %esi,%eax
  8013e8:	29 d8                	sub    %ebx,%eax
  8013ea:	50                   	push   %eax
  8013eb:	89 d8                	mov    %ebx,%eax
  8013ed:	03 45 0c             	add    0xc(%ebp),%eax
  8013f0:	50                   	push   %eax
  8013f1:	57                   	push   %edi
  8013f2:	e8 4d ff ff ff       	call   801344 <read>
		if (m < 0)
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 06                	js     801404 <readn+0x39>
			return m;
		if (m == 0)
  8013fe:	74 06                	je     801406 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801400:	01 c3                	add    %eax,%ebx
  801402:	eb db                	jmp    8013df <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801404:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801406:	89 d8                	mov    %ebx,%eax
  801408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80140b:	5b                   	pop    %ebx
  80140c:	5e                   	pop    %esi
  80140d:	5f                   	pop    %edi
  80140e:	5d                   	pop    %ebp
  80140f:	c3                   	ret    

00801410 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	53                   	push   %ebx
  801414:	83 ec 1c             	sub    $0x1c,%esp
  801417:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80141a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141d:	50                   	push   %eax
  80141e:	53                   	push   %ebx
  80141f:	e8 b0 fc ff ff       	call   8010d4 <fd_lookup>
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 3a                	js     801465 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801431:	50                   	push   %eax
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	ff 30                	pushl  (%eax)
  801437:	e8 e8 fc ff ff       	call   801124 <dev_lookup>
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 22                	js     801465 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801443:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801446:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80144a:	74 1e                	je     80146a <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80144c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144f:	8b 52 0c             	mov    0xc(%edx),%edx
  801452:	85 d2                	test   %edx,%edx
  801454:	74 35                	je     80148b <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	ff 75 10             	pushl  0x10(%ebp)
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	50                   	push   %eax
  801460:	ff d2                	call   *%edx
  801462:	83 c4 10             	add    $0x10,%esp
}
  801465:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801468:	c9                   	leave  
  801469:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80146a:	a1 08 40 80 00       	mov    0x804008,%eax
  80146f:	8b 40 48             	mov    0x48(%eax),%eax
  801472:	83 ec 04             	sub    $0x4,%esp
  801475:	53                   	push   %ebx
  801476:	50                   	push   %eax
  801477:	68 cd 29 80 00       	push   $0x8029cd
  80147c:	e8 b4 ed ff ff       	call   800235 <cprintf>
		return -E_INVAL;
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801489:	eb da                	jmp    801465 <write+0x55>
		return -E_NOT_SUPP;
  80148b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801490:	eb d3                	jmp    801465 <write+0x55>

00801492 <seek>:

int
seek(int fdnum, off_t offset)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801498:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80149b:	50                   	push   %eax
  80149c:	ff 75 08             	pushl  0x8(%ebp)
  80149f:	e8 30 fc ff ff       	call   8010d4 <fd_lookup>
  8014a4:	83 c4 10             	add    $0x10,%esp
  8014a7:	85 c0                	test   %eax,%eax
  8014a9:	78 0e                	js     8014b9 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b1:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    

008014bb <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	53                   	push   %ebx
  8014bf:	83 ec 1c             	sub    $0x1c,%esp
  8014c2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014c5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014c8:	50                   	push   %eax
  8014c9:	53                   	push   %ebx
  8014ca:	e8 05 fc ff ff       	call   8010d4 <fd_lookup>
  8014cf:	83 c4 10             	add    $0x10,%esp
  8014d2:	85 c0                	test   %eax,%eax
  8014d4:	78 37                	js     80150d <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014d6:	83 ec 08             	sub    $0x8,%esp
  8014d9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014dc:	50                   	push   %eax
  8014dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e0:	ff 30                	pushl  (%eax)
  8014e2:	e8 3d fc ff ff       	call   801124 <dev_lookup>
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 1f                	js     80150d <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014f5:	74 1b                	je     801512 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014fa:	8b 52 18             	mov    0x18(%edx),%edx
  8014fd:	85 d2                	test   %edx,%edx
  8014ff:	74 32                	je     801533 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801501:	83 ec 08             	sub    $0x8,%esp
  801504:	ff 75 0c             	pushl  0xc(%ebp)
  801507:	50                   	push   %eax
  801508:	ff d2                	call   *%edx
  80150a:	83 c4 10             	add    $0x10,%esp
}
  80150d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801510:	c9                   	leave  
  801511:	c3                   	ret    
			thisenv->env_id, fdnum);
  801512:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801517:	8b 40 48             	mov    0x48(%eax),%eax
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	53                   	push   %ebx
  80151e:	50                   	push   %eax
  80151f:	68 90 29 80 00       	push   $0x802990
  801524:	e8 0c ed ff ff       	call   800235 <cprintf>
		return -E_INVAL;
  801529:	83 c4 10             	add    $0x10,%esp
  80152c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801531:	eb da                	jmp    80150d <ftruncate+0x52>
		return -E_NOT_SUPP;
  801533:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801538:	eb d3                	jmp    80150d <ftruncate+0x52>

0080153a <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80153a:	55                   	push   %ebp
  80153b:	89 e5                	mov    %esp,%ebp
  80153d:	53                   	push   %ebx
  80153e:	83 ec 1c             	sub    $0x1c,%esp
  801541:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801544:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801547:	50                   	push   %eax
  801548:	ff 75 08             	pushl  0x8(%ebp)
  80154b:	e8 84 fb ff ff       	call   8010d4 <fd_lookup>
  801550:	83 c4 10             	add    $0x10,%esp
  801553:	85 c0                	test   %eax,%eax
  801555:	78 4b                	js     8015a2 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801557:	83 ec 08             	sub    $0x8,%esp
  80155a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155d:	50                   	push   %eax
  80155e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801561:	ff 30                	pushl  (%eax)
  801563:	e8 bc fb ff ff       	call   801124 <dev_lookup>
  801568:	83 c4 10             	add    $0x10,%esp
  80156b:	85 c0                	test   %eax,%eax
  80156d:	78 33                	js     8015a2 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80156f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801572:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801576:	74 2f                	je     8015a7 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801578:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80157b:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801582:	00 00 00 
	stat->st_isdir = 0;
  801585:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80158c:	00 00 00 
	stat->st_dev = dev;
  80158f:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801595:	83 ec 08             	sub    $0x8,%esp
  801598:	53                   	push   %ebx
  801599:	ff 75 f0             	pushl  -0x10(%ebp)
  80159c:	ff 50 14             	call   *0x14(%eax)
  80159f:	83 c4 10             	add    $0x10,%esp
}
  8015a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a5:	c9                   	leave  
  8015a6:	c3                   	ret    
		return -E_NOT_SUPP;
  8015a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ac:	eb f4                	jmp    8015a2 <fstat+0x68>

008015ae <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	56                   	push   %esi
  8015b2:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015b3:	83 ec 08             	sub    $0x8,%esp
  8015b6:	6a 00                	push   $0x0
  8015b8:	ff 75 08             	pushl  0x8(%ebp)
  8015bb:	e8 22 02 00 00       	call   8017e2 <open>
  8015c0:	89 c3                	mov    %eax,%ebx
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 1b                	js     8015e4 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015c9:	83 ec 08             	sub    $0x8,%esp
  8015cc:	ff 75 0c             	pushl  0xc(%ebp)
  8015cf:	50                   	push   %eax
  8015d0:	e8 65 ff ff ff       	call   80153a <fstat>
  8015d5:	89 c6                	mov    %eax,%esi
	close(fd);
  8015d7:	89 1c 24             	mov    %ebx,(%esp)
  8015da:	e8 27 fc ff ff       	call   801206 <close>
	return r;
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 f3                	mov    %esi,%ebx
}
  8015e4:	89 d8                	mov    %ebx,%eax
  8015e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015e9:	5b                   	pop    %ebx
  8015ea:	5e                   	pop    %esi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	89 c6                	mov    %eax,%esi
  8015f4:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015f6:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015fd:	74 27                	je     801626 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ff:	6a 07                	push   $0x7
  801601:	68 00 50 80 00       	push   $0x805000
  801606:	56                   	push   %esi
  801607:	ff 35 00 40 80 00    	pushl  0x804000
  80160d:	e8 69 0c 00 00       	call   80227b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801612:	83 c4 0c             	add    $0xc,%esp
  801615:	6a 00                	push   $0x0
  801617:	53                   	push   %ebx
  801618:	6a 00                	push   $0x0
  80161a:	e8 f3 0b 00 00       	call   802212 <ipc_recv>
}
  80161f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801622:	5b                   	pop    %ebx
  801623:	5e                   	pop    %esi
  801624:	5d                   	pop    %ebp
  801625:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801626:	83 ec 0c             	sub    $0xc,%esp
  801629:	6a 01                	push   $0x1
  80162b:	e8 a3 0c 00 00       	call   8022d3 <ipc_find_env>
  801630:	a3 00 40 80 00       	mov    %eax,0x804000
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	eb c5                	jmp    8015ff <fsipc+0x12>

0080163a <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80163a:	55                   	push   %ebp
  80163b:	89 e5                	mov    %esp,%ebp
  80163d:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8b 40 0c             	mov    0xc(%eax),%eax
  801646:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801653:	ba 00 00 00 00       	mov    $0x0,%edx
  801658:	b8 02 00 00 00       	mov    $0x2,%eax
  80165d:	e8 8b ff ff ff       	call   8015ed <fsipc>
}
  801662:	c9                   	leave  
  801663:	c3                   	ret    

00801664 <devfile_flush>:
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80166a:	8b 45 08             	mov    0x8(%ebp),%eax
  80166d:	8b 40 0c             	mov    0xc(%eax),%eax
  801670:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801675:	ba 00 00 00 00       	mov    $0x0,%edx
  80167a:	b8 06 00 00 00       	mov    $0x6,%eax
  80167f:	e8 69 ff ff ff       	call   8015ed <fsipc>
}
  801684:	c9                   	leave  
  801685:	c3                   	ret    

00801686 <devfile_stat>:
{
  801686:	55                   	push   %ebp
  801687:	89 e5                	mov    %esp,%ebp
  801689:	53                   	push   %ebx
  80168a:	83 ec 04             	sub    $0x4,%esp
  80168d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8b 40 0c             	mov    0xc(%eax),%eax
  801696:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80169b:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8016a5:	e8 43 ff ff ff       	call   8015ed <fsipc>
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 2c                	js     8016da <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	68 00 50 80 00       	push   $0x805000
  8016b6:	53                   	push   %ebx
  8016b7:	e8 d8 f2 ff ff       	call   800994 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016bc:	a1 80 50 80 00       	mov    0x805080,%eax
  8016c1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016c7:	a1 84 50 80 00       	mov    0x805084,%eax
  8016cc:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016dd:	c9                   	leave  
  8016de:	c3                   	ret    

008016df <devfile_write>:
{
  8016df:	55                   	push   %ebp
  8016e0:	89 e5                	mov    %esp,%ebp
  8016e2:	53                   	push   %ebx
  8016e3:	83 ec 08             	sub    $0x8,%esp
  8016e6:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ef:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016f4:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016fa:	53                   	push   %ebx
  8016fb:	ff 75 0c             	pushl  0xc(%ebp)
  8016fe:	68 08 50 80 00       	push   $0x805008
  801703:	e8 7c f4 ff ff       	call   800b84 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801708:	ba 00 00 00 00       	mov    $0x0,%edx
  80170d:	b8 04 00 00 00       	mov    $0x4,%eax
  801712:	e8 d6 fe ff ff       	call   8015ed <fsipc>
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	85 c0                	test   %eax,%eax
  80171c:	78 0b                	js     801729 <devfile_write+0x4a>
	assert(r <= n);
  80171e:	39 d8                	cmp    %ebx,%eax
  801720:	77 0c                	ja     80172e <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801722:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801727:	7f 1e                	jg     801747 <devfile_write+0x68>
}
  801729:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    
	assert(r <= n);
  80172e:	68 00 2a 80 00       	push   $0x802a00
  801733:	68 07 2a 80 00       	push   $0x802a07
  801738:	68 98 00 00 00       	push   $0x98
  80173d:	68 1c 2a 80 00       	push   $0x802a1c
  801742:	e8 6a 0a 00 00       	call   8021b1 <_panic>
	assert(r <= PGSIZE);
  801747:	68 27 2a 80 00       	push   $0x802a27
  80174c:	68 07 2a 80 00       	push   $0x802a07
  801751:	68 99 00 00 00       	push   $0x99
  801756:	68 1c 2a 80 00       	push   $0x802a1c
  80175b:	e8 51 0a 00 00       	call   8021b1 <_panic>

00801760 <devfile_read>:
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	56                   	push   %esi
  801764:	53                   	push   %ebx
  801765:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	8b 40 0c             	mov    0xc(%eax),%eax
  80176e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801773:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801779:	ba 00 00 00 00       	mov    $0x0,%edx
  80177e:	b8 03 00 00 00       	mov    $0x3,%eax
  801783:	e8 65 fe ff ff       	call   8015ed <fsipc>
  801788:	89 c3                	mov    %eax,%ebx
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 1f                	js     8017ad <devfile_read+0x4d>
	assert(r <= n);
  80178e:	39 f0                	cmp    %esi,%eax
  801790:	77 24                	ja     8017b6 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801792:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801797:	7f 33                	jg     8017cc <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	50                   	push   %eax
  80179d:	68 00 50 80 00       	push   $0x805000
  8017a2:	ff 75 0c             	pushl  0xc(%ebp)
  8017a5:	e8 78 f3 ff ff       	call   800b22 <memmove>
	return r;
  8017aa:	83 c4 10             	add    $0x10,%esp
}
  8017ad:	89 d8                	mov    %ebx,%eax
  8017af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b2:	5b                   	pop    %ebx
  8017b3:	5e                   	pop    %esi
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    
	assert(r <= n);
  8017b6:	68 00 2a 80 00       	push   $0x802a00
  8017bb:	68 07 2a 80 00       	push   $0x802a07
  8017c0:	6a 7c                	push   $0x7c
  8017c2:	68 1c 2a 80 00       	push   $0x802a1c
  8017c7:	e8 e5 09 00 00       	call   8021b1 <_panic>
	assert(r <= PGSIZE);
  8017cc:	68 27 2a 80 00       	push   $0x802a27
  8017d1:	68 07 2a 80 00       	push   $0x802a07
  8017d6:	6a 7d                	push   $0x7d
  8017d8:	68 1c 2a 80 00       	push   $0x802a1c
  8017dd:	e8 cf 09 00 00       	call   8021b1 <_panic>

008017e2 <open>:
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	56                   	push   %esi
  8017e6:	53                   	push   %ebx
  8017e7:	83 ec 1c             	sub    $0x1c,%esp
  8017ea:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ed:	56                   	push   %esi
  8017ee:	e8 68 f1 ff ff       	call   80095b <strlen>
  8017f3:	83 c4 10             	add    $0x10,%esp
  8017f6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017fb:	7f 6c                	jg     801869 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017fd:	83 ec 0c             	sub    $0xc,%esp
  801800:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801803:	50                   	push   %eax
  801804:	e8 79 f8 ff ff       	call   801082 <fd_alloc>
  801809:	89 c3                	mov    %eax,%ebx
  80180b:	83 c4 10             	add    $0x10,%esp
  80180e:	85 c0                	test   %eax,%eax
  801810:	78 3c                	js     80184e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	56                   	push   %esi
  801816:	68 00 50 80 00       	push   $0x805000
  80181b:	e8 74 f1 ff ff       	call   800994 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801820:	8b 45 0c             	mov    0xc(%ebp),%eax
  801823:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801828:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80182b:	b8 01 00 00 00       	mov    $0x1,%eax
  801830:	e8 b8 fd ff ff       	call   8015ed <fsipc>
  801835:	89 c3                	mov    %eax,%ebx
  801837:	83 c4 10             	add    $0x10,%esp
  80183a:	85 c0                	test   %eax,%eax
  80183c:	78 19                	js     801857 <open+0x75>
	return fd2num(fd);
  80183e:	83 ec 0c             	sub    $0xc,%esp
  801841:	ff 75 f4             	pushl  -0xc(%ebp)
  801844:	e8 12 f8 ff ff       	call   80105b <fd2num>
  801849:	89 c3                	mov    %eax,%ebx
  80184b:	83 c4 10             	add    $0x10,%esp
}
  80184e:	89 d8                	mov    %ebx,%eax
  801850:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801853:	5b                   	pop    %ebx
  801854:	5e                   	pop    %esi
  801855:	5d                   	pop    %ebp
  801856:	c3                   	ret    
		fd_close(fd, 0);
  801857:	83 ec 08             	sub    $0x8,%esp
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 f4             	pushl  -0xc(%ebp)
  80185f:	e8 1b f9 ff ff       	call   80117f <fd_close>
		return r;
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	eb e5                	jmp    80184e <open+0x6c>
		return -E_BAD_PATH;
  801869:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80186e:	eb de                	jmp    80184e <open+0x6c>

00801870 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801876:	ba 00 00 00 00       	mov    $0x0,%edx
  80187b:	b8 08 00 00 00       	mov    $0x8,%eax
  801880:	e8 68 fd ff ff       	call   8015ed <fsipc>
}
  801885:	c9                   	leave  
  801886:	c3                   	ret    

00801887 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80188d:	68 33 2a 80 00       	push   $0x802a33
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	e8 fa f0 ff ff       	call   800994 <strcpy>
	return 0;
}
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <devsock_close>:
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	53                   	push   %ebx
  8018a5:	83 ec 10             	sub    $0x10,%esp
  8018a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018ab:	53                   	push   %ebx
  8018ac:	e8 5d 0a 00 00       	call   80230e <pageref>
  8018b1:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018b4:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018b9:	83 f8 01             	cmp    $0x1,%eax
  8018bc:	74 07                	je     8018c5 <devsock_close+0x24>
}
  8018be:	89 d0                	mov    %edx,%eax
  8018c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018c3:	c9                   	leave  
  8018c4:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018c5:	83 ec 0c             	sub    $0xc,%esp
  8018c8:	ff 73 0c             	pushl  0xc(%ebx)
  8018cb:	e8 b9 02 00 00       	call   801b89 <nsipc_close>
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	83 c4 10             	add    $0x10,%esp
  8018d5:	eb e7                	jmp    8018be <devsock_close+0x1d>

008018d7 <devsock_write>:
{
  8018d7:	55                   	push   %ebp
  8018d8:	89 e5                	mov    %esp,%ebp
  8018da:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018dd:	6a 00                	push   $0x0
  8018df:	ff 75 10             	pushl  0x10(%ebp)
  8018e2:	ff 75 0c             	pushl  0xc(%ebp)
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e8:	ff 70 0c             	pushl  0xc(%eax)
  8018eb:	e8 76 03 00 00       	call   801c66 <nsipc_send>
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <devsock_read>:
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018f8:	6a 00                	push   $0x0
  8018fa:	ff 75 10             	pushl  0x10(%ebp)
  8018fd:	ff 75 0c             	pushl  0xc(%ebp)
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	ff 70 0c             	pushl  0xc(%eax)
  801906:	e8 ef 02 00 00       	call   801bfa <nsipc_recv>
}
  80190b:	c9                   	leave  
  80190c:	c3                   	ret    

0080190d <fd2sockid>:
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801913:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801916:	52                   	push   %edx
  801917:	50                   	push   %eax
  801918:	e8 b7 f7 ff ff       	call   8010d4 <fd_lookup>
  80191d:	83 c4 10             	add    $0x10,%esp
  801920:	85 c0                	test   %eax,%eax
  801922:	78 10                	js     801934 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801927:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80192d:	39 08                	cmp    %ecx,(%eax)
  80192f:	75 05                	jne    801936 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801931:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    
		return -E_NOT_SUPP;
  801936:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80193b:	eb f7                	jmp    801934 <fd2sockid+0x27>

0080193d <alloc_sockfd>:
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	56                   	push   %esi
  801941:	53                   	push   %ebx
  801942:	83 ec 1c             	sub    $0x1c,%esp
  801945:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801947:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194a:	50                   	push   %eax
  80194b:	e8 32 f7 ff ff       	call   801082 <fd_alloc>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	85 c0                	test   %eax,%eax
  801957:	78 43                	js     80199c <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	68 07 04 00 00       	push   $0x407
  801961:	ff 75 f4             	pushl  -0xc(%ebp)
  801964:	6a 00                	push   $0x0
  801966:	e8 1b f4 ff ff       	call   800d86 <sys_page_alloc>
  80196b:	89 c3                	mov    %eax,%ebx
  80196d:	83 c4 10             	add    $0x10,%esp
  801970:	85 c0                	test   %eax,%eax
  801972:	78 28                	js     80199c <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801977:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80197d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80197f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801982:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801989:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80198c:	83 ec 0c             	sub    $0xc,%esp
  80198f:	50                   	push   %eax
  801990:	e8 c6 f6 ff ff       	call   80105b <fd2num>
  801995:	89 c3                	mov    %eax,%ebx
  801997:	83 c4 10             	add    $0x10,%esp
  80199a:	eb 0c                	jmp    8019a8 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80199c:	83 ec 0c             	sub    $0xc,%esp
  80199f:	56                   	push   %esi
  8019a0:	e8 e4 01 00 00       	call   801b89 <nsipc_close>
		return r;
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	89 d8                	mov    %ebx,%eax
  8019aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ad:	5b                   	pop    %ebx
  8019ae:	5e                   	pop    %esi
  8019af:	5d                   	pop    %ebp
  8019b0:	c3                   	ret    

008019b1 <accept>:
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	e8 4e ff ff ff       	call   80190d <fd2sockid>
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	78 1b                	js     8019de <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	ff 75 10             	pushl  0x10(%ebp)
  8019c9:	ff 75 0c             	pushl  0xc(%ebp)
  8019cc:	50                   	push   %eax
  8019cd:	e8 0e 01 00 00       	call   801ae0 <nsipc_accept>
  8019d2:	83 c4 10             	add    $0x10,%esp
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	78 05                	js     8019de <accept+0x2d>
	return alloc_sockfd(r);
  8019d9:	e8 5f ff ff ff       	call   80193d <alloc_sockfd>
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <bind>:
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	e8 1f ff ff ff       	call   80190d <fd2sockid>
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 12                	js     801a04 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	ff 75 10             	pushl  0x10(%ebp)
  8019f8:	ff 75 0c             	pushl  0xc(%ebp)
  8019fb:	50                   	push   %eax
  8019fc:	e8 31 01 00 00       	call   801b32 <nsipc_bind>
  801a01:	83 c4 10             	add    $0x10,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <shutdown>:
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0f:	e8 f9 fe ff ff       	call   80190d <fd2sockid>
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 0f                	js     801a27 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a18:	83 ec 08             	sub    $0x8,%esp
  801a1b:	ff 75 0c             	pushl  0xc(%ebp)
  801a1e:	50                   	push   %eax
  801a1f:	e8 43 01 00 00       	call   801b67 <nsipc_shutdown>
  801a24:	83 c4 10             	add    $0x10,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <connect>:
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a32:	e8 d6 fe ff ff       	call   80190d <fd2sockid>
  801a37:	85 c0                	test   %eax,%eax
  801a39:	78 12                	js     801a4d <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a3b:	83 ec 04             	sub    $0x4,%esp
  801a3e:	ff 75 10             	pushl  0x10(%ebp)
  801a41:	ff 75 0c             	pushl  0xc(%ebp)
  801a44:	50                   	push   %eax
  801a45:	e8 59 01 00 00       	call   801ba3 <nsipc_connect>
  801a4a:	83 c4 10             	add    $0x10,%esp
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <listen>:
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	e8 b0 fe ff ff       	call   80190d <fd2sockid>
  801a5d:	85 c0                	test   %eax,%eax
  801a5f:	78 0f                	js     801a70 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a61:	83 ec 08             	sub    $0x8,%esp
  801a64:	ff 75 0c             	pushl  0xc(%ebp)
  801a67:	50                   	push   %eax
  801a68:	e8 6b 01 00 00       	call   801bd8 <nsipc_listen>
  801a6d:	83 c4 10             	add    $0x10,%esp
}
  801a70:	c9                   	leave  
  801a71:	c3                   	ret    

00801a72 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a72:	55                   	push   %ebp
  801a73:	89 e5                	mov    %esp,%ebp
  801a75:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a78:	ff 75 10             	pushl  0x10(%ebp)
  801a7b:	ff 75 0c             	pushl  0xc(%ebp)
  801a7e:	ff 75 08             	pushl  0x8(%ebp)
  801a81:	e8 3e 02 00 00       	call   801cc4 <nsipc_socket>
  801a86:	83 c4 10             	add    $0x10,%esp
  801a89:	85 c0                	test   %eax,%eax
  801a8b:	78 05                	js     801a92 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a8d:	e8 ab fe ff ff       	call   80193d <alloc_sockfd>
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	53                   	push   %ebx
  801a98:	83 ec 04             	sub    $0x4,%esp
  801a9b:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a9d:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aa4:	74 26                	je     801acc <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aa6:	6a 07                	push   $0x7
  801aa8:	68 00 60 80 00       	push   $0x806000
  801aad:	53                   	push   %ebx
  801aae:	ff 35 04 40 80 00    	pushl  0x804004
  801ab4:	e8 c2 07 00 00       	call   80227b <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ab9:	83 c4 0c             	add    $0xc,%esp
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	e8 4b 07 00 00       	call   802212 <ipc_recv>
}
  801ac7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801acc:	83 ec 0c             	sub    $0xc,%esp
  801acf:	6a 02                	push   $0x2
  801ad1:	e8 fd 07 00 00       	call   8022d3 <ipc_find_env>
  801ad6:	a3 04 40 80 00       	mov    %eax,0x804004
  801adb:	83 c4 10             	add    $0x10,%esp
  801ade:	eb c6                	jmp    801aa6 <nsipc+0x12>

00801ae0 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	56                   	push   %esi
  801ae4:	53                   	push   %ebx
  801ae5:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aeb:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801af0:	8b 06                	mov    (%esi),%eax
  801af2:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801af7:	b8 01 00 00 00       	mov    $0x1,%eax
  801afc:	e8 93 ff ff ff       	call   801a94 <nsipc>
  801b01:	89 c3                	mov    %eax,%ebx
  801b03:	85 c0                	test   %eax,%eax
  801b05:	79 09                	jns    801b10 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b07:	89 d8                	mov    %ebx,%eax
  801b09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0c:	5b                   	pop    %ebx
  801b0d:	5e                   	pop    %esi
  801b0e:	5d                   	pop    %ebp
  801b0f:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b10:	83 ec 04             	sub    $0x4,%esp
  801b13:	ff 35 10 60 80 00    	pushl  0x806010
  801b19:	68 00 60 80 00       	push   $0x806000
  801b1e:	ff 75 0c             	pushl  0xc(%ebp)
  801b21:	e8 fc ef ff ff       	call   800b22 <memmove>
		*addrlen = ret->ret_addrlen;
  801b26:	a1 10 60 80 00       	mov    0x806010,%eax
  801b2b:	89 06                	mov    %eax,(%esi)
  801b2d:	83 c4 10             	add    $0x10,%esp
	return r;
  801b30:	eb d5                	jmp    801b07 <nsipc_accept+0x27>

00801b32 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
  801b35:	53                   	push   %ebx
  801b36:	83 ec 08             	sub    $0x8,%esp
  801b39:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3f:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b44:	53                   	push   %ebx
  801b45:	ff 75 0c             	pushl  0xc(%ebp)
  801b48:	68 04 60 80 00       	push   $0x806004
  801b4d:	e8 d0 ef ff ff       	call   800b22 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b52:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b58:	b8 02 00 00 00       	mov    $0x2,%eax
  801b5d:	e8 32 ff ff ff       	call   801a94 <nsipc>
}
  801b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
  801b6a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b75:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b78:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b7d:	b8 03 00 00 00       	mov    $0x3,%eax
  801b82:	e8 0d ff ff ff       	call   801a94 <nsipc>
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    

00801b89 <nsipc_close>:

int
nsipc_close(int s)
{
  801b89:	55                   	push   %ebp
  801b8a:	89 e5                	mov    %esp,%ebp
  801b8c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b92:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b97:	b8 04 00 00 00       	mov    $0x4,%eax
  801b9c:	e8 f3 fe ff ff       	call   801a94 <nsipc>
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 08             	sub    $0x8,%esp
  801baa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bb5:	53                   	push   %ebx
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	68 04 60 80 00       	push   $0x806004
  801bbe:	e8 5f ef ff ff       	call   800b22 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bc3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bc9:	b8 05 00 00 00       	mov    $0x5,%eax
  801bce:	e8 c1 fe ff ff       	call   801a94 <nsipc>
}
  801bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bee:	b8 06 00 00 00       	mov    $0x6,%eax
  801bf3:	e8 9c fe ff ff       	call   801a94 <nsipc>
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	56                   	push   %esi
  801bfe:	53                   	push   %ebx
  801bff:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c0a:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c10:	8b 45 14             	mov    0x14(%ebp),%eax
  801c13:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c18:	b8 07 00 00 00       	mov    $0x7,%eax
  801c1d:	e8 72 fe ff ff       	call   801a94 <nsipc>
  801c22:	89 c3                	mov    %eax,%ebx
  801c24:	85 c0                	test   %eax,%eax
  801c26:	78 1f                	js     801c47 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c28:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c2d:	7f 21                	jg     801c50 <nsipc_recv+0x56>
  801c2f:	39 c6                	cmp    %eax,%esi
  801c31:	7c 1d                	jl     801c50 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c33:	83 ec 04             	sub    $0x4,%esp
  801c36:	50                   	push   %eax
  801c37:	68 00 60 80 00       	push   $0x806000
  801c3c:	ff 75 0c             	pushl  0xc(%ebp)
  801c3f:	e8 de ee ff ff       	call   800b22 <memmove>
  801c44:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c47:	89 d8                	mov    %ebx,%eax
  801c49:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c4c:	5b                   	pop    %ebx
  801c4d:	5e                   	pop    %esi
  801c4e:	5d                   	pop    %ebp
  801c4f:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c50:	68 3f 2a 80 00       	push   $0x802a3f
  801c55:	68 07 2a 80 00       	push   $0x802a07
  801c5a:	6a 62                	push   $0x62
  801c5c:	68 54 2a 80 00       	push   $0x802a54
  801c61:	e8 4b 05 00 00       	call   8021b1 <_panic>

00801c66 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c66:	55                   	push   %ebp
  801c67:	89 e5                	mov    %esp,%ebp
  801c69:	53                   	push   %ebx
  801c6a:	83 ec 04             	sub    $0x4,%esp
  801c6d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c70:	8b 45 08             	mov    0x8(%ebp),%eax
  801c73:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c78:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c7e:	7f 2e                	jg     801cae <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c80:	83 ec 04             	sub    $0x4,%esp
  801c83:	53                   	push   %ebx
  801c84:	ff 75 0c             	pushl  0xc(%ebp)
  801c87:	68 0c 60 80 00       	push   $0x80600c
  801c8c:	e8 91 ee ff ff       	call   800b22 <memmove>
	nsipcbuf.send.req_size = size;
  801c91:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c97:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9a:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c9f:	b8 08 00 00 00       	mov    $0x8,%eax
  801ca4:	e8 eb fd ff ff       	call   801a94 <nsipc>
}
  801ca9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cac:	c9                   	leave  
  801cad:	c3                   	ret    
	assert(size < 1600);
  801cae:	68 60 2a 80 00       	push   $0x802a60
  801cb3:	68 07 2a 80 00       	push   $0x802a07
  801cb8:	6a 6d                	push   $0x6d
  801cba:	68 54 2a 80 00       	push   $0x802a54
  801cbf:	e8 ed 04 00 00       	call   8021b1 <_panic>

00801cc4 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
  801cc7:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cca:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccd:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd5:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cda:	8b 45 10             	mov    0x10(%ebp),%eax
  801cdd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ce2:	b8 09 00 00 00       	mov    $0x9,%eax
  801ce7:	e8 a8 fd ff ff       	call   801a94 <nsipc>
}
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	56                   	push   %esi
  801cf2:	53                   	push   %ebx
  801cf3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cf6:	83 ec 0c             	sub    $0xc,%esp
  801cf9:	ff 75 08             	pushl  0x8(%ebp)
  801cfc:	e8 6a f3 ff ff       	call   80106b <fd2data>
  801d01:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d03:	83 c4 08             	add    $0x8,%esp
  801d06:	68 6c 2a 80 00       	push   $0x802a6c
  801d0b:	53                   	push   %ebx
  801d0c:	e8 83 ec ff ff       	call   800994 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d11:	8b 46 04             	mov    0x4(%esi),%eax
  801d14:	2b 06                	sub    (%esi),%eax
  801d16:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d1c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d23:	00 00 00 
	stat->st_dev = &devpipe;
  801d26:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d2d:	30 80 00 
	return 0;
}
  801d30:	b8 00 00 00 00       	mov    $0x0,%eax
  801d35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d38:	5b                   	pop    %ebx
  801d39:	5e                   	pop    %esi
  801d3a:	5d                   	pop    %ebp
  801d3b:	c3                   	ret    

00801d3c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
  801d3f:	53                   	push   %ebx
  801d40:	83 ec 0c             	sub    $0xc,%esp
  801d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d46:	53                   	push   %ebx
  801d47:	6a 00                	push   $0x0
  801d49:	e8 bd f0 ff ff       	call   800e0b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d4e:	89 1c 24             	mov    %ebx,(%esp)
  801d51:	e8 15 f3 ff ff       	call   80106b <fd2data>
  801d56:	83 c4 08             	add    $0x8,%esp
  801d59:	50                   	push   %eax
  801d5a:	6a 00                	push   $0x0
  801d5c:	e8 aa f0 ff ff       	call   800e0b <sys_page_unmap>
}
  801d61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d64:	c9                   	leave  
  801d65:	c3                   	ret    

00801d66 <_pipeisclosed>:
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	57                   	push   %edi
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 1c             	sub    $0x1c,%esp
  801d6f:	89 c7                	mov    %eax,%edi
  801d71:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d73:	a1 08 40 80 00       	mov    0x804008,%eax
  801d78:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d7b:	83 ec 0c             	sub    $0xc,%esp
  801d7e:	57                   	push   %edi
  801d7f:	e8 8a 05 00 00       	call   80230e <pageref>
  801d84:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d87:	89 34 24             	mov    %esi,(%esp)
  801d8a:	e8 7f 05 00 00       	call   80230e <pageref>
		nn = thisenv->env_runs;
  801d8f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d95:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d98:	83 c4 10             	add    $0x10,%esp
  801d9b:	39 cb                	cmp    %ecx,%ebx
  801d9d:	74 1b                	je     801dba <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d9f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da2:	75 cf                	jne    801d73 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801da4:	8b 42 58             	mov    0x58(%edx),%eax
  801da7:	6a 01                	push   $0x1
  801da9:	50                   	push   %eax
  801daa:	53                   	push   %ebx
  801dab:	68 73 2a 80 00       	push   $0x802a73
  801db0:	e8 80 e4 ff ff       	call   800235 <cprintf>
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	eb b9                	jmp    801d73 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dba:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dbd:	0f 94 c0             	sete   %al
  801dc0:	0f b6 c0             	movzbl %al,%eax
}
  801dc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5e                   	pop    %esi
  801dc8:	5f                   	pop    %edi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <devpipe_write>:
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	57                   	push   %edi
  801dcf:	56                   	push   %esi
  801dd0:	53                   	push   %ebx
  801dd1:	83 ec 28             	sub    $0x28,%esp
  801dd4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dd7:	56                   	push   %esi
  801dd8:	e8 8e f2 ff ff       	call   80106b <fd2data>
  801ddd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ddf:	83 c4 10             	add    $0x10,%esp
  801de2:	bf 00 00 00 00       	mov    $0x0,%edi
  801de7:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dea:	74 4f                	je     801e3b <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dec:	8b 43 04             	mov    0x4(%ebx),%eax
  801def:	8b 0b                	mov    (%ebx),%ecx
  801df1:	8d 51 20             	lea    0x20(%ecx),%edx
  801df4:	39 d0                	cmp    %edx,%eax
  801df6:	72 14                	jb     801e0c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801df8:	89 da                	mov    %ebx,%edx
  801dfa:	89 f0                	mov    %esi,%eax
  801dfc:	e8 65 ff ff ff       	call   801d66 <_pipeisclosed>
  801e01:	85 c0                	test   %eax,%eax
  801e03:	75 3b                	jne    801e40 <devpipe_write+0x75>
			sys_yield();
  801e05:	e8 5d ef ff ff       	call   800d67 <sys_yield>
  801e0a:	eb e0                	jmp    801dec <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e0f:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e13:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e16:	89 c2                	mov    %eax,%edx
  801e18:	c1 fa 1f             	sar    $0x1f,%edx
  801e1b:	89 d1                	mov    %edx,%ecx
  801e1d:	c1 e9 1b             	shr    $0x1b,%ecx
  801e20:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e23:	83 e2 1f             	and    $0x1f,%edx
  801e26:	29 ca                	sub    %ecx,%edx
  801e28:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e2c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e30:	83 c0 01             	add    $0x1,%eax
  801e33:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e36:	83 c7 01             	add    $0x1,%edi
  801e39:	eb ac                	jmp    801de7 <devpipe_write+0x1c>
	return i;
  801e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  801e3e:	eb 05                	jmp    801e45 <devpipe_write+0x7a>
				return 0;
  801e40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e48:	5b                   	pop    %ebx
  801e49:	5e                   	pop    %esi
  801e4a:	5f                   	pop    %edi
  801e4b:	5d                   	pop    %ebp
  801e4c:	c3                   	ret    

00801e4d <devpipe_read>:
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	57                   	push   %edi
  801e51:	56                   	push   %esi
  801e52:	53                   	push   %ebx
  801e53:	83 ec 18             	sub    $0x18,%esp
  801e56:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e59:	57                   	push   %edi
  801e5a:	e8 0c f2 ff ff       	call   80106b <fd2data>
  801e5f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e61:	83 c4 10             	add    $0x10,%esp
  801e64:	be 00 00 00 00       	mov    $0x0,%esi
  801e69:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e6c:	75 14                	jne    801e82 <devpipe_read+0x35>
	return i;
  801e6e:	8b 45 10             	mov    0x10(%ebp),%eax
  801e71:	eb 02                	jmp    801e75 <devpipe_read+0x28>
				return i;
  801e73:	89 f0                	mov    %esi,%eax
}
  801e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e78:	5b                   	pop    %ebx
  801e79:	5e                   	pop    %esi
  801e7a:	5f                   	pop    %edi
  801e7b:	5d                   	pop    %ebp
  801e7c:	c3                   	ret    
			sys_yield();
  801e7d:	e8 e5 ee ff ff       	call   800d67 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e82:	8b 03                	mov    (%ebx),%eax
  801e84:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e87:	75 18                	jne    801ea1 <devpipe_read+0x54>
			if (i > 0)
  801e89:	85 f6                	test   %esi,%esi
  801e8b:	75 e6                	jne    801e73 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e8d:	89 da                	mov    %ebx,%edx
  801e8f:	89 f8                	mov    %edi,%eax
  801e91:	e8 d0 fe ff ff       	call   801d66 <_pipeisclosed>
  801e96:	85 c0                	test   %eax,%eax
  801e98:	74 e3                	je     801e7d <devpipe_read+0x30>
				return 0;
  801e9a:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9f:	eb d4                	jmp    801e75 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ea1:	99                   	cltd   
  801ea2:	c1 ea 1b             	shr    $0x1b,%edx
  801ea5:	01 d0                	add    %edx,%eax
  801ea7:	83 e0 1f             	and    $0x1f,%eax
  801eaa:	29 d0                	sub    %edx,%eax
  801eac:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801eb4:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801eb7:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801eba:	83 c6 01             	add    $0x1,%esi
  801ebd:	eb aa                	jmp    801e69 <devpipe_read+0x1c>

00801ebf <pipe>:
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ec7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eca:	50                   	push   %eax
  801ecb:	e8 b2 f1 ff ff       	call   801082 <fd_alloc>
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	0f 88 23 01 00 00    	js     802000 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801edd:	83 ec 04             	sub    $0x4,%esp
  801ee0:	68 07 04 00 00       	push   $0x407
  801ee5:	ff 75 f4             	pushl  -0xc(%ebp)
  801ee8:	6a 00                	push   $0x0
  801eea:	e8 97 ee ff ff       	call   800d86 <sys_page_alloc>
  801eef:	89 c3                	mov    %eax,%ebx
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	0f 88 04 01 00 00    	js     802000 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801efc:	83 ec 0c             	sub    $0xc,%esp
  801eff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f02:	50                   	push   %eax
  801f03:	e8 7a f1 ff ff       	call   801082 <fd_alloc>
  801f08:	89 c3                	mov    %eax,%ebx
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	0f 88 db 00 00 00    	js     801ff0 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f15:	83 ec 04             	sub    $0x4,%esp
  801f18:	68 07 04 00 00       	push   $0x407
  801f1d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f20:	6a 00                	push   $0x0
  801f22:	e8 5f ee ff ff       	call   800d86 <sys_page_alloc>
  801f27:	89 c3                	mov    %eax,%ebx
  801f29:	83 c4 10             	add    $0x10,%esp
  801f2c:	85 c0                	test   %eax,%eax
  801f2e:	0f 88 bc 00 00 00    	js     801ff0 <pipe+0x131>
	va = fd2data(fd0);
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	ff 75 f4             	pushl  -0xc(%ebp)
  801f3a:	e8 2c f1 ff ff       	call   80106b <fd2data>
  801f3f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f41:	83 c4 0c             	add    $0xc,%esp
  801f44:	68 07 04 00 00       	push   $0x407
  801f49:	50                   	push   %eax
  801f4a:	6a 00                	push   $0x0
  801f4c:	e8 35 ee ff ff       	call   800d86 <sys_page_alloc>
  801f51:	89 c3                	mov    %eax,%ebx
  801f53:	83 c4 10             	add    $0x10,%esp
  801f56:	85 c0                	test   %eax,%eax
  801f58:	0f 88 82 00 00 00    	js     801fe0 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f5e:	83 ec 0c             	sub    $0xc,%esp
  801f61:	ff 75 f0             	pushl  -0x10(%ebp)
  801f64:	e8 02 f1 ff ff       	call   80106b <fd2data>
  801f69:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f70:	50                   	push   %eax
  801f71:	6a 00                	push   $0x0
  801f73:	56                   	push   %esi
  801f74:	6a 00                	push   $0x0
  801f76:	e8 4e ee ff ff       	call   800dc9 <sys_page_map>
  801f7b:	89 c3                	mov    %eax,%ebx
  801f7d:	83 c4 20             	add    $0x20,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 4e                	js     801fd2 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f84:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f8c:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f91:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f9b:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	ff 75 f4             	pushl  -0xc(%ebp)
  801fad:	e8 a9 f0 ff ff       	call   80105b <fd2num>
  801fb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fb5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fb7:	83 c4 04             	add    $0x4,%esp
  801fba:	ff 75 f0             	pushl  -0x10(%ebp)
  801fbd:	e8 99 f0 ff ff       	call   80105b <fd2num>
  801fc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fc5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fc8:	83 c4 10             	add    $0x10,%esp
  801fcb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fd0:	eb 2e                	jmp    802000 <pipe+0x141>
	sys_page_unmap(0, va);
  801fd2:	83 ec 08             	sub    $0x8,%esp
  801fd5:	56                   	push   %esi
  801fd6:	6a 00                	push   $0x0
  801fd8:	e8 2e ee ff ff       	call   800e0b <sys_page_unmap>
  801fdd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fe0:	83 ec 08             	sub    $0x8,%esp
  801fe3:	ff 75 f0             	pushl  -0x10(%ebp)
  801fe6:	6a 00                	push   $0x0
  801fe8:	e8 1e ee ff ff       	call   800e0b <sys_page_unmap>
  801fed:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ff0:	83 ec 08             	sub    $0x8,%esp
  801ff3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff6:	6a 00                	push   $0x0
  801ff8:	e8 0e ee ff ff       	call   800e0b <sys_page_unmap>
  801ffd:	83 c4 10             	add    $0x10,%esp
}
  802000:	89 d8                	mov    %ebx,%eax
  802002:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802005:	5b                   	pop    %ebx
  802006:	5e                   	pop    %esi
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <pipeisclosed>:
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80200f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802012:	50                   	push   %eax
  802013:	ff 75 08             	pushl  0x8(%ebp)
  802016:	e8 b9 f0 ff ff       	call   8010d4 <fd_lookup>
  80201b:	83 c4 10             	add    $0x10,%esp
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 18                	js     80203a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802022:	83 ec 0c             	sub    $0xc,%esp
  802025:	ff 75 f4             	pushl  -0xc(%ebp)
  802028:	e8 3e f0 ff ff       	call   80106b <fd2data>
	return _pipeisclosed(fd, p);
  80202d:	89 c2                	mov    %eax,%edx
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	e8 2f fd ff ff       	call   801d66 <_pipeisclosed>
  802037:	83 c4 10             	add    $0x10,%esp
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    

0080203c <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	c3                   	ret    

00802042 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802042:	55                   	push   %ebp
  802043:	89 e5                	mov    %esp,%ebp
  802045:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802048:	68 8b 2a 80 00       	push   $0x802a8b
  80204d:	ff 75 0c             	pushl  0xc(%ebp)
  802050:	e8 3f e9 ff ff       	call   800994 <strcpy>
	return 0;
}
  802055:	b8 00 00 00 00       	mov    $0x0,%eax
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <devcons_write>:
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	57                   	push   %edi
  802060:	56                   	push   %esi
  802061:	53                   	push   %ebx
  802062:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802068:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80206d:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802073:	3b 75 10             	cmp    0x10(%ebp),%esi
  802076:	73 31                	jae    8020a9 <devcons_write+0x4d>
		m = n - tot;
  802078:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80207b:	29 f3                	sub    %esi,%ebx
  80207d:	83 fb 7f             	cmp    $0x7f,%ebx
  802080:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802085:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802088:	83 ec 04             	sub    $0x4,%esp
  80208b:	53                   	push   %ebx
  80208c:	89 f0                	mov    %esi,%eax
  80208e:	03 45 0c             	add    0xc(%ebp),%eax
  802091:	50                   	push   %eax
  802092:	57                   	push   %edi
  802093:	e8 8a ea ff ff       	call   800b22 <memmove>
		sys_cputs(buf, m);
  802098:	83 c4 08             	add    $0x8,%esp
  80209b:	53                   	push   %ebx
  80209c:	57                   	push   %edi
  80209d:	e8 28 ec ff ff       	call   800cca <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a2:	01 de                	add    %ebx,%esi
  8020a4:	83 c4 10             	add    $0x10,%esp
  8020a7:	eb ca                	jmp    802073 <devcons_write+0x17>
}
  8020a9:	89 f0                	mov    %esi,%eax
  8020ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ae:	5b                   	pop    %ebx
  8020af:	5e                   	pop    %esi
  8020b0:	5f                   	pop    %edi
  8020b1:	5d                   	pop    %ebp
  8020b2:	c3                   	ret    

008020b3 <devcons_read>:
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 08             	sub    $0x8,%esp
  8020b9:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020be:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c2:	74 21                	je     8020e5 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020c4:	e8 1f ec ff ff       	call   800ce8 <sys_cgetc>
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	75 07                	jne    8020d4 <devcons_read+0x21>
		sys_yield();
  8020cd:	e8 95 ec ff ff       	call   800d67 <sys_yield>
  8020d2:	eb f0                	jmp    8020c4 <devcons_read+0x11>
	if (c < 0)
  8020d4:	78 0f                	js     8020e5 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020d6:	83 f8 04             	cmp    $0x4,%eax
  8020d9:	74 0c                	je     8020e7 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020de:	88 02                	mov    %al,(%edx)
	return 1;
  8020e0:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    
		return 0;
  8020e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ec:	eb f7                	jmp    8020e5 <devcons_read+0x32>

008020ee <cputchar>:
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020fa:	6a 01                	push   $0x1
  8020fc:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ff:	50                   	push   %eax
  802100:	e8 c5 eb ff ff       	call   800cca <sys_cputs>
}
  802105:	83 c4 10             	add    $0x10,%esp
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <getchar>:
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
  80210d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802110:	6a 01                	push   $0x1
  802112:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802115:	50                   	push   %eax
  802116:	6a 00                	push   $0x0
  802118:	e8 27 f2 ff ff       	call   801344 <read>
	if (r < 0)
  80211d:	83 c4 10             	add    $0x10,%esp
  802120:	85 c0                	test   %eax,%eax
  802122:	78 06                	js     80212a <getchar+0x20>
	if (r < 1)
  802124:	74 06                	je     80212c <getchar+0x22>
	return c;
  802126:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80212a:	c9                   	leave  
  80212b:	c3                   	ret    
		return -E_EOF;
  80212c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802131:	eb f7                	jmp    80212a <getchar+0x20>

00802133 <iscons>:
{
  802133:	55                   	push   %ebp
  802134:	89 e5                	mov    %esp,%ebp
  802136:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802139:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213c:	50                   	push   %eax
  80213d:	ff 75 08             	pushl  0x8(%ebp)
  802140:	e8 8f ef ff ff       	call   8010d4 <fd_lookup>
  802145:	83 c4 10             	add    $0x10,%esp
  802148:	85 c0                	test   %eax,%eax
  80214a:	78 11                	js     80215d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80214c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214f:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802155:	39 10                	cmp    %edx,(%eax)
  802157:	0f 94 c0             	sete   %al
  80215a:	0f b6 c0             	movzbl %al,%eax
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <opencons>:
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802165:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802168:	50                   	push   %eax
  802169:	e8 14 ef ff ff       	call   801082 <fd_alloc>
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	85 c0                	test   %eax,%eax
  802173:	78 3a                	js     8021af <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802175:	83 ec 04             	sub    $0x4,%esp
  802178:	68 07 04 00 00       	push   $0x407
  80217d:	ff 75 f4             	pushl  -0xc(%ebp)
  802180:	6a 00                	push   $0x0
  802182:	e8 ff eb ff ff       	call   800d86 <sys_page_alloc>
  802187:	83 c4 10             	add    $0x10,%esp
  80218a:	85 c0                	test   %eax,%eax
  80218c:	78 21                	js     8021af <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80218e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802191:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802197:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021a3:	83 ec 0c             	sub    $0xc,%esp
  8021a6:	50                   	push   %eax
  8021a7:	e8 af ee ff ff       	call   80105b <fd2num>
  8021ac:	83 c4 10             	add    $0x10,%esp
}
  8021af:	c9                   	leave  
  8021b0:	c3                   	ret    

008021b1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	56                   	push   %esi
  8021b5:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021b6:	a1 08 40 80 00       	mov    0x804008,%eax
  8021bb:	8b 40 48             	mov    0x48(%eax),%eax
  8021be:	83 ec 04             	sub    $0x4,%esp
  8021c1:	68 c8 2a 80 00       	push   $0x802ac8
  8021c6:	50                   	push   %eax
  8021c7:	68 97 2a 80 00       	push   $0x802a97
  8021cc:	e8 64 e0 ff ff       	call   800235 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021d1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021d4:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021da:	e8 69 eb ff ff       	call   800d48 <sys_getenvid>
  8021df:	83 c4 04             	add    $0x4,%esp
  8021e2:	ff 75 0c             	pushl  0xc(%ebp)
  8021e5:	ff 75 08             	pushl  0x8(%ebp)
  8021e8:	56                   	push   %esi
  8021e9:	50                   	push   %eax
  8021ea:	68 a4 2a 80 00       	push   $0x802aa4
  8021ef:	e8 41 e0 ff ff       	call   800235 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021f4:	83 c4 18             	add    $0x18,%esp
  8021f7:	53                   	push   %ebx
  8021f8:	ff 75 10             	pushl  0x10(%ebp)
  8021fb:	e8 e4 df ff ff       	call   8001e4 <vcprintf>
	cprintf("\n");
  802200:	c7 04 24 b0 25 80 00 	movl   $0x8025b0,(%esp)
  802207:	e8 29 e0 ff ff       	call   800235 <cprintf>
  80220c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80220f:	cc                   	int3   
  802210:	eb fd                	jmp    80220f <_panic+0x5e>

00802212 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	56                   	push   %esi
  802216:	53                   	push   %ebx
  802217:	8b 75 08             	mov    0x8(%ebp),%esi
  80221a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80221d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802220:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802222:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802227:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80222a:	83 ec 0c             	sub    $0xc,%esp
  80222d:	50                   	push   %eax
  80222e:	e8 03 ed ff ff       	call   800f36 <sys_ipc_recv>
	if(ret < 0){
  802233:	83 c4 10             	add    $0x10,%esp
  802236:	85 c0                	test   %eax,%eax
  802238:	78 2b                	js     802265 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80223a:	85 f6                	test   %esi,%esi
  80223c:	74 0a                	je     802248 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80223e:	a1 08 40 80 00       	mov    0x804008,%eax
  802243:	8b 40 74             	mov    0x74(%eax),%eax
  802246:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802248:	85 db                	test   %ebx,%ebx
  80224a:	74 0a                	je     802256 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80224c:	a1 08 40 80 00       	mov    0x804008,%eax
  802251:	8b 40 78             	mov    0x78(%eax),%eax
  802254:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  802256:	a1 08 40 80 00       	mov    0x804008,%eax
  80225b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80225e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802261:	5b                   	pop    %ebx
  802262:	5e                   	pop    %esi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    
		if(from_env_store)
  802265:	85 f6                	test   %esi,%esi
  802267:	74 06                	je     80226f <ipc_recv+0x5d>
			*from_env_store = 0;
  802269:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80226f:	85 db                	test   %ebx,%ebx
  802271:	74 eb                	je     80225e <ipc_recv+0x4c>
			*perm_store = 0;
  802273:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802279:	eb e3                	jmp    80225e <ipc_recv+0x4c>

0080227b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	57                   	push   %edi
  80227f:	56                   	push   %esi
  802280:	53                   	push   %ebx
  802281:	83 ec 0c             	sub    $0xc,%esp
  802284:	8b 7d 08             	mov    0x8(%ebp),%edi
  802287:	8b 75 0c             	mov    0xc(%ebp),%esi
  80228a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80228d:	85 db                	test   %ebx,%ebx
  80228f:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802294:	0f 44 d8             	cmove  %eax,%ebx
  802297:	eb 05                	jmp    80229e <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802299:	e8 c9 ea ff ff       	call   800d67 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80229e:	ff 75 14             	pushl  0x14(%ebp)
  8022a1:	53                   	push   %ebx
  8022a2:	56                   	push   %esi
  8022a3:	57                   	push   %edi
  8022a4:	e8 6a ec ff ff       	call   800f13 <sys_ipc_try_send>
  8022a9:	83 c4 10             	add    $0x10,%esp
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	74 1b                	je     8022cb <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  8022b0:	79 e7                	jns    802299 <ipc_send+0x1e>
  8022b2:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022b5:	74 e2                	je     802299 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  8022b7:	83 ec 04             	sub    $0x4,%esp
  8022ba:	68 cf 2a 80 00       	push   $0x802acf
  8022bf:	6a 48                	push   $0x48
  8022c1:	68 e4 2a 80 00       	push   $0x802ae4
  8022c6:	e8 e6 fe ff ff       	call   8021b1 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022ce:	5b                   	pop    %ebx
  8022cf:	5e                   	pop    %esi
  8022d0:	5f                   	pop    %edi
  8022d1:	5d                   	pop    %ebp
  8022d2:	c3                   	ret    

008022d3 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022d3:	55                   	push   %ebp
  8022d4:	89 e5                	mov    %esp,%ebp
  8022d6:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022d9:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022de:	89 c2                	mov    %eax,%edx
  8022e0:	c1 e2 07             	shl    $0x7,%edx
  8022e3:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022e9:	8b 52 50             	mov    0x50(%edx),%edx
  8022ec:	39 ca                	cmp    %ecx,%edx
  8022ee:	74 11                	je     802301 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022f0:	83 c0 01             	add    $0x1,%eax
  8022f3:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022f8:	75 e4                	jne    8022de <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ff:	eb 0b                	jmp    80230c <ipc_find_env+0x39>
			return envs[i].env_id;
  802301:	c1 e0 07             	shl    $0x7,%eax
  802304:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802309:	8b 40 48             	mov    0x48(%eax),%eax
}
  80230c:	5d                   	pop    %ebp
  80230d:	c3                   	ret    

0080230e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802314:	89 d0                	mov    %edx,%eax
  802316:	c1 e8 16             	shr    $0x16,%eax
  802319:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802320:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802325:	f6 c1 01             	test   $0x1,%cl
  802328:	74 1d                	je     802347 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80232a:	c1 ea 0c             	shr    $0xc,%edx
  80232d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802334:	f6 c2 01             	test   $0x1,%dl
  802337:	74 0e                	je     802347 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802339:	c1 ea 0c             	shr    $0xc,%edx
  80233c:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802343:	ef 
  802344:	0f b7 c0             	movzwl %ax,%eax
}
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    
  802349:	66 90                	xchg   %ax,%ax
  80234b:	66 90                	xchg   %ax,%ax
  80234d:	66 90                	xchg   %ax,%ax
  80234f:	90                   	nop

00802350 <__udivdi3>:
  802350:	55                   	push   %ebp
  802351:	57                   	push   %edi
  802352:	56                   	push   %esi
  802353:	53                   	push   %ebx
  802354:	83 ec 1c             	sub    $0x1c,%esp
  802357:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80235b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80235f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802363:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802367:	85 d2                	test   %edx,%edx
  802369:	75 4d                	jne    8023b8 <__udivdi3+0x68>
  80236b:	39 f3                	cmp    %esi,%ebx
  80236d:	76 19                	jbe    802388 <__udivdi3+0x38>
  80236f:	31 ff                	xor    %edi,%edi
  802371:	89 e8                	mov    %ebp,%eax
  802373:	89 f2                	mov    %esi,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 fa                	mov    %edi,%edx
  802379:	83 c4 1c             	add    $0x1c,%esp
  80237c:	5b                   	pop    %ebx
  80237d:	5e                   	pop    %esi
  80237e:	5f                   	pop    %edi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    
  802381:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802388:	89 d9                	mov    %ebx,%ecx
  80238a:	85 db                	test   %ebx,%ebx
  80238c:	75 0b                	jne    802399 <__udivdi3+0x49>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	31 d2                	xor    %edx,%edx
  802395:	f7 f3                	div    %ebx
  802397:	89 c1                	mov    %eax,%ecx
  802399:	31 d2                	xor    %edx,%edx
  80239b:	89 f0                	mov    %esi,%eax
  80239d:	f7 f1                	div    %ecx
  80239f:	89 c6                	mov    %eax,%esi
  8023a1:	89 e8                	mov    %ebp,%eax
  8023a3:	89 f7                	mov    %esi,%edi
  8023a5:	f7 f1                	div    %ecx
  8023a7:	89 fa                	mov    %edi,%edx
  8023a9:	83 c4 1c             	add    $0x1c,%esp
  8023ac:	5b                   	pop    %ebx
  8023ad:	5e                   	pop    %esi
  8023ae:	5f                   	pop    %edi
  8023af:	5d                   	pop    %ebp
  8023b0:	c3                   	ret    
  8023b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023b8:	39 f2                	cmp    %esi,%edx
  8023ba:	77 1c                	ja     8023d8 <__udivdi3+0x88>
  8023bc:	0f bd fa             	bsr    %edx,%edi
  8023bf:	83 f7 1f             	xor    $0x1f,%edi
  8023c2:	75 2c                	jne    8023f0 <__udivdi3+0xa0>
  8023c4:	39 f2                	cmp    %esi,%edx
  8023c6:	72 06                	jb     8023ce <__udivdi3+0x7e>
  8023c8:	31 c0                	xor    %eax,%eax
  8023ca:	39 eb                	cmp    %ebp,%ebx
  8023cc:	77 a9                	ja     802377 <__udivdi3+0x27>
  8023ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d3:	eb a2                	jmp    802377 <__udivdi3+0x27>
  8023d5:	8d 76 00             	lea    0x0(%esi),%esi
  8023d8:	31 ff                	xor    %edi,%edi
  8023da:	31 c0                	xor    %eax,%eax
  8023dc:	89 fa                	mov    %edi,%edx
  8023de:	83 c4 1c             	add    $0x1c,%esp
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    
  8023e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	89 f9                	mov    %edi,%ecx
  8023f2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023f7:	29 f8                	sub    %edi,%eax
  8023f9:	d3 e2                	shl    %cl,%edx
  8023fb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023ff:	89 c1                	mov    %eax,%ecx
  802401:	89 da                	mov    %ebx,%edx
  802403:	d3 ea                	shr    %cl,%edx
  802405:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802409:	09 d1                	or     %edx,%ecx
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e3                	shl    %cl,%ebx
  802415:	89 c1                	mov    %eax,%ecx
  802417:	d3 ea                	shr    %cl,%edx
  802419:	89 f9                	mov    %edi,%ecx
  80241b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80241f:	89 eb                	mov    %ebp,%ebx
  802421:	d3 e6                	shl    %cl,%esi
  802423:	89 c1                	mov    %eax,%ecx
  802425:	d3 eb                	shr    %cl,%ebx
  802427:	09 de                	or     %ebx,%esi
  802429:	89 f0                	mov    %esi,%eax
  80242b:	f7 74 24 08          	divl   0x8(%esp)
  80242f:	89 d6                	mov    %edx,%esi
  802431:	89 c3                	mov    %eax,%ebx
  802433:	f7 64 24 0c          	mull   0xc(%esp)
  802437:	39 d6                	cmp    %edx,%esi
  802439:	72 15                	jb     802450 <__udivdi3+0x100>
  80243b:	89 f9                	mov    %edi,%ecx
  80243d:	d3 e5                	shl    %cl,%ebp
  80243f:	39 c5                	cmp    %eax,%ebp
  802441:	73 04                	jae    802447 <__udivdi3+0xf7>
  802443:	39 d6                	cmp    %edx,%esi
  802445:	74 09                	je     802450 <__udivdi3+0x100>
  802447:	89 d8                	mov    %ebx,%eax
  802449:	31 ff                	xor    %edi,%edi
  80244b:	e9 27 ff ff ff       	jmp    802377 <__udivdi3+0x27>
  802450:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802453:	31 ff                	xor    %edi,%edi
  802455:	e9 1d ff ff ff       	jmp    802377 <__udivdi3+0x27>
  80245a:	66 90                	xchg   %ax,%ax
  80245c:	66 90                	xchg   %ax,%ax
  80245e:	66 90                	xchg   %ax,%ax

00802460 <__umoddi3>:
  802460:	55                   	push   %ebp
  802461:	57                   	push   %edi
  802462:	56                   	push   %esi
  802463:	53                   	push   %ebx
  802464:	83 ec 1c             	sub    $0x1c,%esp
  802467:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80246b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80246f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802473:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802477:	89 da                	mov    %ebx,%edx
  802479:	85 c0                	test   %eax,%eax
  80247b:	75 43                	jne    8024c0 <__umoddi3+0x60>
  80247d:	39 df                	cmp    %ebx,%edi
  80247f:	76 17                	jbe    802498 <__umoddi3+0x38>
  802481:	89 f0                	mov    %esi,%eax
  802483:	f7 f7                	div    %edi
  802485:	89 d0                	mov    %edx,%eax
  802487:	31 d2                	xor    %edx,%edx
  802489:	83 c4 1c             	add    $0x1c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    
  802491:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802498:	89 fd                	mov    %edi,%ebp
  80249a:	85 ff                	test   %edi,%edi
  80249c:	75 0b                	jne    8024a9 <__umoddi3+0x49>
  80249e:	b8 01 00 00 00       	mov    $0x1,%eax
  8024a3:	31 d2                	xor    %edx,%edx
  8024a5:	f7 f7                	div    %edi
  8024a7:	89 c5                	mov    %eax,%ebp
  8024a9:	89 d8                	mov    %ebx,%eax
  8024ab:	31 d2                	xor    %edx,%edx
  8024ad:	f7 f5                	div    %ebp
  8024af:	89 f0                	mov    %esi,%eax
  8024b1:	f7 f5                	div    %ebp
  8024b3:	89 d0                	mov    %edx,%eax
  8024b5:	eb d0                	jmp    802487 <__umoddi3+0x27>
  8024b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024be:	66 90                	xchg   %ax,%ax
  8024c0:	89 f1                	mov    %esi,%ecx
  8024c2:	39 d8                	cmp    %ebx,%eax
  8024c4:	76 0a                	jbe    8024d0 <__umoddi3+0x70>
  8024c6:	89 f0                	mov    %esi,%eax
  8024c8:	83 c4 1c             	add    $0x1c,%esp
  8024cb:	5b                   	pop    %ebx
  8024cc:	5e                   	pop    %esi
  8024cd:	5f                   	pop    %edi
  8024ce:	5d                   	pop    %ebp
  8024cf:	c3                   	ret    
  8024d0:	0f bd e8             	bsr    %eax,%ebp
  8024d3:	83 f5 1f             	xor    $0x1f,%ebp
  8024d6:	75 20                	jne    8024f8 <__umoddi3+0x98>
  8024d8:	39 d8                	cmp    %ebx,%eax
  8024da:	0f 82 b0 00 00 00    	jb     802590 <__umoddi3+0x130>
  8024e0:	39 f7                	cmp    %esi,%edi
  8024e2:	0f 86 a8 00 00 00    	jbe    802590 <__umoddi3+0x130>
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	83 c4 1c             	add    $0x1c,%esp
  8024ed:	5b                   	pop    %ebx
  8024ee:	5e                   	pop    %esi
  8024ef:	5f                   	pop    %edi
  8024f0:	5d                   	pop    %ebp
  8024f1:	c3                   	ret    
  8024f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024f8:	89 e9                	mov    %ebp,%ecx
  8024fa:	ba 20 00 00 00       	mov    $0x20,%edx
  8024ff:	29 ea                	sub    %ebp,%edx
  802501:	d3 e0                	shl    %cl,%eax
  802503:	89 44 24 08          	mov    %eax,0x8(%esp)
  802507:	89 d1                	mov    %edx,%ecx
  802509:	89 f8                	mov    %edi,%eax
  80250b:	d3 e8                	shr    %cl,%eax
  80250d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802511:	89 54 24 04          	mov    %edx,0x4(%esp)
  802515:	8b 54 24 04          	mov    0x4(%esp),%edx
  802519:	09 c1                	or     %eax,%ecx
  80251b:	89 d8                	mov    %ebx,%eax
  80251d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802521:	89 e9                	mov    %ebp,%ecx
  802523:	d3 e7                	shl    %cl,%edi
  802525:	89 d1                	mov    %edx,%ecx
  802527:	d3 e8                	shr    %cl,%eax
  802529:	89 e9                	mov    %ebp,%ecx
  80252b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80252f:	d3 e3                	shl    %cl,%ebx
  802531:	89 c7                	mov    %eax,%edi
  802533:	89 d1                	mov    %edx,%ecx
  802535:	89 f0                	mov    %esi,%eax
  802537:	d3 e8                	shr    %cl,%eax
  802539:	89 e9                	mov    %ebp,%ecx
  80253b:	89 fa                	mov    %edi,%edx
  80253d:	d3 e6                	shl    %cl,%esi
  80253f:	09 d8                	or     %ebx,%eax
  802541:	f7 74 24 08          	divl   0x8(%esp)
  802545:	89 d1                	mov    %edx,%ecx
  802547:	89 f3                	mov    %esi,%ebx
  802549:	f7 64 24 0c          	mull   0xc(%esp)
  80254d:	89 c6                	mov    %eax,%esi
  80254f:	89 d7                	mov    %edx,%edi
  802551:	39 d1                	cmp    %edx,%ecx
  802553:	72 06                	jb     80255b <__umoddi3+0xfb>
  802555:	75 10                	jne    802567 <__umoddi3+0x107>
  802557:	39 c3                	cmp    %eax,%ebx
  802559:	73 0c                	jae    802567 <__umoddi3+0x107>
  80255b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80255f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802563:	89 d7                	mov    %edx,%edi
  802565:	89 c6                	mov    %eax,%esi
  802567:	89 ca                	mov    %ecx,%edx
  802569:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80256e:	29 f3                	sub    %esi,%ebx
  802570:	19 fa                	sbb    %edi,%edx
  802572:	89 d0                	mov    %edx,%eax
  802574:	d3 e0                	shl    %cl,%eax
  802576:	89 e9                	mov    %ebp,%ecx
  802578:	d3 eb                	shr    %cl,%ebx
  80257a:	d3 ea                	shr    %cl,%edx
  80257c:	09 d8                	or     %ebx,%eax
  80257e:	83 c4 1c             	add    $0x1c,%esp
  802581:	5b                   	pop    %ebx
  802582:	5e                   	pop    %esi
  802583:	5f                   	pop    %edi
  802584:	5d                   	pop    %ebp
  802585:	c3                   	ret    
  802586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80258d:	8d 76 00             	lea    0x0(%esi),%esi
  802590:	89 da                	mov    %ebx,%edx
  802592:	29 fe                	sub    %edi,%esi
  802594:	19 c2                	sbb    %eax,%edx
  802596:	89 f1                	mov    %esi,%ecx
  802598:	89 c8                	mov    %ecx,%eax
  80259a:	e9 4b ff ff ff       	jmp    8024ea <__umoddi3+0x8a>
