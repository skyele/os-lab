
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
  800058:	68 80 25 80 00       	push   $0x802580
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 9b 09 00 00       	call   800a00 <strcmp>
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
  800087:	68 83 25 80 00       	push   $0x802583
  80008c:	6a 01                	push   $0x1
  80008e:	e8 5e 13 00 00       	call   8013f1 <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 7b 08 00 00       	call   80091c <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 42 13 00 00       	call   8013f1 <write>
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
  8000d3:	68 ba 2a 80 00       	push   $0x802aba
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 12 13 00 00       	call   8013f1 <write>
  8000df:	83 c4 10             	add    $0x10,%esp
}
  8000e2:	eb e2                	jmp    8000c6 <umain+0x93>

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  8000ef:	e8 15 0c 00 00       	call   800d09 <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8000ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800104:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800109:	85 db                	test   %ebx,%ebx
  80010b:	7e 07                	jle    800114 <libmain+0x30>
		binaryname = argv[0];
  80010d:	8b 06                	mov    (%esi),%eax
  80010f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	56                   	push   %esi
  800118:	53                   	push   %ebx
  800119:	e8 15 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80011e:	e8 0a 00 00 00       	call   80012d <exit>
}
  800123:	83 c4 10             	add    $0x10,%esp
  800126:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800129:	5b                   	pop    %ebx
  80012a:	5e                   	pop    %esi
  80012b:	5d                   	pop    %ebp
  80012c:	c3                   	ret    

0080012d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  800133:	a1 08 40 80 00       	mov    0x804008,%eax
  800138:	8b 40 48             	mov    0x48(%eax),%eax
  80013b:	68 9c 25 80 00       	push   $0x80259c
  800140:	50                   	push   %eax
  800141:	68 8f 25 80 00       	push   $0x80258f
  800146:	e8 ab 00 00 00       	call   8001f6 <cprintf>
	close_all();
  80014b:	e8 c4 10 00 00       	call   801214 <close_all>
	sys_env_destroy(0);
  800150:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800157:	e8 6c 0b 00 00       	call   800cc8 <sys_env_destroy>
}
  80015c:	83 c4 10             	add    $0x10,%esp
  80015f:	c9                   	leave  
  800160:	c3                   	ret    

00800161 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800161:	55                   	push   %ebp
  800162:	89 e5                	mov    %esp,%ebp
  800164:	53                   	push   %ebx
  800165:	83 ec 04             	sub    $0x4,%esp
  800168:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80016b:	8b 13                	mov    (%ebx),%edx
  80016d:	8d 42 01             	lea    0x1(%edx),%eax
  800170:	89 03                	mov    %eax,(%ebx)
  800172:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800175:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800179:	3d ff 00 00 00       	cmp    $0xff,%eax
  80017e:	74 09                	je     800189 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800180:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800184:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800187:	c9                   	leave  
  800188:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800189:	83 ec 08             	sub    $0x8,%esp
  80018c:	68 ff 00 00 00       	push   $0xff
  800191:	8d 43 08             	lea    0x8(%ebx),%eax
  800194:	50                   	push   %eax
  800195:	e8 f1 0a 00 00       	call   800c8b <sys_cputs>
		b->idx = 0;
  80019a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001a0:	83 c4 10             	add    $0x10,%esp
  8001a3:	eb db                	jmp    800180 <putch+0x1f>

008001a5 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001a5:	55                   	push   %ebp
  8001a6:	89 e5                	mov    %esp,%ebp
  8001a8:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001ae:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001b5:	00 00 00 
	b.cnt = 0;
  8001b8:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001bf:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001c2:	ff 75 0c             	pushl  0xc(%ebp)
  8001c5:	ff 75 08             	pushl  0x8(%ebp)
  8001c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001ce:	50                   	push   %eax
  8001cf:	68 61 01 80 00       	push   $0x800161
  8001d4:	e8 4a 01 00 00       	call   800323 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d9:	83 c4 08             	add    $0x8,%esp
  8001dc:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001e2:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e8:	50                   	push   %eax
  8001e9:	e8 9d 0a 00 00       	call   800c8b <sys_cputs>

	return b.cnt;
}
  8001ee:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001f4:	c9                   	leave  
  8001f5:	c3                   	ret    

008001f6 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f6:	55                   	push   %ebp
  8001f7:	89 e5                	mov    %esp,%ebp
  8001f9:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001fc:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001ff:	50                   	push   %eax
  800200:	ff 75 08             	pushl  0x8(%ebp)
  800203:	e8 9d ff ff ff       	call   8001a5 <vcprintf>
	va_end(ap);

	return cnt;
}
  800208:	c9                   	leave  
  800209:	c3                   	ret    

0080020a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80020a:	55                   	push   %ebp
  80020b:	89 e5                	mov    %esp,%ebp
  80020d:	57                   	push   %edi
  80020e:	56                   	push   %esi
  80020f:	53                   	push   %ebx
  800210:	83 ec 1c             	sub    $0x1c,%esp
  800213:	89 c6                	mov    %eax,%esi
  800215:	89 d7                	mov    %edx,%edi
  800217:	8b 45 08             	mov    0x8(%ebp),%eax
  80021a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80021d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800220:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800223:	8b 45 10             	mov    0x10(%ebp),%eax
  800226:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800229:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  80022d:	74 2c                	je     80025b <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  80022f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800232:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800239:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80023c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80023f:	39 c2                	cmp    %eax,%edx
  800241:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  800244:	73 43                	jae    800289 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800246:	83 eb 01             	sub    $0x1,%ebx
  800249:	85 db                	test   %ebx,%ebx
  80024b:	7e 6c                	jle    8002b9 <printnum+0xaf>
				putch(padc, putdat);
  80024d:	83 ec 08             	sub    $0x8,%esp
  800250:	57                   	push   %edi
  800251:	ff 75 18             	pushl  0x18(%ebp)
  800254:	ff d6                	call   *%esi
  800256:	83 c4 10             	add    $0x10,%esp
  800259:	eb eb                	jmp    800246 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  80025b:	83 ec 0c             	sub    $0xc,%esp
  80025e:	6a 20                	push   $0x20
  800260:	6a 00                	push   $0x0
  800262:	50                   	push   %eax
  800263:	ff 75 e4             	pushl  -0x1c(%ebp)
  800266:	ff 75 e0             	pushl  -0x20(%ebp)
  800269:	89 fa                	mov    %edi,%edx
  80026b:	89 f0                	mov    %esi,%eax
  80026d:	e8 98 ff ff ff       	call   80020a <printnum>
		while (--width > 0)
  800272:	83 c4 20             	add    $0x20,%esp
  800275:	83 eb 01             	sub    $0x1,%ebx
  800278:	85 db                	test   %ebx,%ebx
  80027a:	7e 65                	jle    8002e1 <printnum+0xd7>
			putch(padc, putdat);
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	57                   	push   %edi
  800280:	6a 20                	push   $0x20
  800282:	ff d6                	call   *%esi
  800284:	83 c4 10             	add    $0x10,%esp
  800287:	eb ec                	jmp    800275 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	ff 75 18             	pushl  0x18(%ebp)
  80028f:	83 eb 01             	sub    $0x1,%ebx
  800292:	53                   	push   %ebx
  800293:	50                   	push   %eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	ff 75 dc             	pushl  -0x24(%ebp)
  80029a:	ff 75 d8             	pushl  -0x28(%ebp)
  80029d:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002a3:	e8 88 20 00 00       	call   802330 <__udivdi3>
  8002a8:	83 c4 18             	add    $0x18,%esp
  8002ab:	52                   	push   %edx
  8002ac:	50                   	push   %eax
  8002ad:	89 fa                	mov    %edi,%edx
  8002af:	89 f0                	mov    %esi,%eax
  8002b1:	e8 54 ff ff ff       	call   80020a <printnum>
  8002b6:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b9:	83 ec 08             	sub    $0x8,%esp
  8002bc:	57                   	push   %edi
  8002bd:	83 ec 04             	sub    $0x4,%esp
  8002c0:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c3:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002cc:	e8 6f 21 00 00       	call   802440 <__umoddi3>
  8002d1:	83 c4 14             	add    $0x14,%esp
  8002d4:	0f be 80 a1 25 80 00 	movsbl 0x8025a1(%eax),%eax
  8002db:	50                   	push   %eax
  8002dc:	ff d6                	call   *%esi
  8002de:	83 c4 10             	add    $0x10,%esp
	}
}
  8002e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e4:	5b                   	pop    %ebx
  8002e5:	5e                   	pop    %esi
  8002e6:	5f                   	pop    %edi
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    

008002e9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002ef:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002f3:	8b 10                	mov    (%eax),%edx
  8002f5:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f8:	73 0a                	jae    800304 <sprintputch+0x1b>
		*b->buf++ = ch;
  8002fa:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002fd:	89 08                	mov    %ecx,(%eax)
  8002ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800302:	88 02                	mov    %al,(%edx)
}
  800304:	5d                   	pop    %ebp
  800305:	c3                   	ret    

00800306 <printfmt>:
{
  800306:	55                   	push   %ebp
  800307:	89 e5                	mov    %esp,%ebp
  800309:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80030f:	50                   	push   %eax
  800310:	ff 75 10             	pushl  0x10(%ebp)
  800313:	ff 75 0c             	pushl  0xc(%ebp)
  800316:	ff 75 08             	pushl  0x8(%ebp)
  800319:	e8 05 00 00 00       	call   800323 <vprintfmt>
}
  80031e:	83 c4 10             	add    $0x10,%esp
  800321:	c9                   	leave  
  800322:	c3                   	ret    

00800323 <vprintfmt>:
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	57                   	push   %edi
  800327:	56                   	push   %esi
  800328:	53                   	push   %ebx
  800329:	83 ec 3c             	sub    $0x3c,%esp
  80032c:	8b 75 08             	mov    0x8(%ebp),%esi
  80032f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800332:	8b 7d 10             	mov    0x10(%ebp),%edi
  800335:	e9 32 04 00 00       	jmp    80076c <vprintfmt+0x449>
		padc = ' ';
  80033a:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  80033e:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  800345:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  80034c:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  800353:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80035a:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800361:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800366:	8d 47 01             	lea    0x1(%edi),%eax
  800369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036c:	0f b6 17             	movzbl (%edi),%edx
  80036f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800372:	3c 55                	cmp    $0x55,%al
  800374:	0f 87 12 05 00 00    	ja     80088c <vprintfmt+0x569>
  80037a:	0f b6 c0             	movzbl %al,%eax
  80037d:	ff 24 85 80 27 80 00 	jmp    *0x802780(,%eax,4)
  800384:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800387:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80038b:	eb d9                	jmp    800366 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80038d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800390:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800394:	eb d0                	jmp    800366 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800396:	0f b6 d2             	movzbl %dl,%edx
  800399:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80039c:	b8 00 00 00 00       	mov    $0x0,%eax
  8003a1:	89 75 08             	mov    %esi,0x8(%ebp)
  8003a4:	eb 03                	jmp    8003a9 <vprintfmt+0x86>
  8003a6:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a9:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003ac:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003b0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003b3:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b6:	83 fe 09             	cmp    $0x9,%esi
  8003b9:	76 eb                	jbe    8003a6 <vprintfmt+0x83>
  8003bb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003be:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c1:	eb 14                	jmp    8003d7 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c6:	8b 00                	mov    (%eax),%eax
  8003c8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ce:	8d 40 04             	lea    0x4(%eax),%eax
  8003d1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003db:	79 89                	jns    800366 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e3:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003ea:	e9 77 ff ff ff       	jmp    800366 <vprintfmt+0x43>
  8003ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003f2:	85 c0                	test   %eax,%eax
  8003f4:	0f 48 c1             	cmovs  %ecx,%eax
  8003f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003fd:	e9 64 ff ff ff       	jmp    800366 <vprintfmt+0x43>
  800402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800405:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80040c:	e9 55 ff ff ff       	jmp    800366 <vprintfmt+0x43>
			lflag++;
  800411:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800415:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800418:	e9 49 ff ff ff       	jmp    800366 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80041d:	8b 45 14             	mov    0x14(%ebp),%eax
  800420:	8d 78 04             	lea    0x4(%eax),%edi
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	53                   	push   %ebx
  800427:	ff 30                	pushl  (%eax)
  800429:	ff d6                	call   *%esi
			break;
  80042b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80042e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800431:	e9 33 03 00 00       	jmp    800769 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800436:	8b 45 14             	mov    0x14(%ebp),%eax
  800439:	8d 78 04             	lea    0x4(%eax),%edi
  80043c:	8b 00                	mov    (%eax),%eax
  80043e:	99                   	cltd   
  80043f:	31 d0                	xor    %edx,%eax
  800441:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800443:	83 f8 11             	cmp    $0x11,%eax
  800446:	7f 23                	jg     80046b <vprintfmt+0x148>
  800448:	8b 14 85 e0 28 80 00 	mov    0x8028e0(,%eax,4),%edx
  80044f:	85 d2                	test   %edx,%edx
  800451:	74 18                	je     80046b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800453:	52                   	push   %edx
  800454:	68 fd 29 80 00       	push   $0x8029fd
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 a6 fe ff ff       	call   800306 <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
  800466:	e9 fe 02 00 00       	jmp    800769 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80046b:	50                   	push   %eax
  80046c:	68 b9 25 80 00       	push   $0x8025b9
  800471:	53                   	push   %ebx
  800472:	56                   	push   %esi
  800473:	e8 8e fe ff ff       	call   800306 <printfmt>
  800478:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80047b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80047e:	e9 e6 02 00 00       	jmp    800769 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800483:	8b 45 14             	mov    0x14(%ebp),%eax
  800486:	83 c0 04             	add    $0x4,%eax
  800489:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80048c:	8b 45 14             	mov    0x14(%ebp),%eax
  80048f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800491:	85 c9                	test   %ecx,%ecx
  800493:	b8 b2 25 80 00       	mov    $0x8025b2,%eax
  800498:	0f 45 c1             	cmovne %ecx,%eax
  80049b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80049e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004a2:	7e 06                	jle    8004aa <vprintfmt+0x187>
  8004a4:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a8:	75 0d                	jne    8004b7 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004ad:	89 c7                	mov    %eax,%edi
  8004af:	03 45 e0             	add    -0x20(%ebp),%eax
  8004b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004b5:	eb 53                	jmp    80050a <vprintfmt+0x1e7>
  8004b7:	83 ec 08             	sub    $0x8,%esp
  8004ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8004bd:	50                   	push   %eax
  8004be:	e8 71 04 00 00       	call   800934 <strnlen>
  8004c3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c6:	29 c1                	sub    %eax,%ecx
  8004c8:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004cb:	83 c4 10             	add    $0x10,%esp
  8004ce:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004d0:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d7:	eb 0f                	jmp    8004e8 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d9:	83 ec 08             	sub    $0x8,%esp
  8004dc:	53                   	push   %ebx
  8004dd:	ff 75 e0             	pushl  -0x20(%ebp)
  8004e0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e2:	83 ef 01             	sub    $0x1,%edi
  8004e5:	83 c4 10             	add    $0x10,%esp
  8004e8:	85 ff                	test   %edi,%edi
  8004ea:	7f ed                	jg     8004d9 <vprintfmt+0x1b6>
  8004ec:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004ef:	85 c9                	test   %ecx,%ecx
  8004f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f6:	0f 49 c1             	cmovns %ecx,%eax
  8004f9:	29 c1                	sub    %eax,%ecx
  8004fb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004fe:	eb aa                	jmp    8004aa <vprintfmt+0x187>
					putch(ch, putdat);
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	53                   	push   %ebx
  800504:	52                   	push   %edx
  800505:	ff d6                	call   *%esi
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80050d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050f:	83 c7 01             	add    $0x1,%edi
  800512:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800516:	0f be d0             	movsbl %al,%edx
  800519:	85 d2                	test   %edx,%edx
  80051b:	74 4b                	je     800568 <vprintfmt+0x245>
  80051d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800521:	78 06                	js     800529 <vprintfmt+0x206>
  800523:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800527:	78 1e                	js     800547 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800529:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80052d:	74 d1                	je     800500 <vprintfmt+0x1dd>
  80052f:	0f be c0             	movsbl %al,%eax
  800532:	83 e8 20             	sub    $0x20,%eax
  800535:	83 f8 5e             	cmp    $0x5e,%eax
  800538:	76 c6                	jbe    800500 <vprintfmt+0x1dd>
					putch('?', putdat);
  80053a:	83 ec 08             	sub    $0x8,%esp
  80053d:	53                   	push   %ebx
  80053e:	6a 3f                	push   $0x3f
  800540:	ff d6                	call   *%esi
  800542:	83 c4 10             	add    $0x10,%esp
  800545:	eb c3                	jmp    80050a <vprintfmt+0x1e7>
  800547:	89 cf                	mov    %ecx,%edi
  800549:	eb 0e                	jmp    800559 <vprintfmt+0x236>
				putch(' ', putdat);
  80054b:	83 ec 08             	sub    $0x8,%esp
  80054e:	53                   	push   %ebx
  80054f:	6a 20                	push   $0x20
  800551:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800553:	83 ef 01             	sub    $0x1,%edi
  800556:	83 c4 10             	add    $0x10,%esp
  800559:	85 ff                	test   %edi,%edi
  80055b:	7f ee                	jg     80054b <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  80055d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800560:	89 45 14             	mov    %eax,0x14(%ebp)
  800563:	e9 01 02 00 00       	jmp    800769 <vprintfmt+0x446>
  800568:	89 cf                	mov    %ecx,%edi
  80056a:	eb ed                	jmp    800559 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80056c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  80056f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800576:	e9 eb fd ff ff       	jmp    800366 <vprintfmt+0x43>
	if (lflag >= 2)
  80057b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80057f:	7f 21                	jg     8005a2 <vprintfmt+0x27f>
	else if (lflag)
  800581:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800585:	74 68                	je     8005ef <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8b 00                	mov    (%eax),%eax
  80058c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80058f:	89 c1                	mov    %eax,%ecx
  800591:	c1 f9 1f             	sar    $0x1f,%ecx
  800594:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8d 40 04             	lea    0x4(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
  8005a0:	eb 17                	jmp    8005b9 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  8005a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a5:	8b 50 04             	mov    0x4(%eax),%edx
  8005a8:	8b 00                	mov    (%eax),%eax
  8005aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b3:	8d 40 08             	lea    0x8(%eax),%eax
  8005b6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005bc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005c5:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c9:	78 3f                	js     80060a <vprintfmt+0x2e7>
			base = 10;
  8005cb:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005d0:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005d4:	0f 84 71 01 00 00    	je     80074b <vprintfmt+0x428>
				putch('+', putdat);
  8005da:	83 ec 08             	sub    $0x8,%esp
  8005dd:	53                   	push   %ebx
  8005de:	6a 2b                	push   $0x2b
  8005e0:	ff d6                	call   *%esi
  8005e2:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ea:	e9 5c 01 00 00       	jmp    80074b <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	8b 00                	mov    (%eax),%eax
  8005f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f7:	89 c1                	mov    %eax,%ecx
  8005f9:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fc:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800602:	8d 40 04             	lea    0x4(%eax),%eax
  800605:	89 45 14             	mov    %eax,0x14(%ebp)
  800608:	eb af                	jmp    8005b9 <vprintfmt+0x296>
				putch('-', putdat);
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	53                   	push   %ebx
  80060e:	6a 2d                	push   $0x2d
  800610:	ff d6                	call   *%esi
				num = -(long long) num;
  800612:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800615:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800618:	f7 d8                	neg    %eax
  80061a:	83 d2 00             	adc    $0x0,%edx
  80061d:	f7 da                	neg    %edx
  80061f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800622:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800625:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800628:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062d:	e9 19 01 00 00       	jmp    80074b <vprintfmt+0x428>
	if (lflag >= 2)
  800632:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800636:	7f 29                	jg     800661 <vprintfmt+0x33e>
	else if (lflag)
  800638:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80063c:	74 44                	je     800682 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  80063e:	8b 45 14             	mov    0x14(%ebp),%eax
  800641:	8b 00                	mov    (%eax),%eax
  800643:	ba 00 00 00 00       	mov    $0x0,%edx
  800648:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8d 40 04             	lea    0x4(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800657:	b8 0a 00 00 00       	mov    $0xa,%eax
  80065c:	e9 ea 00 00 00       	jmp    80074b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 50 04             	mov    0x4(%eax),%edx
  800667:	8b 00                	mov    (%eax),%eax
  800669:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066f:	8b 45 14             	mov    0x14(%ebp),%eax
  800672:	8d 40 08             	lea    0x8(%eax),%eax
  800675:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800678:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067d:	e9 c9 00 00 00       	jmp    80074b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800682:	8b 45 14             	mov    0x14(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	ba 00 00 00 00       	mov    $0x0,%edx
  80068c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80068f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80069b:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a0:	e9 a6 00 00 00       	jmp    80074b <vprintfmt+0x428>
			putch('0', putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	6a 30                	push   $0x30
  8006ab:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006ad:	83 c4 10             	add    $0x10,%esp
  8006b0:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006b4:	7f 26                	jg     8006dc <vprintfmt+0x3b9>
	else if (lflag)
  8006b6:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ba:	74 3e                	je     8006fa <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006d5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006da:	eb 6f                	jmp    80074b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006df:	8b 50 04             	mov    0x4(%eax),%edx
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 40 08             	lea    0x8(%eax),%eax
  8006f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f3:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f8:	eb 51                	jmp    80074b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	ba 00 00 00 00       	mov    $0x0,%edx
  800704:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800707:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070a:	8b 45 14             	mov    0x14(%ebp),%eax
  80070d:	8d 40 04             	lea    0x4(%eax),%eax
  800710:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800713:	b8 08 00 00 00       	mov    $0x8,%eax
  800718:	eb 31                	jmp    80074b <vprintfmt+0x428>
			putch('0', putdat);
  80071a:	83 ec 08             	sub    $0x8,%esp
  80071d:	53                   	push   %ebx
  80071e:	6a 30                	push   $0x30
  800720:	ff d6                	call   *%esi
			putch('x', putdat);
  800722:	83 c4 08             	add    $0x8,%esp
  800725:	53                   	push   %ebx
  800726:	6a 78                	push   $0x78
  800728:	ff d6                	call   *%esi
			num = (unsigned long long)
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	ba 00 00 00 00       	mov    $0x0,%edx
  800734:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800737:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  80073a:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800746:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80074b:	83 ec 0c             	sub    $0xc,%esp
  80074e:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800752:	52                   	push   %edx
  800753:	ff 75 e0             	pushl  -0x20(%ebp)
  800756:	50                   	push   %eax
  800757:	ff 75 dc             	pushl  -0x24(%ebp)
  80075a:	ff 75 d8             	pushl  -0x28(%ebp)
  80075d:	89 da                	mov    %ebx,%edx
  80075f:	89 f0                	mov    %esi,%eax
  800761:	e8 a4 fa ff ff       	call   80020a <printnum>
			break;
  800766:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800769:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	83 c7 01             	add    $0x1,%edi
  80076f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800773:	83 f8 25             	cmp    $0x25,%eax
  800776:	0f 84 be fb ff ff    	je     80033a <vprintfmt+0x17>
			if (ch == '\0')
  80077c:	85 c0                	test   %eax,%eax
  80077e:	0f 84 28 01 00 00    	je     8008ac <vprintfmt+0x589>
			putch(ch, putdat);
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	53                   	push   %ebx
  800788:	50                   	push   %eax
  800789:	ff d6                	call   *%esi
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	eb dc                	jmp    80076c <vprintfmt+0x449>
	if (lflag >= 2)
  800790:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800794:	7f 26                	jg     8007bc <vprintfmt+0x499>
	else if (lflag)
  800796:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80079a:	74 41                	je     8007dd <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8007af:	8d 40 04             	lea    0x4(%eax),%eax
  8007b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007b5:	b8 10 00 00 00       	mov    $0x10,%eax
  8007ba:	eb 8f                	jmp    80074b <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 50 04             	mov    0x4(%eax),%edx
  8007c2:	8b 00                	mov    (%eax),%eax
  8007c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8d 40 08             	lea    0x8(%eax),%eax
  8007d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d3:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d8:	e9 6e ff ff ff       	jmp    80074b <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ea:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f0:	8d 40 04             	lea    0x4(%eax),%eax
  8007f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f6:	b8 10 00 00 00       	mov    $0x10,%eax
  8007fb:	e9 4b ff ff ff       	jmp    80074b <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	85 c0                	test   %eax,%eax
  800810:	74 14                	je     800826 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800812:	8b 13                	mov    (%ebx),%edx
  800814:	83 fa 7f             	cmp    $0x7f,%edx
  800817:	7f 37                	jg     800850 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800819:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80081e:	89 45 14             	mov    %eax,0x14(%ebp)
  800821:	e9 43 ff ff ff       	jmp    800769 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800826:	b8 0a 00 00 00       	mov    $0xa,%eax
  80082b:	bf d5 26 80 00       	mov    $0x8026d5,%edi
							putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	53                   	push   %ebx
  800834:	50                   	push   %eax
  800835:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800837:	83 c7 01             	add    $0x1,%edi
  80083a:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	85 c0                	test   %eax,%eax
  800843:	75 eb                	jne    800830 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  800845:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800848:	89 45 14             	mov    %eax,0x14(%ebp)
  80084b:	e9 19 ff ff ff       	jmp    800769 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800850:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800852:	b8 0a 00 00 00       	mov    $0xa,%eax
  800857:	bf 0d 27 80 00       	mov    $0x80270d,%edi
							putch(ch, putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	53                   	push   %ebx
  800860:	50                   	push   %eax
  800861:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800863:	83 c7 01             	add    $0x1,%edi
  800866:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80086a:	83 c4 10             	add    $0x10,%esp
  80086d:	85 c0                	test   %eax,%eax
  80086f:	75 eb                	jne    80085c <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800874:	89 45 14             	mov    %eax,0x14(%ebp)
  800877:	e9 ed fe ff ff       	jmp    800769 <vprintfmt+0x446>
			putch(ch, putdat);
  80087c:	83 ec 08             	sub    $0x8,%esp
  80087f:	53                   	push   %ebx
  800880:	6a 25                	push   $0x25
  800882:	ff d6                	call   *%esi
			break;
  800884:	83 c4 10             	add    $0x10,%esp
  800887:	e9 dd fe ff ff       	jmp    800769 <vprintfmt+0x446>
			putch('%', putdat);
  80088c:	83 ec 08             	sub    $0x8,%esp
  80088f:	53                   	push   %ebx
  800890:	6a 25                	push   $0x25
  800892:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800894:	83 c4 10             	add    $0x10,%esp
  800897:	89 f8                	mov    %edi,%eax
  800899:	eb 03                	jmp    80089e <vprintfmt+0x57b>
  80089b:	83 e8 01             	sub    $0x1,%eax
  80089e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008a2:	75 f7                	jne    80089b <vprintfmt+0x578>
  8008a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a7:	e9 bd fe ff ff       	jmp    800769 <vprintfmt+0x446>
}
  8008ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008af:	5b                   	pop    %ebx
  8008b0:	5e                   	pop    %esi
  8008b1:	5f                   	pop    %edi
  8008b2:	5d                   	pop    %ebp
  8008b3:	c3                   	ret    

008008b4 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b4:	55                   	push   %ebp
  8008b5:	89 e5                	mov    %esp,%ebp
  8008b7:	83 ec 18             	sub    $0x18,%esp
  8008ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bd:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008c3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c7:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008d1:	85 c0                	test   %eax,%eax
  8008d3:	74 26                	je     8008fb <vsnprintf+0x47>
  8008d5:	85 d2                	test   %edx,%edx
  8008d7:	7e 22                	jle    8008fb <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d9:	ff 75 14             	pushl  0x14(%ebp)
  8008dc:	ff 75 10             	pushl  0x10(%ebp)
  8008df:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008e2:	50                   	push   %eax
  8008e3:	68 e9 02 80 00       	push   $0x8002e9
  8008e8:	e8 36 fa ff ff       	call   800323 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008f0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f6:	83 c4 10             	add    $0x10,%esp
}
  8008f9:	c9                   	leave  
  8008fa:	c3                   	ret    
		return -E_INVAL;
  8008fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800900:	eb f7                	jmp    8008f9 <vsnprintf+0x45>

00800902 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800902:	55                   	push   %ebp
  800903:	89 e5                	mov    %esp,%ebp
  800905:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800908:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80090b:	50                   	push   %eax
  80090c:	ff 75 10             	pushl  0x10(%ebp)
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	ff 75 08             	pushl  0x8(%ebp)
  800915:	e8 9a ff ff ff       	call   8008b4 <vsnprintf>
	va_end(ap);

	return rc;
}
  80091a:	c9                   	leave  
  80091b:	c3                   	ret    

0080091c <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091c:	55                   	push   %ebp
  80091d:	89 e5                	mov    %esp,%ebp
  80091f:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800922:	b8 00 00 00 00       	mov    $0x0,%eax
  800927:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092b:	74 05                	je     800932 <strlen+0x16>
		n++;
  80092d:	83 c0 01             	add    $0x1,%eax
  800930:	eb f5                	jmp    800927 <strlen+0xb>
	return n;
}
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    

00800934 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800934:	55                   	push   %ebp
  800935:	89 e5                	mov    %esp,%ebp
  800937:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093d:	ba 00 00 00 00       	mov    $0x0,%edx
  800942:	39 c2                	cmp    %eax,%edx
  800944:	74 0d                	je     800953 <strnlen+0x1f>
  800946:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  80094a:	74 05                	je     800951 <strnlen+0x1d>
		n++;
  80094c:	83 c2 01             	add    $0x1,%edx
  80094f:	eb f1                	jmp    800942 <strnlen+0xe>
  800951:	89 d0                	mov    %edx,%eax
	return n;
}
  800953:	5d                   	pop    %ebp
  800954:	c3                   	ret    

00800955 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800955:	55                   	push   %ebp
  800956:	89 e5                	mov    %esp,%ebp
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80095f:	ba 00 00 00 00       	mov    $0x0,%edx
  800964:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800968:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80096b:	83 c2 01             	add    $0x1,%edx
  80096e:	84 c9                	test   %cl,%cl
  800970:	75 f2                	jne    800964 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800972:	5b                   	pop    %ebx
  800973:	5d                   	pop    %ebp
  800974:	c3                   	ret    

00800975 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800975:	55                   	push   %ebp
  800976:	89 e5                	mov    %esp,%ebp
  800978:	53                   	push   %ebx
  800979:	83 ec 10             	sub    $0x10,%esp
  80097c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80097f:	53                   	push   %ebx
  800980:	e8 97 ff ff ff       	call   80091c <strlen>
  800985:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	01 d8                	add    %ebx,%eax
  80098d:	50                   	push   %eax
  80098e:	e8 c2 ff ff ff       	call   800955 <strcpy>
	return dst;
}
  800993:	89 d8                	mov    %ebx,%eax
  800995:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	56                   	push   %esi
  80099e:	53                   	push   %ebx
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009a5:	89 c6                	mov    %eax,%esi
  8009a7:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	39 f2                	cmp    %esi,%edx
  8009ae:	74 11                	je     8009c1 <strncpy+0x27>
		*dst++ = *src;
  8009b0:	83 c2 01             	add    $0x1,%edx
  8009b3:	0f b6 19             	movzbl (%ecx),%ebx
  8009b6:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b9:	80 fb 01             	cmp    $0x1,%bl
  8009bc:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009bf:	eb eb                	jmp    8009ac <strncpy+0x12>
	}
	return ret;
}
  8009c1:	5b                   	pop    %ebx
  8009c2:	5e                   	pop    %esi
  8009c3:	5d                   	pop    %ebp
  8009c4:	c3                   	ret    

008009c5 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009c5:	55                   	push   %ebp
  8009c6:	89 e5                	mov    %esp,%ebp
  8009c8:	56                   	push   %esi
  8009c9:	53                   	push   %ebx
  8009ca:	8b 75 08             	mov    0x8(%ebp),%esi
  8009cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d0:	8b 55 10             	mov    0x10(%ebp),%edx
  8009d3:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009d5:	85 d2                	test   %edx,%edx
  8009d7:	74 21                	je     8009fa <strlcpy+0x35>
  8009d9:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009dd:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009df:	39 c2                	cmp    %eax,%edx
  8009e1:	74 14                	je     8009f7 <strlcpy+0x32>
  8009e3:	0f b6 19             	movzbl (%ecx),%ebx
  8009e6:	84 db                	test   %bl,%bl
  8009e8:	74 0b                	je     8009f5 <strlcpy+0x30>
			*dst++ = *src++;
  8009ea:	83 c1 01             	add    $0x1,%ecx
  8009ed:	83 c2 01             	add    $0x1,%edx
  8009f0:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009f3:	eb ea                	jmp    8009df <strlcpy+0x1a>
  8009f5:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009fa:	29 f0                	sub    %esi,%eax
}
  8009fc:	5b                   	pop    %ebx
  8009fd:	5e                   	pop    %esi
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    

00800a00 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a06:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a09:	0f b6 01             	movzbl (%ecx),%eax
  800a0c:	84 c0                	test   %al,%al
  800a0e:	74 0c                	je     800a1c <strcmp+0x1c>
  800a10:	3a 02                	cmp    (%edx),%al
  800a12:	75 08                	jne    800a1c <strcmp+0x1c>
		p++, q++;
  800a14:	83 c1 01             	add    $0x1,%ecx
  800a17:	83 c2 01             	add    $0x1,%edx
  800a1a:	eb ed                	jmp    800a09 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a1c:	0f b6 c0             	movzbl %al,%eax
  800a1f:	0f b6 12             	movzbl (%edx),%edx
  800a22:	29 d0                	sub    %edx,%eax
}
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    

00800a26 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	53                   	push   %ebx
  800a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a30:	89 c3                	mov    %eax,%ebx
  800a32:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a35:	eb 06                	jmp    800a3d <strncmp+0x17>
		n--, p++, q++;
  800a37:	83 c0 01             	add    $0x1,%eax
  800a3a:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a3d:	39 d8                	cmp    %ebx,%eax
  800a3f:	74 16                	je     800a57 <strncmp+0x31>
  800a41:	0f b6 08             	movzbl (%eax),%ecx
  800a44:	84 c9                	test   %cl,%cl
  800a46:	74 04                	je     800a4c <strncmp+0x26>
  800a48:	3a 0a                	cmp    (%edx),%cl
  800a4a:	74 eb                	je     800a37 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a4c:	0f b6 00             	movzbl (%eax),%eax
  800a4f:	0f b6 12             	movzbl (%edx),%edx
  800a52:	29 d0                	sub    %edx,%eax
}
  800a54:	5b                   	pop    %ebx
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    
		return 0;
  800a57:	b8 00 00 00 00       	mov    $0x0,%eax
  800a5c:	eb f6                	jmp    800a54 <strncmp+0x2e>

00800a5e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a68:	0f b6 10             	movzbl (%eax),%edx
  800a6b:	84 d2                	test   %dl,%dl
  800a6d:	74 09                	je     800a78 <strchr+0x1a>
		if (*s == c)
  800a6f:	38 ca                	cmp    %cl,%dl
  800a71:	74 0a                	je     800a7d <strchr+0x1f>
	for (; *s; s++)
  800a73:	83 c0 01             	add    $0x1,%eax
  800a76:	eb f0                	jmp    800a68 <strchr+0xa>
			return (char *) s;
	return 0;
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7d:	5d                   	pop    %ebp
  800a7e:	c3                   	ret    

00800a7f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a7f:	55                   	push   %ebp
  800a80:	89 e5                	mov    %esp,%ebp
  800a82:	8b 45 08             	mov    0x8(%ebp),%eax
  800a85:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a89:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a8c:	38 ca                	cmp    %cl,%dl
  800a8e:	74 09                	je     800a99 <strfind+0x1a>
  800a90:	84 d2                	test   %dl,%dl
  800a92:	74 05                	je     800a99 <strfind+0x1a>
	for (; *s; s++)
  800a94:	83 c0 01             	add    $0x1,%eax
  800a97:	eb f0                	jmp    800a89 <strfind+0xa>
			break;
	return (char *) s;
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	57                   	push   %edi
  800a9f:	56                   	push   %esi
  800aa0:	53                   	push   %ebx
  800aa1:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aa4:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa7:	85 c9                	test   %ecx,%ecx
  800aa9:	74 31                	je     800adc <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aab:	89 f8                	mov    %edi,%eax
  800aad:	09 c8                	or     %ecx,%eax
  800aaf:	a8 03                	test   $0x3,%al
  800ab1:	75 23                	jne    800ad6 <memset+0x3b>
		c &= 0xFF;
  800ab3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab7:	89 d3                	mov    %edx,%ebx
  800ab9:	c1 e3 08             	shl    $0x8,%ebx
  800abc:	89 d0                	mov    %edx,%eax
  800abe:	c1 e0 18             	shl    $0x18,%eax
  800ac1:	89 d6                	mov    %edx,%esi
  800ac3:	c1 e6 10             	shl    $0x10,%esi
  800ac6:	09 f0                	or     %esi,%eax
  800ac8:	09 c2                	or     %eax,%edx
  800aca:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800acc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800acf:	89 d0                	mov    %edx,%eax
  800ad1:	fc                   	cld    
  800ad2:	f3 ab                	rep stos %eax,%es:(%edi)
  800ad4:	eb 06                	jmp    800adc <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	fc                   	cld    
  800ada:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800adc:	89 f8                	mov    %edi,%eax
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    

00800ae3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ae3:	55                   	push   %ebp
  800ae4:	89 e5                	mov    %esp,%ebp
  800ae6:	57                   	push   %edi
  800ae7:	56                   	push   %esi
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  800aeb:	8b 75 0c             	mov    0xc(%ebp),%esi
  800aee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800af1:	39 c6                	cmp    %eax,%esi
  800af3:	73 32                	jae    800b27 <memmove+0x44>
  800af5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af8:	39 c2                	cmp    %eax,%edx
  800afa:	76 2b                	jbe    800b27 <memmove+0x44>
		s += n;
		d += n;
  800afc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aff:	89 fe                	mov    %edi,%esi
  800b01:	09 ce                	or     %ecx,%esi
  800b03:	09 d6                	or     %edx,%esi
  800b05:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b0b:	75 0e                	jne    800b1b <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b0d:	83 ef 04             	sub    $0x4,%edi
  800b10:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b13:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b16:	fd                   	std    
  800b17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b19:	eb 09                	jmp    800b24 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b1b:	83 ef 01             	sub    $0x1,%edi
  800b1e:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b21:	fd                   	std    
  800b22:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b24:	fc                   	cld    
  800b25:	eb 1a                	jmp    800b41 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b27:	89 c2                	mov    %eax,%edx
  800b29:	09 ca                	or     %ecx,%edx
  800b2b:	09 f2                	or     %esi,%edx
  800b2d:	f6 c2 03             	test   $0x3,%dl
  800b30:	75 0a                	jne    800b3c <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b32:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b35:	89 c7                	mov    %eax,%edi
  800b37:	fc                   	cld    
  800b38:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3a:	eb 05                	jmp    800b41 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b3c:	89 c7                	mov    %eax,%edi
  800b3e:	fc                   	cld    
  800b3f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b41:	5e                   	pop    %esi
  800b42:	5f                   	pop    %edi
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b4b:	ff 75 10             	pushl  0x10(%ebp)
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	ff 75 08             	pushl  0x8(%ebp)
  800b54:	e8 8a ff ff ff       	call   800ae3 <memmove>
}
  800b59:	c9                   	leave  
  800b5a:	c3                   	ret    

00800b5b <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
  800b60:	8b 45 08             	mov    0x8(%ebp),%eax
  800b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b66:	89 c6                	mov    %eax,%esi
  800b68:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b6b:	39 f0                	cmp    %esi,%eax
  800b6d:	74 1c                	je     800b8b <memcmp+0x30>
		if (*s1 != *s2)
  800b6f:	0f b6 08             	movzbl (%eax),%ecx
  800b72:	0f b6 1a             	movzbl (%edx),%ebx
  800b75:	38 d9                	cmp    %bl,%cl
  800b77:	75 08                	jne    800b81 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b79:	83 c0 01             	add    $0x1,%eax
  800b7c:	83 c2 01             	add    $0x1,%edx
  800b7f:	eb ea                	jmp    800b6b <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b81:	0f b6 c1             	movzbl %cl,%eax
  800b84:	0f b6 db             	movzbl %bl,%ebx
  800b87:	29 d8                	sub    %ebx,%eax
  800b89:	eb 05                	jmp    800b90 <memcmp+0x35>
	}

	return 0;
  800b8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b90:	5b                   	pop    %ebx
  800b91:	5e                   	pop    %esi
  800b92:	5d                   	pop    %ebp
  800b93:	c3                   	ret    

00800b94 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b94:	55                   	push   %ebp
  800b95:	89 e5                	mov    %esp,%ebp
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b9d:	89 c2                	mov    %eax,%edx
  800b9f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ba2:	39 d0                	cmp    %edx,%eax
  800ba4:	73 09                	jae    800baf <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba6:	38 08                	cmp    %cl,(%eax)
  800ba8:	74 05                	je     800baf <memfind+0x1b>
	for (; s < ends; s++)
  800baa:	83 c0 01             	add    $0x1,%eax
  800bad:	eb f3                	jmp    800ba2 <memfind+0xe>
			break;
	return (void *) s;
}
  800baf:	5d                   	pop    %ebp
  800bb0:	c3                   	ret    

00800bb1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bb1:	55                   	push   %ebp
  800bb2:	89 e5                	mov    %esp,%ebp
  800bb4:	57                   	push   %edi
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
  800bb7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bba:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bbd:	eb 03                	jmp    800bc2 <strtol+0x11>
		s++;
  800bbf:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bc2:	0f b6 01             	movzbl (%ecx),%eax
  800bc5:	3c 20                	cmp    $0x20,%al
  800bc7:	74 f6                	je     800bbf <strtol+0xe>
  800bc9:	3c 09                	cmp    $0x9,%al
  800bcb:	74 f2                	je     800bbf <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bcd:	3c 2b                	cmp    $0x2b,%al
  800bcf:	74 2a                	je     800bfb <strtol+0x4a>
	int neg = 0;
  800bd1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd6:	3c 2d                	cmp    $0x2d,%al
  800bd8:	74 2b                	je     800c05 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bda:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800be0:	75 0f                	jne    800bf1 <strtol+0x40>
  800be2:	80 39 30             	cmpb   $0x30,(%ecx)
  800be5:	74 28                	je     800c0f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be7:	85 db                	test   %ebx,%ebx
  800be9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bee:	0f 44 d8             	cmove  %eax,%ebx
  800bf1:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf6:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf9:	eb 50                	jmp    800c4b <strtol+0x9a>
		s++;
  800bfb:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bfe:	bf 00 00 00 00       	mov    $0x0,%edi
  800c03:	eb d5                	jmp    800bda <strtol+0x29>
		s++, neg = 1;
  800c05:	83 c1 01             	add    $0x1,%ecx
  800c08:	bf 01 00 00 00       	mov    $0x1,%edi
  800c0d:	eb cb                	jmp    800bda <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c0f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c13:	74 0e                	je     800c23 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c15:	85 db                	test   %ebx,%ebx
  800c17:	75 d8                	jne    800bf1 <strtol+0x40>
		s++, base = 8;
  800c19:	83 c1 01             	add    $0x1,%ecx
  800c1c:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c21:	eb ce                	jmp    800bf1 <strtol+0x40>
		s += 2, base = 16;
  800c23:	83 c1 02             	add    $0x2,%ecx
  800c26:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c2b:	eb c4                	jmp    800bf1 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c2d:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c30:	89 f3                	mov    %esi,%ebx
  800c32:	80 fb 19             	cmp    $0x19,%bl
  800c35:	77 29                	ja     800c60 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c37:	0f be d2             	movsbl %dl,%edx
  800c3a:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c3d:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c40:	7d 30                	jge    800c72 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c42:	83 c1 01             	add    $0x1,%ecx
  800c45:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c49:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c4b:	0f b6 11             	movzbl (%ecx),%edx
  800c4e:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c51:	89 f3                	mov    %esi,%ebx
  800c53:	80 fb 09             	cmp    $0x9,%bl
  800c56:	77 d5                	ja     800c2d <strtol+0x7c>
			dig = *s - '0';
  800c58:	0f be d2             	movsbl %dl,%edx
  800c5b:	83 ea 30             	sub    $0x30,%edx
  800c5e:	eb dd                	jmp    800c3d <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c60:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c63:	89 f3                	mov    %esi,%ebx
  800c65:	80 fb 19             	cmp    $0x19,%bl
  800c68:	77 08                	ja     800c72 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c6a:	0f be d2             	movsbl %dl,%edx
  800c6d:	83 ea 37             	sub    $0x37,%edx
  800c70:	eb cb                	jmp    800c3d <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c76:	74 05                	je     800c7d <strtol+0xcc>
		*endptr = (char *) s;
  800c78:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c7b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c7d:	89 c2                	mov    %eax,%edx
  800c7f:	f7 da                	neg    %edx
  800c81:	85 ff                	test   %edi,%edi
  800c83:	0f 45 c2             	cmovne %edx,%eax
}
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5f                   	pop    %edi
  800c89:	5d                   	pop    %ebp
  800c8a:	c3                   	ret    

00800c8b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c8b:	55                   	push   %ebp
  800c8c:	89 e5                	mov    %esp,%ebp
  800c8e:	57                   	push   %edi
  800c8f:	56                   	push   %esi
  800c90:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c91:	b8 00 00 00 00       	mov    $0x0,%eax
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c9c:	89 c3                	mov    %eax,%ebx
  800c9e:	89 c7                	mov    %eax,%edi
  800ca0:	89 c6                	mov    %eax,%esi
  800ca2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800caf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb4:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb9:	89 d1                	mov    %edx,%ecx
  800cbb:	89 d3                	mov    %edx,%ebx
  800cbd:	89 d7                	mov    %edx,%edi
  800cbf:	89 d6                	mov    %edx,%esi
  800cc1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	57                   	push   %edi
  800ccc:	56                   	push   %esi
  800ccd:	53                   	push   %ebx
  800cce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	b8 03 00 00 00       	mov    $0x3,%eax
  800cde:	89 cb                	mov    %ecx,%ebx
  800ce0:	89 cf                	mov    %ecx,%edi
  800ce2:	89 ce                	mov    %ecx,%esi
  800ce4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce6:	85 c0                	test   %eax,%eax
  800ce8:	7f 08                	jg     800cf2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5f                   	pop    %edi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf2:	83 ec 0c             	sub    $0xc,%esp
  800cf5:	50                   	push   %eax
  800cf6:	6a 03                	push   $0x3
  800cf8:	68 28 29 80 00       	push   $0x802928
  800cfd:	6a 43                	push   $0x43
  800cff:	68 45 29 80 00       	push   $0x802945
  800d04:	e8 89 14 00 00       	call   802192 <_panic>

00800d09 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	57                   	push   %edi
  800d0d:	56                   	push   %esi
  800d0e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d14:	b8 02 00 00 00       	mov    $0x2,%eax
  800d19:	89 d1                	mov    %edx,%ecx
  800d1b:	89 d3                	mov    %edx,%ebx
  800d1d:	89 d7                	mov    %edx,%edi
  800d1f:	89 d6                	mov    %edx,%esi
  800d21:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d23:	5b                   	pop    %ebx
  800d24:	5e                   	pop    %esi
  800d25:	5f                   	pop    %edi
  800d26:	5d                   	pop    %ebp
  800d27:	c3                   	ret    

00800d28 <sys_yield>:

void
sys_yield(void)
{
  800d28:	55                   	push   %ebp
  800d29:	89 e5                	mov    %esp,%ebp
  800d2b:	57                   	push   %edi
  800d2c:	56                   	push   %esi
  800d2d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800d33:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d38:	89 d1                	mov    %edx,%ecx
  800d3a:	89 d3                	mov    %edx,%ebx
  800d3c:	89 d7                	mov    %edx,%edi
  800d3e:	89 d6                	mov    %edx,%esi
  800d40:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d50:	be 00 00 00 00       	mov    $0x0,%esi
  800d55:	8b 55 08             	mov    0x8(%ebp),%edx
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d60:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d63:	89 f7                	mov    %esi,%edi
  800d65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d67:	85 c0                	test   %eax,%eax
  800d69:	7f 08                	jg     800d73 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6e:	5b                   	pop    %ebx
  800d6f:	5e                   	pop    %esi
  800d70:	5f                   	pop    %edi
  800d71:	5d                   	pop    %ebp
  800d72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d73:	83 ec 0c             	sub    $0xc,%esp
  800d76:	50                   	push   %eax
  800d77:	6a 04                	push   $0x4
  800d79:	68 28 29 80 00       	push   $0x802928
  800d7e:	6a 43                	push   $0x43
  800d80:	68 45 29 80 00       	push   $0x802945
  800d85:	e8 08 14 00 00       	call   802192 <_panic>

00800d8a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
  800d90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d93:	8b 55 08             	mov    0x8(%ebp),%edx
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	b8 05 00 00 00       	mov    $0x5,%eax
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da4:	8b 75 18             	mov    0x18(%ebp),%esi
  800da7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	7f 08                	jg     800db5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db5:	83 ec 0c             	sub    $0xc,%esp
  800db8:	50                   	push   %eax
  800db9:	6a 05                	push   $0x5
  800dbb:	68 28 29 80 00       	push   $0x802928
  800dc0:	6a 43                	push   $0x43
  800dc2:	68 45 29 80 00       	push   $0x802945
  800dc7:	e8 c6 13 00 00       	call   802192 <_panic>

00800dcc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
  800dd2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dda:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de0:	b8 06 00 00 00       	mov    $0x6,%eax
  800de5:	89 df                	mov    %ebx,%edi
  800de7:	89 de                	mov    %ebx,%esi
  800de9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800deb:	85 c0                	test   %eax,%eax
  800ded:	7f 08                	jg     800df7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800def:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df2:	5b                   	pop    %ebx
  800df3:	5e                   	pop    %esi
  800df4:	5f                   	pop    %edi
  800df5:	5d                   	pop    %ebp
  800df6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df7:	83 ec 0c             	sub    $0xc,%esp
  800dfa:	50                   	push   %eax
  800dfb:	6a 06                	push   $0x6
  800dfd:	68 28 29 80 00       	push   $0x802928
  800e02:	6a 43                	push   $0x43
  800e04:	68 45 29 80 00       	push   $0x802945
  800e09:	e8 84 13 00 00       	call   802192 <_panic>

00800e0e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
  800e14:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e17:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e22:	b8 08 00 00 00       	mov    $0x8,%eax
  800e27:	89 df                	mov    %ebx,%edi
  800e29:	89 de                	mov    %ebx,%esi
  800e2b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e2d:	85 c0                	test   %eax,%eax
  800e2f:	7f 08                	jg     800e39 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5f                   	pop    %edi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e39:	83 ec 0c             	sub    $0xc,%esp
  800e3c:	50                   	push   %eax
  800e3d:	6a 08                	push   $0x8
  800e3f:	68 28 29 80 00       	push   $0x802928
  800e44:	6a 43                	push   $0x43
  800e46:	68 45 29 80 00       	push   $0x802945
  800e4b:	e8 42 13 00 00       	call   802192 <_panic>

00800e50 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
  800e56:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e64:	b8 09 00 00 00       	mov    $0x9,%eax
  800e69:	89 df                	mov    %ebx,%edi
  800e6b:	89 de                	mov    %ebx,%esi
  800e6d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7f 08                	jg     800e7b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e76:	5b                   	pop    %ebx
  800e77:	5e                   	pop    %esi
  800e78:	5f                   	pop    %edi
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e7b:	83 ec 0c             	sub    $0xc,%esp
  800e7e:	50                   	push   %eax
  800e7f:	6a 09                	push   $0x9
  800e81:	68 28 29 80 00       	push   $0x802928
  800e86:	6a 43                	push   $0x43
  800e88:	68 45 29 80 00       	push   $0x802945
  800e8d:	e8 00 13 00 00       	call   802192 <_panic>

00800e92 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e92:	55                   	push   %ebp
  800e93:	89 e5                	mov    %esp,%ebp
  800e95:	57                   	push   %edi
  800e96:	56                   	push   %esi
  800e97:	53                   	push   %ebx
  800e98:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800eab:	89 df                	mov    %ebx,%edi
  800ead:	89 de                	mov    %ebx,%esi
  800eaf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb1:	85 c0                	test   %eax,%eax
  800eb3:	7f 08                	jg     800ebd <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb8:	5b                   	pop    %ebx
  800eb9:	5e                   	pop    %esi
  800eba:	5f                   	pop    %edi
  800ebb:	5d                   	pop    %ebp
  800ebc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ebd:	83 ec 0c             	sub    $0xc,%esp
  800ec0:	50                   	push   %eax
  800ec1:	6a 0a                	push   $0xa
  800ec3:	68 28 29 80 00       	push   $0x802928
  800ec8:	6a 43                	push   $0x43
  800eca:	68 45 29 80 00       	push   $0x802945
  800ecf:	e8 be 12 00 00       	call   802192 <_panic>

00800ed4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed4:	55                   	push   %ebp
  800ed5:	89 e5                	mov    %esp,%ebp
  800ed7:	57                   	push   %edi
  800ed8:	56                   	push   %esi
  800ed9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eda:	8b 55 08             	mov    0x8(%ebp),%edx
  800edd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ee5:	be 00 00 00 00       	mov    $0x0,%esi
  800eea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800eed:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ef2:	5b                   	pop    %ebx
  800ef3:	5e                   	pop    %esi
  800ef4:	5f                   	pop    %edi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	57                   	push   %edi
  800efb:	56                   	push   %esi
  800efc:	53                   	push   %ebx
  800efd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f00:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f05:	8b 55 08             	mov    0x8(%ebp),%edx
  800f08:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f0d:	89 cb                	mov    %ecx,%ebx
  800f0f:	89 cf                	mov    %ecx,%edi
  800f11:	89 ce                	mov    %ecx,%esi
  800f13:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f15:	85 c0                	test   %eax,%eax
  800f17:	7f 08                	jg     800f21 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f19:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1c:	5b                   	pop    %ebx
  800f1d:	5e                   	pop    %esi
  800f1e:	5f                   	pop    %edi
  800f1f:	5d                   	pop    %ebp
  800f20:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f21:	83 ec 0c             	sub    $0xc,%esp
  800f24:	50                   	push   %eax
  800f25:	6a 0d                	push   $0xd
  800f27:	68 28 29 80 00       	push   $0x802928
  800f2c:	6a 43                	push   $0x43
  800f2e:	68 45 29 80 00       	push   $0x802945
  800f33:	e8 5a 12 00 00       	call   802192 <_panic>

00800f38 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	57                   	push   %edi
  800f3c:	56                   	push   %esi
  800f3d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f43:	8b 55 08             	mov    0x8(%ebp),%edx
  800f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f49:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f4e:	89 df                	mov    %ebx,%edi
  800f50:	89 de                	mov    %ebx,%esi
  800f52:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f54:	5b                   	pop    %ebx
  800f55:	5e                   	pop    %esi
  800f56:	5f                   	pop    %edi
  800f57:	5d                   	pop    %ebp
  800f58:	c3                   	ret    

00800f59 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f59:	55                   	push   %ebp
  800f5a:	89 e5                	mov    %esp,%ebp
  800f5c:	57                   	push   %edi
  800f5d:	56                   	push   %esi
  800f5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f64:	8b 55 08             	mov    0x8(%ebp),%edx
  800f67:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f6c:	89 cb                	mov    %ecx,%ebx
  800f6e:	89 cf                	mov    %ecx,%edi
  800f70:	89 ce                	mov    %ecx,%esi
  800f72:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f74:	5b                   	pop    %ebx
  800f75:	5e                   	pop    %esi
  800f76:	5f                   	pop    %edi
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    

00800f79 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	57                   	push   %edi
  800f7d:	56                   	push   %esi
  800f7e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7f:	ba 00 00 00 00       	mov    $0x0,%edx
  800f84:	b8 10 00 00 00       	mov    $0x10,%eax
  800f89:	89 d1                	mov    %edx,%ecx
  800f8b:	89 d3                	mov    %edx,%ebx
  800f8d:	89 d7                	mov    %edx,%edi
  800f8f:	89 d6                	mov    %edx,%esi
  800f91:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f93:	5b                   	pop    %ebx
  800f94:	5e                   	pop    %esi
  800f95:	5f                   	pop    %edi
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
  800f9b:	57                   	push   %edi
  800f9c:	56                   	push   %esi
  800f9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa9:	b8 11 00 00 00       	mov    $0x11,%eax
  800fae:	89 df                	mov    %ebx,%edi
  800fb0:	89 de                	mov    %ebx,%esi
  800fb2:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fb4:	5b                   	pop    %ebx
  800fb5:	5e                   	pop    %esi
  800fb6:	5f                   	pop    %edi
  800fb7:	5d                   	pop    %ebp
  800fb8:	c3                   	ret    

00800fb9 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fb9:	55                   	push   %ebp
  800fba:	89 e5                	mov    %esp,%ebp
  800fbc:	57                   	push   %edi
  800fbd:	56                   	push   %esi
  800fbe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	b8 12 00 00 00       	mov    $0x12,%eax
  800fcf:	89 df                	mov    %ebx,%edi
  800fd1:	89 de                	mov    %ebx,%esi
  800fd3:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fd5:	5b                   	pop    %ebx
  800fd6:	5e                   	pop    %esi
  800fd7:	5f                   	pop    %edi
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	57                   	push   %edi
  800fde:	56                   	push   %esi
  800fdf:	53                   	push   %ebx
  800fe0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fe3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  800feb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fee:	b8 13 00 00 00       	mov    $0x13,%eax
  800ff3:	89 df                	mov    %ebx,%edi
  800ff5:	89 de                	mov    %ebx,%esi
  800ff7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff9:	85 c0                	test   %eax,%eax
  800ffb:	7f 08                	jg     801005 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801000:	5b                   	pop    %ebx
  801001:	5e                   	pop    %esi
  801002:	5f                   	pop    %edi
  801003:	5d                   	pop    %ebp
  801004:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801005:	83 ec 0c             	sub    $0xc,%esp
  801008:	50                   	push   %eax
  801009:	6a 13                	push   $0x13
  80100b:	68 28 29 80 00       	push   $0x802928
  801010:	6a 43                	push   $0x43
  801012:	68 45 29 80 00       	push   $0x802945
  801017:	e8 76 11 00 00       	call   802192 <_panic>

0080101c <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	57                   	push   %edi
  801020:	56                   	push   %esi
  801021:	53                   	push   %ebx
	asm volatile("int %1\n"
  801022:	b9 00 00 00 00       	mov    $0x0,%ecx
  801027:	8b 55 08             	mov    0x8(%ebp),%edx
  80102a:	b8 14 00 00 00       	mov    $0x14,%eax
  80102f:	89 cb                	mov    %ecx,%ebx
  801031:	89 cf                	mov    %ecx,%edi
  801033:	89 ce                	mov    %ecx,%esi
  801035:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801037:	5b                   	pop    %ebx
  801038:	5e                   	pop    %esi
  801039:	5f                   	pop    %edi
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	05 00 00 00 30       	add    $0x30000000,%eax
  801047:	c1 e8 0c             	shr    $0xc,%eax
}
  80104a:	5d                   	pop    %ebp
  80104b:	c3                   	ret    

0080104c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80104c:	55                   	push   %ebp
  80104d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80105c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801061:	5d                   	pop    %ebp
  801062:	c3                   	ret    

00801063 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80106b:	89 c2                	mov    %eax,%edx
  80106d:	c1 ea 16             	shr    $0x16,%edx
  801070:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801077:	f6 c2 01             	test   $0x1,%dl
  80107a:	74 2d                	je     8010a9 <fd_alloc+0x46>
  80107c:	89 c2                	mov    %eax,%edx
  80107e:	c1 ea 0c             	shr    $0xc,%edx
  801081:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801088:	f6 c2 01             	test   $0x1,%dl
  80108b:	74 1c                	je     8010a9 <fd_alloc+0x46>
  80108d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801092:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801097:	75 d2                	jne    80106b <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010a2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010a7:	eb 0a                	jmp    8010b3 <fd_alloc+0x50>
			*fd_store = fd;
  8010a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ac:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010bb:	83 f8 1f             	cmp    $0x1f,%eax
  8010be:	77 30                	ja     8010f0 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010c0:	c1 e0 0c             	shl    $0xc,%eax
  8010c3:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010c8:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010ce:	f6 c2 01             	test   $0x1,%dl
  8010d1:	74 24                	je     8010f7 <fd_lookup+0x42>
  8010d3:	89 c2                	mov    %eax,%edx
  8010d5:	c1 ea 0c             	shr    $0xc,%edx
  8010d8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010df:	f6 c2 01             	test   $0x1,%dl
  8010e2:	74 1a                	je     8010fe <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e7:	89 02                	mov    %eax,(%edx)
	return 0;
  8010e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    
		return -E_INVAL;
  8010f0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f5:	eb f7                	jmp    8010ee <fd_lookup+0x39>
		return -E_INVAL;
  8010f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fc:	eb f0                	jmp    8010ee <fd_lookup+0x39>
  8010fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801103:	eb e9                	jmp    8010ee <fd_lookup+0x39>

00801105 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
  80110b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80110e:	ba 00 00 00 00       	mov    $0x0,%edx
  801113:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801118:	39 08                	cmp    %ecx,(%eax)
  80111a:	74 38                	je     801154 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80111c:	83 c2 01             	add    $0x1,%edx
  80111f:	8b 04 95 d0 29 80 00 	mov    0x8029d0(,%edx,4),%eax
  801126:	85 c0                	test   %eax,%eax
  801128:	75 ee                	jne    801118 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80112a:	a1 08 40 80 00       	mov    0x804008,%eax
  80112f:	8b 40 48             	mov    0x48(%eax),%eax
  801132:	83 ec 04             	sub    $0x4,%esp
  801135:	51                   	push   %ecx
  801136:	50                   	push   %eax
  801137:	68 54 29 80 00       	push   $0x802954
  80113c:	e8 b5 f0 ff ff       	call   8001f6 <cprintf>
	*dev = 0;
  801141:	8b 45 0c             	mov    0xc(%ebp),%eax
  801144:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80114a:	83 c4 10             	add    $0x10,%esp
  80114d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801152:	c9                   	leave  
  801153:	c3                   	ret    
			*dev = devtab[i];
  801154:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801157:	89 01                	mov    %eax,(%ecx)
			return 0;
  801159:	b8 00 00 00 00       	mov    $0x0,%eax
  80115e:	eb f2                	jmp    801152 <dev_lookup+0x4d>

00801160 <fd_close>:
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	57                   	push   %edi
  801164:	56                   	push   %esi
  801165:	53                   	push   %ebx
  801166:	83 ec 24             	sub    $0x24,%esp
  801169:	8b 75 08             	mov    0x8(%ebp),%esi
  80116c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80116f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801172:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801173:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801179:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80117c:	50                   	push   %eax
  80117d:	e8 33 ff ff ff       	call   8010b5 <fd_lookup>
  801182:	89 c3                	mov    %eax,%ebx
  801184:	83 c4 10             	add    $0x10,%esp
  801187:	85 c0                	test   %eax,%eax
  801189:	78 05                	js     801190 <fd_close+0x30>
	    || fd != fd2)
  80118b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80118e:	74 16                	je     8011a6 <fd_close+0x46>
		return (must_exist ? r : 0);
  801190:	89 f8                	mov    %edi,%eax
  801192:	84 c0                	test   %al,%al
  801194:	b8 00 00 00 00       	mov    $0x0,%eax
  801199:	0f 44 d8             	cmove  %eax,%ebx
}
  80119c:	89 d8                	mov    %ebx,%eax
  80119e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a1:	5b                   	pop    %ebx
  8011a2:	5e                   	pop    %esi
  8011a3:	5f                   	pop    %edi
  8011a4:	5d                   	pop    %ebp
  8011a5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011a6:	83 ec 08             	sub    $0x8,%esp
  8011a9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011ac:	50                   	push   %eax
  8011ad:	ff 36                	pushl  (%esi)
  8011af:	e8 51 ff ff ff       	call   801105 <dev_lookup>
  8011b4:	89 c3                	mov    %eax,%ebx
  8011b6:	83 c4 10             	add    $0x10,%esp
  8011b9:	85 c0                	test   %eax,%eax
  8011bb:	78 1a                	js     8011d7 <fd_close+0x77>
		if (dev->dev_close)
  8011bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c0:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011c3:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	74 0b                	je     8011d7 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	56                   	push   %esi
  8011d0:	ff d0                	call   *%eax
  8011d2:	89 c3                	mov    %eax,%ebx
  8011d4:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011d7:	83 ec 08             	sub    $0x8,%esp
  8011da:	56                   	push   %esi
  8011db:	6a 00                	push   $0x0
  8011dd:	e8 ea fb ff ff       	call   800dcc <sys_page_unmap>
	return r;
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	eb b5                	jmp    80119c <fd_close+0x3c>

008011e7 <close>:

int
close(int fdnum)
{
  8011e7:	55                   	push   %ebp
  8011e8:	89 e5                	mov    %esp,%ebp
  8011ea:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ed:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f0:	50                   	push   %eax
  8011f1:	ff 75 08             	pushl  0x8(%ebp)
  8011f4:	e8 bc fe ff ff       	call   8010b5 <fd_lookup>
  8011f9:	83 c4 10             	add    $0x10,%esp
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	79 02                	jns    801202 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801200:	c9                   	leave  
  801201:	c3                   	ret    
		return fd_close(fd, 1);
  801202:	83 ec 08             	sub    $0x8,%esp
  801205:	6a 01                	push   $0x1
  801207:	ff 75 f4             	pushl  -0xc(%ebp)
  80120a:	e8 51 ff ff ff       	call   801160 <fd_close>
  80120f:	83 c4 10             	add    $0x10,%esp
  801212:	eb ec                	jmp    801200 <close+0x19>

00801214 <close_all>:

void
close_all(void)
{
  801214:	55                   	push   %ebp
  801215:	89 e5                	mov    %esp,%ebp
  801217:	53                   	push   %ebx
  801218:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80121b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801220:	83 ec 0c             	sub    $0xc,%esp
  801223:	53                   	push   %ebx
  801224:	e8 be ff ff ff       	call   8011e7 <close>
	for (i = 0; i < MAXFD; i++)
  801229:	83 c3 01             	add    $0x1,%ebx
  80122c:	83 c4 10             	add    $0x10,%esp
  80122f:	83 fb 20             	cmp    $0x20,%ebx
  801232:	75 ec                	jne    801220 <close_all+0xc>
}
  801234:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801237:	c9                   	leave  
  801238:	c3                   	ret    

00801239 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801239:	55                   	push   %ebp
  80123a:	89 e5                	mov    %esp,%ebp
  80123c:	57                   	push   %edi
  80123d:	56                   	push   %esi
  80123e:	53                   	push   %ebx
  80123f:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801242:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801245:	50                   	push   %eax
  801246:	ff 75 08             	pushl  0x8(%ebp)
  801249:	e8 67 fe ff ff       	call   8010b5 <fd_lookup>
  80124e:	89 c3                	mov    %eax,%ebx
  801250:	83 c4 10             	add    $0x10,%esp
  801253:	85 c0                	test   %eax,%eax
  801255:	0f 88 81 00 00 00    	js     8012dc <dup+0xa3>
		return r;
	close(newfdnum);
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	ff 75 0c             	pushl  0xc(%ebp)
  801261:	e8 81 ff ff ff       	call   8011e7 <close>

	newfd = INDEX2FD(newfdnum);
  801266:	8b 75 0c             	mov    0xc(%ebp),%esi
  801269:	c1 e6 0c             	shl    $0xc,%esi
  80126c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	ff 75 e4             	pushl  -0x1c(%ebp)
  801278:	e8 cf fd ff ff       	call   80104c <fd2data>
  80127d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80127f:	89 34 24             	mov    %esi,(%esp)
  801282:	e8 c5 fd ff ff       	call   80104c <fd2data>
  801287:	83 c4 10             	add    $0x10,%esp
  80128a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80128c:	89 d8                	mov    %ebx,%eax
  80128e:	c1 e8 16             	shr    $0x16,%eax
  801291:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801298:	a8 01                	test   $0x1,%al
  80129a:	74 11                	je     8012ad <dup+0x74>
  80129c:	89 d8                	mov    %ebx,%eax
  80129e:	c1 e8 0c             	shr    $0xc,%eax
  8012a1:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012a8:	f6 c2 01             	test   $0x1,%dl
  8012ab:	75 39                	jne    8012e6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012b0:	89 d0                	mov    %edx,%eax
  8012b2:	c1 e8 0c             	shr    $0xc,%eax
  8012b5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012bc:	83 ec 0c             	sub    $0xc,%esp
  8012bf:	25 07 0e 00 00       	and    $0xe07,%eax
  8012c4:	50                   	push   %eax
  8012c5:	56                   	push   %esi
  8012c6:	6a 00                	push   $0x0
  8012c8:	52                   	push   %edx
  8012c9:	6a 00                	push   $0x0
  8012cb:	e8 ba fa ff ff       	call   800d8a <sys_page_map>
  8012d0:	89 c3                	mov    %eax,%ebx
  8012d2:	83 c4 20             	add    $0x20,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 31                	js     80130a <dup+0xd1>
		goto err;

	return newfdnum;
  8012d9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012dc:	89 d8                	mov    %ebx,%eax
  8012de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e1:	5b                   	pop    %ebx
  8012e2:	5e                   	pop    %esi
  8012e3:	5f                   	pop    %edi
  8012e4:	5d                   	pop    %ebp
  8012e5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012e6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	25 07 0e 00 00       	and    $0xe07,%eax
  8012f5:	50                   	push   %eax
  8012f6:	57                   	push   %edi
  8012f7:	6a 00                	push   $0x0
  8012f9:	53                   	push   %ebx
  8012fa:	6a 00                	push   $0x0
  8012fc:	e8 89 fa ff ff       	call   800d8a <sys_page_map>
  801301:	89 c3                	mov    %eax,%ebx
  801303:	83 c4 20             	add    $0x20,%esp
  801306:	85 c0                	test   %eax,%eax
  801308:	79 a3                	jns    8012ad <dup+0x74>
	sys_page_unmap(0, newfd);
  80130a:	83 ec 08             	sub    $0x8,%esp
  80130d:	56                   	push   %esi
  80130e:	6a 00                	push   $0x0
  801310:	e8 b7 fa ff ff       	call   800dcc <sys_page_unmap>
	sys_page_unmap(0, nva);
  801315:	83 c4 08             	add    $0x8,%esp
  801318:	57                   	push   %edi
  801319:	6a 00                	push   $0x0
  80131b:	e8 ac fa ff ff       	call   800dcc <sys_page_unmap>
	return r;
  801320:	83 c4 10             	add    $0x10,%esp
  801323:	eb b7                	jmp    8012dc <dup+0xa3>

00801325 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	53                   	push   %ebx
  801329:	83 ec 1c             	sub    $0x1c,%esp
  80132c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80132f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801332:	50                   	push   %eax
  801333:	53                   	push   %ebx
  801334:	e8 7c fd ff ff       	call   8010b5 <fd_lookup>
  801339:	83 c4 10             	add    $0x10,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	78 3f                	js     80137f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801340:	83 ec 08             	sub    $0x8,%esp
  801343:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801346:	50                   	push   %eax
  801347:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134a:	ff 30                	pushl  (%eax)
  80134c:	e8 b4 fd ff ff       	call   801105 <dev_lookup>
  801351:	83 c4 10             	add    $0x10,%esp
  801354:	85 c0                	test   %eax,%eax
  801356:	78 27                	js     80137f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801358:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80135b:	8b 42 08             	mov    0x8(%edx),%eax
  80135e:	83 e0 03             	and    $0x3,%eax
  801361:	83 f8 01             	cmp    $0x1,%eax
  801364:	74 1e                	je     801384 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801369:	8b 40 08             	mov    0x8(%eax),%eax
  80136c:	85 c0                	test   %eax,%eax
  80136e:	74 35                	je     8013a5 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801370:	83 ec 04             	sub    $0x4,%esp
  801373:	ff 75 10             	pushl  0x10(%ebp)
  801376:	ff 75 0c             	pushl  0xc(%ebp)
  801379:	52                   	push   %edx
  80137a:	ff d0                	call   *%eax
  80137c:	83 c4 10             	add    $0x10,%esp
}
  80137f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801382:	c9                   	leave  
  801383:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801384:	a1 08 40 80 00       	mov    0x804008,%eax
  801389:	8b 40 48             	mov    0x48(%eax),%eax
  80138c:	83 ec 04             	sub    $0x4,%esp
  80138f:	53                   	push   %ebx
  801390:	50                   	push   %eax
  801391:	68 95 29 80 00       	push   $0x802995
  801396:	e8 5b ee ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a3:	eb da                	jmp    80137f <read+0x5a>
		return -E_NOT_SUPP;
  8013a5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013aa:	eb d3                	jmp    80137f <read+0x5a>

008013ac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	57                   	push   %edi
  8013b0:	56                   	push   %esi
  8013b1:	53                   	push   %ebx
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013b8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c0:	39 f3                	cmp    %esi,%ebx
  8013c2:	73 23                	jae    8013e7 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	89 f0                	mov    %esi,%eax
  8013c9:	29 d8                	sub    %ebx,%eax
  8013cb:	50                   	push   %eax
  8013cc:	89 d8                	mov    %ebx,%eax
  8013ce:	03 45 0c             	add    0xc(%ebp),%eax
  8013d1:	50                   	push   %eax
  8013d2:	57                   	push   %edi
  8013d3:	e8 4d ff ff ff       	call   801325 <read>
		if (m < 0)
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	85 c0                	test   %eax,%eax
  8013dd:	78 06                	js     8013e5 <readn+0x39>
			return m;
		if (m == 0)
  8013df:	74 06                	je     8013e7 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013e1:	01 c3                	add    %eax,%ebx
  8013e3:	eb db                	jmp    8013c0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013e5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013e7:	89 d8                	mov    %ebx,%eax
  8013e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013ec:	5b                   	pop    %ebx
  8013ed:	5e                   	pop    %esi
  8013ee:	5f                   	pop    %edi
  8013ef:	5d                   	pop    %ebp
  8013f0:	c3                   	ret    

008013f1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	53                   	push   %ebx
  8013f5:	83 ec 1c             	sub    $0x1c,%esp
  8013f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013fb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	53                   	push   %ebx
  801400:	e8 b0 fc ff ff       	call   8010b5 <fd_lookup>
  801405:	83 c4 10             	add    $0x10,%esp
  801408:	85 c0                	test   %eax,%eax
  80140a:	78 3a                	js     801446 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80140c:	83 ec 08             	sub    $0x8,%esp
  80140f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801412:	50                   	push   %eax
  801413:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801416:	ff 30                	pushl  (%eax)
  801418:	e8 e8 fc ff ff       	call   801105 <dev_lookup>
  80141d:	83 c4 10             	add    $0x10,%esp
  801420:	85 c0                	test   %eax,%eax
  801422:	78 22                	js     801446 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801424:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801427:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80142b:	74 1e                	je     80144b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80142d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801430:	8b 52 0c             	mov    0xc(%edx),%edx
  801433:	85 d2                	test   %edx,%edx
  801435:	74 35                	je     80146c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801437:	83 ec 04             	sub    $0x4,%esp
  80143a:	ff 75 10             	pushl  0x10(%ebp)
  80143d:	ff 75 0c             	pushl  0xc(%ebp)
  801440:	50                   	push   %eax
  801441:	ff d2                	call   *%edx
  801443:	83 c4 10             	add    $0x10,%esp
}
  801446:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801449:	c9                   	leave  
  80144a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80144b:	a1 08 40 80 00       	mov    0x804008,%eax
  801450:	8b 40 48             	mov    0x48(%eax),%eax
  801453:	83 ec 04             	sub    $0x4,%esp
  801456:	53                   	push   %ebx
  801457:	50                   	push   %eax
  801458:	68 b1 29 80 00       	push   $0x8029b1
  80145d:	e8 94 ed ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  801462:	83 c4 10             	add    $0x10,%esp
  801465:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146a:	eb da                	jmp    801446 <write+0x55>
		return -E_NOT_SUPP;
  80146c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801471:	eb d3                	jmp    801446 <write+0x55>

00801473 <seek>:

int
seek(int fdnum, off_t offset)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
  801476:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801479:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	ff 75 08             	pushl  0x8(%ebp)
  801480:	e8 30 fc ff ff       	call   8010b5 <fd_lookup>
  801485:	83 c4 10             	add    $0x10,%esp
  801488:	85 c0                	test   %eax,%eax
  80148a:	78 0e                	js     80149a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80148c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801495:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80149a:	c9                   	leave  
  80149b:	c3                   	ret    

0080149c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	53                   	push   %ebx
  8014a0:	83 ec 1c             	sub    $0x1c,%esp
  8014a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	53                   	push   %ebx
  8014ab:	e8 05 fc ff ff       	call   8010b5 <fd_lookup>
  8014b0:	83 c4 10             	add    $0x10,%esp
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	78 37                	js     8014ee <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b7:	83 ec 08             	sub    $0x8,%esp
  8014ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bd:	50                   	push   %eax
  8014be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c1:	ff 30                	pushl  (%eax)
  8014c3:	e8 3d fc ff ff       	call   801105 <dev_lookup>
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	78 1f                	js     8014ee <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d6:	74 1b                	je     8014f3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014db:	8b 52 18             	mov    0x18(%edx),%edx
  8014de:	85 d2                	test   %edx,%edx
  8014e0:	74 32                	je     801514 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014e2:	83 ec 08             	sub    $0x8,%esp
  8014e5:	ff 75 0c             	pushl  0xc(%ebp)
  8014e8:	50                   	push   %eax
  8014e9:	ff d2                	call   *%edx
  8014eb:	83 c4 10             	add    $0x10,%esp
}
  8014ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f1:	c9                   	leave  
  8014f2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014f3:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014f8:	8b 40 48             	mov    0x48(%eax),%eax
  8014fb:	83 ec 04             	sub    $0x4,%esp
  8014fe:	53                   	push   %ebx
  8014ff:	50                   	push   %eax
  801500:	68 74 29 80 00       	push   $0x802974
  801505:	e8 ec ec ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801512:	eb da                	jmp    8014ee <ftruncate+0x52>
		return -E_NOT_SUPP;
  801514:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801519:	eb d3                	jmp    8014ee <ftruncate+0x52>

0080151b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80151b:	55                   	push   %ebp
  80151c:	89 e5                	mov    %esp,%ebp
  80151e:	53                   	push   %ebx
  80151f:	83 ec 1c             	sub    $0x1c,%esp
  801522:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801525:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801528:	50                   	push   %eax
  801529:	ff 75 08             	pushl  0x8(%ebp)
  80152c:	e8 84 fb ff ff       	call   8010b5 <fd_lookup>
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	78 4b                	js     801583 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801538:	83 ec 08             	sub    $0x8,%esp
  80153b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153e:	50                   	push   %eax
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	ff 30                	pushl  (%eax)
  801544:	e8 bc fb ff ff       	call   801105 <dev_lookup>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	85 c0                	test   %eax,%eax
  80154e:	78 33                	js     801583 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801553:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801557:	74 2f                	je     801588 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801559:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80155c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801563:	00 00 00 
	stat->st_isdir = 0;
  801566:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80156d:	00 00 00 
	stat->st_dev = dev;
  801570:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	53                   	push   %ebx
  80157a:	ff 75 f0             	pushl  -0x10(%ebp)
  80157d:	ff 50 14             	call   *0x14(%eax)
  801580:	83 c4 10             	add    $0x10,%esp
}
  801583:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801586:	c9                   	leave  
  801587:	c3                   	ret    
		return -E_NOT_SUPP;
  801588:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80158d:	eb f4                	jmp    801583 <fstat+0x68>

0080158f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80158f:	55                   	push   %ebp
  801590:	89 e5                	mov    %esp,%ebp
  801592:	56                   	push   %esi
  801593:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801594:	83 ec 08             	sub    $0x8,%esp
  801597:	6a 00                	push   $0x0
  801599:	ff 75 08             	pushl  0x8(%ebp)
  80159c:	e8 22 02 00 00       	call   8017c3 <open>
  8015a1:	89 c3                	mov    %eax,%ebx
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	85 c0                	test   %eax,%eax
  8015a8:	78 1b                	js     8015c5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015aa:	83 ec 08             	sub    $0x8,%esp
  8015ad:	ff 75 0c             	pushl  0xc(%ebp)
  8015b0:	50                   	push   %eax
  8015b1:	e8 65 ff ff ff       	call   80151b <fstat>
  8015b6:	89 c6                	mov    %eax,%esi
	close(fd);
  8015b8:	89 1c 24             	mov    %ebx,(%esp)
  8015bb:	e8 27 fc ff ff       	call   8011e7 <close>
	return r;
  8015c0:	83 c4 10             	add    $0x10,%esp
  8015c3:	89 f3                	mov    %esi,%ebx
}
  8015c5:	89 d8                	mov    %ebx,%eax
  8015c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	56                   	push   %esi
  8015d2:	53                   	push   %ebx
  8015d3:	89 c6                	mov    %eax,%esi
  8015d5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015d7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015de:	74 27                	je     801607 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015e0:	6a 07                	push   $0x7
  8015e2:	68 00 50 80 00       	push   $0x805000
  8015e7:	56                   	push   %esi
  8015e8:	ff 35 00 40 80 00    	pushl  0x804000
  8015ee:	e8 69 0c 00 00       	call   80225c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015f3:	83 c4 0c             	add    $0xc,%esp
  8015f6:	6a 00                	push   $0x0
  8015f8:	53                   	push   %ebx
  8015f9:	6a 00                	push   $0x0
  8015fb:	e8 f3 0b 00 00       	call   8021f3 <ipc_recv>
}
  801600:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801603:	5b                   	pop    %ebx
  801604:	5e                   	pop    %esi
  801605:	5d                   	pop    %ebp
  801606:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801607:	83 ec 0c             	sub    $0xc,%esp
  80160a:	6a 01                	push   $0x1
  80160c:	e8 a3 0c 00 00       	call   8022b4 <ipc_find_env>
  801611:	a3 00 40 80 00       	mov    %eax,0x804000
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	eb c5                	jmp    8015e0 <fsipc+0x12>

0080161b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80161b:	55                   	push   %ebp
  80161c:	89 e5                	mov    %esp,%ebp
  80161e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801621:	8b 45 08             	mov    0x8(%ebp),%eax
  801624:	8b 40 0c             	mov    0xc(%eax),%eax
  801627:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80162c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801634:	ba 00 00 00 00       	mov    $0x0,%edx
  801639:	b8 02 00 00 00       	mov    $0x2,%eax
  80163e:	e8 8b ff ff ff       	call   8015ce <fsipc>
}
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <devfile_flush>:
{
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8b 40 0c             	mov    0xc(%eax),%eax
  801651:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801656:	ba 00 00 00 00       	mov    $0x0,%edx
  80165b:	b8 06 00 00 00       	mov    $0x6,%eax
  801660:	e8 69 ff ff ff       	call   8015ce <fsipc>
}
  801665:	c9                   	leave  
  801666:	c3                   	ret    

00801667 <devfile_stat>:
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	53                   	push   %ebx
  80166b:	83 ec 04             	sub    $0x4,%esp
  80166e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8b 40 0c             	mov    0xc(%eax),%eax
  801677:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80167c:	ba 00 00 00 00       	mov    $0x0,%edx
  801681:	b8 05 00 00 00       	mov    $0x5,%eax
  801686:	e8 43 ff ff ff       	call   8015ce <fsipc>
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 2c                	js     8016bb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80168f:	83 ec 08             	sub    $0x8,%esp
  801692:	68 00 50 80 00       	push   $0x805000
  801697:	53                   	push   %ebx
  801698:	e8 b8 f2 ff ff       	call   800955 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80169d:	a1 80 50 80 00       	mov    0x805080,%eax
  8016a2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016a8:	a1 84 50 80 00       	mov    0x805084,%eax
  8016ad:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016b3:	83 c4 10             	add    $0x10,%esp
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016bb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016be:	c9                   	leave  
  8016bf:	c3                   	ret    

008016c0 <devfile_write>:
{
  8016c0:	55                   	push   %ebp
  8016c1:	89 e5                	mov    %esp,%ebp
  8016c3:	53                   	push   %ebx
  8016c4:	83 ec 08             	sub    $0x8,%esp
  8016c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016d5:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016db:	53                   	push   %ebx
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	68 08 50 80 00       	push   $0x805008
  8016e4:	e8 5c f4 ff ff       	call   800b45 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ee:	b8 04 00 00 00       	mov    $0x4,%eax
  8016f3:	e8 d6 fe ff ff       	call   8015ce <fsipc>
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 0b                	js     80170a <devfile_write+0x4a>
	assert(r <= n);
  8016ff:	39 d8                	cmp    %ebx,%eax
  801701:	77 0c                	ja     80170f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801703:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801708:	7f 1e                	jg     801728 <devfile_write+0x68>
}
  80170a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    
	assert(r <= n);
  80170f:	68 e4 29 80 00       	push   $0x8029e4
  801714:	68 eb 29 80 00       	push   $0x8029eb
  801719:	68 98 00 00 00       	push   $0x98
  80171e:	68 00 2a 80 00       	push   $0x802a00
  801723:	e8 6a 0a 00 00       	call   802192 <_panic>
	assert(r <= PGSIZE);
  801728:	68 0b 2a 80 00       	push   $0x802a0b
  80172d:	68 eb 29 80 00       	push   $0x8029eb
  801732:	68 99 00 00 00       	push   $0x99
  801737:	68 00 2a 80 00       	push   $0x802a00
  80173c:	e8 51 0a 00 00       	call   802192 <_panic>

00801741 <devfile_read>:
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	56                   	push   %esi
  801745:	53                   	push   %ebx
  801746:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801749:	8b 45 08             	mov    0x8(%ebp),%eax
  80174c:	8b 40 0c             	mov    0xc(%eax),%eax
  80174f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801754:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80175a:	ba 00 00 00 00       	mov    $0x0,%edx
  80175f:	b8 03 00 00 00       	mov    $0x3,%eax
  801764:	e8 65 fe ff ff       	call   8015ce <fsipc>
  801769:	89 c3                	mov    %eax,%ebx
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 1f                	js     80178e <devfile_read+0x4d>
	assert(r <= n);
  80176f:	39 f0                	cmp    %esi,%eax
  801771:	77 24                	ja     801797 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801773:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801778:	7f 33                	jg     8017ad <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80177a:	83 ec 04             	sub    $0x4,%esp
  80177d:	50                   	push   %eax
  80177e:	68 00 50 80 00       	push   $0x805000
  801783:	ff 75 0c             	pushl  0xc(%ebp)
  801786:	e8 58 f3 ff ff       	call   800ae3 <memmove>
	return r;
  80178b:	83 c4 10             	add    $0x10,%esp
}
  80178e:	89 d8                	mov    %ebx,%eax
  801790:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801793:	5b                   	pop    %ebx
  801794:	5e                   	pop    %esi
  801795:	5d                   	pop    %ebp
  801796:	c3                   	ret    
	assert(r <= n);
  801797:	68 e4 29 80 00       	push   $0x8029e4
  80179c:	68 eb 29 80 00       	push   $0x8029eb
  8017a1:	6a 7c                	push   $0x7c
  8017a3:	68 00 2a 80 00       	push   $0x802a00
  8017a8:	e8 e5 09 00 00       	call   802192 <_panic>
	assert(r <= PGSIZE);
  8017ad:	68 0b 2a 80 00       	push   $0x802a0b
  8017b2:	68 eb 29 80 00       	push   $0x8029eb
  8017b7:	6a 7d                	push   $0x7d
  8017b9:	68 00 2a 80 00       	push   $0x802a00
  8017be:	e8 cf 09 00 00       	call   802192 <_panic>

008017c3 <open>:
{
  8017c3:	55                   	push   %ebp
  8017c4:	89 e5                	mov    %esp,%ebp
  8017c6:	56                   	push   %esi
  8017c7:	53                   	push   %ebx
  8017c8:	83 ec 1c             	sub    $0x1c,%esp
  8017cb:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017ce:	56                   	push   %esi
  8017cf:	e8 48 f1 ff ff       	call   80091c <strlen>
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017dc:	7f 6c                	jg     80184a <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017de:	83 ec 0c             	sub    $0xc,%esp
  8017e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017e4:	50                   	push   %eax
  8017e5:	e8 79 f8 ff ff       	call   801063 <fd_alloc>
  8017ea:	89 c3                	mov    %eax,%ebx
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	85 c0                	test   %eax,%eax
  8017f1:	78 3c                	js     80182f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017f3:	83 ec 08             	sub    $0x8,%esp
  8017f6:	56                   	push   %esi
  8017f7:	68 00 50 80 00       	push   $0x805000
  8017fc:	e8 54 f1 ff ff       	call   800955 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801801:	8b 45 0c             	mov    0xc(%ebp),%eax
  801804:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801809:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80180c:	b8 01 00 00 00       	mov    $0x1,%eax
  801811:	e8 b8 fd ff ff       	call   8015ce <fsipc>
  801816:	89 c3                	mov    %eax,%ebx
  801818:	83 c4 10             	add    $0x10,%esp
  80181b:	85 c0                	test   %eax,%eax
  80181d:	78 19                	js     801838 <open+0x75>
	return fd2num(fd);
  80181f:	83 ec 0c             	sub    $0xc,%esp
  801822:	ff 75 f4             	pushl  -0xc(%ebp)
  801825:	e8 12 f8 ff ff       	call   80103c <fd2num>
  80182a:	89 c3                	mov    %eax,%ebx
  80182c:	83 c4 10             	add    $0x10,%esp
}
  80182f:	89 d8                	mov    %ebx,%eax
  801831:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801834:	5b                   	pop    %ebx
  801835:	5e                   	pop    %esi
  801836:	5d                   	pop    %ebp
  801837:	c3                   	ret    
		fd_close(fd, 0);
  801838:	83 ec 08             	sub    $0x8,%esp
  80183b:	6a 00                	push   $0x0
  80183d:	ff 75 f4             	pushl  -0xc(%ebp)
  801840:	e8 1b f9 ff ff       	call   801160 <fd_close>
		return r;
  801845:	83 c4 10             	add    $0x10,%esp
  801848:	eb e5                	jmp    80182f <open+0x6c>
		return -E_BAD_PATH;
  80184a:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80184f:	eb de                	jmp    80182f <open+0x6c>

00801851 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801857:	ba 00 00 00 00       	mov    $0x0,%edx
  80185c:	b8 08 00 00 00       	mov    $0x8,%eax
  801861:	e8 68 fd ff ff       	call   8015ce <fsipc>
}
  801866:	c9                   	leave  
  801867:	c3                   	ret    

00801868 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801868:	55                   	push   %ebp
  801869:	89 e5                	mov    %esp,%ebp
  80186b:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  80186e:	68 17 2a 80 00       	push   $0x802a17
  801873:	ff 75 0c             	pushl  0xc(%ebp)
  801876:	e8 da f0 ff ff       	call   800955 <strcpy>
	return 0;
}
  80187b:	b8 00 00 00 00       	mov    $0x0,%eax
  801880:	c9                   	leave  
  801881:	c3                   	ret    

00801882 <devsock_close>:
{
  801882:	55                   	push   %ebp
  801883:	89 e5                	mov    %esp,%ebp
  801885:	53                   	push   %ebx
  801886:	83 ec 10             	sub    $0x10,%esp
  801889:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80188c:	53                   	push   %ebx
  80188d:	e8 61 0a 00 00       	call   8022f3 <pageref>
  801892:	83 c4 10             	add    $0x10,%esp
		return 0;
  801895:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80189a:	83 f8 01             	cmp    $0x1,%eax
  80189d:	74 07                	je     8018a6 <devsock_close+0x24>
}
  80189f:	89 d0                	mov    %edx,%eax
  8018a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018a6:	83 ec 0c             	sub    $0xc,%esp
  8018a9:	ff 73 0c             	pushl  0xc(%ebx)
  8018ac:	e8 b9 02 00 00       	call   801b6a <nsipc_close>
  8018b1:	89 c2                	mov    %eax,%edx
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	eb e7                	jmp    80189f <devsock_close+0x1d>

008018b8 <devsock_write>:
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018be:	6a 00                	push   $0x0
  8018c0:	ff 75 10             	pushl  0x10(%ebp)
  8018c3:	ff 75 0c             	pushl  0xc(%ebp)
  8018c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c9:	ff 70 0c             	pushl  0xc(%eax)
  8018cc:	e8 76 03 00 00       	call   801c47 <nsipc_send>
}
  8018d1:	c9                   	leave  
  8018d2:	c3                   	ret    

008018d3 <devsock_read>:
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	ff 75 10             	pushl  0x10(%ebp)
  8018de:	ff 75 0c             	pushl  0xc(%ebp)
  8018e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e4:	ff 70 0c             	pushl  0xc(%eax)
  8018e7:	e8 ef 02 00 00       	call   801bdb <nsipc_recv>
}
  8018ec:	c9                   	leave  
  8018ed:	c3                   	ret    

008018ee <fd2sockid>:
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018f4:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018f7:	52                   	push   %edx
  8018f8:	50                   	push   %eax
  8018f9:	e8 b7 f7 ff ff       	call   8010b5 <fd_lookup>
  8018fe:	83 c4 10             	add    $0x10,%esp
  801901:	85 c0                	test   %eax,%eax
  801903:	78 10                	js     801915 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801908:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80190e:	39 08                	cmp    %ecx,(%eax)
  801910:	75 05                	jne    801917 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801912:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801915:	c9                   	leave  
  801916:	c3                   	ret    
		return -E_NOT_SUPP;
  801917:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80191c:	eb f7                	jmp    801915 <fd2sockid+0x27>

0080191e <alloc_sockfd>:
{
  80191e:	55                   	push   %ebp
  80191f:	89 e5                	mov    %esp,%ebp
  801921:	56                   	push   %esi
  801922:	53                   	push   %ebx
  801923:	83 ec 1c             	sub    $0x1c,%esp
  801926:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801928:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192b:	50                   	push   %eax
  80192c:	e8 32 f7 ff ff       	call   801063 <fd_alloc>
  801931:	89 c3                	mov    %eax,%ebx
  801933:	83 c4 10             	add    $0x10,%esp
  801936:	85 c0                	test   %eax,%eax
  801938:	78 43                	js     80197d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  80193a:	83 ec 04             	sub    $0x4,%esp
  80193d:	68 07 04 00 00       	push   $0x407
  801942:	ff 75 f4             	pushl  -0xc(%ebp)
  801945:	6a 00                	push   $0x0
  801947:	e8 fb f3 ff ff       	call   800d47 <sys_page_alloc>
  80194c:	89 c3                	mov    %eax,%ebx
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	85 c0                	test   %eax,%eax
  801953:	78 28                	js     80197d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  801955:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801958:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80195e:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801960:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801963:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  80196a:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	50                   	push   %eax
  801971:	e8 c6 f6 ff ff       	call   80103c <fd2num>
  801976:	89 c3                	mov    %eax,%ebx
  801978:	83 c4 10             	add    $0x10,%esp
  80197b:	eb 0c                	jmp    801989 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	56                   	push   %esi
  801981:	e8 e4 01 00 00       	call   801b6a <nsipc_close>
		return r;
  801986:	83 c4 10             	add    $0x10,%esp
}
  801989:	89 d8                	mov    %ebx,%eax
  80198b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198e:	5b                   	pop    %ebx
  80198f:	5e                   	pop    %esi
  801990:	5d                   	pop    %ebp
  801991:	c3                   	ret    

00801992 <accept>:
{
  801992:	55                   	push   %ebp
  801993:	89 e5                	mov    %esp,%ebp
  801995:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	e8 4e ff ff ff       	call   8018ee <fd2sockid>
  8019a0:	85 c0                	test   %eax,%eax
  8019a2:	78 1b                	js     8019bf <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019a4:	83 ec 04             	sub    $0x4,%esp
  8019a7:	ff 75 10             	pushl  0x10(%ebp)
  8019aa:	ff 75 0c             	pushl  0xc(%ebp)
  8019ad:	50                   	push   %eax
  8019ae:	e8 0e 01 00 00       	call   801ac1 <nsipc_accept>
  8019b3:	83 c4 10             	add    $0x10,%esp
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 05                	js     8019bf <accept+0x2d>
	return alloc_sockfd(r);
  8019ba:	e8 5f ff ff ff       	call   80191e <alloc_sockfd>
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <bind>:
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	e8 1f ff ff ff       	call   8018ee <fd2sockid>
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 12                	js     8019e5 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	ff 75 10             	pushl  0x10(%ebp)
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	e8 31 01 00 00       	call   801b13 <nsipc_bind>
  8019e2:	83 c4 10             	add    $0x10,%esp
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <shutdown>:
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	e8 f9 fe ff ff       	call   8018ee <fd2sockid>
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 0f                	js     801a08 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019f9:	83 ec 08             	sub    $0x8,%esp
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	e8 43 01 00 00       	call   801b48 <nsipc_shutdown>
  801a05:	83 c4 10             	add    $0x10,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <connect>:
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	e8 d6 fe ff ff       	call   8018ee <fd2sockid>
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	78 12                	js     801a2e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	ff 75 10             	pushl  0x10(%ebp)
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	50                   	push   %eax
  801a26:	e8 59 01 00 00       	call   801b84 <nsipc_connect>
  801a2b:	83 c4 10             	add    $0x10,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <listen>:
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	e8 b0 fe ff ff       	call   8018ee <fd2sockid>
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 0f                	js     801a51 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a42:	83 ec 08             	sub    $0x8,%esp
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	50                   	push   %eax
  801a49:	e8 6b 01 00 00       	call   801bb9 <nsipc_listen>
  801a4e:	83 c4 10             	add    $0x10,%esp
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a59:	ff 75 10             	pushl  0x10(%ebp)
  801a5c:	ff 75 0c             	pushl  0xc(%ebp)
  801a5f:	ff 75 08             	pushl  0x8(%ebp)
  801a62:	e8 3e 02 00 00       	call   801ca5 <nsipc_socket>
  801a67:	83 c4 10             	add    $0x10,%esp
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	78 05                	js     801a73 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a6e:	e8 ab fe ff ff       	call   80191e <alloc_sockfd>
}
  801a73:	c9                   	leave  
  801a74:	c3                   	ret    

00801a75 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a75:	55                   	push   %ebp
  801a76:	89 e5                	mov    %esp,%ebp
  801a78:	53                   	push   %ebx
  801a79:	83 ec 04             	sub    $0x4,%esp
  801a7c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a7e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a85:	74 26                	je     801aad <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a87:	6a 07                	push   $0x7
  801a89:	68 00 60 80 00       	push   $0x806000
  801a8e:	53                   	push   %ebx
  801a8f:	ff 35 04 40 80 00    	pushl  0x804004
  801a95:	e8 c2 07 00 00       	call   80225c <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a9a:	83 c4 0c             	add    $0xc,%esp
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	e8 4b 07 00 00       	call   8021f3 <ipc_recv>
}
  801aa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aad:	83 ec 0c             	sub    $0xc,%esp
  801ab0:	6a 02                	push   $0x2
  801ab2:	e8 fd 07 00 00       	call   8022b4 <ipc_find_env>
  801ab7:	a3 04 40 80 00       	mov    %eax,0x804004
  801abc:	83 c4 10             	add    $0x10,%esp
  801abf:	eb c6                	jmp    801a87 <nsipc+0x12>

00801ac1 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	56                   	push   %esi
  801ac5:	53                   	push   %ebx
  801ac6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  801acc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ad1:	8b 06                	mov    (%esi),%eax
  801ad3:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ad8:	b8 01 00 00 00       	mov    $0x1,%eax
  801add:	e8 93 ff ff ff       	call   801a75 <nsipc>
  801ae2:	89 c3                	mov    %eax,%ebx
  801ae4:	85 c0                	test   %eax,%eax
  801ae6:	79 09                	jns    801af1 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ae8:	89 d8                	mov    %ebx,%eax
  801aea:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801aed:	5b                   	pop    %ebx
  801aee:	5e                   	pop    %esi
  801aef:	5d                   	pop    %ebp
  801af0:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	ff 35 10 60 80 00    	pushl  0x806010
  801afa:	68 00 60 80 00       	push   $0x806000
  801aff:	ff 75 0c             	pushl  0xc(%ebp)
  801b02:	e8 dc ef ff ff       	call   800ae3 <memmove>
		*addrlen = ret->ret_addrlen;
  801b07:	a1 10 60 80 00       	mov    0x806010,%eax
  801b0c:	89 06                	mov    %eax,(%esi)
  801b0e:	83 c4 10             	add    $0x10,%esp
	return r;
  801b11:	eb d5                	jmp    801ae8 <nsipc_accept+0x27>

00801b13 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
  801b16:	53                   	push   %ebx
  801b17:	83 ec 08             	sub    $0x8,%esp
  801b1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b20:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b25:	53                   	push   %ebx
  801b26:	ff 75 0c             	pushl  0xc(%ebp)
  801b29:	68 04 60 80 00       	push   $0x806004
  801b2e:	e8 b0 ef ff ff       	call   800ae3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b33:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b39:	b8 02 00 00 00       	mov    $0x2,%eax
  801b3e:	e8 32 ff ff ff       	call   801a75 <nsipc>
}
  801b43:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
  801b4b:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b59:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b5e:	b8 03 00 00 00       	mov    $0x3,%eax
  801b63:	e8 0d ff ff ff       	call   801a75 <nsipc>
}
  801b68:	c9                   	leave  
  801b69:	c3                   	ret    

00801b6a <nsipc_close>:

int
nsipc_close(int s)
{
  801b6a:	55                   	push   %ebp
  801b6b:	89 e5                	mov    %esp,%ebp
  801b6d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b78:	b8 04 00 00 00       	mov    $0x4,%eax
  801b7d:	e8 f3 fe ff ff       	call   801a75 <nsipc>
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	83 ec 08             	sub    $0x8,%esp
  801b8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b96:	53                   	push   %ebx
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	68 04 60 80 00       	push   $0x806004
  801b9f:	e8 3f ef ff ff       	call   800ae3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801ba4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801baa:	b8 05 00 00 00       	mov    $0x5,%eax
  801baf:	e8 c1 fe ff ff       	call   801a75 <nsipc>
}
  801bb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb7:	c9                   	leave  
  801bb8:	c3                   	ret    

00801bb9 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bb9:	55                   	push   %ebp
  801bba:	89 e5                	mov    %esp,%ebp
  801bbc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bca:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bcf:	b8 06 00 00 00       	mov    $0x6,%eax
  801bd4:	e8 9c fe ff ff       	call   801a75 <nsipc>
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
  801bde:	56                   	push   %esi
  801bdf:	53                   	push   %ebx
  801be0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801beb:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bf1:	8b 45 14             	mov    0x14(%ebp),%eax
  801bf4:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bf9:	b8 07 00 00 00       	mov    $0x7,%eax
  801bfe:	e8 72 fe ff ff       	call   801a75 <nsipc>
  801c03:	89 c3                	mov    %eax,%ebx
  801c05:	85 c0                	test   %eax,%eax
  801c07:	78 1f                	js     801c28 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c09:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c0e:	7f 21                	jg     801c31 <nsipc_recv+0x56>
  801c10:	39 c6                	cmp    %eax,%esi
  801c12:	7c 1d                	jl     801c31 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c14:	83 ec 04             	sub    $0x4,%esp
  801c17:	50                   	push   %eax
  801c18:	68 00 60 80 00       	push   $0x806000
  801c1d:	ff 75 0c             	pushl  0xc(%ebp)
  801c20:	e8 be ee ff ff       	call   800ae3 <memmove>
  801c25:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c2d:	5b                   	pop    %ebx
  801c2e:	5e                   	pop    %esi
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c31:	68 23 2a 80 00       	push   $0x802a23
  801c36:	68 eb 29 80 00       	push   $0x8029eb
  801c3b:	6a 62                	push   $0x62
  801c3d:	68 38 2a 80 00       	push   $0x802a38
  801c42:	e8 4b 05 00 00       	call   802192 <_panic>

00801c47 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	53                   	push   %ebx
  801c4b:	83 ec 04             	sub    $0x4,%esp
  801c4e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c59:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c5f:	7f 2e                	jg     801c8f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c61:	83 ec 04             	sub    $0x4,%esp
  801c64:	53                   	push   %ebx
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	68 0c 60 80 00       	push   $0x80600c
  801c6d:	e8 71 ee ff ff       	call   800ae3 <memmove>
	nsipcbuf.send.req_size = size;
  801c72:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c78:	8b 45 14             	mov    0x14(%ebp),%eax
  801c7b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c80:	b8 08 00 00 00       	mov    $0x8,%eax
  801c85:	e8 eb fd ff ff       	call   801a75 <nsipc>
}
  801c8a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c8d:	c9                   	leave  
  801c8e:	c3                   	ret    
	assert(size < 1600);
  801c8f:	68 44 2a 80 00       	push   $0x802a44
  801c94:	68 eb 29 80 00       	push   $0x8029eb
  801c99:	6a 6d                	push   $0x6d
  801c9b:	68 38 2a 80 00       	push   $0x802a38
  801ca0:	e8 ed 04 00 00       	call   802192 <_panic>

00801ca5 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801cbe:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cc3:	b8 09 00 00 00       	mov    $0x9,%eax
  801cc8:	e8 a8 fd ff ff       	call   801a75 <nsipc>
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	56                   	push   %esi
  801cd3:	53                   	push   %ebx
  801cd4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	ff 75 08             	pushl  0x8(%ebp)
  801cdd:	e8 6a f3 ff ff       	call   80104c <fd2data>
  801ce2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801ce4:	83 c4 08             	add    $0x8,%esp
  801ce7:	68 50 2a 80 00       	push   $0x802a50
  801cec:	53                   	push   %ebx
  801ced:	e8 63 ec ff ff       	call   800955 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cf2:	8b 46 04             	mov    0x4(%esi),%eax
  801cf5:	2b 06                	sub    (%esi),%eax
  801cf7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cfd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d04:	00 00 00 
	stat->st_dev = &devpipe;
  801d07:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d0e:	30 80 00 
	return 0;
}
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
  801d16:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d19:	5b                   	pop    %ebx
  801d1a:	5e                   	pop    %esi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	53                   	push   %ebx
  801d21:	83 ec 0c             	sub    $0xc,%esp
  801d24:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d27:	53                   	push   %ebx
  801d28:	6a 00                	push   $0x0
  801d2a:	e8 9d f0 ff ff       	call   800dcc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d2f:	89 1c 24             	mov    %ebx,(%esp)
  801d32:	e8 15 f3 ff ff       	call   80104c <fd2data>
  801d37:	83 c4 08             	add    $0x8,%esp
  801d3a:	50                   	push   %eax
  801d3b:	6a 00                	push   $0x0
  801d3d:	e8 8a f0 ff ff       	call   800dcc <sys_page_unmap>
}
  801d42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d45:	c9                   	leave  
  801d46:	c3                   	ret    

00801d47 <_pipeisclosed>:
{
  801d47:	55                   	push   %ebp
  801d48:	89 e5                	mov    %esp,%ebp
  801d4a:	57                   	push   %edi
  801d4b:	56                   	push   %esi
  801d4c:	53                   	push   %ebx
  801d4d:	83 ec 1c             	sub    $0x1c,%esp
  801d50:	89 c7                	mov    %eax,%edi
  801d52:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d54:	a1 08 40 80 00       	mov    0x804008,%eax
  801d59:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d5c:	83 ec 0c             	sub    $0xc,%esp
  801d5f:	57                   	push   %edi
  801d60:	e8 8e 05 00 00       	call   8022f3 <pageref>
  801d65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d68:	89 34 24             	mov    %esi,(%esp)
  801d6b:	e8 83 05 00 00       	call   8022f3 <pageref>
		nn = thisenv->env_runs;
  801d70:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d76:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d79:	83 c4 10             	add    $0x10,%esp
  801d7c:	39 cb                	cmp    %ecx,%ebx
  801d7e:	74 1b                	je     801d9b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d80:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d83:	75 cf                	jne    801d54 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d85:	8b 42 58             	mov    0x58(%edx),%eax
  801d88:	6a 01                	push   $0x1
  801d8a:	50                   	push   %eax
  801d8b:	53                   	push   %ebx
  801d8c:	68 57 2a 80 00       	push   $0x802a57
  801d91:	e8 60 e4 ff ff       	call   8001f6 <cprintf>
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	eb b9                	jmp    801d54 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d9b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d9e:	0f 94 c0             	sete   %al
  801da1:	0f b6 c0             	movzbl %al,%eax
}
  801da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    

00801dac <devpipe_write>:
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	57                   	push   %edi
  801db0:	56                   	push   %esi
  801db1:	53                   	push   %ebx
  801db2:	83 ec 28             	sub    $0x28,%esp
  801db5:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801db8:	56                   	push   %esi
  801db9:	e8 8e f2 ff ff       	call   80104c <fd2data>
  801dbe:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc0:	83 c4 10             	add    $0x10,%esp
  801dc3:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dcb:	74 4f                	je     801e1c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dcd:	8b 43 04             	mov    0x4(%ebx),%eax
  801dd0:	8b 0b                	mov    (%ebx),%ecx
  801dd2:	8d 51 20             	lea    0x20(%ecx),%edx
  801dd5:	39 d0                	cmp    %edx,%eax
  801dd7:	72 14                	jb     801ded <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dd9:	89 da                	mov    %ebx,%edx
  801ddb:	89 f0                	mov    %esi,%eax
  801ddd:	e8 65 ff ff ff       	call   801d47 <_pipeisclosed>
  801de2:	85 c0                	test   %eax,%eax
  801de4:	75 3b                	jne    801e21 <devpipe_write+0x75>
			sys_yield();
  801de6:	e8 3d ef ff ff       	call   800d28 <sys_yield>
  801deb:	eb e0                	jmp    801dcd <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ded:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801df0:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801df4:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801df7:	89 c2                	mov    %eax,%edx
  801df9:	c1 fa 1f             	sar    $0x1f,%edx
  801dfc:	89 d1                	mov    %edx,%ecx
  801dfe:	c1 e9 1b             	shr    $0x1b,%ecx
  801e01:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e04:	83 e2 1f             	and    $0x1f,%edx
  801e07:	29 ca                	sub    %ecx,%edx
  801e09:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e0d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e11:	83 c0 01             	add    $0x1,%eax
  801e14:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e17:	83 c7 01             	add    $0x1,%edi
  801e1a:	eb ac                	jmp    801dc8 <devpipe_write+0x1c>
	return i;
  801e1c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e1f:	eb 05                	jmp    801e26 <devpipe_write+0x7a>
				return 0;
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e29:	5b                   	pop    %ebx
  801e2a:	5e                   	pop    %esi
  801e2b:	5f                   	pop    %edi
  801e2c:	5d                   	pop    %ebp
  801e2d:	c3                   	ret    

00801e2e <devpipe_read>:
{
  801e2e:	55                   	push   %ebp
  801e2f:	89 e5                	mov    %esp,%ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 18             	sub    $0x18,%esp
  801e37:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e3a:	57                   	push   %edi
  801e3b:	e8 0c f2 ff ff       	call   80104c <fd2data>
  801e40:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e42:	83 c4 10             	add    $0x10,%esp
  801e45:	be 00 00 00 00       	mov    $0x0,%esi
  801e4a:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e4d:	75 14                	jne    801e63 <devpipe_read+0x35>
	return i;
  801e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e52:	eb 02                	jmp    801e56 <devpipe_read+0x28>
				return i;
  801e54:	89 f0                	mov    %esi,%eax
}
  801e56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e59:	5b                   	pop    %ebx
  801e5a:	5e                   	pop    %esi
  801e5b:	5f                   	pop    %edi
  801e5c:	5d                   	pop    %ebp
  801e5d:	c3                   	ret    
			sys_yield();
  801e5e:	e8 c5 ee ff ff       	call   800d28 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e63:	8b 03                	mov    (%ebx),%eax
  801e65:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e68:	75 18                	jne    801e82 <devpipe_read+0x54>
			if (i > 0)
  801e6a:	85 f6                	test   %esi,%esi
  801e6c:	75 e6                	jne    801e54 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e6e:	89 da                	mov    %ebx,%edx
  801e70:	89 f8                	mov    %edi,%eax
  801e72:	e8 d0 fe ff ff       	call   801d47 <_pipeisclosed>
  801e77:	85 c0                	test   %eax,%eax
  801e79:	74 e3                	je     801e5e <devpipe_read+0x30>
				return 0;
  801e7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801e80:	eb d4                	jmp    801e56 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e82:	99                   	cltd   
  801e83:	c1 ea 1b             	shr    $0x1b,%edx
  801e86:	01 d0                	add    %edx,%eax
  801e88:	83 e0 1f             	and    $0x1f,%eax
  801e8b:	29 d0                	sub    %edx,%eax
  801e8d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e95:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e98:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e9b:	83 c6 01             	add    $0x1,%esi
  801e9e:	eb aa                	jmp    801e4a <devpipe_read+0x1c>

00801ea0 <pipe>:
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	56                   	push   %esi
  801ea4:	53                   	push   %ebx
  801ea5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ea8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eab:	50                   	push   %eax
  801eac:	e8 b2 f1 ff ff       	call   801063 <fd_alloc>
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	83 c4 10             	add    $0x10,%esp
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	0f 88 23 01 00 00    	js     801fe1 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ebe:	83 ec 04             	sub    $0x4,%esp
  801ec1:	68 07 04 00 00       	push   $0x407
  801ec6:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec9:	6a 00                	push   $0x0
  801ecb:	e8 77 ee ff ff       	call   800d47 <sys_page_alloc>
  801ed0:	89 c3                	mov    %eax,%ebx
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	0f 88 04 01 00 00    	js     801fe1 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ee3:	50                   	push   %eax
  801ee4:	e8 7a f1 ff ff       	call   801063 <fd_alloc>
  801ee9:	89 c3                	mov    %eax,%ebx
  801eeb:	83 c4 10             	add    $0x10,%esp
  801eee:	85 c0                	test   %eax,%eax
  801ef0:	0f 88 db 00 00 00    	js     801fd1 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	68 07 04 00 00       	push   $0x407
  801efe:	ff 75 f0             	pushl  -0x10(%ebp)
  801f01:	6a 00                	push   $0x0
  801f03:	e8 3f ee ff ff       	call   800d47 <sys_page_alloc>
  801f08:	89 c3                	mov    %eax,%ebx
  801f0a:	83 c4 10             	add    $0x10,%esp
  801f0d:	85 c0                	test   %eax,%eax
  801f0f:	0f 88 bc 00 00 00    	js     801fd1 <pipe+0x131>
	va = fd2data(fd0);
  801f15:	83 ec 0c             	sub    $0xc,%esp
  801f18:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1b:	e8 2c f1 ff ff       	call   80104c <fd2data>
  801f20:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f22:	83 c4 0c             	add    $0xc,%esp
  801f25:	68 07 04 00 00       	push   $0x407
  801f2a:	50                   	push   %eax
  801f2b:	6a 00                	push   $0x0
  801f2d:	e8 15 ee ff ff       	call   800d47 <sys_page_alloc>
  801f32:	89 c3                	mov    %eax,%ebx
  801f34:	83 c4 10             	add    $0x10,%esp
  801f37:	85 c0                	test   %eax,%eax
  801f39:	0f 88 82 00 00 00    	js     801fc1 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f3f:	83 ec 0c             	sub    $0xc,%esp
  801f42:	ff 75 f0             	pushl  -0x10(%ebp)
  801f45:	e8 02 f1 ff ff       	call   80104c <fd2data>
  801f4a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f51:	50                   	push   %eax
  801f52:	6a 00                	push   $0x0
  801f54:	56                   	push   %esi
  801f55:	6a 00                	push   $0x0
  801f57:	e8 2e ee ff ff       	call   800d8a <sys_page_map>
  801f5c:	89 c3                	mov    %eax,%ebx
  801f5e:	83 c4 20             	add    $0x20,%esp
  801f61:	85 c0                	test   %eax,%eax
  801f63:	78 4e                	js     801fb3 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f65:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6d:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f72:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f79:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f7c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f81:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f88:	83 ec 0c             	sub    $0xc,%esp
  801f8b:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8e:	e8 a9 f0 ff ff       	call   80103c <fd2num>
  801f93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f96:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f98:	83 c4 04             	add    $0x4,%esp
  801f9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9e:	e8 99 f0 ff ff       	call   80103c <fd2num>
  801fa3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa6:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fa9:	83 c4 10             	add    $0x10,%esp
  801fac:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fb1:	eb 2e                	jmp    801fe1 <pipe+0x141>
	sys_page_unmap(0, va);
  801fb3:	83 ec 08             	sub    $0x8,%esp
  801fb6:	56                   	push   %esi
  801fb7:	6a 00                	push   $0x0
  801fb9:	e8 0e ee ff ff       	call   800dcc <sys_page_unmap>
  801fbe:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fc1:	83 ec 08             	sub    $0x8,%esp
  801fc4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc7:	6a 00                	push   $0x0
  801fc9:	e8 fe ed ff ff       	call   800dcc <sys_page_unmap>
  801fce:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fd1:	83 ec 08             	sub    $0x8,%esp
  801fd4:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd7:	6a 00                	push   $0x0
  801fd9:	e8 ee ed ff ff       	call   800dcc <sys_page_unmap>
  801fde:	83 c4 10             	add    $0x10,%esp
}
  801fe1:	89 d8                	mov    %ebx,%eax
  801fe3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe6:	5b                   	pop    %ebx
  801fe7:	5e                   	pop    %esi
  801fe8:	5d                   	pop    %ebp
  801fe9:	c3                   	ret    

00801fea <pipeisclosed>:
{
  801fea:	55                   	push   %ebp
  801feb:	89 e5                	mov    %esp,%ebp
  801fed:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff3:	50                   	push   %eax
  801ff4:	ff 75 08             	pushl  0x8(%ebp)
  801ff7:	e8 b9 f0 ff ff       	call   8010b5 <fd_lookup>
  801ffc:	83 c4 10             	add    $0x10,%esp
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 18                	js     80201b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802003:	83 ec 0c             	sub    $0xc,%esp
  802006:	ff 75 f4             	pushl  -0xc(%ebp)
  802009:	e8 3e f0 ff ff       	call   80104c <fd2data>
	return _pipeisclosed(fd, p);
  80200e:	89 c2                	mov    %eax,%edx
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	e8 2f fd ff ff       	call   801d47 <_pipeisclosed>
  802018:	83 c4 10             	add    $0x10,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80201d:	b8 00 00 00 00       	mov    $0x0,%eax
  802022:	c3                   	ret    

00802023 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802023:	55                   	push   %ebp
  802024:	89 e5                	mov    %esp,%ebp
  802026:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802029:	68 6f 2a 80 00       	push   $0x802a6f
  80202e:	ff 75 0c             	pushl  0xc(%ebp)
  802031:	e8 1f e9 ff ff       	call   800955 <strcpy>
	return 0;
}
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	c9                   	leave  
  80203c:	c3                   	ret    

0080203d <devcons_write>:
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	57                   	push   %edi
  802041:	56                   	push   %esi
  802042:	53                   	push   %ebx
  802043:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802049:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80204e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802054:	3b 75 10             	cmp    0x10(%ebp),%esi
  802057:	73 31                	jae    80208a <devcons_write+0x4d>
		m = n - tot;
  802059:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80205c:	29 f3                	sub    %esi,%ebx
  80205e:	83 fb 7f             	cmp    $0x7f,%ebx
  802061:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802066:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802069:	83 ec 04             	sub    $0x4,%esp
  80206c:	53                   	push   %ebx
  80206d:	89 f0                	mov    %esi,%eax
  80206f:	03 45 0c             	add    0xc(%ebp),%eax
  802072:	50                   	push   %eax
  802073:	57                   	push   %edi
  802074:	e8 6a ea ff ff       	call   800ae3 <memmove>
		sys_cputs(buf, m);
  802079:	83 c4 08             	add    $0x8,%esp
  80207c:	53                   	push   %ebx
  80207d:	57                   	push   %edi
  80207e:	e8 08 ec ff ff       	call   800c8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802083:	01 de                	add    %ebx,%esi
  802085:	83 c4 10             	add    $0x10,%esp
  802088:	eb ca                	jmp    802054 <devcons_write+0x17>
}
  80208a:	89 f0                	mov    %esi,%eax
  80208c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80208f:	5b                   	pop    %ebx
  802090:	5e                   	pop    %esi
  802091:	5f                   	pop    %edi
  802092:	5d                   	pop    %ebp
  802093:	c3                   	ret    

00802094 <devcons_read>:
{
  802094:	55                   	push   %ebp
  802095:	89 e5                	mov    %esp,%ebp
  802097:	83 ec 08             	sub    $0x8,%esp
  80209a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80209f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020a3:	74 21                	je     8020c6 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020a5:	e8 ff eb ff ff       	call   800ca9 <sys_cgetc>
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	75 07                	jne    8020b5 <devcons_read+0x21>
		sys_yield();
  8020ae:	e8 75 ec ff ff       	call   800d28 <sys_yield>
  8020b3:	eb f0                	jmp    8020a5 <devcons_read+0x11>
	if (c < 0)
  8020b5:	78 0f                	js     8020c6 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020b7:	83 f8 04             	cmp    $0x4,%eax
  8020ba:	74 0c                	je     8020c8 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020bf:	88 02                	mov    %al,(%edx)
	return 1;
  8020c1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    
		return 0;
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cd:	eb f7                	jmp    8020c6 <devcons_read+0x32>

008020cf <cputchar>:
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020db:	6a 01                	push   $0x1
  8020dd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e0:	50                   	push   %eax
  8020e1:	e8 a5 eb ff ff       	call   800c8b <sys_cputs>
}
  8020e6:	83 c4 10             	add    $0x10,%esp
  8020e9:	c9                   	leave  
  8020ea:	c3                   	ret    

008020eb <getchar>:
{
  8020eb:	55                   	push   %ebp
  8020ec:	89 e5                	mov    %esp,%ebp
  8020ee:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020f1:	6a 01                	push   $0x1
  8020f3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f6:	50                   	push   %eax
  8020f7:	6a 00                	push   $0x0
  8020f9:	e8 27 f2 ff ff       	call   801325 <read>
	if (r < 0)
  8020fe:	83 c4 10             	add    $0x10,%esp
  802101:	85 c0                	test   %eax,%eax
  802103:	78 06                	js     80210b <getchar+0x20>
	if (r < 1)
  802105:	74 06                	je     80210d <getchar+0x22>
	return c;
  802107:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80210b:	c9                   	leave  
  80210c:	c3                   	ret    
		return -E_EOF;
  80210d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802112:	eb f7                	jmp    80210b <getchar+0x20>

00802114 <iscons>:
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80211a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80211d:	50                   	push   %eax
  80211e:	ff 75 08             	pushl  0x8(%ebp)
  802121:	e8 8f ef ff ff       	call   8010b5 <fd_lookup>
  802126:	83 c4 10             	add    $0x10,%esp
  802129:	85 c0                	test   %eax,%eax
  80212b:	78 11                	js     80213e <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802136:	39 10                	cmp    %edx,(%eax)
  802138:	0f 94 c0             	sete   %al
  80213b:	0f b6 c0             	movzbl %al,%eax
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <opencons>:
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802146:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802149:	50                   	push   %eax
  80214a:	e8 14 ef ff ff       	call   801063 <fd_alloc>
  80214f:	83 c4 10             	add    $0x10,%esp
  802152:	85 c0                	test   %eax,%eax
  802154:	78 3a                	js     802190 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802156:	83 ec 04             	sub    $0x4,%esp
  802159:	68 07 04 00 00       	push   $0x407
  80215e:	ff 75 f4             	pushl  -0xc(%ebp)
  802161:	6a 00                	push   $0x0
  802163:	e8 df eb ff ff       	call   800d47 <sys_page_alloc>
  802168:	83 c4 10             	add    $0x10,%esp
  80216b:	85 c0                	test   %eax,%eax
  80216d:	78 21                	js     802190 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802178:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80217a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	50                   	push   %eax
  802188:	e8 af ee ff ff       	call   80103c <fd2num>
  80218d:	83 c4 10             	add    $0x10,%esp
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	56                   	push   %esi
  802196:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802197:	a1 08 40 80 00       	mov    0x804008,%eax
  80219c:	8b 40 48             	mov    0x48(%eax),%eax
  80219f:	83 ec 04             	sub    $0x4,%esp
  8021a2:	68 a0 2a 80 00       	push   $0x802aa0
  8021a7:	50                   	push   %eax
  8021a8:	68 8f 25 80 00       	push   $0x80258f
  8021ad:	e8 44 e0 ff ff       	call   8001f6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021b2:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021b5:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021bb:	e8 49 eb ff ff       	call   800d09 <sys_getenvid>
  8021c0:	83 c4 04             	add    $0x4,%esp
  8021c3:	ff 75 0c             	pushl  0xc(%ebp)
  8021c6:	ff 75 08             	pushl  0x8(%ebp)
  8021c9:	56                   	push   %esi
  8021ca:	50                   	push   %eax
  8021cb:	68 7c 2a 80 00       	push   $0x802a7c
  8021d0:	e8 21 e0 ff ff       	call   8001f6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021d5:	83 c4 18             	add    $0x18,%esp
  8021d8:	53                   	push   %ebx
  8021d9:	ff 75 10             	pushl  0x10(%ebp)
  8021dc:	e8 c4 df ff ff       	call   8001a5 <vcprintf>
	cprintf("\n");
  8021e1:	c7 04 24 ba 2a 80 00 	movl   $0x802aba,(%esp)
  8021e8:	e8 09 e0 ff ff       	call   8001f6 <cprintf>
  8021ed:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021f0:	cc                   	int3   
  8021f1:	eb fd                	jmp    8021f0 <_panic+0x5e>

008021f3 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	56                   	push   %esi
  8021f7:	53                   	push   %ebx
  8021f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8021fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021fe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802201:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802203:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802208:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80220b:	83 ec 0c             	sub    $0xc,%esp
  80220e:	50                   	push   %eax
  80220f:	e8 e3 ec ff ff       	call   800ef7 <sys_ipc_recv>
	if(ret < 0){
  802214:	83 c4 10             	add    $0x10,%esp
  802217:	85 c0                	test   %eax,%eax
  802219:	78 2b                	js     802246 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80221b:	85 f6                	test   %esi,%esi
  80221d:	74 0a                	je     802229 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  80221f:	a1 08 40 80 00       	mov    0x804008,%eax
  802224:	8b 40 78             	mov    0x78(%eax),%eax
  802227:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802229:	85 db                	test   %ebx,%ebx
  80222b:	74 0a                	je     802237 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80222d:	a1 08 40 80 00       	mov    0x804008,%eax
  802232:	8b 40 7c             	mov    0x7c(%eax),%eax
  802235:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802237:	a1 08 40 80 00       	mov    0x804008,%eax
  80223c:	8b 40 74             	mov    0x74(%eax),%eax
}
  80223f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802242:	5b                   	pop    %ebx
  802243:	5e                   	pop    %esi
  802244:	5d                   	pop    %ebp
  802245:	c3                   	ret    
		if(from_env_store)
  802246:	85 f6                	test   %esi,%esi
  802248:	74 06                	je     802250 <ipc_recv+0x5d>
			*from_env_store = 0;
  80224a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  802250:	85 db                	test   %ebx,%ebx
  802252:	74 eb                	je     80223f <ipc_recv+0x4c>
			*perm_store = 0;
  802254:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80225a:	eb e3                	jmp    80223f <ipc_recv+0x4c>

0080225c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	57                   	push   %edi
  802260:	56                   	push   %esi
  802261:	53                   	push   %ebx
  802262:	83 ec 0c             	sub    $0xc,%esp
  802265:	8b 7d 08             	mov    0x8(%ebp),%edi
  802268:	8b 75 0c             	mov    0xc(%ebp),%esi
  80226b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  80226e:	85 db                	test   %ebx,%ebx
  802270:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802275:	0f 44 d8             	cmove  %eax,%ebx
  802278:	eb 05                	jmp    80227f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80227a:	e8 a9 ea ff ff       	call   800d28 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80227f:	ff 75 14             	pushl  0x14(%ebp)
  802282:	53                   	push   %ebx
  802283:	56                   	push   %esi
  802284:	57                   	push   %edi
  802285:	e8 4a ec ff ff       	call   800ed4 <sys_ipc_try_send>
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	85 c0                	test   %eax,%eax
  80228f:	74 1b                	je     8022ac <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802291:	79 e7                	jns    80227a <ipc_send+0x1e>
  802293:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802296:	74 e2                	je     80227a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802298:	83 ec 04             	sub    $0x4,%esp
  80229b:	68 a7 2a 80 00       	push   $0x802aa7
  8022a0:	6a 46                	push   $0x46
  8022a2:	68 bc 2a 80 00       	push   $0x802abc
  8022a7:	e8 e6 fe ff ff       	call   802192 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022af:	5b                   	pop    %ebx
  8022b0:	5e                   	pop    %esi
  8022b1:	5f                   	pop    %edi
  8022b2:	5d                   	pop    %ebp
  8022b3:	c3                   	ret    

008022b4 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022b4:	55                   	push   %ebp
  8022b5:	89 e5                	mov    %esp,%ebp
  8022b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022bf:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  8022c5:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022cb:	8b 52 50             	mov    0x50(%edx),%edx
  8022ce:	39 ca                	cmp    %ecx,%edx
  8022d0:	74 11                	je     8022e3 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8022d2:	83 c0 01             	add    $0x1,%eax
  8022d5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022da:	75 e3                	jne    8022bf <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022e1:	eb 0e                	jmp    8022f1 <ipc_find_env+0x3d>
			return envs[i].env_id;
  8022e3:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  8022e9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022ee:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022f1:	5d                   	pop    %ebp
  8022f2:	c3                   	ret    

008022f3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022f9:	89 d0                	mov    %edx,%eax
  8022fb:	c1 e8 16             	shr    $0x16,%eax
  8022fe:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802305:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80230a:	f6 c1 01             	test   $0x1,%cl
  80230d:	74 1d                	je     80232c <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80230f:	c1 ea 0c             	shr    $0xc,%edx
  802312:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802319:	f6 c2 01             	test   $0x1,%dl
  80231c:	74 0e                	je     80232c <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80231e:	c1 ea 0c             	shr    $0xc,%edx
  802321:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802328:	ef 
  802329:	0f b7 c0             	movzwl %ax,%eax
}
  80232c:	5d                   	pop    %ebp
  80232d:	c3                   	ret    
  80232e:	66 90                	xchg   %ax,%ax

00802330 <__udivdi3>:
  802330:	55                   	push   %ebp
  802331:	57                   	push   %edi
  802332:	56                   	push   %esi
  802333:	53                   	push   %ebx
  802334:	83 ec 1c             	sub    $0x1c,%esp
  802337:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80233b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80233f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802343:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802347:	85 d2                	test   %edx,%edx
  802349:	75 4d                	jne    802398 <__udivdi3+0x68>
  80234b:	39 f3                	cmp    %esi,%ebx
  80234d:	76 19                	jbe    802368 <__udivdi3+0x38>
  80234f:	31 ff                	xor    %edi,%edi
  802351:	89 e8                	mov    %ebp,%eax
  802353:	89 f2                	mov    %esi,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 fa                	mov    %edi,%edx
  802359:	83 c4 1c             	add    $0x1c,%esp
  80235c:	5b                   	pop    %ebx
  80235d:	5e                   	pop    %esi
  80235e:	5f                   	pop    %edi
  80235f:	5d                   	pop    %ebp
  802360:	c3                   	ret    
  802361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802368:	89 d9                	mov    %ebx,%ecx
  80236a:	85 db                	test   %ebx,%ebx
  80236c:	75 0b                	jne    802379 <__udivdi3+0x49>
  80236e:	b8 01 00 00 00       	mov    $0x1,%eax
  802373:	31 d2                	xor    %edx,%edx
  802375:	f7 f3                	div    %ebx
  802377:	89 c1                	mov    %eax,%ecx
  802379:	31 d2                	xor    %edx,%edx
  80237b:	89 f0                	mov    %esi,%eax
  80237d:	f7 f1                	div    %ecx
  80237f:	89 c6                	mov    %eax,%esi
  802381:	89 e8                	mov    %ebp,%eax
  802383:	89 f7                	mov    %esi,%edi
  802385:	f7 f1                	div    %ecx
  802387:	89 fa                	mov    %edi,%edx
  802389:	83 c4 1c             	add    $0x1c,%esp
  80238c:	5b                   	pop    %ebx
  80238d:	5e                   	pop    %esi
  80238e:	5f                   	pop    %edi
  80238f:	5d                   	pop    %ebp
  802390:	c3                   	ret    
  802391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802398:	39 f2                	cmp    %esi,%edx
  80239a:	77 1c                	ja     8023b8 <__udivdi3+0x88>
  80239c:	0f bd fa             	bsr    %edx,%edi
  80239f:	83 f7 1f             	xor    $0x1f,%edi
  8023a2:	75 2c                	jne    8023d0 <__udivdi3+0xa0>
  8023a4:	39 f2                	cmp    %esi,%edx
  8023a6:	72 06                	jb     8023ae <__udivdi3+0x7e>
  8023a8:	31 c0                	xor    %eax,%eax
  8023aa:	39 eb                	cmp    %ebp,%ebx
  8023ac:	77 a9                	ja     802357 <__udivdi3+0x27>
  8023ae:	b8 01 00 00 00       	mov    $0x1,%eax
  8023b3:	eb a2                	jmp    802357 <__udivdi3+0x27>
  8023b5:	8d 76 00             	lea    0x0(%esi),%esi
  8023b8:	31 ff                	xor    %edi,%edi
  8023ba:	31 c0                	xor    %eax,%eax
  8023bc:	89 fa                	mov    %edi,%edx
  8023be:	83 c4 1c             	add    $0x1c,%esp
  8023c1:	5b                   	pop    %ebx
  8023c2:	5e                   	pop    %esi
  8023c3:	5f                   	pop    %edi
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    
  8023c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023cd:	8d 76 00             	lea    0x0(%esi),%esi
  8023d0:	89 f9                	mov    %edi,%ecx
  8023d2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023d7:	29 f8                	sub    %edi,%eax
  8023d9:	d3 e2                	shl    %cl,%edx
  8023db:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023df:	89 c1                	mov    %eax,%ecx
  8023e1:	89 da                	mov    %ebx,%edx
  8023e3:	d3 ea                	shr    %cl,%edx
  8023e5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023e9:	09 d1                	or     %edx,%ecx
  8023eb:	89 f2                	mov    %esi,%edx
  8023ed:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f1:	89 f9                	mov    %edi,%ecx
  8023f3:	d3 e3                	shl    %cl,%ebx
  8023f5:	89 c1                	mov    %eax,%ecx
  8023f7:	d3 ea                	shr    %cl,%edx
  8023f9:	89 f9                	mov    %edi,%ecx
  8023fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023ff:	89 eb                	mov    %ebp,%ebx
  802401:	d3 e6                	shl    %cl,%esi
  802403:	89 c1                	mov    %eax,%ecx
  802405:	d3 eb                	shr    %cl,%ebx
  802407:	09 de                	or     %ebx,%esi
  802409:	89 f0                	mov    %esi,%eax
  80240b:	f7 74 24 08          	divl   0x8(%esp)
  80240f:	89 d6                	mov    %edx,%esi
  802411:	89 c3                	mov    %eax,%ebx
  802413:	f7 64 24 0c          	mull   0xc(%esp)
  802417:	39 d6                	cmp    %edx,%esi
  802419:	72 15                	jb     802430 <__udivdi3+0x100>
  80241b:	89 f9                	mov    %edi,%ecx
  80241d:	d3 e5                	shl    %cl,%ebp
  80241f:	39 c5                	cmp    %eax,%ebp
  802421:	73 04                	jae    802427 <__udivdi3+0xf7>
  802423:	39 d6                	cmp    %edx,%esi
  802425:	74 09                	je     802430 <__udivdi3+0x100>
  802427:	89 d8                	mov    %ebx,%eax
  802429:	31 ff                	xor    %edi,%edi
  80242b:	e9 27 ff ff ff       	jmp    802357 <__udivdi3+0x27>
  802430:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802433:	31 ff                	xor    %edi,%edi
  802435:	e9 1d ff ff ff       	jmp    802357 <__udivdi3+0x27>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	66 90                	xchg   %ax,%ax
  80243e:	66 90                	xchg   %ax,%ax

00802440 <__umoddi3>:
  802440:	55                   	push   %ebp
  802441:	57                   	push   %edi
  802442:	56                   	push   %esi
  802443:	53                   	push   %ebx
  802444:	83 ec 1c             	sub    $0x1c,%esp
  802447:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80244b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80244f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802453:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802457:	89 da                	mov    %ebx,%edx
  802459:	85 c0                	test   %eax,%eax
  80245b:	75 43                	jne    8024a0 <__umoddi3+0x60>
  80245d:	39 df                	cmp    %ebx,%edi
  80245f:	76 17                	jbe    802478 <__umoddi3+0x38>
  802461:	89 f0                	mov    %esi,%eax
  802463:	f7 f7                	div    %edi
  802465:	89 d0                	mov    %edx,%eax
  802467:	31 d2                	xor    %edx,%edx
  802469:	83 c4 1c             	add    $0x1c,%esp
  80246c:	5b                   	pop    %ebx
  80246d:	5e                   	pop    %esi
  80246e:	5f                   	pop    %edi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    
  802471:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802478:	89 fd                	mov    %edi,%ebp
  80247a:	85 ff                	test   %edi,%edi
  80247c:	75 0b                	jne    802489 <__umoddi3+0x49>
  80247e:	b8 01 00 00 00       	mov    $0x1,%eax
  802483:	31 d2                	xor    %edx,%edx
  802485:	f7 f7                	div    %edi
  802487:	89 c5                	mov    %eax,%ebp
  802489:	89 d8                	mov    %ebx,%eax
  80248b:	31 d2                	xor    %edx,%edx
  80248d:	f7 f5                	div    %ebp
  80248f:	89 f0                	mov    %esi,%eax
  802491:	f7 f5                	div    %ebp
  802493:	89 d0                	mov    %edx,%eax
  802495:	eb d0                	jmp    802467 <__umoddi3+0x27>
  802497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80249e:	66 90                	xchg   %ax,%ax
  8024a0:	89 f1                	mov    %esi,%ecx
  8024a2:	39 d8                	cmp    %ebx,%eax
  8024a4:	76 0a                	jbe    8024b0 <__umoddi3+0x70>
  8024a6:	89 f0                	mov    %esi,%eax
  8024a8:	83 c4 1c             	add    $0x1c,%esp
  8024ab:	5b                   	pop    %ebx
  8024ac:	5e                   	pop    %esi
  8024ad:	5f                   	pop    %edi
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    
  8024b0:	0f bd e8             	bsr    %eax,%ebp
  8024b3:	83 f5 1f             	xor    $0x1f,%ebp
  8024b6:	75 20                	jne    8024d8 <__umoddi3+0x98>
  8024b8:	39 d8                	cmp    %ebx,%eax
  8024ba:	0f 82 b0 00 00 00    	jb     802570 <__umoddi3+0x130>
  8024c0:	39 f7                	cmp    %esi,%edi
  8024c2:	0f 86 a8 00 00 00    	jbe    802570 <__umoddi3+0x130>
  8024c8:	89 c8                	mov    %ecx,%eax
  8024ca:	83 c4 1c             	add    $0x1c,%esp
  8024cd:	5b                   	pop    %ebx
  8024ce:	5e                   	pop    %esi
  8024cf:	5f                   	pop    %edi
  8024d0:	5d                   	pop    %ebp
  8024d1:	c3                   	ret    
  8024d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024d8:	89 e9                	mov    %ebp,%ecx
  8024da:	ba 20 00 00 00       	mov    $0x20,%edx
  8024df:	29 ea                	sub    %ebp,%edx
  8024e1:	d3 e0                	shl    %cl,%eax
  8024e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024e7:	89 d1                	mov    %edx,%ecx
  8024e9:	89 f8                	mov    %edi,%eax
  8024eb:	d3 e8                	shr    %cl,%eax
  8024ed:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024f1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024f5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024f9:	09 c1                	or     %eax,%ecx
  8024fb:	89 d8                	mov    %ebx,%eax
  8024fd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802501:	89 e9                	mov    %ebp,%ecx
  802503:	d3 e7                	shl    %cl,%edi
  802505:	89 d1                	mov    %edx,%ecx
  802507:	d3 e8                	shr    %cl,%eax
  802509:	89 e9                	mov    %ebp,%ecx
  80250b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80250f:	d3 e3                	shl    %cl,%ebx
  802511:	89 c7                	mov    %eax,%edi
  802513:	89 d1                	mov    %edx,%ecx
  802515:	89 f0                	mov    %esi,%eax
  802517:	d3 e8                	shr    %cl,%eax
  802519:	89 e9                	mov    %ebp,%ecx
  80251b:	89 fa                	mov    %edi,%edx
  80251d:	d3 e6                	shl    %cl,%esi
  80251f:	09 d8                	or     %ebx,%eax
  802521:	f7 74 24 08          	divl   0x8(%esp)
  802525:	89 d1                	mov    %edx,%ecx
  802527:	89 f3                	mov    %esi,%ebx
  802529:	f7 64 24 0c          	mull   0xc(%esp)
  80252d:	89 c6                	mov    %eax,%esi
  80252f:	89 d7                	mov    %edx,%edi
  802531:	39 d1                	cmp    %edx,%ecx
  802533:	72 06                	jb     80253b <__umoddi3+0xfb>
  802535:	75 10                	jne    802547 <__umoddi3+0x107>
  802537:	39 c3                	cmp    %eax,%ebx
  802539:	73 0c                	jae    802547 <__umoddi3+0x107>
  80253b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80253f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802543:	89 d7                	mov    %edx,%edi
  802545:	89 c6                	mov    %eax,%esi
  802547:	89 ca                	mov    %ecx,%edx
  802549:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80254e:	29 f3                	sub    %esi,%ebx
  802550:	19 fa                	sbb    %edi,%edx
  802552:	89 d0                	mov    %edx,%eax
  802554:	d3 e0                	shl    %cl,%eax
  802556:	89 e9                	mov    %ebp,%ecx
  802558:	d3 eb                	shr    %cl,%ebx
  80255a:	d3 ea                	shr    %cl,%edx
  80255c:	09 d8                	or     %ebx,%eax
  80255e:	83 c4 1c             	add    $0x1c,%esp
  802561:	5b                   	pop    %ebx
  802562:	5e                   	pop    %esi
  802563:	5f                   	pop    %edi
  802564:	5d                   	pop    %ebp
  802565:	c3                   	ret    
  802566:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80256d:	8d 76 00             	lea    0x0(%esi),%esi
  802570:	89 da                	mov    %ebx,%edx
  802572:	29 fe                	sub    %edi,%esi
  802574:	19 c2                	sbb    %eax,%edx
  802576:	89 f1                	mov    %esi,%ecx
  802578:	89 c8                	mov    %ecx,%eax
  80257a:	e9 4b ff ff ff       	jmp    8024ca <__umoddi3+0x8a>
