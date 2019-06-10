
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
  800058:	68 20 26 80 00       	push   $0x802620
  80005d:	ff 76 04             	pushl  0x4(%esi)
  800060:	e8 2b 0a 00 00       	call   800a90 <strcmp>
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
  800087:	68 23 26 80 00       	push   $0x802623
  80008c:	6a 01                	push   $0x1
  80008e:	e8 ee 13 00 00       	call   801481 <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 0b 09 00 00       	call   8009ac <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 d2 13 00 00       	call   801481 <write>
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
  8000d3:	68 41 26 80 00       	push   $0x802641
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 a2 13 00 00       	call   801481 <write>
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
  8000f7:	e8 9d 0c 00 00       	call   800d99 <sys_getenvid>
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

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80015b:	a1 08 40 80 00       	mov    0x804008,%eax
  800160:	8b 40 48             	mov    0x48(%eax),%eax
  800163:	83 ec 08             	sub    $0x8,%esp
  800166:	50                   	push   %eax
  800167:	68 25 26 80 00       	push   $0x802625
  80016c:	e8 15 01 00 00       	call   800286 <cprintf>
	cprintf("before umain\n");
  800171:	c7 04 24 43 26 80 00 	movl   $0x802643,(%esp)
  800178:	e8 09 01 00 00       	call   800286 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017d:	83 c4 08             	add    $0x8,%esp
  800180:	ff 75 0c             	pushl  0xc(%ebp)
  800183:	ff 75 08             	pushl  0x8(%ebp)
  800186:	e8 a8 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80018b:	c7 04 24 51 26 80 00 	movl   $0x802651,(%esp)
  800192:	e8 ef 00 00 00       	call   800286 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800197:	a1 08 40 80 00       	mov    0x804008,%eax
  80019c:	8b 40 48             	mov    0x48(%eax),%eax
  80019f:	83 c4 08             	add    $0x8,%esp
  8001a2:	50                   	push   %eax
  8001a3:	68 5e 26 80 00       	push   $0x80265e
  8001a8:	e8 d9 00 00 00       	call   800286 <cprintf>
	// exit gracefully
	exit();
  8001ad:	e8 0b 00 00 00       	call   8001bd <exit>
}
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b8:	5b                   	pop    %ebx
  8001b9:	5e                   	pop    %esi
  8001ba:	5f                   	pop    %edi
  8001bb:	5d                   	pop    %ebp
  8001bc:	c3                   	ret    

008001bd <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001bd:	55                   	push   %ebp
  8001be:	89 e5                	mov    %esp,%ebp
  8001c0:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001c3:	a1 08 40 80 00       	mov    0x804008,%eax
  8001c8:	8b 40 48             	mov    0x48(%eax),%eax
  8001cb:	68 88 26 80 00       	push   $0x802688
  8001d0:	50                   	push   %eax
  8001d1:	68 7d 26 80 00       	push   $0x80267d
  8001d6:	e8 ab 00 00 00       	call   800286 <cprintf>
	close_all();
  8001db:	e8 c4 10 00 00       	call   8012a4 <close_all>
	sys_env_destroy(0);
  8001e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e7:	e8 6c 0b 00 00       	call   800d58 <sys_env_destroy>
}
  8001ec:	83 c4 10             	add    $0x10,%esp
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	53                   	push   %ebx
  8001f5:	83 ec 04             	sub    $0x4,%esp
  8001f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001fb:	8b 13                	mov    (%ebx),%edx
  8001fd:	8d 42 01             	lea    0x1(%edx),%eax
  800200:	89 03                	mov    %eax,(%ebx)
  800202:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800205:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800209:	3d ff 00 00 00       	cmp    $0xff,%eax
  80020e:	74 09                	je     800219 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800210:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800214:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800217:	c9                   	leave  
  800218:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800219:	83 ec 08             	sub    $0x8,%esp
  80021c:	68 ff 00 00 00       	push   $0xff
  800221:	8d 43 08             	lea    0x8(%ebx),%eax
  800224:	50                   	push   %eax
  800225:	e8 f1 0a 00 00       	call   800d1b <sys_cputs>
		b->idx = 0;
  80022a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800230:	83 c4 10             	add    $0x10,%esp
  800233:	eb db                	jmp    800210 <putch+0x1f>

00800235 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80023e:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800245:	00 00 00 
	b.cnt = 0;
  800248:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80024f:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800252:	ff 75 0c             	pushl  0xc(%ebp)
  800255:	ff 75 08             	pushl  0x8(%ebp)
  800258:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025e:	50                   	push   %eax
  80025f:	68 f1 01 80 00       	push   $0x8001f1
  800264:	e8 4a 01 00 00       	call   8003b3 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800269:	83 c4 08             	add    $0x8,%esp
  80026c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800272:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800278:	50                   	push   %eax
  800279:	e8 9d 0a 00 00       	call   800d1b <sys_cputs>

	return b.cnt;
}
  80027e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800284:	c9                   	leave  
  800285:	c3                   	ret    

00800286 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800286:	55                   	push   %ebp
  800287:	89 e5                	mov    %esp,%ebp
  800289:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028c:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80028f:	50                   	push   %eax
  800290:	ff 75 08             	pushl  0x8(%ebp)
  800293:	e8 9d ff ff ff       	call   800235 <vcprintf>
	va_end(ap);

	return cnt;
}
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	57                   	push   %edi
  80029e:	56                   	push   %esi
  80029f:	53                   	push   %ebx
  8002a0:	83 ec 1c             	sub    $0x1c,%esp
  8002a3:	89 c6                	mov    %eax,%esi
  8002a5:	89 d7                	mov    %edx,%edi
  8002a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8002aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b0:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b6:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002b9:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002bd:	74 2c                	je     8002eb <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002c9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002cc:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002cf:	39 c2                	cmp    %eax,%edx
  8002d1:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002d4:	73 43                	jae    800319 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002d6:	83 eb 01             	sub    $0x1,%ebx
  8002d9:	85 db                	test   %ebx,%ebx
  8002db:	7e 6c                	jle    800349 <printnum+0xaf>
				putch(padc, putdat);
  8002dd:	83 ec 08             	sub    $0x8,%esp
  8002e0:	57                   	push   %edi
  8002e1:	ff 75 18             	pushl  0x18(%ebp)
  8002e4:	ff d6                	call   *%esi
  8002e6:	83 c4 10             	add    $0x10,%esp
  8002e9:	eb eb                	jmp    8002d6 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	6a 20                	push   $0x20
  8002f0:	6a 00                	push   $0x0
  8002f2:	50                   	push   %eax
  8002f3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f6:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f9:	89 fa                	mov    %edi,%edx
  8002fb:	89 f0                	mov    %esi,%eax
  8002fd:	e8 98 ff ff ff       	call   80029a <printnum>
		while (--width > 0)
  800302:	83 c4 20             	add    $0x20,%esp
  800305:	83 eb 01             	sub    $0x1,%ebx
  800308:	85 db                	test   %ebx,%ebx
  80030a:	7e 65                	jle    800371 <printnum+0xd7>
			putch(padc, putdat);
  80030c:	83 ec 08             	sub    $0x8,%esp
  80030f:	57                   	push   %edi
  800310:	6a 20                	push   $0x20
  800312:	ff d6                	call   *%esi
  800314:	83 c4 10             	add    $0x10,%esp
  800317:	eb ec                	jmp    800305 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800319:	83 ec 0c             	sub    $0xc,%esp
  80031c:	ff 75 18             	pushl  0x18(%ebp)
  80031f:	83 eb 01             	sub    $0x1,%ebx
  800322:	53                   	push   %ebx
  800323:	50                   	push   %eax
  800324:	83 ec 08             	sub    $0x8,%esp
  800327:	ff 75 dc             	pushl  -0x24(%ebp)
  80032a:	ff 75 d8             	pushl  -0x28(%ebp)
  80032d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800330:	ff 75 e0             	pushl  -0x20(%ebp)
  800333:	e8 88 20 00 00       	call   8023c0 <__udivdi3>
  800338:	83 c4 18             	add    $0x18,%esp
  80033b:	52                   	push   %edx
  80033c:	50                   	push   %eax
  80033d:	89 fa                	mov    %edi,%edx
  80033f:	89 f0                	mov    %esi,%eax
  800341:	e8 54 ff ff ff       	call   80029a <printnum>
  800346:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  800349:	83 ec 08             	sub    $0x8,%esp
  80034c:	57                   	push   %edi
  80034d:	83 ec 04             	sub    $0x4,%esp
  800350:	ff 75 dc             	pushl  -0x24(%ebp)
  800353:	ff 75 d8             	pushl  -0x28(%ebp)
  800356:	ff 75 e4             	pushl  -0x1c(%ebp)
  800359:	ff 75 e0             	pushl  -0x20(%ebp)
  80035c:	e8 6f 21 00 00       	call   8024d0 <__umoddi3>
  800361:	83 c4 14             	add    $0x14,%esp
  800364:	0f be 80 8d 26 80 00 	movsbl 0x80268d(%eax),%eax
  80036b:	50                   	push   %eax
  80036c:	ff d6                	call   *%esi
  80036e:	83 c4 10             	add    $0x10,%esp
	}
}
  800371:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800374:	5b                   	pop    %ebx
  800375:	5e                   	pop    %esi
  800376:	5f                   	pop    %edi
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    

00800379 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80037f:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800383:	8b 10                	mov    (%eax),%edx
  800385:	3b 50 04             	cmp    0x4(%eax),%edx
  800388:	73 0a                	jae    800394 <sprintputch+0x1b>
		*b->buf++ = ch;
  80038a:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038d:	89 08                	mov    %ecx,(%eax)
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	88 02                	mov    %al,(%edx)
}
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <printfmt>:
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80039c:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80039f:	50                   	push   %eax
  8003a0:	ff 75 10             	pushl  0x10(%ebp)
  8003a3:	ff 75 0c             	pushl  0xc(%ebp)
  8003a6:	ff 75 08             	pushl  0x8(%ebp)
  8003a9:	e8 05 00 00 00       	call   8003b3 <vprintfmt>
}
  8003ae:	83 c4 10             	add    $0x10,%esp
  8003b1:	c9                   	leave  
  8003b2:	c3                   	ret    

008003b3 <vprintfmt>:
{
  8003b3:	55                   	push   %ebp
  8003b4:	89 e5                	mov    %esp,%ebp
  8003b6:	57                   	push   %edi
  8003b7:	56                   	push   %esi
  8003b8:	53                   	push   %ebx
  8003b9:	83 ec 3c             	sub    $0x3c,%esp
  8003bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c2:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c5:	e9 32 04 00 00       	jmp    8007fc <vprintfmt+0x449>
		padc = ' ';
  8003ca:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003ce:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003d5:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003dc:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ea:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003f1:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f6:	8d 47 01             	lea    0x1(%edi),%eax
  8003f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fc:	0f b6 17             	movzbl (%edi),%edx
  8003ff:	8d 42 dd             	lea    -0x23(%edx),%eax
  800402:	3c 55                	cmp    $0x55,%al
  800404:	0f 87 12 05 00 00    	ja     80091c <vprintfmt+0x569>
  80040a:	0f b6 c0             	movzbl %al,%eax
  80040d:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
  800414:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800417:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80041b:	eb d9                	jmp    8003f6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80041d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800420:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800424:	eb d0                	jmp    8003f6 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800426:	0f b6 d2             	movzbl %dl,%edx
  800429:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80042c:	b8 00 00 00 00       	mov    $0x0,%eax
  800431:	89 75 08             	mov    %esi,0x8(%ebp)
  800434:	eb 03                	jmp    800439 <vprintfmt+0x86>
  800436:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800439:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043c:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800440:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800443:	8d 72 d0             	lea    -0x30(%edx),%esi
  800446:	83 fe 09             	cmp    $0x9,%esi
  800449:	76 eb                	jbe    800436 <vprintfmt+0x83>
  80044b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80044e:	8b 75 08             	mov    0x8(%ebp),%esi
  800451:	eb 14                	jmp    800467 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800453:	8b 45 14             	mov    0x14(%ebp),%eax
  800456:	8b 00                	mov    (%eax),%eax
  800458:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045b:	8b 45 14             	mov    0x14(%ebp),%eax
  80045e:	8d 40 04             	lea    0x4(%eax),%eax
  800461:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800464:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800467:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046b:	79 89                	jns    8003f6 <vprintfmt+0x43>
				width = precision, precision = -1;
  80046d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800470:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800473:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80047a:	e9 77 ff ff ff       	jmp    8003f6 <vprintfmt+0x43>
  80047f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800482:	85 c0                	test   %eax,%eax
  800484:	0f 48 c1             	cmovs  %ecx,%eax
  800487:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048d:	e9 64 ff ff ff       	jmp    8003f6 <vprintfmt+0x43>
  800492:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800495:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80049c:	e9 55 ff ff ff       	jmp    8003f6 <vprintfmt+0x43>
			lflag++;
  8004a1:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004a8:	e9 49 ff ff ff       	jmp    8003f6 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b0:	8d 78 04             	lea    0x4(%eax),%edi
  8004b3:	83 ec 08             	sub    $0x8,%esp
  8004b6:	53                   	push   %ebx
  8004b7:	ff 30                	pushl  (%eax)
  8004b9:	ff d6                	call   *%esi
			break;
  8004bb:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004be:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004c1:	e9 33 03 00 00       	jmp    8007f9 <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c9:	8d 78 04             	lea    0x4(%eax),%edi
  8004cc:	8b 00                	mov    (%eax),%eax
  8004ce:	99                   	cltd   
  8004cf:	31 d0                	xor    %edx,%eax
  8004d1:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d3:	83 f8 11             	cmp    $0x11,%eax
  8004d6:	7f 23                	jg     8004fb <vprintfmt+0x148>
  8004d8:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  8004df:	85 d2                	test   %edx,%edx
  8004e1:	74 18                	je     8004fb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004e3:	52                   	push   %edx
  8004e4:	68 dd 2a 80 00       	push   $0x802add
  8004e9:	53                   	push   %ebx
  8004ea:	56                   	push   %esi
  8004eb:	e8 a6 fe ff ff       	call   800396 <printfmt>
  8004f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f6:	e9 fe 02 00 00       	jmp    8007f9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	50                   	push   %eax
  8004fc:	68 a5 26 80 00       	push   $0x8026a5
  800501:	53                   	push   %ebx
  800502:	56                   	push   %esi
  800503:	e8 8e fe ff ff       	call   800396 <printfmt>
  800508:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80050e:	e9 e6 02 00 00       	jmp    8007f9 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800513:	8b 45 14             	mov    0x14(%ebp),%eax
  800516:	83 c0 04             	add    $0x4,%eax
  800519:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80051c:	8b 45 14             	mov    0x14(%ebp),%eax
  80051f:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800521:	85 c9                	test   %ecx,%ecx
  800523:	b8 9e 26 80 00       	mov    $0x80269e,%eax
  800528:	0f 45 c1             	cmovne %ecx,%eax
  80052b:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80052e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800532:	7e 06                	jle    80053a <vprintfmt+0x187>
  800534:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800538:	75 0d                	jne    800547 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80053a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80053d:	89 c7                	mov    %eax,%edi
  80053f:	03 45 e0             	add    -0x20(%ebp),%eax
  800542:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800545:	eb 53                	jmp    80059a <vprintfmt+0x1e7>
  800547:	83 ec 08             	sub    $0x8,%esp
  80054a:	ff 75 d8             	pushl  -0x28(%ebp)
  80054d:	50                   	push   %eax
  80054e:	e8 71 04 00 00       	call   8009c4 <strnlen>
  800553:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800556:	29 c1                	sub    %eax,%ecx
  800558:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80055b:	83 c4 10             	add    $0x10,%esp
  80055e:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800560:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800564:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800567:	eb 0f                	jmp    800578 <vprintfmt+0x1c5>
					putch(padc, putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	ff 75 e0             	pushl  -0x20(%ebp)
  800570:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800572:	83 ef 01             	sub    $0x1,%edi
  800575:	83 c4 10             	add    $0x10,%esp
  800578:	85 ff                	test   %edi,%edi
  80057a:	7f ed                	jg     800569 <vprintfmt+0x1b6>
  80057c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80057f:	85 c9                	test   %ecx,%ecx
  800581:	b8 00 00 00 00       	mov    $0x0,%eax
  800586:	0f 49 c1             	cmovns %ecx,%eax
  800589:	29 c1                	sub    %eax,%ecx
  80058b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80058e:	eb aa                	jmp    80053a <vprintfmt+0x187>
					putch(ch, putdat);
  800590:	83 ec 08             	sub    $0x8,%esp
  800593:	53                   	push   %ebx
  800594:	52                   	push   %edx
  800595:	ff d6                	call   *%esi
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059d:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80059f:	83 c7 01             	add    $0x1,%edi
  8005a2:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a6:	0f be d0             	movsbl %al,%edx
  8005a9:	85 d2                	test   %edx,%edx
  8005ab:	74 4b                	je     8005f8 <vprintfmt+0x245>
  8005ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b1:	78 06                	js     8005b9 <vprintfmt+0x206>
  8005b3:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005b7:	78 1e                	js     8005d7 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005b9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005bd:	74 d1                	je     800590 <vprintfmt+0x1dd>
  8005bf:	0f be c0             	movsbl %al,%eax
  8005c2:	83 e8 20             	sub    $0x20,%eax
  8005c5:	83 f8 5e             	cmp    $0x5e,%eax
  8005c8:	76 c6                	jbe    800590 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005ca:	83 ec 08             	sub    $0x8,%esp
  8005cd:	53                   	push   %ebx
  8005ce:	6a 3f                	push   $0x3f
  8005d0:	ff d6                	call   *%esi
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	eb c3                	jmp    80059a <vprintfmt+0x1e7>
  8005d7:	89 cf                	mov    %ecx,%edi
  8005d9:	eb 0e                	jmp    8005e9 <vprintfmt+0x236>
				putch(' ', putdat);
  8005db:	83 ec 08             	sub    $0x8,%esp
  8005de:	53                   	push   %ebx
  8005df:	6a 20                	push   $0x20
  8005e1:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005e3:	83 ef 01             	sub    $0x1,%edi
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	85 ff                	test   %edi,%edi
  8005eb:	7f ee                	jg     8005db <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ed:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f3:	e9 01 02 00 00       	jmp    8007f9 <vprintfmt+0x446>
  8005f8:	89 cf                	mov    %ecx,%edi
  8005fa:	eb ed                	jmp    8005e9 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8005ff:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800606:	e9 eb fd ff ff       	jmp    8003f6 <vprintfmt+0x43>
	if (lflag >= 2)
  80060b:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80060f:	7f 21                	jg     800632 <vprintfmt+0x27f>
	else if (lflag)
  800611:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800615:	74 68                	je     80067f <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800617:	8b 45 14             	mov    0x14(%ebp),%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80061f:	89 c1                	mov    %eax,%ecx
  800621:	c1 f9 1f             	sar    $0x1f,%ecx
  800624:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 40 04             	lea    0x4(%eax),%eax
  80062d:	89 45 14             	mov    %eax,0x14(%ebp)
  800630:	eb 17                	jmp    800649 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 50 04             	mov    0x4(%eax),%edx
  800638:	8b 00                	mov    (%eax),%eax
  80063a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8d 40 08             	lea    0x8(%eax),%eax
  800646:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800649:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80064f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800652:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800655:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800659:	78 3f                	js     80069a <vprintfmt+0x2e7>
			base = 10;
  80065b:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800660:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800664:	0f 84 71 01 00 00    	je     8007db <vprintfmt+0x428>
				putch('+', putdat);
  80066a:	83 ec 08             	sub    $0x8,%esp
  80066d:	53                   	push   %ebx
  80066e:	6a 2b                	push   $0x2b
  800670:	ff d6                	call   *%esi
  800672:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800675:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067a:	e9 5c 01 00 00       	jmp    8007db <vprintfmt+0x428>
		return va_arg(*ap, int);
  80067f:	8b 45 14             	mov    0x14(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800687:	89 c1                	mov    %eax,%ecx
  800689:	c1 f9 1f             	sar    $0x1f,%ecx
  80068c:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80068f:	8b 45 14             	mov    0x14(%ebp),%eax
  800692:	8d 40 04             	lea    0x4(%eax),%eax
  800695:	89 45 14             	mov    %eax,0x14(%ebp)
  800698:	eb af                	jmp    800649 <vprintfmt+0x296>
				putch('-', putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	6a 2d                	push   $0x2d
  8006a0:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006a8:	f7 d8                	neg    %eax
  8006aa:	83 d2 00             	adc    $0x0,%edx
  8006ad:	f7 da                	neg    %edx
  8006af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b5:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bd:	e9 19 01 00 00       	jmp    8007db <vprintfmt+0x428>
	if (lflag >= 2)
  8006c2:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c6:	7f 29                	jg     8006f1 <vprintfmt+0x33e>
	else if (lflag)
  8006c8:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006cc:	74 44                	je     800712 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006db:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8d 40 04             	lea    0x4(%eax),%eax
  8006e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ec:	e9 ea 00 00 00       	jmp    8007db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8b 50 04             	mov    0x4(%eax),%edx
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 40 08             	lea    0x8(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800708:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070d:	e9 c9 00 00 00       	jmp    8007db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800712:	8b 45 14             	mov    0x14(%ebp),%eax
  800715:	8b 00                	mov    (%eax),%eax
  800717:	ba 00 00 00 00       	mov    $0x0,%edx
  80071c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071f:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800722:	8b 45 14             	mov    0x14(%ebp),%eax
  800725:	8d 40 04             	lea    0x4(%eax),%eax
  800728:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800730:	e9 a6 00 00 00       	jmp    8007db <vprintfmt+0x428>
			putch('0', putdat);
  800735:	83 ec 08             	sub    $0x8,%esp
  800738:	53                   	push   %ebx
  800739:	6a 30                	push   $0x30
  80073b:	ff d6                	call   *%esi
	if (lflag >= 2)
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800744:	7f 26                	jg     80076c <vprintfmt+0x3b9>
	else if (lflag)
  800746:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074a:	74 3e                	je     80078a <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80074c:	8b 45 14             	mov    0x14(%ebp),%eax
  80074f:	8b 00                	mov    (%eax),%eax
  800751:	ba 00 00 00 00       	mov    $0x0,%edx
  800756:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800759:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8d 40 04             	lea    0x4(%eax),%eax
  800762:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800765:	b8 08 00 00 00       	mov    $0x8,%eax
  80076a:	eb 6f                	jmp    8007db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8b 50 04             	mov    0x4(%eax),%edx
  800772:	8b 00                	mov    (%eax),%eax
  800774:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800777:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077a:	8b 45 14             	mov    0x14(%ebp),%eax
  80077d:	8d 40 08             	lea    0x8(%eax),%eax
  800780:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800783:	b8 08 00 00 00       	mov    $0x8,%eax
  800788:	eb 51                	jmp    8007db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	ba 00 00 00 00       	mov    $0x0,%edx
  800794:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800797:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8d 40 04             	lea    0x4(%eax),%eax
  8007a0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a3:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a8:	eb 31                	jmp    8007db <vprintfmt+0x428>
			putch('0', putdat);
  8007aa:	83 ec 08             	sub    $0x8,%esp
  8007ad:	53                   	push   %ebx
  8007ae:	6a 30                	push   $0x30
  8007b0:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b2:	83 c4 08             	add    $0x8,%esp
  8007b5:	53                   	push   %ebx
  8007b6:	6a 78                	push   $0x78
  8007b8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c7:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007ca:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 40 04             	lea    0x4(%eax),%eax
  8007d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007db:	83 ec 0c             	sub    $0xc,%esp
  8007de:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007e2:	52                   	push   %edx
  8007e3:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e6:	50                   	push   %eax
  8007e7:	ff 75 dc             	pushl  -0x24(%ebp)
  8007ea:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ed:	89 da                	mov    %ebx,%edx
  8007ef:	89 f0                	mov    %esi,%eax
  8007f1:	e8 a4 fa ff ff       	call   80029a <printnum>
			break;
  8007f6:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007f9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fc:	83 c7 01             	add    $0x1,%edi
  8007ff:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800803:	83 f8 25             	cmp    $0x25,%eax
  800806:	0f 84 be fb ff ff    	je     8003ca <vprintfmt+0x17>
			if (ch == '\0')
  80080c:	85 c0                	test   %eax,%eax
  80080e:	0f 84 28 01 00 00    	je     80093c <vprintfmt+0x589>
			putch(ch, putdat);
  800814:	83 ec 08             	sub    $0x8,%esp
  800817:	53                   	push   %ebx
  800818:	50                   	push   %eax
  800819:	ff d6                	call   *%esi
  80081b:	83 c4 10             	add    $0x10,%esp
  80081e:	eb dc                	jmp    8007fc <vprintfmt+0x449>
	if (lflag >= 2)
  800820:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800824:	7f 26                	jg     80084c <vprintfmt+0x499>
	else if (lflag)
  800826:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80082a:	74 41                	je     80086d <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	8b 00                	mov    (%eax),%eax
  800831:	ba 00 00 00 00       	mov    $0x0,%edx
  800836:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800839:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	8d 40 04             	lea    0x4(%eax),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800845:	b8 10 00 00 00       	mov    $0x10,%eax
  80084a:	eb 8f                	jmp    8007db <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	8b 50 04             	mov    0x4(%eax),%edx
  800852:	8b 00                	mov    (%eax),%eax
  800854:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800857:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	8d 40 08             	lea    0x8(%eax),%eax
  800860:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800863:	b8 10 00 00 00       	mov    $0x10,%eax
  800868:	e9 6e ff ff ff       	jmp    8007db <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8b 00                	mov    (%eax),%eax
  800872:	ba 00 00 00 00       	mov    $0x0,%edx
  800877:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087d:	8b 45 14             	mov    0x14(%ebp),%eax
  800880:	8d 40 04             	lea    0x4(%eax),%eax
  800883:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800886:	b8 10 00 00 00       	mov    $0x10,%eax
  80088b:	e9 4b ff ff ff       	jmp    8007db <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800890:	8b 45 14             	mov    0x14(%ebp),%eax
  800893:	83 c0 04             	add    $0x4,%eax
  800896:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	85 c0                	test   %eax,%eax
  8008a0:	74 14                	je     8008b6 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008a2:	8b 13                	mov    (%ebx),%edx
  8008a4:	83 fa 7f             	cmp    $0x7f,%edx
  8008a7:	7f 37                	jg     8008e0 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008a9:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008ae:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b1:	e9 43 ff ff ff       	jmp    8007f9 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008b6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bb:	bf c1 27 80 00       	mov    $0x8027c1,%edi
							putch(ch, putdat);
  8008c0:	83 ec 08             	sub    $0x8,%esp
  8008c3:	53                   	push   %ebx
  8008c4:	50                   	push   %eax
  8008c5:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c7:	83 c7 01             	add    $0x1,%edi
  8008ca:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
  8008d1:	85 c0                	test   %eax,%eax
  8008d3:	75 eb                	jne    8008c0 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008d8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008db:	e9 19 ff ff ff       	jmp    8007f9 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008e0:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008e2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e7:	bf f9 27 80 00       	mov    $0x8027f9,%edi
							putch(ch, putdat);
  8008ec:	83 ec 08             	sub    $0x8,%esp
  8008ef:	53                   	push   %ebx
  8008f0:	50                   	push   %eax
  8008f1:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f3:	83 c7 01             	add    $0x1,%edi
  8008f6:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	85 c0                	test   %eax,%eax
  8008ff:	75 eb                	jne    8008ec <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800901:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800904:	89 45 14             	mov    %eax,0x14(%ebp)
  800907:	e9 ed fe ff ff       	jmp    8007f9 <vprintfmt+0x446>
			putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	53                   	push   %ebx
  800910:	6a 25                	push   $0x25
  800912:	ff d6                	call   *%esi
			break;
  800914:	83 c4 10             	add    $0x10,%esp
  800917:	e9 dd fe ff ff       	jmp    8007f9 <vprintfmt+0x446>
			putch('%', putdat);
  80091c:	83 ec 08             	sub    $0x8,%esp
  80091f:	53                   	push   %ebx
  800920:	6a 25                	push   $0x25
  800922:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800924:	83 c4 10             	add    $0x10,%esp
  800927:	89 f8                	mov    %edi,%eax
  800929:	eb 03                	jmp    80092e <vprintfmt+0x57b>
  80092b:	83 e8 01             	sub    $0x1,%eax
  80092e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800932:	75 f7                	jne    80092b <vprintfmt+0x578>
  800934:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800937:	e9 bd fe ff ff       	jmp    8007f9 <vprintfmt+0x446>
}
  80093c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80093f:	5b                   	pop    %ebx
  800940:	5e                   	pop    %esi
  800941:	5f                   	pop    %edi
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    

00800944 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800944:	55                   	push   %ebp
  800945:	89 e5                	mov    %esp,%ebp
  800947:	83 ec 18             	sub    $0x18,%esp
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800950:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800953:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800957:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80095a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800961:	85 c0                	test   %eax,%eax
  800963:	74 26                	je     80098b <vsnprintf+0x47>
  800965:	85 d2                	test   %edx,%edx
  800967:	7e 22                	jle    80098b <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800969:	ff 75 14             	pushl  0x14(%ebp)
  80096c:	ff 75 10             	pushl  0x10(%ebp)
  80096f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800972:	50                   	push   %eax
  800973:	68 79 03 80 00       	push   $0x800379
  800978:	e8 36 fa ff ff       	call   8003b3 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80097d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800980:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800983:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800986:	83 c4 10             	add    $0x10,%esp
}
  800989:	c9                   	leave  
  80098a:	c3                   	ret    
		return -E_INVAL;
  80098b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800990:	eb f7                	jmp    800989 <vsnprintf+0x45>

00800992 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800992:	55                   	push   %ebp
  800993:	89 e5                	mov    %esp,%ebp
  800995:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800998:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099b:	50                   	push   %eax
  80099c:	ff 75 10             	pushl  0x10(%ebp)
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	ff 75 08             	pushl  0x8(%ebp)
  8009a5:	e8 9a ff ff ff       	call   800944 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009aa:	c9                   	leave  
  8009ab:	c3                   	ret    

008009ac <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009bb:	74 05                	je     8009c2 <strlen+0x16>
		n++;
  8009bd:	83 c0 01             	add    $0x1,%eax
  8009c0:	eb f5                	jmp    8009b7 <strlen+0xb>
	return n;
}
  8009c2:	5d                   	pop    %ebp
  8009c3:	c3                   	ret    

008009c4 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c4:	55                   	push   %ebp
  8009c5:	89 e5                	mov    %esp,%ebp
  8009c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ca:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d2:	39 c2                	cmp    %eax,%edx
  8009d4:	74 0d                	je     8009e3 <strnlen+0x1f>
  8009d6:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009da:	74 05                	je     8009e1 <strnlen+0x1d>
		n++;
  8009dc:	83 c2 01             	add    $0x1,%edx
  8009df:	eb f1                	jmp    8009d2 <strnlen+0xe>
  8009e1:	89 d0                	mov    %edx,%eax
	return n;
}
  8009e3:	5d                   	pop    %ebp
  8009e4:	c3                   	ret    

008009e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	53                   	push   %ebx
  8009e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f4:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009f8:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009fb:	83 c2 01             	add    $0x1,%edx
  8009fe:	84 c9                	test   %cl,%cl
  800a00:	75 f2                	jne    8009f4 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a02:	5b                   	pop    %ebx
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	53                   	push   %ebx
  800a09:	83 ec 10             	sub    $0x10,%esp
  800a0c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a0f:	53                   	push   %ebx
  800a10:	e8 97 ff ff ff       	call   8009ac <strlen>
  800a15:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	01 d8                	add    %ebx,%eax
  800a1d:	50                   	push   %eax
  800a1e:	e8 c2 ff ff ff       	call   8009e5 <strcpy>
	return dst;
}
  800a23:	89 d8                	mov    %ebx,%eax
  800a25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a28:	c9                   	leave  
  800a29:	c3                   	ret    

00800a2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	56                   	push   %esi
  800a2e:	53                   	push   %ebx
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a35:	89 c6                	mov    %eax,%esi
  800a37:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3a:	89 c2                	mov    %eax,%edx
  800a3c:	39 f2                	cmp    %esi,%edx
  800a3e:	74 11                	je     800a51 <strncpy+0x27>
		*dst++ = *src;
  800a40:	83 c2 01             	add    $0x1,%edx
  800a43:	0f b6 19             	movzbl (%ecx),%ebx
  800a46:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a49:	80 fb 01             	cmp    $0x1,%bl
  800a4c:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a4f:	eb eb                	jmp    800a3c <strncpy+0x12>
	}
	return ret;
}
  800a51:	5b                   	pop    %ebx
  800a52:	5e                   	pop    %esi
  800a53:	5d                   	pop    %ebp
  800a54:	c3                   	ret    

00800a55 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	56                   	push   %esi
  800a59:	53                   	push   %ebx
  800a5a:	8b 75 08             	mov    0x8(%ebp),%esi
  800a5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a60:	8b 55 10             	mov    0x10(%ebp),%edx
  800a63:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a65:	85 d2                	test   %edx,%edx
  800a67:	74 21                	je     800a8a <strlcpy+0x35>
  800a69:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a6d:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a6f:	39 c2                	cmp    %eax,%edx
  800a71:	74 14                	je     800a87 <strlcpy+0x32>
  800a73:	0f b6 19             	movzbl (%ecx),%ebx
  800a76:	84 db                	test   %bl,%bl
  800a78:	74 0b                	je     800a85 <strlcpy+0x30>
			*dst++ = *src++;
  800a7a:	83 c1 01             	add    $0x1,%ecx
  800a7d:	83 c2 01             	add    $0x1,%edx
  800a80:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a83:	eb ea                	jmp    800a6f <strlcpy+0x1a>
  800a85:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a87:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8a:	29 f0                	sub    %esi,%eax
}
  800a8c:	5b                   	pop    %ebx
  800a8d:	5e                   	pop    %esi
  800a8e:	5d                   	pop    %ebp
  800a8f:	c3                   	ret    

00800a90 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a99:	0f b6 01             	movzbl (%ecx),%eax
  800a9c:	84 c0                	test   %al,%al
  800a9e:	74 0c                	je     800aac <strcmp+0x1c>
  800aa0:	3a 02                	cmp    (%edx),%al
  800aa2:	75 08                	jne    800aac <strcmp+0x1c>
		p++, q++;
  800aa4:	83 c1 01             	add    $0x1,%ecx
  800aa7:	83 c2 01             	add    $0x1,%edx
  800aaa:	eb ed                	jmp    800a99 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aac:	0f b6 c0             	movzbl %al,%eax
  800aaf:	0f b6 12             	movzbl (%edx),%edx
  800ab2:	29 d0                	sub    %edx,%eax
}
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	53                   	push   %ebx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac0:	89 c3                	mov    %eax,%ebx
  800ac2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac5:	eb 06                	jmp    800acd <strncmp+0x17>
		n--, p++, q++;
  800ac7:	83 c0 01             	add    $0x1,%eax
  800aca:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800acd:	39 d8                	cmp    %ebx,%eax
  800acf:	74 16                	je     800ae7 <strncmp+0x31>
  800ad1:	0f b6 08             	movzbl (%eax),%ecx
  800ad4:	84 c9                	test   %cl,%cl
  800ad6:	74 04                	je     800adc <strncmp+0x26>
  800ad8:	3a 0a                	cmp    (%edx),%cl
  800ada:	74 eb                	je     800ac7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800adc:	0f b6 00             	movzbl (%eax),%eax
  800adf:	0f b6 12             	movzbl (%edx),%edx
  800ae2:	29 d0                	sub    %edx,%eax
}
  800ae4:	5b                   	pop    %ebx
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    
		return 0;
  800ae7:	b8 00 00 00 00       	mov    $0x0,%eax
  800aec:	eb f6                	jmp    800ae4 <strncmp+0x2e>

00800aee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800af8:	0f b6 10             	movzbl (%eax),%edx
  800afb:	84 d2                	test   %dl,%dl
  800afd:	74 09                	je     800b08 <strchr+0x1a>
		if (*s == c)
  800aff:	38 ca                	cmp    %cl,%dl
  800b01:	74 0a                	je     800b0d <strchr+0x1f>
	for (; *s; s++)
  800b03:	83 c0 01             	add    $0x1,%eax
  800b06:	eb f0                	jmp    800af8 <strchr+0xa>
			return (char *) s;
	return 0;
  800b08:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	8b 45 08             	mov    0x8(%ebp),%eax
  800b15:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b19:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b1c:	38 ca                	cmp    %cl,%dl
  800b1e:	74 09                	je     800b29 <strfind+0x1a>
  800b20:	84 d2                	test   %dl,%dl
  800b22:	74 05                	je     800b29 <strfind+0x1a>
	for (; *s; s++)
  800b24:	83 c0 01             	add    $0x1,%eax
  800b27:	eb f0                	jmp    800b19 <strfind+0xa>
			break;
	return (char *) s;
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	57                   	push   %edi
  800b2f:	56                   	push   %esi
  800b30:	53                   	push   %ebx
  800b31:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b34:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b37:	85 c9                	test   %ecx,%ecx
  800b39:	74 31                	je     800b6c <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b3b:	89 f8                	mov    %edi,%eax
  800b3d:	09 c8                	or     %ecx,%eax
  800b3f:	a8 03                	test   $0x3,%al
  800b41:	75 23                	jne    800b66 <memset+0x3b>
		c &= 0xFF;
  800b43:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b47:	89 d3                	mov    %edx,%ebx
  800b49:	c1 e3 08             	shl    $0x8,%ebx
  800b4c:	89 d0                	mov    %edx,%eax
  800b4e:	c1 e0 18             	shl    $0x18,%eax
  800b51:	89 d6                	mov    %edx,%esi
  800b53:	c1 e6 10             	shl    $0x10,%esi
  800b56:	09 f0                	or     %esi,%eax
  800b58:	09 c2                	or     %eax,%edx
  800b5a:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b5c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b5f:	89 d0                	mov    %edx,%eax
  800b61:	fc                   	cld    
  800b62:	f3 ab                	rep stos %eax,%es:(%edi)
  800b64:	eb 06                	jmp    800b6c <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	fc                   	cld    
  800b6a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b6c:	89 f8                	mov    %edi,%eax
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5f                   	pop    %edi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    

00800b73 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b73:	55                   	push   %ebp
  800b74:	89 e5                	mov    %esp,%ebp
  800b76:	57                   	push   %edi
  800b77:	56                   	push   %esi
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b7e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b81:	39 c6                	cmp    %eax,%esi
  800b83:	73 32                	jae    800bb7 <memmove+0x44>
  800b85:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b88:	39 c2                	cmp    %eax,%edx
  800b8a:	76 2b                	jbe    800bb7 <memmove+0x44>
		s += n;
		d += n;
  800b8c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8f:	89 fe                	mov    %edi,%esi
  800b91:	09 ce                	or     %ecx,%esi
  800b93:	09 d6                	or     %edx,%esi
  800b95:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9b:	75 0e                	jne    800bab <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b9d:	83 ef 04             	sub    $0x4,%edi
  800ba0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ba6:	fd                   	std    
  800ba7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ba9:	eb 09                	jmp    800bb4 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bab:	83 ef 01             	sub    $0x1,%edi
  800bae:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb1:	fd                   	std    
  800bb2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb4:	fc                   	cld    
  800bb5:	eb 1a                	jmp    800bd1 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb7:	89 c2                	mov    %eax,%edx
  800bb9:	09 ca                	or     %ecx,%edx
  800bbb:	09 f2                	or     %esi,%edx
  800bbd:	f6 c2 03             	test   $0x3,%dl
  800bc0:	75 0a                	jne    800bcc <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bc2:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bc5:	89 c7                	mov    %eax,%edi
  800bc7:	fc                   	cld    
  800bc8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bca:	eb 05                	jmp    800bd1 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bcc:	89 c7                	mov    %eax,%edi
  800bce:	fc                   	cld    
  800bcf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd1:	5e                   	pop    %esi
  800bd2:	5f                   	pop    %edi
  800bd3:	5d                   	pop    %ebp
  800bd4:	c3                   	ret    

00800bd5 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd5:	55                   	push   %ebp
  800bd6:	89 e5                	mov    %esp,%ebp
  800bd8:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bdb:	ff 75 10             	pushl  0x10(%ebp)
  800bde:	ff 75 0c             	pushl  0xc(%ebp)
  800be1:	ff 75 08             	pushl  0x8(%ebp)
  800be4:	e8 8a ff ff ff       	call   800b73 <memmove>
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	56                   	push   %esi
  800bef:	53                   	push   %ebx
  800bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf6:	89 c6                	mov    %eax,%esi
  800bf8:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bfb:	39 f0                	cmp    %esi,%eax
  800bfd:	74 1c                	je     800c1b <memcmp+0x30>
		if (*s1 != *s2)
  800bff:	0f b6 08             	movzbl (%eax),%ecx
  800c02:	0f b6 1a             	movzbl (%edx),%ebx
  800c05:	38 d9                	cmp    %bl,%cl
  800c07:	75 08                	jne    800c11 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c09:	83 c0 01             	add    $0x1,%eax
  800c0c:	83 c2 01             	add    $0x1,%edx
  800c0f:	eb ea                	jmp    800bfb <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c11:	0f b6 c1             	movzbl %cl,%eax
  800c14:	0f b6 db             	movzbl %bl,%ebx
  800c17:	29 d8                	sub    %ebx,%eax
  800c19:	eb 05                	jmp    800c20 <memcmp+0x35>
	}

	return 0;
  800c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c20:	5b                   	pop    %ebx
  800c21:	5e                   	pop    %esi
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    

00800c24 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c2d:	89 c2                	mov    %eax,%edx
  800c2f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c32:	39 d0                	cmp    %edx,%eax
  800c34:	73 09                	jae    800c3f <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c36:	38 08                	cmp    %cl,(%eax)
  800c38:	74 05                	je     800c3f <memfind+0x1b>
	for (; s < ends; s++)
  800c3a:	83 c0 01             	add    $0x1,%eax
  800c3d:	eb f3                	jmp    800c32 <memfind+0xe>
			break;
	return (void *) s;
}
  800c3f:	5d                   	pop    %ebp
  800c40:	c3                   	ret    

00800c41 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c41:	55                   	push   %ebp
  800c42:	89 e5                	mov    %esp,%ebp
  800c44:	57                   	push   %edi
  800c45:	56                   	push   %esi
  800c46:	53                   	push   %ebx
  800c47:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4d:	eb 03                	jmp    800c52 <strtol+0x11>
		s++;
  800c4f:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c52:	0f b6 01             	movzbl (%ecx),%eax
  800c55:	3c 20                	cmp    $0x20,%al
  800c57:	74 f6                	je     800c4f <strtol+0xe>
  800c59:	3c 09                	cmp    $0x9,%al
  800c5b:	74 f2                	je     800c4f <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c5d:	3c 2b                	cmp    $0x2b,%al
  800c5f:	74 2a                	je     800c8b <strtol+0x4a>
	int neg = 0;
  800c61:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c66:	3c 2d                	cmp    $0x2d,%al
  800c68:	74 2b                	je     800c95 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6a:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c70:	75 0f                	jne    800c81 <strtol+0x40>
  800c72:	80 39 30             	cmpb   $0x30,(%ecx)
  800c75:	74 28                	je     800c9f <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c77:	85 db                	test   %ebx,%ebx
  800c79:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c7e:	0f 44 d8             	cmove  %eax,%ebx
  800c81:	b8 00 00 00 00       	mov    $0x0,%eax
  800c86:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c89:	eb 50                	jmp    800cdb <strtol+0x9a>
		s++;
  800c8b:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c8e:	bf 00 00 00 00       	mov    $0x0,%edi
  800c93:	eb d5                	jmp    800c6a <strtol+0x29>
		s++, neg = 1;
  800c95:	83 c1 01             	add    $0x1,%ecx
  800c98:	bf 01 00 00 00       	mov    $0x1,%edi
  800c9d:	eb cb                	jmp    800c6a <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ca3:	74 0e                	je     800cb3 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ca5:	85 db                	test   %ebx,%ebx
  800ca7:	75 d8                	jne    800c81 <strtol+0x40>
		s++, base = 8;
  800ca9:	83 c1 01             	add    $0x1,%ecx
  800cac:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cb1:	eb ce                	jmp    800c81 <strtol+0x40>
		s += 2, base = 16;
  800cb3:	83 c1 02             	add    $0x2,%ecx
  800cb6:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cbb:	eb c4                	jmp    800c81 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cbd:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cc0:	89 f3                	mov    %esi,%ebx
  800cc2:	80 fb 19             	cmp    $0x19,%bl
  800cc5:	77 29                	ja     800cf0 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cc7:	0f be d2             	movsbl %dl,%edx
  800cca:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ccd:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cd0:	7d 30                	jge    800d02 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cd2:	83 c1 01             	add    $0x1,%ecx
  800cd5:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cd9:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cdb:	0f b6 11             	movzbl (%ecx),%edx
  800cde:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ce1:	89 f3                	mov    %esi,%ebx
  800ce3:	80 fb 09             	cmp    $0x9,%bl
  800ce6:	77 d5                	ja     800cbd <strtol+0x7c>
			dig = *s - '0';
  800ce8:	0f be d2             	movsbl %dl,%edx
  800ceb:	83 ea 30             	sub    $0x30,%edx
  800cee:	eb dd                	jmp    800ccd <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cf0:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cf3:	89 f3                	mov    %esi,%ebx
  800cf5:	80 fb 19             	cmp    $0x19,%bl
  800cf8:	77 08                	ja     800d02 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cfa:	0f be d2             	movsbl %dl,%edx
  800cfd:	83 ea 37             	sub    $0x37,%edx
  800d00:	eb cb                	jmp    800ccd <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d06:	74 05                	je     800d0d <strtol+0xcc>
		*endptr = (char *) s;
  800d08:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d0d:	89 c2                	mov    %eax,%edx
  800d0f:	f7 da                	neg    %edx
  800d11:	85 ff                	test   %edi,%edi
  800d13:	0f 45 c2             	cmovne %edx,%eax
}
  800d16:	5b                   	pop    %ebx
  800d17:	5e                   	pop    %esi
  800d18:	5f                   	pop    %edi
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	8b 55 08             	mov    0x8(%ebp),%edx
  800d29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2c:	89 c3                	mov    %eax,%ebx
  800d2e:	89 c7                	mov    %eax,%edi
  800d30:	89 c6                	mov    %eax,%esi
  800d32:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d34:	5b                   	pop    %ebx
  800d35:	5e                   	pop    %esi
  800d36:	5f                   	pop    %edi
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <sys_cgetc>:

int
sys_cgetc(void)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	57                   	push   %edi
  800d3d:	56                   	push   %esi
  800d3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d3f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d44:	b8 01 00 00 00       	mov    $0x1,%eax
  800d49:	89 d1                	mov    %edx,%ecx
  800d4b:	89 d3                	mov    %edx,%ebx
  800d4d:	89 d7                	mov    %edx,%edi
  800d4f:	89 d6                	mov    %edx,%esi
  800d51:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d53:	5b                   	pop    %ebx
  800d54:	5e                   	pop    %esi
  800d55:	5f                   	pop    %edi
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	57                   	push   %edi
  800d5c:	56                   	push   %esi
  800d5d:	53                   	push   %ebx
  800d5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d66:	8b 55 08             	mov    0x8(%ebp),%edx
  800d69:	b8 03 00 00 00       	mov    $0x3,%eax
  800d6e:	89 cb                	mov    %ecx,%ebx
  800d70:	89 cf                	mov    %ecx,%edi
  800d72:	89 ce                	mov    %ecx,%esi
  800d74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d76:	85 c0                	test   %eax,%eax
  800d78:	7f 08                	jg     800d82 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7d:	5b                   	pop    %ebx
  800d7e:	5e                   	pop    %esi
  800d7f:	5f                   	pop    %edi
  800d80:	5d                   	pop    %ebp
  800d81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d82:	83 ec 0c             	sub    $0xc,%esp
  800d85:	50                   	push   %eax
  800d86:	6a 03                	push   $0x3
  800d88:	68 08 2a 80 00       	push   $0x802a08
  800d8d:	6a 43                	push   $0x43
  800d8f:	68 25 2a 80 00       	push   $0x802a25
  800d94:	e8 89 14 00 00       	call   802222 <_panic>

00800d99 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	57                   	push   %edi
  800d9d:	56                   	push   %esi
  800d9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d9f:	ba 00 00 00 00       	mov    $0x0,%edx
  800da4:	b8 02 00 00 00       	mov    $0x2,%eax
  800da9:	89 d1                	mov    %edx,%ecx
  800dab:	89 d3                	mov    %edx,%ebx
  800dad:	89 d7                	mov    %edx,%edi
  800daf:	89 d6                	mov    %edx,%esi
  800db1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800db3:	5b                   	pop    %ebx
  800db4:	5e                   	pop    %esi
  800db5:	5f                   	pop    %edi
  800db6:	5d                   	pop    %ebp
  800db7:	c3                   	ret    

00800db8 <sys_yield>:

void
sys_yield(void)
{
  800db8:	55                   	push   %ebp
  800db9:	89 e5                	mov    %esp,%ebp
  800dbb:	57                   	push   %edi
  800dbc:	56                   	push   %esi
  800dbd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc3:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dc8:	89 d1                	mov    %edx,%ecx
  800dca:	89 d3                	mov    %edx,%ebx
  800dcc:	89 d7                	mov    %edx,%edi
  800dce:	89 d6                	mov    %edx,%esi
  800dd0:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd2:	5b                   	pop    %ebx
  800dd3:	5e                   	pop    %esi
  800dd4:	5f                   	pop    %edi
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	57                   	push   %edi
  800ddb:	56                   	push   %esi
  800ddc:	53                   	push   %ebx
  800ddd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de0:	be 00 00 00 00       	mov    $0x0,%esi
  800de5:	8b 55 08             	mov    0x8(%ebp),%edx
  800de8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800deb:	b8 04 00 00 00       	mov    $0x4,%eax
  800df0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df3:	89 f7                	mov    %esi,%edi
  800df5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df7:	85 c0                	test   %eax,%eax
  800df9:	7f 08                	jg     800e03 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dfe:	5b                   	pop    %ebx
  800dff:	5e                   	pop    %esi
  800e00:	5f                   	pop    %edi
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e03:	83 ec 0c             	sub    $0xc,%esp
  800e06:	50                   	push   %eax
  800e07:	6a 04                	push   $0x4
  800e09:	68 08 2a 80 00       	push   $0x802a08
  800e0e:	6a 43                	push   $0x43
  800e10:	68 25 2a 80 00       	push   $0x802a25
  800e15:	e8 08 14 00 00       	call   802222 <_panic>

00800e1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1a:	55                   	push   %ebp
  800e1b:	89 e5                	mov    %esp,%ebp
  800e1d:	57                   	push   %edi
  800e1e:	56                   	push   %esi
  800e1f:	53                   	push   %ebx
  800e20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e23:	8b 55 08             	mov    0x8(%ebp),%edx
  800e26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e29:	b8 05 00 00 00       	mov    $0x5,%eax
  800e2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e34:	8b 75 18             	mov    0x18(%ebp),%esi
  800e37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	7f 08                	jg     800e45 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e40:	5b                   	pop    %ebx
  800e41:	5e                   	pop    %esi
  800e42:	5f                   	pop    %edi
  800e43:	5d                   	pop    %ebp
  800e44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e45:	83 ec 0c             	sub    $0xc,%esp
  800e48:	50                   	push   %eax
  800e49:	6a 05                	push   $0x5
  800e4b:	68 08 2a 80 00       	push   $0x802a08
  800e50:	6a 43                	push   $0x43
  800e52:	68 25 2a 80 00       	push   $0x802a25
  800e57:	e8 c6 13 00 00       	call   802222 <_panic>

00800e5c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e5c:	55                   	push   %ebp
  800e5d:	89 e5                	mov    %esp,%ebp
  800e5f:	57                   	push   %edi
  800e60:	56                   	push   %esi
  800e61:	53                   	push   %ebx
  800e62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	b8 06 00 00 00       	mov    $0x6,%eax
  800e75:	89 df                	mov    %ebx,%edi
  800e77:	89 de                	mov    %ebx,%esi
  800e79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	7f 08                	jg     800e87 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e82:	5b                   	pop    %ebx
  800e83:	5e                   	pop    %esi
  800e84:	5f                   	pop    %edi
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e87:	83 ec 0c             	sub    $0xc,%esp
  800e8a:	50                   	push   %eax
  800e8b:	6a 06                	push   $0x6
  800e8d:	68 08 2a 80 00       	push   $0x802a08
  800e92:	6a 43                	push   $0x43
  800e94:	68 25 2a 80 00       	push   $0x802a25
  800e99:	e8 84 13 00 00       	call   802222 <_panic>

00800e9e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e9e:	55                   	push   %ebp
  800e9f:	89 e5                	mov    %esp,%ebp
  800ea1:	57                   	push   %edi
  800ea2:	56                   	push   %esi
  800ea3:	53                   	push   %ebx
  800ea4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb7:	89 df                	mov    %ebx,%edi
  800eb9:	89 de                	mov    %ebx,%esi
  800ebb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebd:	85 c0                	test   %eax,%eax
  800ebf:	7f 08                	jg     800ec9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec9:	83 ec 0c             	sub    $0xc,%esp
  800ecc:	50                   	push   %eax
  800ecd:	6a 08                	push   $0x8
  800ecf:	68 08 2a 80 00       	push   $0x802a08
  800ed4:	6a 43                	push   $0x43
  800ed6:	68 25 2a 80 00       	push   $0x802a25
  800edb:	e8 42 13 00 00       	call   802222 <_panic>

00800ee0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	57                   	push   %edi
  800ee4:	56                   	push   %esi
  800ee5:	53                   	push   %ebx
  800ee6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eee:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef4:	b8 09 00 00 00       	mov    $0x9,%eax
  800ef9:	89 df                	mov    %ebx,%edi
  800efb:	89 de                	mov    %ebx,%esi
  800efd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7f 08                	jg     800f0b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800f0f:	6a 09                	push   $0x9
  800f11:	68 08 2a 80 00       	push   $0x802a08
  800f16:	6a 43                	push   $0x43
  800f18:	68 25 2a 80 00       	push   $0x802a25
  800f1d:	e8 00 13 00 00       	call   802222 <_panic>

00800f22 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f22:	55                   	push   %ebp
  800f23:	89 e5                	mov    %esp,%ebp
  800f25:	57                   	push   %edi
  800f26:	56                   	push   %esi
  800f27:	53                   	push   %ebx
  800f28:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f30:	8b 55 08             	mov    0x8(%ebp),%edx
  800f33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f36:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3b:	89 df                	mov    %ebx,%edi
  800f3d:	89 de                	mov    %ebx,%esi
  800f3f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f41:	85 c0                	test   %eax,%eax
  800f43:	7f 08                	jg     800f4d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f48:	5b                   	pop    %ebx
  800f49:	5e                   	pop    %esi
  800f4a:	5f                   	pop    %edi
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4d:	83 ec 0c             	sub    $0xc,%esp
  800f50:	50                   	push   %eax
  800f51:	6a 0a                	push   $0xa
  800f53:	68 08 2a 80 00       	push   $0x802a08
  800f58:	6a 43                	push   $0x43
  800f5a:	68 25 2a 80 00       	push   $0x802a25
  800f5f:	e8 be 12 00 00       	call   802222 <_panic>

00800f64 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	57                   	push   %edi
  800f68:	56                   	push   %esi
  800f69:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f70:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f75:	be 00 00 00 00       	mov    $0x0,%esi
  800f7a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f80:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    

00800f87 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f87:	55                   	push   %ebp
  800f88:	89 e5                	mov    %esp,%ebp
  800f8a:	57                   	push   %edi
  800f8b:	56                   	push   %esi
  800f8c:	53                   	push   %ebx
  800f8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f90:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f95:	8b 55 08             	mov    0x8(%ebp),%edx
  800f98:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f9d:	89 cb                	mov    %ecx,%ebx
  800f9f:	89 cf                	mov    %ecx,%edi
  800fa1:	89 ce                	mov    %ecx,%esi
  800fa3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	7f 08                	jg     800fb1 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fac:	5b                   	pop    %ebx
  800fad:	5e                   	pop    %esi
  800fae:	5f                   	pop    %edi
  800faf:	5d                   	pop    %ebp
  800fb0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb1:	83 ec 0c             	sub    $0xc,%esp
  800fb4:	50                   	push   %eax
  800fb5:	6a 0d                	push   $0xd
  800fb7:	68 08 2a 80 00       	push   $0x802a08
  800fbc:	6a 43                	push   $0x43
  800fbe:	68 25 2a 80 00       	push   $0x802a25
  800fc3:	e8 5a 12 00 00       	call   802222 <_panic>

00800fc8 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	57                   	push   %edi
  800fcc:	56                   	push   %esi
  800fcd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fce:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fde:	89 df                	mov    %ebx,%edi
  800fe0:	89 de                	mov    %ebx,%esi
  800fe2:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fe4:	5b                   	pop    %ebx
  800fe5:	5e                   	pop    %esi
  800fe6:	5f                   	pop    %edi
  800fe7:	5d                   	pop    %ebp
  800fe8:	c3                   	ret    

00800fe9 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800fe9:	55                   	push   %ebp
  800fea:	89 e5                	mov    %esp,%ebp
  800fec:	57                   	push   %edi
  800fed:	56                   	push   %esi
  800fee:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fef:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ffc:	89 cb                	mov    %ecx,%ebx
  800ffe:	89 cf                	mov    %ecx,%edi
  801000:	89 ce                	mov    %ecx,%esi
  801002:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5f                   	pop    %edi
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80100f:	ba 00 00 00 00       	mov    $0x0,%edx
  801014:	b8 10 00 00 00       	mov    $0x10,%eax
  801019:	89 d1                	mov    %edx,%ecx
  80101b:	89 d3                	mov    %edx,%ebx
  80101d:	89 d7                	mov    %edx,%edi
  80101f:	89 d6                	mov    %edx,%esi
  801021:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801023:	5b                   	pop    %ebx
  801024:	5e                   	pop    %esi
  801025:	5f                   	pop    %edi
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	57                   	push   %edi
  80102c:	56                   	push   %esi
  80102d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80102e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801033:	8b 55 08             	mov    0x8(%ebp),%edx
  801036:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801039:	b8 11 00 00 00       	mov    $0x11,%eax
  80103e:	89 df                	mov    %ebx,%edi
  801040:	89 de                	mov    %ebx,%esi
  801042:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801044:	5b                   	pop    %ebx
  801045:	5e                   	pop    %esi
  801046:	5f                   	pop    %edi
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	57                   	push   %edi
  80104d:	56                   	push   %esi
  80104e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80104f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801054:	8b 55 08             	mov    0x8(%ebp),%edx
  801057:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105a:	b8 12 00 00 00       	mov    $0x12,%eax
  80105f:	89 df                	mov    %ebx,%edi
  801061:	89 de                	mov    %ebx,%esi
  801063:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801065:	5b                   	pop    %ebx
  801066:	5e                   	pop    %esi
  801067:	5f                   	pop    %edi
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	57                   	push   %edi
  80106e:	56                   	push   %esi
  80106f:	53                   	push   %ebx
  801070:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801073:	bb 00 00 00 00       	mov    $0x0,%ebx
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107e:	b8 13 00 00 00       	mov    $0x13,%eax
  801083:	89 df                	mov    %ebx,%edi
  801085:	89 de                	mov    %ebx,%esi
  801087:	cd 30                	int    $0x30
	if(check && ret > 0)
  801089:	85 c0                	test   %eax,%eax
  80108b:	7f 08                	jg     801095 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80108d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801095:	83 ec 0c             	sub    $0xc,%esp
  801098:	50                   	push   %eax
  801099:	6a 13                	push   $0x13
  80109b:	68 08 2a 80 00       	push   $0x802a08
  8010a0:	6a 43                	push   $0x43
  8010a2:	68 25 2a 80 00       	push   $0x802a25
  8010a7:	e8 76 11 00 00       	call   802222 <_panic>

008010ac <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
  8010af:	57                   	push   %edi
  8010b0:	56                   	push   %esi
  8010b1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ba:	b8 14 00 00 00       	mov    $0x14,%eax
  8010bf:	89 cb                	mov    %ecx,%ebx
  8010c1:	89 cf                	mov    %ecx,%edi
  8010c3:	89 ce                	mov    %ecx,%esi
  8010c5:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010c7:	5b                   	pop    %ebx
  8010c8:	5e                   	pop    %esi
  8010c9:	5f                   	pop    %edi
  8010ca:	5d                   	pop    %ebp
  8010cb:	c3                   	ret    

008010cc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010cc:	55                   	push   %ebp
  8010cd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	05 00 00 00 30       	add    $0x30000000,%eax
  8010d7:	c1 e8 0c             	shr    $0xc,%eax
}
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010df:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010ec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010f1:	5d                   	pop    %ebp
  8010f2:	c3                   	ret    

008010f3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010f3:	55                   	push   %ebp
  8010f4:	89 e5                	mov    %esp,%ebp
  8010f6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010fb:	89 c2                	mov    %eax,%edx
  8010fd:	c1 ea 16             	shr    $0x16,%edx
  801100:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801107:	f6 c2 01             	test   $0x1,%dl
  80110a:	74 2d                	je     801139 <fd_alloc+0x46>
  80110c:	89 c2                	mov    %eax,%edx
  80110e:	c1 ea 0c             	shr    $0xc,%edx
  801111:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801118:	f6 c2 01             	test   $0x1,%dl
  80111b:	74 1c                	je     801139 <fd_alloc+0x46>
  80111d:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801122:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801127:	75 d2                	jne    8010fb <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801132:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801137:	eb 0a                	jmp    801143 <fd_alloc+0x50>
			*fd_store = fd;
  801139:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80113e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80114b:	83 f8 1f             	cmp    $0x1f,%eax
  80114e:	77 30                	ja     801180 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801150:	c1 e0 0c             	shl    $0xc,%eax
  801153:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801158:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80115e:	f6 c2 01             	test   $0x1,%dl
  801161:	74 24                	je     801187 <fd_lookup+0x42>
  801163:	89 c2                	mov    %eax,%edx
  801165:	c1 ea 0c             	shr    $0xc,%edx
  801168:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80116f:	f6 c2 01             	test   $0x1,%dl
  801172:	74 1a                	je     80118e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801174:	8b 55 0c             	mov    0xc(%ebp),%edx
  801177:	89 02                	mov    %eax,(%edx)
	return 0;
  801179:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    
		return -E_INVAL;
  801180:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801185:	eb f7                	jmp    80117e <fd_lookup+0x39>
		return -E_INVAL;
  801187:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118c:	eb f0                	jmp    80117e <fd_lookup+0x39>
  80118e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801193:	eb e9                	jmp    80117e <fd_lookup+0x39>

00801195 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80119e:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a3:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011a8:	39 08                	cmp    %ecx,(%eax)
  8011aa:	74 38                	je     8011e4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011ac:	83 c2 01             	add    $0x1,%edx
  8011af:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	75 ee                	jne    8011a8 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011ba:	a1 08 40 80 00       	mov    0x804008,%eax
  8011bf:	8b 40 48             	mov    0x48(%eax),%eax
  8011c2:	83 ec 04             	sub    $0x4,%esp
  8011c5:	51                   	push   %ecx
  8011c6:	50                   	push   %eax
  8011c7:	68 34 2a 80 00       	push   $0x802a34
  8011cc:	e8 b5 f0 ff ff       	call   800286 <cprintf>
	*dev = 0;
  8011d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011da:	83 c4 10             	add    $0x10,%esp
  8011dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    
			*dev = devtab[i];
  8011e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ee:	eb f2                	jmp    8011e2 <dev_lookup+0x4d>

008011f0 <fd_close>:
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	57                   	push   %edi
  8011f4:	56                   	push   %esi
  8011f5:	53                   	push   %ebx
  8011f6:	83 ec 24             	sub    $0x24,%esp
  8011f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801202:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801203:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801209:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80120c:	50                   	push   %eax
  80120d:	e8 33 ff ff ff       	call   801145 <fd_lookup>
  801212:	89 c3                	mov    %eax,%ebx
  801214:	83 c4 10             	add    $0x10,%esp
  801217:	85 c0                	test   %eax,%eax
  801219:	78 05                	js     801220 <fd_close+0x30>
	    || fd != fd2)
  80121b:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80121e:	74 16                	je     801236 <fd_close+0x46>
		return (must_exist ? r : 0);
  801220:	89 f8                	mov    %edi,%eax
  801222:	84 c0                	test   %al,%al
  801224:	b8 00 00 00 00       	mov    $0x0,%eax
  801229:	0f 44 d8             	cmove  %eax,%ebx
}
  80122c:	89 d8                	mov    %ebx,%eax
  80122e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801231:	5b                   	pop    %ebx
  801232:	5e                   	pop    %esi
  801233:	5f                   	pop    %edi
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801236:	83 ec 08             	sub    $0x8,%esp
  801239:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80123c:	50                   	push   %eax
  80123d:	ff 36                	pushl  (%esi)
  80123f:	e8 51 ff ff ff       	call   801195 <dev_lookup>
  801244:	89 c3                	mov    %eax,%ebx
  801246:	83 c4 10             	add    $0x10,%esp
  801249:	85 c0                	test   %eax,%eax
  80124b:	78 1a                	js     801267 <fd_close+0x77>
		if (dev->dev_close)
  80124d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801250:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801253:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801258:	85 c0                	test   %eax,%eax
  80125a:	74 0b                	je     801267 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80125c:	83 ec 0c             	sub    $0xc,%esp
  80125f:	56                   	push   %esi
  801260:	ff d0                	call   *%eax
  801262:	89 c3                	mov    %eax,%ebx
  801264:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801267:	83 ec 08             	sub    $0x8,%esp
  80126a:	56                   	push   %esi
  80126b:	6a 00                	push   $0x0
  80126d:	e8 ea fb ff ff       	call   800e5c <sys_page_unmap>
	return r;
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	eb b5                	jmp    80122c <fd_close+0x3c>

00801277 <close>:

int
close(int fdnum)
{
  801277:	55                   	push   %ebp
  801278:	89 e5                	mov    %esp,%ebp
  80127a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801280:	50                   	push   %eax
  801281:	ff 75 08             	pushl  0x8(%ebp)
  801284:	e8 bc fe ff ff       	call   801145 <fd_lookup>
  801289:	83 c4 10             	add    $0x10,%esp
  80128c:	85 c0                	test   %eax,%eax
  80128e:	79 02                	jns    801292 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801290:	c9                   	leave  
  801291:	c3                   	ret    
		return fd_close(fd, 1);
  801292:	83 ec 08             	sub    $0x8,%esp
  801295:	6a 01                	push   $0x1
  801297:	ff 75 f4             	pushl  -0xc(%ebp)
  80129a:	e8 51 ff ff ff       	call   8011f0 <fd_close>
  80129f:	83 c4 10             	add    $0x10,%esp
  8012a2:	eb ec                	jmp    801290 <close+0x19>

008012a4 <close_all>:

void
close_all(void)
{
  8012a4:	55                   	push   %ebp
  8012a5:	89 e5                	mov    %esp,%ebp
  8012a7:	53                   	push   %ebx
  8012a8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ab:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012b0:	83 ec 0c             	sub    $0xc,%esp
  8012b3:	53                   	push   %ebx
  8012b4:	e8 be ff ff ff       	call   801277 <close>
	for (i = 0; i < MAXFD; i++)
  8012b9:	83 c3 01             	add    $0x1,%ebx
  8012bc:	83 c4 10             	add    $0x10,%esp
  8012bf:	83 fb 20             	cmp    $0x20,%ebx
  8012c2:	75 ec                	jne    8012b0 <close_all+0xc>
}
  8012c4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c7:	c9                   	leave  
  8012c8:	c3                   	ret    

008012c9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	57                   	push   %edi
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
  8012cf:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012d2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d5:	50                   	push   %eax
  8012d6:	ff 75 08             	pushl  0x8(%ebp)
  8012d9:	e8 67 fe ff ff       	call   801145 <fd_lookup>
  8012de:	89 c3                	mov    %eax,%ebx
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	0f 88 81 00 00 00    	js     80136c <dup+0xa3>
		return r;
	close(newfdnum);
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	ff 75 0c             	pushl  0xc(%ebp)
  8012f1:	e8 81 ff ff ff       	call   801277 <close>

	newfd = INDEX2FD(newfdnum);
  8012f6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012f9:	c1 e6 0c             	shl    $0xc,%esi
  8012fc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801302:	83 c4 04             	add    $0x4,%esp
  801305:	ff 75 e4             	pushl  -0x1c(%ebp)
  801308:	e8 cf fd ff ff       	call   8010dc <fd2data>
  80130d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80130f:	89 34 24             	mov    %esi,(%esp)
  801312:	e8 c5 fd ff ff       	call   8010dc <fd2data>
  801317:	83 c4 10             	add    $0x10,%esp
  80131a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80131c:	89 d8                	mov    %ebx,%eax
  80131e:	c1 e8 16             	shr    $0x16,%eax
  801321:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801328:	a8 01                	test   $0x1,%al
  80132a:	74 11                	je     80133d <dup+0x74>
  80132c:	89 d8                	mov    %ebx,%eax
  80132e:	c1 e8 0c             	shr    $0xc,%eax
  801331:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801338:	f6 c2 01             	test   $0x1,%dl
  80133b:	75 39                	jne    801376 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80133d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801340:	89 d0                	mov    %edx,%eax
  801342:	c1 e8 0c             	shr    $0xc,%eax
  801345:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134c:	83 ec 0c             	sub    $0xc,%esp
  80134f:	25 07 0e 00 00       	and    $0xe07,%eax
  801354:	50                   	push   %eax
  801355:	56                   	push   %esi
  801356:	6a 00                	push   $0x0
  801358:	52                   	push   %edx
  801359:	6a 00                	push   $0x0
  80135b:	e8 ba fa ff ff       	call   800e1a <sys_page_map>
  801360:	89 c3                	mov    %eax,%ebx
  801362:	83 c4 20             	add    $0x20,%esp
  801365:	85 c0                	test   %eax,%eax
  801367:	78 31                	js     80139a <dup+0xd1>
		goto err;

	return newfdnum;
  801369:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80136c:	89 d8                	mov    %ebx,%eax
  80136e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801371:	5b                   	pop    %ebx
  801372:	5e                   	pop    %esi
  801373:	5f                   	pop    %edi
  801374:	5d                   	pop    %ebp
  801375:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801376:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80137d:	83 ec 0c             	sub    $0xc,%esp
  801380:	25 07 0e 00 00       	and    $0xe07,%eax
  801385:	50                   	push   %eax
  801386:	57                   	push   %edi
  801387:	6a 00                	push   $0x0
  801389:	53                   	push   %ebx
  80138a:	6a 00                	push   $0x0
  80138c:	e8 89 fa ff ff       	call   800e1a <sys_page_map>
  801391:	89 c3                	mov    %eax,%ebx
  801393:	83 c4 20             	add    $0x20,%esp
  801396:	85 c0                	test   %eax,%eax
  801398:	79 a3                	jns    80133d <dup+0x74>
	sys_page_unmap(0, newfd);
  80139a:	83 ec 08             	sub    $0x8,%esp
  80139d:	56                   	push   %esi
  80139e:	6a 00                	push   $0x0
  8013a0:	e8 b7 fa ff ff       	call   800e5c <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013a5:	83 c4 08             	add    $0x8,%esp
  8013a8:	57                   	push   %edi
  8013a9:	6a 00                	push   $0x0
  8013ab:	e8 ac fa ff ff       	call   800e5c <sys_page_unmap>
	return r;
  8013b0:	83 c4 10             	add    $0x10,%esp
  8013b3:	eb b7                	jmp    80136c <dup+0xa3>

008013b5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013b5:	55                   	push   %ebp
  8013b6:	89 e5                	mov    %esp,%ebp
  8013b8:	53                   	push   %ebx
  8013b9:	83 ec 1c             	sub    $0x1c,%esp
  8013bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c2:	50                   	push   %eax
  8013c3:	53                   	push   %ebx
  8013c4:	e8 7c fd ff ff       	call   801145 <fd_lookup>
  8013c9:	83 c4 10             	add    $0x10,%esp
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	78 3f                	js     80140f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d0:	83 ec 08             	sub    $0x8,%esp
  8013d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d6:	50                   	push   %eax
  8013d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013da:	ff 30                	pushl  (%eax)
  8013dc:	e8 b4 fd ff ff       	call   801195 <dev_lookup>
  8013e1:	83 c4 10             	add    $0x10,%esp
  8013e4:	85 c0                	test   %eax,%eax
  8013e6:	78 27                	js     80140f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013eb:	8b 42 08             	mov    0x8(%edx),%eax
  8013ee:	83 e0 03             	and    $0x3,%eax
  8013f1:	83 f8 01             	cmp    $0x1,%eax
  8013f4:	74 1e                	je     801414 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f9:	8b 40 08             	mov    0x8(%eax),%eax
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	74 35                	je     801435 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801400:	83 ec 04             	sub    $0x4,%esp
  801403:	ff 75 10             	pushl  0x10(%ebp)
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	52                   	push   %edx
  80140a:	ff d0                	call   *%eax
  80140c:	83 c4 10             	add    $0x10,%esp
}
  80140f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801412:	c9                   	leave  
  801413:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801414:	a1 08 40 80 00       	mov    0x804008,%eax
  801419:	8b 40 48             	mov    0x48(%eax),%eax
  80141c:	83 ec 04             	sub    $0x4,%esp
  80141f:	53                   	push   %ebx
  801420:	50                   	push   %eax
  801421:	68 75 2a 80 00       	push   $0x802a75
  801426:	e8 5b ee ff ff       	call   800286 <cprintf>
		return -E_INVAL;
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801433:	eb da                	jmp    80140f <read+0x5a>
		return -E_NOT_SUPP;
  801435:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143a:	eb d3                	jmp    80140f <read+0x5a>

0080143c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80143c:	55                   	push   %ebp
  80143d:	89 e5                	mov    %esp,%ebp
  80143f:	57                   	push   %edi
  801440:	56                   	push   %esi
  801441:	53                   	push   %ebx
  801442:	83 ec 0c             	sub    $0xc,%esp
  801445:	8b 7d 08             	mov    0x8(%ebp),%edi
  801448:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80144b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801450:	39 f3                	cmp    %esi,%ebx
  801452:	73 23                	jae    801477 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801454:	83 ec 04             	sub    $0x4,%esp
  801457:	89 f0                	mov    %esi,%eax
  801459:	29 d8                	sub    %ebx,%eax
  80145b:	50                   	push   %eax
  80145c:	89 d8                	mov    %ebx,%eax
  80145e:	03 45 0c             	add    0xc(%ebp),%eax
  801461:	50                   	push   %eax
  801462:	57                   	push   %edi
  801463:	e8 4d ff ff ff       	call   8013b5 <read>
		if (m < 0)
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	78 06                	js     801475 <readn+0x39>
			return m;
		if (m == 0)
  80146f:	74 06                	je     801477 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801471:	01 c3                	add    %eax,%ebx
  801473:	eb db                	jmp    801450 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801475:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801477:	89 d8                	mov    %ebx,%eax
  801479:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147c:	5b                   	pop    %ebx
  80147d:	5e                   	pop    %esi
  80147e:	5f                   	pop    %edi
  80147f:	5d                   	pop    %ebp
  801480:	c3                   	ret    

00801481 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801481:	55                   	push   %ebp
  801482:	89 e5                	mov    %esp,%ebp
  801484:	53                   	push   %ebx
  801485:	83 ec 1c             	sub    $0x1c,%esp
  801488:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80148e:	50                   	push   %eax
  80148f:	53                   	push   %ebx
  801490:	e8 b0 fc ff ff       	call   801145 <fd_lookup>
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	78 3a                	js     8014d6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149c:	83 ec 08             	sub    $0x8,%esp
  80149f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a2:	50                   	push   %eax
  8014a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a6:	ff 30                	pushl  (%eax)
  8014a8:	e8 e8 fc ff ff       	call   801195 <dev_lookup>
  8014ad:	83 c4 10             	add    $0x10,%esp
  8014b0:	85 c0                	test   %eax,%eax
  8014b2:	78 22                	js     8014d6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014bb:	74 1e                	je     8014db <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c0:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c3:	85 d2                	test   %edx,%edx
  8014c5:	74 35                	je     8014fc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	ff 75 10             	pushl  0x10(%ebp)
  8014cd:	ff 75 0c             	pushl  0xc(%ebp)
  8014d0:	50                   	push   %eax
  8014d1:	ff d2                	call   *%edx
  8014d3:	83 c4 10             	add    $0x10,%esp
}
  8014d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d9:	c9                   	leave  
  8014da:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014db:	a1 08 40 80 00       	mov    0x804008,%eax
  8014e0:	8b 40 48             	mov    0x48(%eax),%eax
  8014e3:	83 ec 04             	sub    $0x4,%esp
  8014e6:	53                   	push   %ebx
  8014e7:	50                   	push   %eax
  8014e8:	68 91 2a 80 00       	push   $0x802a91
  8014ed:	e8 94 ed ff ff       	call   800286 <cprintf>
		return -E_INVAL;
  8014f2:	83 c4 10             	add    $0x10,%esp
  8014f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fa:	eb da                	jmp    8014d6 <write+0x55>
		return -E_NOT_SUPP;
  8014fc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801501:	eb d3                	jmp    8014d6 <write+0x55>

00801503 <seek>:

int
seek(int fdnum, off_t offset)
{
  801503:	55                   	push   %ebp
  801504:	89 e5                	mov    %esp,%ebp
  801506:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801509:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150c:	50                   	push   %eax
  80150d:	ff 75 08             	pushl  0x8(%ebp)
  801510:	e8 30 fc ff ff       	call   801145 <fd_lookup>
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	85 c0                	test   %eax,%eax
  80151a:	78 0e                	js     80152a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80151c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80151f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801522:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801525:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
  80152f:	53                   	push   %ebx
  801530:	83 ec 1c             	sub    $0x1c,%esp
  801533:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801536:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801539:	50                   	push   %eax
  80153a:	53                   	push   %ebx
  80153b:	e8 05 fc ff ff       	call   801145 <fd_lookup>
  801540:	83 c4 10             	add    $0x10,%esp
  801543:	85 c0                	test   %eax,%eax
  801545:	78 37                	js     80157e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801547:	83 ec 08             	sub    $0x8,%esp
  80154a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154d:	50                   	push   %eax
  80154e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801551:	ff 30                	pushl  (%eax)
  801553:	e8 3d fc ff ff       	call   801195 <dev_lookup>
  801558:	83 c4 10             	add    $0x10,%esp
  80155b:	85 c0                	test   %eax,%eax
  80155d:	78 1f                	js     80157e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801566:	74 1b                	je     801583 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156b:	8b 52 18             	mov    0x18(%edx),%edx
  80156e:	85 d2                	test   %edx,%edx
  801570:	74 32                	je     8015a4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801572:	83 ec 08             	sub    $0x8,%esp
  801575:	ff 75 0c             	pushl  0xc(%ebp)
  801578:	50                   	push   %eax
  801579:	ff d2                	call   *%edx
  80157b:	83 c4 10             	add    $0x10,%esp
}
  80157e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801581:	c9                   	leave  
  801582:	c3                   	ret    
			thisenv->env_id, fdnum);
  801583:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801588:	8b 40 48             	mov    0x48(%eax),%eax
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	53                   	push   %ebx
  80158f:	50                   	push   %eax
  801590:	68 54 2a 80 00       	push   $0x802a54
  801595:	e8 ec ec ff ff       	call   800286 <cprintf>
		return -E_INVAL;
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a2:	eb da                	jmp    80157e <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015a4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a9:	eb d3                	jmp    80157e <ftruncate+0x52>

008015ab <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015ab:	55                   	push   %ebp
  8015ac:	89 e5                	mov    %esp,%ebp
  8015ae:	53                   	push   %ebx
  8015af:	83 ec 1c             	sub    $0x1c,%esp
  8015b2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b8:	50                   	push   %eax
  8015b9:	ff 75 08             	pushl  0x8(%ebp)
  8015bc:	e8 84 fb ff ff       	call   801145 <fd_lookup>
  8015c1:	83 c4 10             	add    $0x10,%esp
  8015c4:	85 c0                	test   %eax,%eax
  8015c6:	78 4b                	js     801613 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015c8:	83 ec 08             	sub    $0x8,%esp
  8015cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ce:	50                   	push   %eax
  8015cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d2:	ff 30                	pushl  (%eax)
  8015d4:	e8 bc fb ff ff       	call   801195 <dev_lookup>
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	78 33                	js     801613 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015e7:	74 2f                	je     801618 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015e9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ec:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015f3:	00 00 00 
	stat->st_isdir = 0;
  8015f6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015fd:	00 00 00 
	stat->st_dev = dev;
  801600:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801606:	83 ec 08             	sub    $0x8,%esp
  801609:	53                   	push   %ebx
  80160a:	ff 75 f0             	pushl  -0x10(%ebp)
  80160d:	ff 50 14             	call   *0x14(%eax)
  801610:	83 c4 10             	add    $0x10,%esp
}
  801613:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801616:	c9                   	leave  
  801617:	c3                   	ret    
		return -E_NOT_SUPP;
  801618:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161d:	eb f4                	jmp    801613 <fstat+0x68>

0080161f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	56                   	push   %esi
  801623:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801624:	83 ec 08             	sub    $0x8,%esp
  801627:	6a 00                	push   $0x0
  801629:	ff 75 08             	pushl  0x8(%ebp)
  80162c:	e8 22 02 00 00       	call   801853 <open>
  801631:	89 c3                	mov    %eax,%ebx
  801633:	83 c4 10             	add    $0x10,%esp
  801636:	85 c0                	test   %eax,%eax
  801638:	78 1b                	js     801655 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80163a:	83 ec 08             	sub    $0x8,%esp
  80163d:	ff 75 0c             	pushl  0xc(%ebp)
  801640:	50                   	push   %eax
  801641:	e8 65 ff ff ff       	call   8015ab <fstat>
  801646:	89 c6                	mov    %eax,%esi
	close(fd);
  801648:	89 1c 24             	mov    %ebx,(%esp)
  80164b:	e8 27 fc ff ff       	call   801277 <close>
	return r;
  801650:	83 c4 10             	add    $0x10,%esp
  801653:	89 f3                	mov    %esi,%ebx
}
  801655:	89 d8                	mov    %ebx,%eax
  801657:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165a:	5b                   	pop    %ebx
  80165b:	5e                   	pop    %esi
  80165c:	5d                   	pop    %ebp
  80165d:	c3                   	ret    

0080165e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	56                   	push   %esi
  801662:	53                   	push   %ebx
  801663:	89 c6                	mov    %eax,%esi
  801665:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801667:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80166e:	74 27                	je     801697 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801670:	6a 07                	push   $0x7
  801672:	68 00 50 80 00       	push   $0x805000
  801677:	56                   	push   %esi
  801678:	ff 35 00 40 80 00    	pushl  0x804000
  80167e:	e8 69 0c 00 00       	call   8022ec <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801683:	83 c4 0c             	add    $0xc,%esp
  801686:	6a 00                	push   $0x0
  801688:	53                   	push   %ebx
  801689:	6a 00                	push   $0x0
  80168b:	e8 f3 0b 00 00       	call   802283 <ipc_recv>
}
  801690:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801693:	5b                   	pop    %ebx
  801694:	5e                   	pop    %esi
  801695:	5d                   	pop    %ebp
  801696:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	6a 01                	push   $0x1
  80169c:	e8 a3 0c 00 00       	call   802344 <ipc_find_env>
  8016a1:	a3 00 40 80 00       	mov    %eax,0x804000
  8016a6:	83 c4 10             	add    $0x10,%esp
  8016a9:	eb c5                	jmp    801670 <fsipc+0x12>

008016ab <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016bf:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c9:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ce:	e8 8b ff ff ff       	call   80165e <fsipc>
}
  8016d3:	c9                   	leave  
  8016d4:	c3                   	ret    

008016d5 <devfile_flush>:
{
  8016d5:	55                   	push   %ebp
  8016d6:	89 e5                	mov    %esp,%ebp
  8016d8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016db:	8b 45 08             	mov    0x8(%ebp),%eax
  8016de:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016eb:	b8 06 00 00 00       	mov    $0x6,%eax
  8016f0:	e8 69 ff ff ff       	call   80165e <fsipc>
}
  8016f5:	c9                   	leave  
  8016f6:	c3                   	ret    

008016f7 <devfile_stat>:
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	53                   	push   %ebx
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801701:	8b 45 08             	mov    0x8(%ebp),%eax
  801704:	8b 40 0c             	mov    0xc(%eax),%eax
  801707:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80170c:	ba 00 00 00 00       	mov    $0x0,%edx
  801711:	b8 05 00 00 00       	mov    $0x5,%eax
  801716:	e8 43 ff ff ff       	call   80165e <fsipc>
  80171b:	85 c0                	test   %eax,%eax
  80171d:	78 2c                	js     80174b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80171f:	83 ec 08             	sub    $0x8,%esp
  801722:	68 00 50 80 00       	push   $0x805000
  801727:	53                   	push   %ebx
  801728:	e8 b8 f2 ff ff       	call   8009e5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80172d:	a1 80 50 80 00       	mov    0x805080,%eax
  801732:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801738:	a1 84 50 80 00       	mov    0x805084,%eax
  80173d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801743:	83 c4 10             	add    $0x10,%esp
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <devfile_write>:
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	53                   	push   %ebx
  801754:	83 ec 08             	sub    $0x8,%esp
  801757:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80175a:	8b 45 08             	mov    0x8(%ebp),%eax
  80175d:	8b 40 0c             	mov    0xc(%eax),%eax
  801760:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801765:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80176b:	53                   	push   %ebx
  80176c:	ff 75 0c             	pushl  0xc(%ebp)
  80176f:	68 08 50 80 00       	push   $0x805008
  801774:	e8 5c f4 ff ff       	call   800bd5 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801779:	ba 00 00 00 00       	mov    $0x0,%edx
  80177e:	b8 04 00 00 00       	mov    $0x4,%eax
  801783:	e8 d6 fe ff ff       	call   80165e <fsipc>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	78 0b                	js     80179a <devfile_write+0x4a>
	assert(r <= n);
  80178f:	39 d8                	cmp    %ebx,%eax
  801791:	77 0c                	ja     80179f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801793:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801798:	7f 1e                	jg     8017b8 <devfile_write+0x68>
}
  80179a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179d:	c9                   	leave  
  80179e:	c3                   	ret    
	assert(r <= n);
  80179f:	68 c4 2a 80 00       	push   $0x802ac4
  8017a4:	68 cb 2a 80 00       	push   $0x802acb
  8017a9:	68 98 00 00 00       	push   $0x98
  8017ae:	68 e0 2a 80 00       	push   $0x802ae0
  8017b3:	e8 6a 0a 00 00       	call   802222 <_panic>
	assert(r <= PGSIZE);
  8017b8:	68 eb 2a 80 00       	push   $0x802aeb
  8017bd:	68 cb 2a 80 00       	push   $0x802acb
  8017c2:	68 99 00 00 00       	push   $0x99
  8017c7:	68 e0 2a 80 00       	push   $0x802ae0
  8017cc:	e8 51 0a 00 00       	call   802222 <_panic>

008017d1 <devfile_read>:
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
  8017d4:	56                   	push   %esi
  8017d5:	53                   	push   %ebx
  8017d6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017df:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017e4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ef:	b8 03 00 00 00       	mov    $0x3,%eax
  8017f4:	e8 65 fe ff ff       	call   80165e <fsipc>
  8017f9:	89 c3                	mov    %eax,%ebx
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	78 1f                	js     80181e <devfile_read+0x4d>
	assert(r <= n);
  8017ff:	39 f0                	cmp    %esi,%eax
  801801:	77 24                	ja     801827 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801803:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801808:	7f 33                	jg     80183d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	50                   	push   %eax
  80180e:	68 00 50 80 00       	push   $0x805000
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	e8 58 f3 ff ff       	call   800b73 <memmove>
	return r;
  80181b:	83 c4 10             	add    $0x10,%esp
}
  80181e:	89 d8                	mov    %ebx,%eax
  801820:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5d                   	pop    %ebp
  801826:	c3                   	ret    
	assert(r <= n);
  801827:	68 c4 2a 80 00       	push   $0x802ac4
  80182c:	68 cb 2a 80 00       	push   $0x802acb
  801831:	6a 7c                	push   $0x7c
  801833:	68 e0 2a 80 00       	push   $0x802ae0
  801838:	e8 e5 09 00 00       	call   802222 <_panic>
	assert(r <= PGSIZE);
  80183d:	68 eb 2a 80 00       	push   $0x802aeb
  801842:	68 cb 2a 80 00       	push   $0x802acb
  801847:	6a 7d                	push   $0x7d
  801849:	68 e0 2a 80 00       	push   $0x802ae0
  80184e:	e8 cf 09 00 00       	call   802222 <_panic>

00801853 <open>:
{
  801853:	55                   	push   %ebp
  801854:	89 e5                	mov    %esp,%ebp
  801856:	56                   	push   %esi
  801857:	53                   	push   %ebx
  801858:	83 ec 1c             	sub    $0x1c,%esp
  80185b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80185e:	56                   	push   %esi
  80185f:	e8 48 f1 ff ff       	call   8009ac <strlen>
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80186c:	7f 6c                	jg     8018da <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80186e:	83 ec 0c             	sub    $0xc,%esp
  801871:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801874:	50                   	push   %eax
  801875:	e8 79 f8 ff ff       	call   8010f3 <fd_alloc>
  80187a:	89 c3                	mov    %eax,%ebx
  80187c:	83 c4 10             	add    $0x10,%esp
  80187f:	85 c0                	test   %eax,%eax
  801881:	78 3c                	js     8018bf <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801883:	83 ec 08             	sub    $0x8,%esp
  801886:	56                   	push   %esi
  801887:	68 00 50 80 00       	push   $0x805000
  80188c:	e8 54 f1 ff ff       	call   8009e5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801891:	8b 45 0c             	mov    0xc(%ebp),%eax
  801894:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801899:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189c:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a1:	e8 b8 fd ff ff       	call   80165e <fsipc>
  8018a6:	89 c3                	mov    %eax,%ebx
  8018a8:	83 c4 10             	add    $0x10,%esp
  8018ab:	85 c0                	test   %eax,%eax
  8018ad:	78 19                	js     8018c8 <open+0x75>
	return fd2num(fd);
  8018af:	83 ec 0c             	sub    $0xc,%esp
  8018b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b5:	e8 12 f8 ff ff       	call   8010cc <fd2num>
  8018ba:	89 c3                	mov    %eax,%ebx
  8018bc:	83 c4 10             	add    $0x10,%esp
}
  8018bf:	89 d8                	mov    %ebx,%eax
  8018c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c4:	5b                   	pop    %ebx
  8018c5:	5e                   	pop    %esi
  8018c6:	5d                   	pop    %ebp
  8018c7:	c3                   	ret    
		fd_close(fd, 0);
  8018c8:	83 ec 08             	sub    $0x8,%esp
  8018cb:	6a 00                	push   $0x0
  8018cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d0:	e8 1b f9 ff ff       	call   8011f0 <fd_close>
		return r;
  8018d5:	83 c4 10             	add    $0x10,%esp
  8018d8:	eb e5                	jmp    8018bf <open+0x6c>
		return -E_BAD_PATH;
  8018da:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018df:	eb de                	jmp    8018bf <open+0x6c>

008018e1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018e1:	55                   	push   %ebp
  8018e2:	89 e5                	mov    %esp,%ebp
  8018e4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ec:	b8 08 00 00 00       	mov    $0x8,%eax
  8018f1:	e8 68 fd ff ff       	call   80165e <fsipc>
}
  8018f6:	c9                   	leave  
  8018f7:	c3                   	ret    

008018f8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018fe:	68 f7 2a 80 00       	push   $0x802af7
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	e8 da f0 ff ff       	call   8009e5 <strcpy>
	return 0;
}
  80190b:	b8 00 00 00 00       	mov    $0x0,%eax
  801910:	c9                   	leave  
  801911:	c3                   	ret    

00801912 <devsock_close>:
{
  801912:	55                   	push   %ebp
  801913:	89 e5                	mov    %esp,%ebp
  801915:	53                   	push   %ebx
  801916:	83 ec 10             	sub    $0x10,%esp
  801919:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80191c:	53                   	push   %ebx
  80191d:	e8 5d 0a 00 00       	call   80237f <pageref>
  801922:	83 c4 10             	add    $0x10,%esp
		return 0;
  801925:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80192a:	83 f8 01             	cmp    $0x1,%eax
  80192d:	74 07                	je     801936 <devsock_close+0x24>
}
  80192f:	89 d0                	mov    %edx,%eax
  801931:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801934:	c9                   	leave  
  801935:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801936:	83 ec 0c             	sub    $0xc,%esp
  801939:	ff 73 0c             	pushl  0xc(%ebx)
  80193c:	e8 b9 02 00 00       	call   801bfa <nsipc_close>
  801941:	89 c2                	mov    %eax,%edx
  801943:	83 c4 10             	add    $0x10,%esp
  801946:	eb e7                	jmp    80192f <devsock_close+0x1d>

00801948 <devsock_write>:
{
  801948:	55                   	push   %ebp
  801949:	89 e5                	mov    %esp,%ebp
  80194b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 10             	pushl  0x10(%ebp)
  801953:	ff 75 0c             	pushl  0xc(%ebp)
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	ff 70 0c             	pushl  0xc(%eax)
  80195c:	e8 76 03 00 00       	call   801cd7 <nsipc_send>
}
  801961:	c9                   	leave  
  801962:	c3                   	ret    

00801963 <devsock_read>:
{
  801963:	55                   	push   %ebp
  801964:	89 e5                	mov    %esp,%ebp
  801966:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801969:	6a 00                	push   $0x0
  80196b:	ff 75 10             	pushl  0x10(%ebp)
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	ff 70 0c             	pushl  0xc(%eax)
  801977:	e8 ef 02 00 00       	call   801c6b <nsipc_recv>
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <fd2sockid>:
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801984:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801987:	52                   	push   %edx
  801988:	50                   	push   %eax
  801989:	e8 b7 f7 ff ff       	call   801145 <fd_lookup>
  80198e:	83 c4 10             	add    $0x10,%esp
  801991:	85 c0                	test   %eax,%eax
  801993:	78 10                	js     8019a5 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801998:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80199e:	39 08                	cmp    %ecx,(%eax)
  8019a0:	75 05                	jne    8019a7 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019a2:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    
		return -E_NOT_SUPP;
  8019a7:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ac:	eb f7                	jmp    8019a5 <fd2sockid+0x27>

008019ae <alloc_sockfd>:
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	56                   	push   %esi
  8019b2:	53                   	push   %ebx
  8019b3:	83 ec 1c             	sub    $0x1c,%esp
  8019b6:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bb:	50                   	push   %eax
  8019bc:	e8 32 f7 ff ff       	call   8010f3 <fd_alloc>
  8019c1:	89 c3                	mov    %eax,%ebx
  8019c3:	83 c4 10             	add    $0x10,%esp
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 43                	js     801a0d <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	68 07 04 00 00       	push   $0x407
  8019d2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d5:	6a 00                	push   $0x0
  8019d7:	e8 fb f3 ff ff       	call   800dd7 <sys_page_alloc>
  8019dc:	89 c3                	mov    %eax,%ebx
  8019de:	83 c4 10             	add    $0x10,%esp
  8019e1:	85 c0                	test   %eax,%eax
  8019e3:	78 28                	js     801a0d <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019ee:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019fa:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019fd:	83 ec 0c             	sub    $0xc,%esp
  801a00:	50                   	push   %eax
  801a01:	e8 c6 f6 ff ff       	call   8010cc <fd2num>
  801a06:	89 c3                	mov    %eax,%ebx
  801a08:	83 c4 10             	add    $0x10,%esp
  801a0b:	eb 0c                	jmp    801a19 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a0d:	83 ec 0c             	sub    $0xc,%esp
  801a10:	56                   	push   %esi
  801a11:	e8 e4 01 00 00       	call   801bfa <nsipc_close>
		return r;
  801a16:	83 c4 10             	add    $0x10,%esp
}
  801a19:	89 d8                	mov    %ebx,%eax
  801a1b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1e:	5b                   	pop    %ebx
  801a1f:	5e                   	pop    %esi
  801a20:	5d                   	pop    %ebp
  801a21:	c3                   	ret    

00801a22 <accept>:
{
  801a22:	55                   	push   %ebp
  801a23:	89 e5                	mov    %esp,%ebp
  801a25:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a28:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2b:	e8 4e ff ff ff       	call   80197e <fd2sockid>
  801a30:	85 c0                	test   %eax,%eax
  801a32:	78 1b                	js     801a4f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a34:	83 ec 04             	sub    $0x4,%esp
  801a37:	ff 75 10             	pushl  0x10(%ebp)
  801a3a:	ff 75 0c             	pushl  0xc(%ebp)
  801a3d:	50                   	push   %eax
  801a3e:	e8 0e 01 00 00       	call   801b51 <nsipc_accept>
  801a43:	83 c4 10             	add    $0x10,%esp
  801a46:	85 c0                	test   %eax,%eax
  801a48:	78 05                	js     801a4f <accept+0x2d>
	return alloc_sockfd(r);
  801a4a:	e8 5f ff ff ff       	call   8019ae <alloc_sockfd>
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <bind>:
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a57:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5a:	e8 1f ff ff ff       	call   80197e <fd2sockid>
  801a5f:	85 c0                	test   %eax,%eax
  801a61:	78 12                	js     801a75 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a63:	83 ec 04             	sub    $0x4,%esp
  801a66:	ff 75 10             	pushl  0x10(%ebp)
  801a69:	ff 75 0c             	pushl  0xc(%ebp)
  801a6c:	50                   	push   %eax
  801a6d:	e8 31 01 00 00       	call   801ba3 <nsipc_bind>
  801a72:	83 c4 10             	add    $0x10,%esp
}
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <shutdown>:
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a80:	e8 f9 fe ff ff       	call   80197e <fd2sockid>
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 0f                	js     801a98 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a89:	83 ec 08             	sub    $0x8,%esp
  801a8c:	ff 75 0c             	pushl  0xc(%ebp)
  801a8f:	50                   	push   %eax
  801a90:	e8 43 01 00 00       	call   801bd8 <nsipc_shutdown>
  801a95:	83 c4 10             	add    $0x10,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <connect>:
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
  801a9d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa3:	e8 d6 fe ff ff       	call   80197e <fd2sockid>
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	78 12                	js     801abe <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801aac:	83 ec 04             	sub    $0x4,%esp
  801aaf:	ff 75 10             	pushl  0x10(%ebp)
  801ab2:	ff 75 0c             	pushl  0xc(%ebp)
  801ab5:	50                   	push   %eax
  801ab6:	e8 59 01 00 00       	call   801c14 <nsipc_connect>
  801abb:	83 c4 10             	add    $0x10,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <listen>:
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
  801ac3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	e8 b0 fe ff ff       	call   80197e <fd2sockid>
  801ace:	85 c0                	test   %eax,%eax
  801ad0:	78 0f                	js     801ae1 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ad2:	83 ec 08             	sub    $0x8,%esp
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	e8 6b 01 00 00       	call   801c49 <nsipc_listen>
  801ade:	83 c4 10             	add    $0x10,%esp
}
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ae9:	ff 75 10             	pushl  0x10(%ebp)
  801aec:	ff 75 0c             	pushl  0xc(%ebp)
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	e8 3e 02 00 00       	call   801d35 <nsipc_socket>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 05                	js     801b03 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801afe:	e8 ab fe ff ff       	call   8019ae <alloc_sockfd>
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	53                   	push   %ebx
  801b09:	83 ec 04             	sub    $0x4,%esp
  801b0c:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b0e:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b15:	74 26                	je     801b3d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b17:	6a 07                	push   $0x7
  801b19:	68 00 60 80 00       	push   $0x806000
  801b1e:	53                   	push   %ebx
  801b1f:	ff 35 04 40 80 00    	pushl  0x804004
  801b25:	e8 c2 07 00 00       	call   8022ec <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b2a:	83 c4 0c             	add    $0xc,%esp
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	e8 4b 07 00 00       	call   802283 <ipc_recv>
}
  801b38:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3b:	c9                   	leave  
  801b3c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b3d:	83 ec 0c             	sub    $0xc,%esp
  801b40:	6a 02                	push   $0x2
  801b42:	e8 fd 07 00 00       	call   802344 <ipc_find_env>
  801b47:	a3 04 40 80 00       	mov    %eax,0x804004
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	eb c6                	jmp    801b17 <nsipc+0x12>

00801b51 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	56                   	push   %esi
  801b55:	53                   	push   %ebx
  801b56:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b61:	8b 06                	mov    (%esi),%eax
  801b63:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b68:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6d:	e8 93 ff ff ff       	call   801b05 <nsipc>
  801b72:	89 c3                	mov    %eax,%ebx
  801b74:	85 c0                	test   %eax,%eax
  801b76:	79 09                	jns    801b81 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b78:	89 d8                	mov    %ebx,%eax
  801b7a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7d:	5b                   	pop    %ebx
  801b7e:	5e                   	pop    %esi
  801b7f:	5d                   	pop    %ebp
  801b80:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b81:	83 ec 04             	sub    $0x4,%esp
  801b84:	ff 35 10 60 80 00    	pushl  0x806010
  801b8a:	68 00 60 80 00       	push   $0x806000
  801b8f:	ff 75 0c             	pushl  0xc(%ebp)
  801b92:	e8 dc ef ff ff       	call   800b73 <memmove>
		*addrlen = ret->ret_addrlen;
  801b97:	a1 10 60 80 00       	mov    0x806010,%eax
  801b9c:	89 06                	mov    %eax,(%esi)
  801b9e:	83 c4 10             	add    $0x10,%esp
	return r;
  801ba1:	eb d5                	jmp    801b78 <nsipc_accept+0x27>

00801ba3 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	53                   	push   %ebx
  801ba7:	83 ec 08             	sub    $0x8,%esp
  801baa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bb5:	53                   	push   %ebx
  801bb6:	ff 75 0c             	pushl  0xc(%ebp)
  801bb9:	68 04 60 80 00       	push   $0x806004
  801bbe:	e8 b0 ef ff ff       	call   800b73 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bc3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bc9:	b8 02 00 00 00       	mov    $0x2,%eax
  801bce:	e8 32 ff ff ff       	call   801b05 <nsipc>
}
  801bd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
  801bdb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801be9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bee:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf3:	e8 0d ff ff ff       	call   801b05 <nsipc>
}
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <nsipc_close>:

int
nsipc_close(int s)
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c08:	b8 04 00 00 00       	mov    $0x4,%eax
  801c0d:	e8 f3 fe ff ff       	call   801b05 <nsipc>
}
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	53                   	push   %ebx
  801c18:	83 ec 08             	sub    $0x8,%esp
  801c1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c26:	53                   	push   %ebx
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	68 04 60 80 00       	push   $0x806004
  801c2f:	e8 3f ef ff ff       	call   800b73 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c34:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c3a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c3f:	e8 c1 fe ff ff       	call   801b05 <nsipc>
}
  801c44:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c47:	c9                   	leave  
  801c48:	c3                   	ret    

00801c49 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c49:	55                   	push   %ebp
  801c4a:	89 e5                	mov    %esp,%ebp
  801c4c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c5f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c64:	e8 9c fe ff ff       	call   801b05 <nsipc>
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c7b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c81:	8b 45 14             	mov    0x14(%ebp),%eax
  801c84:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c89:	b8 07 00 00 00       	mov    $0x7,%eax
  801c8e:	e8 72 fe ff ff       	call   801b05 <nsipc>
  801c93:	89 c3                	mov    %eax,%ebx
  801c95:	85 c0                	test   %eax,%eax
  801c97:	78 1f                	js     801cb8 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c99:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c9e:	7f 21                	jg     801cc1 <nsipc_recv+0x56>
  801ca0:	39 c6                	cmp    %eax,%esi
  801ca2:	7c 1d                	jl     801cc1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ca4:	83 ec 04             	sub    $0x4,%esp
  801ca7:	50                   	push   %eax
  801ca8:	68 00 60 80 00       	push   $0x806000
  801cad:	ff 75 0c             	pushl  0xc(%ebp)
  801cb0:	e8 be ee ff ff       	call   800b73 <memmove>
  801cb5:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cb8:	89 d8                	mov    %ebx,%eax
  801cba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbd:	5b                   	pop    %ebx
  801cbe:	5e                   	pop    %esi
  801cbf:	5d                   	pop    %ebp
  801cc0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cc1:	68 03 2b 80 00       	push   $0x802b03
  801cc6:	68 cb 2a 80 00       	push   $0x802acb
  801ccb:	6a 62                	push   $0x62
  801ccd:	68 18 2b 80 00       	push   $0x802b18
  801cd2:	e8 4b 05 00 00       	call   802222 <_panic>

00801cd7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cd7:	55                   	push   %ebp
  801cd8:	89 e5                	mov    %esp,%ebp
  801cda:	53                   	push   %ebx
  801cdb:	83 ec 04             	sub    $0x4,%esp
  801cde:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ce9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cef:	7f 2e                	jg     801d1f <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cf1:	83 ec 04             	sub    $0x4,%esp
  801cf4:	53                   	push   %ebx
  801cf5:	ff 75 0c             	pushl  0xc(%ebp)
  801cf8:	68 0c 60 80 00       	push   $0x80600c
  801cfd:	e8 71 ee ff ff       	call   800b73 <memmove>
	nsipcbuf.send.req_size = size;
  801d02:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d08:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0b:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d10:	b8 08 00 00 00       	mov    $0x8,%eax
  801d15:	e8 eb fd ff ff       	call   801b05 <nsipc>
}
  801d1a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    
	assert(size < 1600);
  801d1f:	68 24 2b 80 00       	push   $0x802b24
  801d24:	68 cb 2a 80 00       	push   $0x802acb
  801d29:	6a 6d                	push   $0x6d
  801d2b:	68 18 2b 80 00       	push   $0x802b18
  801d30:	e8 ed 04 00 00       	call   802222 <_panic>

00801d35 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d35:	55                   	push   %ebp
  801d36:	89 e5                	mov    %esp,%ebp
  801d38:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d3e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d46:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d4b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d4e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d53:	b8 09 00 00 00       	mov    $0x9,%eax
  801d58:	e8 a8 fd ff ff       	call   801b05 <nsipc>
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	56                   	push   %esi
  801d63:	53                   	push   %ebx
  801d64:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d67:	83 ec 0c             	sub    $0xc,%esp
  801d6a:	ff 75 08             	pushl  0x8(%ebp)
  801d6d:	e8 6a f3 ff ff       	call   8010dc <fd2data>
  801d72:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d74:	83 c4 08             	add    $0x8,%esp
  801d77:	68 30 2b 80 00       	push   $0x802b30
  801d7c:	53                   	push   %ebx
  801d7d:	e8 63 ec ff ff       	call   8009e5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d82:	8b 46 04             	mov    0x4(%esi),%eax
  801d85:	2b 06                	sub    (%esi),%eax
  801d87:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d8d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d94:	00 00 00 
	stat->st_dev = &devpipe;
  801d97:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d9e:	30 80 00 
	return 0;
}
  801da1:	b8 00 00 00 00       	mov    $0x0,%eax
  801da6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801da9:	5b                   	pop    %ebx
  801daa:	5e                   	pop    %esi
  801dab:	5d                   	pop    %ebp
  801dac:	c3                   	ret    

00801dad <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	53                   	push   %ebx
  801db1:	83 ec 0c             	sub    $0xc,%esp
  801db4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801db7:	53                   	push   %ebx
  801db8:	6a 00                	push   $0x0
  801dba:	e8 9d f0 ff ff       	call   800e5c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dbf:	89 1c 24             	mov    %ebx,(%esp)
  801dc2:	e8 15 f3 ff ff       	call   8010dc <fd2data>
  801dc7:	83 c4 08             	add    $0x8,%esp
  801dca:	50                   	push   %eax
  801dcb:	6a 00                	push   $0x0
  801dcd:	e8 8a f0 ff ff       	call   800e5c <sys_page_unmap>
}
  801dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd5:	c9                   	leave  
  801dd6:	c3                   	ret    

00801dd7 <_pipeisclosed>:
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
  801dda:	57                   	push   %edi
  801ddb:	56                   	push   %esi
  801ddc:	53                   	push   %ebx
  801ddd:	83 ec 1c             	sub    $0x1c,%esp
  801de0:	89 c7                	mov    %eax,%edi
  801de2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801de4:	a1 08 40 80 00       	mov    0x804008,%eax
  801de9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dec:	83 ec 0c             	sub    $0xc,%esp
  801def:	57                   	push   %edi
  801df0:	e8 8a 05 00 00       	call   80237f <pageref>
  801df5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801df8:	89 34 24             	mov    %esi,(%esp)
  801dfb:	e8 7f 05 00 00       	call   80237f <pageref>
		nn = thisenv->env_runs;
  801e00:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e06:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e09:	83 c4 10             	add    $0x10,%esp
  801e0c:	39 cb                	cmp    %ecx,%ebx
  801e0e:	74 1b                	je     801e2b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e10:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e13:	75 cf                	jne    801de4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e15:	8b 42 58             	mov    0x58(%edx),%eax
  801e18:	6a 01                	push   $0x1
  801e1a:	50                   	push   %eax
  801e1b:	53                   	push   %ebx
  801e1c:	68 37 2b 80 00       	push   $0x802b37
  801e21:	e8 60 e4 ff ff       	call   800286 <cprintf>
  801e26:	83 c4 10             	add    $0x10,%esp
  801e29:	eb b9                	jmp    801de4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e2b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e2e:	0f 94 c0             	sete   %al
  801e31:	0f b6 c0             	movzbl %al,%eax
}
  801e34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    

00801e3c <devpipe_write>:
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	57                   	push   %edi
  801e40:	56                   	push   %esi
  801e41:	53                   	push   %ebx
  801e42:	83 ec 28             	sub    $0x28,%esp
  801e45:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e48:	56                   	push   %esi
  801e49:	e8 8e f2 ff ff       	call   8010dc <fd2data>
  801e4e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e50:	83 c4 10             	add    $0x10,%esp
  801e53:	bf 00 00 00 00       	mov    $0x0,%edi
  801e58:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e5b:	74 4f                	je     801eac <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e5d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e60:	8b 0b                	mov    (%ebx),%ecx
  801e62:	8d 51 20             	lea    0x20(%ecx),%edx
  801e65:	39 d0                	cmp    %edx,%eax
  801e67:	72 14                	jb     801e7d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e69:	89 da                	mov    %ebx,%edx
  801e6b:	89 f0                	mov    %esi,%eax
  801e6d:	e8 65 ff ff ff       	call   801dd7 <_pipeisclosed>
  801e72:	85 c0                	test   %eax,%eax
  801e74:	75 3b                	jne    801eb1 <devpipe_write+0x75>
			sys_yield();
  801e76:	e8 3d ef ff ff       	call   800db8 <sys_yield>
  801e7b:	eb e0                	jmp    801e5d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e80:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e84:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e87:	89 c2                	mov    %eax,%edx
  801e89:	c1 fa 1f             	sar    $0x1f,%edx
  801e8c:	89 d1                	mov    %edx,%ecx
  801e8e:	c1 e9 1b             	shr    $0x1b,%ecx
  801e91:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e94:	83 e2 1f             	and    $0x1f,%edx
  801e97:	29 ca                	sub    %ecx,%edx
  801e99:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e9d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ea1:	83 c0 01             	add    $0x1,%eax
  801ea4:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ea7:	83 c7 01             	add    $0x1,%edi
  801eaa:	eb ac                	jmp    801e58 <devpipe_write+0x1c>
	return i;
  801eac:	8b 45 10             	mov    0x10(%ebp),%eax
  801eaf:	eb 05                	jmp    801eb6 <devpipe_write+0x7a>
				return 0;
  801eb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb9:	5b                   	pop    %ebx
  801eba:	5e                   	pop    %esi
  801ebb:	5f                   	pop    %edi
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <devpipe_read>:
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	57                   	push   %edi
  801ec2:	56                   	push   %esi
  801ec3:	53                   	push   %ebx
  801ec4:	83 ec 18             	sub    $0x18,%esp
  801ec7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801eca:	57                   	push   %edi
  801ecb:	e8 0c f2 ff ff       	call   8010dc <fd2data>
  801ed0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ed2:	83 c4 10             	add    $0x10,%esp
  801ed5:	be 00 00 00 00       	mov    $0x0,%esi
  801eda:	3b 75 10             	cmp    0x10(%ebp),%esi
  801edd:	75 14                	jne    801ef3 <devpipe_read+0x35>
	return i;
  801edf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee2:	eb 02                	jmp    801ee6 <devpipe_read+0x28>
				return i;
  801ee4:	89 f0                	mov    %esi,%eax
}
  801ee6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ee9:	5b                   	pop    %ebx
  801eea:	5e                   	pop    %esi
  801eeb:	5f                   	pop    %edi
  801eec:	5d                   	pop    %ebp
  801eed:	c3                   	ret    
			sys_yield();
  801eee:	e8 c5 ee ff ff       	call   800db8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ef3:	8b 03                	mov    (%ebx),%eax
  801ef5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ef8:	75 18                	jne    801f12 <devpipe_read+0x54>
			if (i > 0)
  801efa:	85 f6                	test   %esi,%esi
  801efc:	75 e6                	jne    801ee4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801efe:	89 da                	mov    %ebx,%edx
  801f00:	89 f8                	mov    %edi,%eax
  801f02:	e8 d0 fe ff ff       	call   801dd7 <_pipeisclosed>
  801f07:	85 c0                	test   %eax,%eax
  801f09:	74 e3                	je     801eee <devpipe_read+0x30>
				return 0;
  801f0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f10:	eb d4                	jmp    801ee6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f12:	99                   	cltd   
  801f13:	c1 ea 1b             	shr    $0x1b,%edx
  801f16:	01 d0                	add    %edx,%eax
  801f18:	83 e0 1f             	and    $0x1f,%eax
  801f1b:	29 d0                	sub    %edx,%eax
  801f1d:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f25:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f28:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f2b:	83 c6 01             	add    $0x1,%esi
  801f2e:	eb aa                	jmp    801eda <devpipe_read+0x1c>

00801f30 <pipe>:
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	56                   	push   %esi
  801f34:	53                   	push   %ebx
  801f35:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f38:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3b:	50                   	push   %eax
  801f3c:	e8 b2 f1 ff ff       	call   8010f3 <fd_alloc>
  801f41:	89 c3                	mov    %eax,%ebx
  801f43:	83 c4 10             	add    $0x10,%esp
  801f46:	85 c0                	test   %eax,%eax
  801f48:	0f 88 23 01 00 00    	js     802071 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4e:	83 ec 04             	sub    $0x4,%esp
  801f51:	68 07 04 00 00       	push   $0x407
  801f56:	ff 75 f4             	pushl  -0xc(%ebp)
  801f59:	6a 00                	push   $0x0
  801f5b:	e8 77 ee ff ff       	call   800dd7 <sys_page_alloc>
  801f60:	89 c3                	mov    %eax,%ebx
  801f62:	83 c4 10             	add    $0x10,%esp
  801f65:	85 c0                	test   %eax,%eax
  801f67:	0f 88 04 01 00 00    	js     802071 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f6d:	83 ec 0c             	sub    $0xc,%esp
  801f70:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f73:	50                   	push   %eax
  801f74:	e8 7a f1 ff ff       	call   8010f3 <fd_alloc>
  801f79:	89 c3                	mov    %eax,%ebx
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	0f 88 db 00 00 00    	js     802061 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f86:	83 ec 04             	sub    $0x4,%esp
  801f89:	68 07 04 00 00       	push   $0x407
  801f8e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f91:	6a 00                	push   $0x0
  801f93:	e8 3f ee ff ff       	call   800dd7 <sys_page_alloc>
  801f98:	89 c3                	mov    %eax,%ebx
  801f9a:	83 c4 10             	add    $0x10,%esp
  801f9d:	85 c0                	test   %eax,%eax
  801f9f:	0f 88 bc 00 00 00    	js     802061 <pipe+0x131>
	va = fd2data(fd0);
  801fa5:	83 ec 0c             	sub    $0xc,%esp
  801fa8:	ff 75 f4             	pushl  -0xc(%ebp)
  801fab:	e8 2c f1 ff ff       	call   8010dc <fd2data>
  801fb0:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb2:	83 c4 0c             	add    $0xc,%esp
  801fb5:	68 07 04 00 00       	push   $0x407
  801fba:	50                   	push   %eax
  801fbb:	6a 00                	push   $0x0
  801fbd:	e8 15 ee ff ff       	call   800dd7 <sys_page_alloc>
  801fc2:	89 c3                	mov    %eax,%ebx
  801fc4:	83 c4 10             	add    $0x10,%esp
  801fc7:	85 c0                	test   %eax,%eax
  801fc9:	0f 88 82 00 00 00    	js     802051 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fcf:	83 ec 0c             	sub    $0xc,%esp
  801fd2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd5:	e8 02 f1 ff ff       	call   8010dc <fd2data>
  801fda:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fe1:	50                   	push   %eax
  801fe2:	6a 00                	push   $0x0
  801fe4:	56                   	push   %esi
  801fe5:	6a 00                	push   $0x0
  801fe7:	e8 2e ee ff ff       	call   800e1a <sys_page_map>
  801fec:	89 c3                	mov    %eax,%ebx
  801fee:	83 c4 20             	add    $0x20,%esp
  801ff1:	85 c0                	test   %eax,%eax
  801ff3:	78 4e                	js     802043 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ff5:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ffa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802002:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  802009:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200c:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  80200e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802011:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802018:	83 ec 0c             	sub    $0xc,%esp
  80201b:	ff 75 f4             	pushl  -0xc(%ebp)
  80201e:	e8 a9 f0 ff ff       	call   8010cc <fd2num>
  802023:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802026:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802028:	83 c4 04             	add    $0x4,%esp
  80202b:	ff 75 f0             	pushl  -0x10(%ebp)
  80202e:	e8 99 f0 ff ff       	call   8010cc <fd2num>
  802033:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802036:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802039:	83 c4 10             	add    $0x10,%esp
  80203c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802041:	eb 2e                	jmp    802071 <pipe+0x141>
	sys_page_unmap(0, va);
  802043:	83 ec 08             	sub    $0x8,%esp
  802046:	56                   	push   %esi
  802047:	6a 00                	push   $0x0
  802049:	e8 0e ee ff ff       	call   800e5c <sys_page_unmap>
  80204e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802051:	83 ec 08             	sub    $0x8,%esp
  802054:	ff 75 f0             	pushl  -0x10(%ebp)
  802057:	6a 00                	push   $0x0
  802059:	e8 fe ed ff ff       	call   800e5c <sys_page_unmap>
  80205e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802061:	83 ec 08             	sub    $0x8,%esp
  802064:	ff 75 f4             	pushl  -0xc(%ebp)
  802067:	6a 00                	push   $0x0
  802069:	e8 ee ed ff ff       	call   800e5c <sys_page_unmap>
  80206e:	83 c4 10             	add    $0x10,%esp
}
  802071:	89 d8                	mov    %ebx,%eax
  802073:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802076:	5b                   	pop    %ebx
  802077:	5e                   	pop    %esi
  802078:	5d                   	pop    %ebp
  802079:	c3                   	ret    

0080207a <pipeisclosed>:
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
  80207d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802080:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802083:	50                   	push   %eax
  802084:	ff 75 08             	pushl  0x8(%ebp)
  802087:	e8 b9 f0 ff ff       	call   801145 <fd_lookup>
  80208c:	83 c4 10             	add    $0x10,%esp
  80208f:	85 c0                	test   %eax,%eax
  802091:	78 18                	js     8020ab <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802093:	83 ec 0c             	sub    $0xc,%esp
  802096:	ff 75 f4             	pushl  -0xc(%ebp)
  802099:	e8 3e f0 ff ff       	call   8010dc <fd2data>
	return _pipeisclosed(fd, p);
  80209e:	89 c2                	mov    %eax,%edx
  8020a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a3:	e8 2f fd ff ff       	call   801dd7 <_pipeisclosed>
  8020a8:	83 c4 10             	add    $0x10,%esp
}
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b2:	c3                   	ret    

008020b3 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020b3:	55                   	push   %ebp
  8020b4:	89 e5                	mov    %esp,%ebp
  8020b6:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020b9:	68 4f 2b 80 00       	push   $0x802b4f
  8020be:	ff 75 0c             	pushl  0xc(%ebp)
  8020c1:	e8 1f e9 ff ff       	call   8009e5 <strcpy>
	return 0;
}
  8020c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cb:	c9                   	leave  
  8020cc:	c3                   	ret    

008020cd <devcons_write>:
{
  8020cd:	55                   	push   %ebp
  8020ce:	89 e5                	mov    %esp,%ebp
  8020d0:	57                   	push   %edi
  8020d1:	56                   	push   %esi
  8020d2:	53                   	push   %ebx
  8020d3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020d9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020de:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020e4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020e7:	73 31                	jae    80211a <devcons_write+0x4d>
		m = n - tot;
  8020e9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020ec:	29 f3                	sub    %esi,%ebx
  8020ee:	83 fb 7f             	cmp    $0x7f,%ebx
  8020f1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020f6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020f9:	83 ec 04             	sub    $0x4,%esp
  8020fc:	53                   	push   %ebx
  8020fd:	89 f0                	mov    %esi,%eax
  8020ff:	03 45 0c             	add    0xc(%ebp),%eax
  802102:	50                   	push   %eax
  802103:	57                   	push   %edi
  802104:	e8 6a ea ff ff       	call   800b73 <memmove>
		sys_cputs(buf, m);
  802109:	83 c4 08             	add    $0x8,%esp
  80210c:	53                   	push   %ebx
  80210d:	57                   	push   %edi
  80210e:	e8 08 ec ff ff       	call   800d1b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802113:	01 de                	add    %ebx,%esi
  802115:	83 c4 10             	add    $0x10,%esp
  802118:	eb ca                	jmp    8020e4 <devcons_write+0x17>
}
  80211a:	89 f0                	mov    %esi,%eax
  80211c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80211f:	5b                   	pop    %ebx
  802120:	5e                   	pop    %esi
  802121:	5f                   	pop    %edi
  802122:	5d                   	pop    %ebp
  802123:	c3                   	ret    

00802124 <devcons_read>:
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	83 ec 08             	sub    $0x8,%esp
  80212a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80212f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802133:	74 21                	je     802156 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802135:	e8 ff eb ff ff       	call   800d39 <sys_cgetc>
  80213a:	85 c0                	test   %eax,%eax
  80213c:	75 07                	jne    802145 <devcons_read+0x21>
		sys_yield();
  80213e:	e8 75 ec ff ff       	call   800db8 <sys_yield>
  802143:	eb f0                	jmp    802135 <devcons_read+0x11>
	if (c < 0)
  802145:	78 0f                	js     802156 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802147:	83 f8 04             	cmp    $0x4,%eax
  80214a:	74 0c                	je     802158 <devcons_read+0x34>
	*(char*)vbuf = c;
  80214c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80214f:	88 02                	mov    %al,(%edx)
	return 1;
  802151:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802156:	c9                   	leave  
  802157:	c3                   	ret    
		return 0;
  802158:	b8 00 00 00 00       	mov    $0x0,%eax
  80215d:	eb f7                	jmp    802156 <devcons_read+0x32>

0080215f <cputchar>:
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802165:	8b 45 08             	mov    0x8(%ebp),%eax
  802168:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80216b:	6a 01                	push   $0x1
  80216d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802170:	50                   	push   %eax
  802171:	e8 a5 eb ff ff       	call   800d1b <sys_cputs>
}
  802176:	83 c4 10             	add    $0x10,%esp
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <getchar>:
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802181:	6a 01                	push   $0x1
  802183:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802186:	50                   	push   %eax
  802187:	6a 00                	push   $0x0
  802189:	e8 27 f2 ff ff       	call   8013b5 <read>
	if (r < 0)
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	78 06                	js     80219b <getchar+0x20>
	if (r < 1)
  802195:	74 06                	je     80219d <getchar+0x22>
	return c;
  802197:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80219b:	c9                   	leave  
  80219c:	c3                   	ret    
		return -E_EOF;
  80219d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021a2:	eb f7                	jmp    80219b <getchar+0x20>

008021a4 <iscons>:
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021ad:	50                   	push   %eax
  8021ae:	ff 75 08             	pushl  0x8(%ebp)
  8021b1:	e8 8f ef ff ff       	call   801145 <fd_lookup>
  8021b6:	83 c4 10             	add    $0x10,%esp
  8021b9:	85 c0                	test   %eax,%eax
  8021bb:	78 11                	js     8021ce <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021c6:	39 10                	cmp    %edx,(%eax)
  8021c8:	0f 94 c0             	sete   %al
  8021cb:	0f b6 c0             	movzbl %al,%eax
}
  8021ce:	c9                   	leave  
  8021cf:	c3                   	ret    

008021d0 <opencons>:
{
  8021d0:	55                   	push   %ebp
  8021d1:	89 e5                	mov    %esp,%ebp
  8021d3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021d9:	50                   	push   %eax
  8021da:	e8 14 ef ff ff       	call   8010f3 <fd_alloc>
  8021df:	83 c4 10             	add    $0x10,%esp
  8021e2:	85 c0                	test   %eax,%eax
  8021e4:	78 3a                	js     802220 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021e6:	83 ec 04             	sub    $0x4,%esp
  8021e9:	68 07 04 00 00       	push   $0x407
  8021ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f1:	6a 00                	push   $0x0
  8021f3:	e8 df eb ff ff       	call   800dd7 <sys_page_alloc>
  8021f8:	83 c4 10             	add    $0x10,%esp
  8021fb:	85 c0                	test   %eax,%eax
  8021fd:	78 21                	js     802220 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802208:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80220a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802214:	83 ec 0c             	sub    $0xc,%esp
  802217:	50                   	push   %eax
  802218:	e8 af ee ff ff       	call   8010cc <fd2num>
  80221d:	83 c4 10             	add    $0x10,%esp
}
  802220:	c9                   	leave  
  802221:	c3                   	ret    

00802222 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802222:	55                   	push   %ebp
  802223:	89 e5                	mov    %esp,%ebp
  802225:	56                   	push   %esi
  802226:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802227:	a1 08 40 80 00       	mov    0x804008,%eax
  80222c:	8b 40 48             	mov    0x48(%eax),%eax
  80222f:	83 ec 04             	sub    $0x4,%esp
  802232:	68 80 2b 80 00       	push   $0x802b80
  802237:	50                   	push   %eax
  802238:	68 7d 26 80 00       	push   $0x80267d
  80223d:	e8 44 e0 ff ff       	call   800286 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802242:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802245:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80224b:	e8 49 eb ff ff       	call   800d99 <sys_getenvid>
  802250:	83 c4 04             	add    $0x4,%esp
  802253:	ff 75 0c             	pushl  0xc(%ebp)
  802256:	ff 75 08             	pushl  0x8(%ebp)
  802259:	56                   	push   %esi
  80225a:	50                   	push   %eax
  80225b:	68 5c 2b 80 00       	push   $0x802b5c
  802260:	e8 21 e0 ff ff       	call   800286 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802265:	83 c4 18             	add    $0x18,%esp
  802268:	53                   	push   %ebx
  802269:	ff 75 10             	pushl  0x10(%ebp)
  80226c:	e8 c4 df ff ff       	call   800235 <vcprintf>
	cprintf("\n");
  802271:	c7 04 24 41 26 80 00 	movl   $0x802641,(%esp)
  802278:	e8 09 e0 ff ff       	call   800286 <cprintf>
  80227d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802280:	cc                   	int3   
  802281:	eb fd                	jmp    802280 <_panic+0x5e>

00802283 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802283:	55                   	push   %ebp
  802284:	89 e5                	mov    %esp,%ebp
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	8b 75 08             	mov    0x8(%ebp),%esi
  80228b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802291:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802293:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802298:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80229b:	83 ec 0c             	sub    $0xc,%esp
  80229e:	50                   	push   %eax
  80229f:	e8 e3 ec ff ff       	call   800f87 <sys_ipc_recv>
	if(ret < 0){
  8022a4:	83 c4 10             	add    $0x10,%esp
  8022a7:	85 c0                	test   %eax,%eax
  8022a9:	78 2b                	js     8022d6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022ab:	85 f6                	test   %esi,%esi
  8022ad:	74 0a                	je     8022b9 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022af:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b4:	8b 40 74             	mov    0x74(%eax),%eax
  8022b7:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022b9:	85 db                	test   %ebx,%ebx
  8022bb:	74 0a                	je     8022c7 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022bd:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c2:	8b 40 78             	mov    0x78(%eax),%eax
  8022c5:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022c7:	a1 08 40 80 00       	mov    0x804008,%eax
  8022cc:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d2:	5b                   	pop    %ebx
  8022d3:	5e                   	pop    %esi
  8022d4:	5d                   	pop    %ebp
  8022d5:	c3                   	ret    
		if(from_env_store)
  8022d6:	85 f6                	test   %esi,%esi
  8022d8:	74 06                	je     8022e0 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022da:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022e0:	85 db                	test   %ebx,%ebx
  8022e2:	74 eb                	je     8022cf <ipc_recv+0x4c>
			*perm_store = 0;
  8022e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022ea:	eb e3                	jmp    8022cf <ipc_recv+0x4c>

008022ec <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022ec:	55                   	push   %ebp
  8022ed:	89 e5                	mov    %esp,%ebp
  8022ef:	57                   	push   %edi
  8022f0:	56                   	push   %esi
  8022f1:	53                   	push   %ebx
  8022f2:	83 ec 0c             	sub    $0xc,%esp
  8022f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022fb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022fe:	85 db                	test   %ebx,%ebx
  802300:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802305:	0f 44 d8             	cmove  %eax,%ebx
  802308:	eb 05                	jmp    80230f <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80230a:	e8 a9 ea ff ff       	call   800db8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  80230f:	ff 75 14             	pushl  0x14(%ebp)
  802312:	53                   	push   %ebx
  802313:	56                   	push   %esi
  802314:	57                   	push   %edi
  802315:	e8 4a ec ff ff       	call   800f64 <sys_ipc_try_send>
  80231a:	83 c4 10             	add    $0x10,%esp
  80231d:	85 c0                	test   %eax,%eax
  80231f:	74 1b                	je     80233c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802321:	79 e7                	jns    80230a <ipc_send+0x1e>
  802323:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802326:	74 e2                	je     80230a <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802328:	83 ec 04             	sub    $0x4,%esp
  80232b:	68 87 2b 80 00       	push   $0x802b87
  802330:	6a 46                	push   $0x46
  802332:	68 9c 2b 80 00       	push   $0x802b9c
  802337:	e8 e6 fe ff ff       	call   802222 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80233c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80233f:	5b                   	pop    %ebx
  802340:	5e                   	pop    %esi
  802341:	5f                   	pop    %edi
  802342:	5d                   	pop    %ebp
  802343:	c3                   	ret    

00802344 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80234a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80234f:	89 c2                	mov    %eax,%edx
  802351:	c1 e2 07             	shl    $0x7,%edx
  802354:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80235a:	8b 52 50             	mov    0x50(%edx),%edx
  80235d:	39 ca                	cmp    %ecx,%edx
  80235f:	74 11                	je     802372 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802361:	83 c0 01             	add    $0x1,%eax
  802364:	3d 00 04 00 00       	cmp    $0x400,%eax
  802369:	75 e4                	jne    80234f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80236b:	b8 00 00 00 00       	mov    $0x0,%eax
  802370:	eb 0b                	jmp    80237d <ipc_find_env+0x39>
			return envs[i].env_id;
  802372:	c1 e0 07             	shl    $0x7,%eax
  802375:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80237a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802385:	89 d0                	mov    %edx,%eax
  802387:	c1 e8 16             	shr    $0x16,%eax
  80238a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802391:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802396:	f6 c1 01             	test   $0x1,%cl
  802399:	74 1d                	je     8023b8 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80239b:	c1 ea 0c             	shr    $0xc,%edx
  80239e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023a5:	f6 c2 01             	test   $0x1,%dl
  8023a8:	74 0e                	je     8023b8 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023aa:	c1 ea 0c             	shr    $0xc,%edx
  8023ad:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023b4:	ef 
  8023b5:	0f b7 c0             	movzwl %ax,%eax
}
  8023b8:	5d                   	pop    %ebp
  8023b9:	c3                   	ret    
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__udivdi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 1c             	sub    $0x1c,%esp
  8023c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023d7:	85 d2                	test   %edx,%edx
  8023d9:	75 4d                	jne    802428 <__udivdi3+0x68>
  8023db:	39 f3                	cmp    %esi,%ebx
  8023dd:	76 19                	jbe    8023f8 <__udivdi3+0x38>
  8023df:	31 ff                	xor    %edi,%edi
  8023e1:	89 e8                	mov    %ebp,%eax
  8023e3:	89 f2                	mov    %esi,%edx
  8023e5:	f7 f3                	div    %ebx
  8023e7:	89 fa                	mov    %edi,%edx
  8023e9:	83 c4 1c             	add    $0x1c,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
  8023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	89 d9                	mov    %ebx,%ecx
  8023fa:	85 db                	test   %ebx,%ebx
  8023fc:	75 0b                	jne    802409 <__udivdi3+0x49>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f3                	div    %ebx
  802407:	89 c1                	mov    %eax,%ecx
  802409:	31 d2                	xor    %edx,%edx
  80240b:	89 f0                	mov    %esi,%eax
  80240d:	f7 f1                	div    %ecx
  80240f:	89 c6                	mov    %eax,%esi
  802411:	89 e8                	mov    %ebp,%eax
  802413:	89 f7                	mov    %esi,%edi
  802415:	f7 f1                	div    %ecx
  802417:	89 fa                	mov    %edi,%edx
  802419:	83 c4 1c             	add    $0x1c,%esp
  80241c:	5b                   	pop    %ebx
  80241d:	5e                   	pop    %esi
  80241e:	5f                   	pop    %edi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    
  802421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802428:	39 f2                	cmp    %esi,%edx
  80242a:	77 1c                	ja     802448 <__udivdi3+0x88>
  80242c:	0f bd fa             	bsr    %edx,%edi
  80242f:	83 f7 1f             	xor    $0x1f,%edi
  802432:	75 2c                	jne    802460 <__udivdi3+0xa0>
  802434:	39 f2                	cmp    %esi,%edx
  802436:	72 06                	jb     80243e <__udivdi3+0x7e>
  802438:	31 c0                	xor    %eax,%eax
  80243a:	39 eb                	cmp    %ebp,%ebx
  80243c:	77 a9                	ja     8023e7 <__udivdi3+0x27>
  80243e:	b8 01 00 00 00       	mov    $0x1,%eax
  802443:	eb a2                	jmp    8023e7 <__udivdi3+0x27>
  802445:	8d 76 00             	lea    0x0(%esi),%esi
  802448:	31 ff                	xor    %edi,%edi
  80244a:	31 c0                	xor    %eax,%eax
  80244c:	89 fa                	mov    %edi,%edx
  80244e:	83 c4 1c             	add    $0x1c,%esp
  802451:	5b                   	pop    %ebx
  802452:	5e                   	pop    %esi
  802453:	5f                   	pop    %edi
  802454:	5d                   	pop    %ebp
  802455:	c3                   	ret    
  802456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80245d:	8d 76 00             	lea    0x0(%esi),%esi
  802460:	89 f9                	mov    %edi,%ecx
  802462:	b8 20 00 00 00       	mov    $0x20,%eax
  802467:	29 f8                	sub    %edi,%eax
  802469:	d3 e2                	shl    %cl,%edx
  80246b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80246f:	89 c1                	mov    %eax,%ecx
  802471:	89 da                	mov    %ebx,%edx
  802473:	d3 ea                	shr    %cl,%edx
  802475:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802479:	09 d1                	or     %edx,%ecx
  80247b:	89 f2                	mov    %esi,%edx
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 f9                	mov    %edi,%ecx
  802483:	d3 e3                	shl    %cl,%ebx
  802485:	89 c1                	mov    %eax,%ecx
  802487:	d3 ea                	shr    %cl,%edx
  802489:	89 f9                	mov    %edi,%ecx
  80248b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80248f:	89 eb                	mov    %ebp,%ebx
  802491:	d3 e6                	shl    %cl,%esi
  802493:	89 c1                	mov    %eax,%ecx
  802495:	d3 eb                	shr    %cl,%ebx
  802497:	09 de                	or     %ebx,%esi
  802499:	89 f0                	mov    %esi,%eax
  80249b:	f7 74 24 08          	divl   0x8(%esp)
  80249f:	89 d6                	mov    %edx,%esi
  8024a1:	89 c3                	mov    %eax,%ebx
  8024a3:	f7 64 24 0c          	mull   0xc(%esp)
  8024a7:	39 d6                	cmp    %edx,%esi
  8024a9:	72 15                	jb     8024c0 <__udivdi3+0x100>
  8024ab:	89 f9                	mov    %edi,%ecx
  8024ad:	d3 e5                	shl    %cl,%ebp
  8024af:	39 c5                	cmp    %eax,%ebp
  8024b1:	73 04                	jae    8024b7 <__udivdi3+0xf7>
  8024b3:	39 d6                	cmp    %edx,%esi
  8024b5:	74 09                	je     8024c0 <__udivdi3+0x100>
  8024b7:	89 d8                	mov    %ebx,%eax
  8024b9:	31 ff                	xor    %edi,%edi
  8024bb:	e9 27 ff ff ff       	jmp    8023e7 <__udivdi3+0x27>
  8024c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024c3:	31 ff                	xor    %edi,%edi
  8024c5:	e9 1d ff ff ff       	jmp    8023e7 <__udivdi3+0x27>
  8024ca:	66 90                	xchg   %ax,%ax
  8024cc:	66 90                	xchg   %ax,%ax
  8024ce:	66 90                	xchg   %ax,%ax

008024d0 <__umoddi3>:
  8024d0:	55                   	push   %ebp
  8024d1:	57                   	push   %edi
  8024d2:	56                   	push   %esi
  8024d3:	53                   	push   %ebx
  8024d4:	83 ec 1c             	sub    $0x1c,%esp
  8024d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024e7:	89 da                	mov    %ebx,%edx
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	75 43                	jne    802530 <__umoddi3+0x60>
  8024ed:	39 df                	cmp    %ebx,%edi
  8024ef:	76 17                	jbe    802508 <__umoddi3+0x38>
  8024f1:	89 f0                	mov    %esi,%eax
  8024f3:	f7 f7                	div    %edi
  8024f5:	89 d0                	mov    %edx,%eax
  8024f7:	31 d2                	xor    %edx,%edx
  8024f9:	83 c4 1c             	add    $0x1c,%esp
  8024fc:	5b                   	pop    %ebx
  8024fd:	5e                   	pop    %esi
  8024fe:	5f                   	pop    %edi
  8024ff:	5d                   	pop    %ebp
  802500:	c3                   	ret    
  802501:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802508:	89 fd                	mov    %edi,%ebp
  80250a:	85 ff                	test   %edi,%edi
  80250c:	75 0b                	jne    802519 <__umoddi3+0x49>
  80250e:	b8 01 00 00 00       	mov    $0x1,%eax
  802513:	31 d2                	xor    %edx,%edx
  802515:	f7 f7                	div    %edi
  802517:	89 c5                	mov    %eax,%ebp
  802519:	89 d8                	mov    %ebx,%eax
  80251b:	31 d2                	xor    %edx,%edx
  80251d:	f7 f5                	div    %ebp
  80251f:	89 f0                	mov    %esi,%eax
  802521:	f7 f5                	div    %ebp
  802523:	89 d0                	mov    %edx,%eax
  802525:	eb d0                	jmp    8024f7 <__umoddi3+0x27>
  802527:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80252e:	66 90                	xchg   %ax,%ax
  802530:	89 f1                	mov    %esi,%ecx
  802532:	39 d8                	cmp    %ebx,%eax
  802534:	76 0a                	jbe    802540 <__umoddi3+0x70>
  802536:	89 f0                	mov    %esi,%eax
  802538:	83 c4 1c             	add    $0x1c,%esp
  80253b:	5b                   	pop    %ebx
  80253c:	5e                   	pop    %esi
  80253d:	5f                   	pop    %edi
  80253e:	5d                   	pop    %ebp
  80253f:	c3                   	ret    
  802540:	0f bd e8             	bsr    %eax,%ebp
  802543:	83 f5 1f             	xor    $0x1f,%ebp
  802546:	75 20                	jne    802568 <__umoddi3+0x98>
  802548:	39 d8                	cmp    %ebx,%eax
  80254a:	0f 82 b0 00 00 00    	jb     802600 <__umoddi3+0x130>
  802550:	39 f7                	cmp    %esi,%edi
  802552:	0f 86 a8 00 00 00    	jbe    802600 <__umoddi3+0x130>
  802558:	89 c8                	mov    %ecx,%eax
  80255a:	83 c4 1c             	add    $0x1c,%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5e                   	pop    %esi
  80255f:	5f                   	pop    %edi
  802560:	5d                   	pop    %ebp
  802561:	c3                   	ret    
  802562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802568:	89 e9                	mov    %ebp,%ecx
  80256a:	ba 20 00 00 00       	mov    $0x20,%edx
  80256f:	29 ea                	sub    %ebp,%edx
  802571:	d3 e0                	shl    %cl,%eax
  802573:	89 44 24 08          	mov    %eax,0x8(%esp)
  802577:	89 d1                	mov    %edx,%ecx
  802579:	89 f8                	mov    %edi,%eax
  80257b:	d3 e8                	shr    %cl,%eax
  80257d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802581:	89 54 24 04          	mov    %edx,0x4(%esp)
  802585:	8b 54 24 04          	mov    0x4(%esp),%edx
  802589:	09 c1                	or     %eax,%ecx
  80258b:	89 d8                	mov    %ebx,%eax
  80258d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802591:	89 e9                	mov    %ebp,%ecx
  802593:	d3 e7                	shl    %cl,%edi
  802595:	89 d1                	mov    %edx,%ecx
  802597:	d3 e8                	shr    %cl,%eax
  802599:	89 e9                	mov    %ebp,%ecx
  80259b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80259f:	d3 e3                	shl    %cl,%ebx
  8025a1:	89 c7                	mov    %eax,%edi
  8025a3:	89 d1                	mov    %edx,%ecx
  8025a5:	89 f0                	mov    %esi,%eax
  8025a7:	d3 e8                	shr    %cl,%eax
  8025a9:	89 e9                	mov    %ebp,%ecx
  8025ab:	89 fa                	mov    %edi,%edx
  8025ad:	d3 e6                	shl    %cl,%esi
  8025af:	09 d8                	or     %ebx,%eax
  8025b1:	f7 74 24 08          	divl   0x8(%esp)
  8025b5:	89 d1                	mov    %edx,%ecx
  8025b7:	89 f3                	mov    %esi,%ebx
  8025b9:	f7 64 24 0c          	mull   0xc(%esp)
  8025bd:	89 c6                	mov    %eax,%esi
  8025bf:	89 d7                	mov    %edx,%edi
  8025c1:	39 d1                	cmp    %edx,%ecx
  8025c3:	72 06                	jb     8025cb <__umoddi3+0xfb>
  8025c5:	75 10                	jne    8025d7 <__umoddi3+0x107>
  8025c7:	39 c3                	cmp    %eax,%ebx
  8025c9:	73 0c                	jae    8025d7 <__umoddi3+0x107>
  8025cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025d3:	89 d7                	mov    %edx,%edi
  8025d5:	89 c6                	mov    %eax,%esi
  8025d7:	89 ca                	mov    %ecx,%edx
  8025d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025de:	29 f3                	sub    %esi,%ebx
  8025e0:	19 fa                	sbb    %edi,%edx
  8025e2:	89 d0                	mov    %edx,%eax
  8025e4:	d3 e0                	shl    %cl,%eax
  8025e6:	89 e9                	mov    %ebp,%ecx
  8025e8:	d3 eb                	shr    %cl,%ebx
  8025ea:	d3 ea                	shr    %cl,%edx
  8025ec:	09 d8                	or     %ebx,%eax
  8025ee:	83 c4 1c             	add    $0x1c,%esp
  8025f1:	5b                   	pop    %ebx
  8025f2:	5e                   	pop    %esi
  8025f3:	5f                   	pop    %edi
  8025f4:	5d                   	pop    %ebp
  8025f5:	c3                   	ret    
  8025f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025fd:	8d 76 00             	lea    0x0(%esi),%esi
  802600:	89 da                	mov    %ebx,%edx
  802602:	29 fe                	sub    %edi,%esi
  802604:	19 c2                	sbb    %eax,%edx
  802606:	89 f1                	mov    %esi,%ecx
  802608:	89 c8                	mov    %ecx,%eax
  80260a:	e9 4b ff ff ff       	jmp    80255a <__umoddi3+0x8a>
