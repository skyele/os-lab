
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
  800058:	68 00 26 80 00       	push   $0x802600
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
  800087:	68 03 26 80 00       	push   $0x802603
  80008c:	6a 01                	push   $0x1
  80008e:	e8 ce 13 00 00       	call   801461 <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 0b 09 00 00       	call   8009ac <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 b2 13 00 00       	call   801461 <write>
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
  8000d3:	68 21 26 80 00       	push   $0x802621
  8000d8:	6a 01                	push   $0x1
  8000da:	e8 82 13 00 00       	call   801461 <write>
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
  800167:	68 05 26 80 00       	push   $0x802605
  80016c:	e8 15 01 00 00       	call   800286 <cprintf>
	cprintf("before umain\n");
  800171:	c7 04 24 23 26 80 00 	movl   $0x802623,(%esp)
  800178:	e8 09 01 00 00       	call   800286 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017d:	83 c4 08             	add    $0x8,%esp
  800180:	ff 75 0c             	pushl  0xc(%ebp)
  800183:	ff 75 08             	pushl  0x8(%ebp)
  800186:	e8 a8 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80018b:	c7 04 24 31 26 80 00 	movl   $0x802631,(%esp)
  800192:	e8 ef 00 00 00       	call   800286 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800197:	a1 08 40 80 00       	mov    0x804008,%eax
  80019c:	8b 40 48             	mov    0x48(%eax),%eax
  80019f:	83 c4 08             	add    $0x8,%esp
  8001a2:	50                   	push   %eax
  8001a3:	68 3e 26 80 00       	push   $0x80263e
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
  8001cb:	68 68 26 80 00       	push   $0x802668
  8001d0:	50                   	push   %eax
  8001d1:	68 5d 26 80 00       	push   $0x80265d
  8001d6:	e8 ab 00 00 00       	call   800286 <cprintf>
	close_all();
  8001db:	e8 a4 10 00 00       	call   801284 <close_all>
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
  800333:	e8 68 20 00 00       	call   8023a0 <__udivdi3>
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
  80035c:	e8 4f 21 00 00       	call   8024b0 <__umoddi3>
  800361:	83 c4 14             	add    $0x14,%esp
  800364:	0f be 80 6d 26 80 00 	movsbl 0x80266d(%eax),%eax
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
  80040d:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
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
  8004d8:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  8004df:	85 d2                	test   %edx,%edx
  8004e1:	74 18                	je     8004fb <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004e3:	52                   	push   %edx
  8004e4:	68 bd 2a 80 00       	push   $0x802abd
  8004e9:	53                   	push   %ebx
  8004ea:	56                   	push   %esi
  8004eb:	e8 a6 fe ff ff       	call   800396 <printfmt>
  8004f0:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f3:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f6:	e9 fe 02 00 00       	jmp    8007f9 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004fb:	50                   	push   %eax
  8004fc:	68 85 26 80 00       	push   $0x802685
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
  800523:	b8 7e 26 80 00       	mov    $0x80267e,%eax
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
  8008bb:	bf a1 27 80 00       	mov    $0x8027a1,%edi
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
  8008e7:	bf d9 27 80 00       	mov    $0x8027d9,%edi
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
  800d88:	68 e8 29 80 00       	push   $0x8029e8
  800d8d:	6a 43                	push   $0x43
  800d8f:	68 05 2a 80 00       	push   $0x802a05
  800d94:	e8 69 14 00 00       	call   802202 <_panic>

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
  800e09:	68 e8 29 80 00       	push   $0x8029e8
  800e0e:	6a 43                	push   $0x43
  800e10:	68 05 2a 80 00       	push   $0x802a05
  800e15:	e8 e8 13 00 00       	call   802202 <_panic>

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
  800e4b:	68 e8 29 80 00       	push   $0x8029e8
  800e50:	6a 43                	push   $0x43
  800e52:	68 05 2a 80 00       	push   $0x802a05
  800e57:	e8 a6 13 00 00       	call   802202 <_panic>

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
  800e8d:	68 e8 29 80 00       	push   $0x8029e8
  800e92:	6a 43                	push   $0x43
  800e94:	68 05 2a 80 00       	push   $0x802a05
  800e99:	e8 64 13 00 00       	call   802202 <_panic>

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
  800ecf:	68 e8 29 80 00       	push   $0x8029e8
  800ed4:	6a 43                	push   $0x43
  800ed6:	68 05 2a 80 00       	push   $0x802a05
  800edb:	e8 22 13 00 00       	call   802202 <_panic>

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
  800f11:	68 e8 29 80 00       	push   $0x8029e8
  800f16:	6a 43                	push   $0x43
  800f18:	68 05 2a 80 00       	push   $0x802a05
  800f1d:	e8 e0 12 00 00       	call   802202 <_panic>

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
  800f53:	68 e8 29 80 00       	push   $0x8029e8
  800f58:	6a 43                	push   $0x43
  800f5a:	68 05 2a 80 00       	push   $0x802a05
  800f5f:	e8 9e 12 00 00       	call   802202 <_panic>

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
  800fb7:	68 e8 29 80 00       	push   $0x8029e8
  800fbc:	6a 43                	push   $0x43
  800fbe:	68 05 2a 80 00       	push   $0x802a05
  800fc3:	e8 3a 12 00 00       	call   802202 <_panic>

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
  80109b:	68 e8 29 80 00       	push   $0x8029e8
  8010a0:	6a 43                	push   $0x43
  8010a2:	68 05 2a 80 00       	push   $0x802a05
  8010a7:	e8 56 11 00 00       	call   802202 <_panic>

008010ac <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010ac:	55                   	push   %ebp
  8010ad:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	05 00 00 00 30       	add    $0x30000000,%eax
  8010b7:	c1 e8 0c             	shr    $0xc,%eax
}
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010c7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010cc:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010d1:	5d                   	pop    %ebp
  8010d2:	c3                   	ret    

008010d3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010d3:	55                   	push   %ebp
  8010d4:	89 e5                	mov    %esp,%ebp
  8010d6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010db:	89 c2                	mov    %eax,%edx
  8010dd:	c1 ea 16             	shr    $0x16,%edx
  8010e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010e7:	f6 c2 01             	test   $0x1,%dl
  8010ea:	74 2d                	je     801119 <fd_alloc+0x46>
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	c1 ea 0c             	shr    $0xc,%edx
  8010f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f8:	f6 c2 01             	test   $0x1,%dl
  8010fb:	74 1c                	je     801119 <fd_alloc+0x46>
  8010fd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801102:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801107:	75 d2                	jne    8010db <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801109:	8b 45 08             	mov    0x8(%ebp),%eax
  80110c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801112:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801117:	eb 0a                	jmp    801123 <fd_alloc+0x50>
			*fd_store = fd;
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80111e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80112b:	83 f8 1f             	cmp    $0x1f,%eax
  80112e:	77 30                	ja     801160 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801130:	c1 e0 0c             	shl    $0xc,%eax
  801133:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801138:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80113e:	f6 c2 01             	test   $0x1,%dl
  801141:	74 24                	je     801167 <fd_lookup+0x42>
  801143:	89 c2                	mov    %eax,%edx
  801145:	c1 ea 0c             	shr    $0xc,%edx
  801148:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80114f:	f6 c2 01             	test   $0x1,%dl
  801152:	74 1a                	je     80116e <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801154:	8b 55 0c             	mov    0xc(%ebp),%edx
  801157:	89 02                	mov    %eax,(%edx)
	return 0;
  801159:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115e:	5d                   	pop    %ebp
  80115f:	c3                   	ret    
		return -E_INVAL;
  801160:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801165:	eb f7                	jmp    80115e <fd_lookup+0x39>
		return -E_INVAL;
  801167:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116c:	eb f0                	jmp    80115e <fd_lookup+0x39>
  80116e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801173:	eb e9                	jmp    80115e <fd_lookup+0x39>

00801175 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801175:	55                   	push   %ebp
  801176:	89 e5                	mov    %esp,%ebp
  801178:	83 ec 08             	sub    $0x8,%esp
  80117b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80117e:	ba 00 00 00 00       	mov    $0x0,%edx
  801183:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801188:	39 08                	cmp    %ecx,(%eax)
  80118a:	74 38                	je     8011c4 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80118c:	83 c2 01             	add    $0x1,%edx
  80118f:	8b 04 95 90 2a 80 00 	mov    0x802a90(,%edx,4),%eax
  801196:	85 c0                	test   %eax,%eax
  801198:	75 ee                	jne    801188 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80119a:	a1 08 40 80 00       	mov    0x804008,%eax
  80119f:	8b 40 48             	mov    0x48(%eax),%eax
  8011a2:	83 ec 04             	sub    $0x4,%esp
  8011a5:	51                   	push   %ecx
  8011a6:	50                   	push   %eax
  8011a7:	68 14 2a 80 00       	push   $0x802a14
  8011ac:	e8 d5 f0 ff ff       	call   800286 <cprintf>
	*dev = 0;
  8011b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011ba:	83 c4 10             	add    $0x10,%esp
  8011bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011c2:	c9                   	leave  
  8011c3:	c3                   	ret    
			*dev = devtab[i];
  8011c4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb f2                	jmp    8011c2 <dev_lookup+0x4d>

008011d0 <fd_close>:
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	57                   	push   %edi
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 24             	sub    $0x24,%esp
  8011d9:	8b 75 08             	mov    0x8(%ebp),%esi
  8011dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011df:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011e2:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011e3:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e9:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011ec:	50                   	push   %eax
  8011ed:	e8 33 ff ff ff       	call   801125 <fd_lookup>
  8011f2:	89 c3                	mov    %eax,%ebx
  8011f4:	83 c4 10             	add    $0x10,%esp
  8011f7:	85 c0                	test   %eax,%eax
  8011f9:	78 05                	js     801200 <fd_close+0x30>
	    || fd != fd2)
  8011fb:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011fe:	74 16                	je     801216 <fd_close+0x46>
		return (must_exist ? r : 0);
  801200:	89 f8                	mov    %edi,%eax
  801202:	84 c0                	test   %al,%al
  801204:	b8 00 00 00 00       	mov    $0x0,%eax
  801209:	0f 44 d8             	cmove  %eax,%ebx
}
  80120c:	89 d8                	mov    %ebx,%eax
  80120e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801211:	5b                   	pop    %ebx
  801212:	5e                   	pop    %esi
  801213:	5f                   	pop    %edi
  801214:	5d                   	pop    %ebp
  801215:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801216:	83 ec 08             	sub    $0x8,%esp
  801219:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80121c:	50                   	push   %eax
  80121d:	ff 36                	pushl  (%esi)
  80121f:	e8 51 ff ff ff       	call   801175 <dev_lookup>
  801224:	89 c3                	mov    %eax,%ebx
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	78 1a                	js     801247 <fd_close+0x77>
		if (dev->dev_close)
  80122d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801230:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801233:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801238:	85 c0                	test   %eax,%eax
  80123a:	74 0b                	je     801247 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80123c:	83 ec 0c             	sub    $0xc,%esp
  80123f:	56                   	push   %esi
  801240:	ff d0                	call   *%eax
  801242:	89 c3                	mov    %eax,%ebx
  801244:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801247:	83 ec 08             	sub    $0x8,%esp
  80124a:	56                   	push   %esi
  80124b:	6a 00                	push   $0x0
  80124d:	e8 0a fc ff ff       	call   800e5c <sys_page_unmap>
	return r;
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	eb b5                	jmp    80120c <fd_close+0x3c>

00801257 <close>:

int
close(int fdnum)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80125d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801260:	50                   	push   %eax
  801261:	ff 75 08             	pushl  0x8(%ebp)
  801264:	e8 bc fe ff ff       	call   801125 <fd_lookup>
  801269:	83 c4 10             	add    $0x10,%esp
  80126c:	85 c0                	test   %eax,%eax
  80126e:	79 02                	jns    801272 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    
		return fd_close(fd, 1);
  801272:	83 ec 08             	sub    $0x8,%esp
  801275:	6a 01                	push   $0x1
  801277:	ff 75 f4             	pushl  -0xc(%ebp)
  80127a:	e8 51 ff ff ff       	call   8011d0 <fd_close>
  80127f:	83 c4 10             	add    $0x10,%esp
  801282:	eb ec                	jmp    801270 <close+0x19>

00801284 <close_all>:

void
close_all(void)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	53                   	push   %ebx
  801288:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80128b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801290:	83 ec 0c             	sub    $0xc,%esp
  801293:	53                   	push   %ebx
  801294:	e8 be ff ff ff       	call   801257 <close>
	for (i = 0; i < MAXFD; i++)
  801299:	83 c3 01             	add    $0x1,%ebx
  80129c:	83 c4 10             	add    $0x10,%esp
  80129f:	83 fb 20             	cmp    $0x20,%ebx
  8012a2:	75 ec                	jne    801290 <close_all+0xc>
}
  8012a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012a7:	c9                   	leave  
  8012a8:	c3                   	ret    

008012a9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012a9:	55                   	push   %ebp
  8012aa:	89 e5                	mov    %esp,%ebp
  8012ac:	57                   	push   %edi
  8012ad:	56                   	push   %esi
  8012ae:	53                   	push   %ebx
  8012af:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012b2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012b5:	50                   	push   %eax
  8012b6:	ff 75 08             	pushl  0x8(%ebp)
  8012b9:	e8 67 fe ff ff       	call   801125 <fd_lookup>
  8012be:	89 c3                	mov    %eax,%ebx
  8012c0:	83 c4 10             	add    $0x10,%esp
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	0f 88 81 00 00 00    	js     80134c <dup+0xa3>
		return r;
	close(newfdnum);
  8012cb:	83 ec 0c             	sub    $0xc,%esp
  8012ce:	ff 75 0c             	pushl  0xc(%ebp)
  8012d1:	e8 81 ff ff ff       	call   801257 <close>

	newfd = INDEX2FD(newfdnum);
  8012d6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012d9:	c1 e6 0c             	shl    $0xc,%esi
  8012dc:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012e2:	83 c4 04             	add    $0x4,%esp
  8012e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e8:	e8 cf fd ff ff       	call   8010bc <fd2data>
  8012ed:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012ef:	89 34 24             	mov    %esi,(%esp)
  8012f2:	e8 c5 fd ff ff       	call   8010bc <fd2data>
  8012f7:	83 c4 10             	add    $0x10,%esp
  8012fa:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012fc:	89 d8                	mov    %ebx,%eax
  8012fe:	c1 e8 16             	shr    $0x16,%eax
  801301:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801308:	a8 01                	test   $0x1,%al
  80130a:	74 11                	je     80131d <dup+0x74>
  80130c:	89 d8                	mov    %ebx,%eax
  80130e:	c1 e8 0c             	shr    $0xc,%eax
  801311:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801318:	f6 c2 01             	test   $0x1,%dl
  80131b:	75 39                	jne    801356 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80131d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801320:	89 d0                	mov    %edx,%eax
  801322:	c1 e8 0c             	shr    $0xc,%eax
  801325:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80132c:	83 ec 0c             	sub    $0xc,%esp
  80132f:	25 07 0e 00 00       	and    $0xe07,%eax
  801334:	50                   	push   %eax
  801335:	56                   	push   %esi
  801336:	6a 00                	push   $0x0
  801338:	52                   	push   %edx
  801339:	6a 00                	push   $0x0
  80133b:	e8 da fa ff ff       	call   800e1a <sys_page_map>
  801340:	89 c3                	mov    %eax,%ebx
  801342:	83 c4 20             	add    $0x20,%esp
  801345:	85 c0                	test   %eax,%eax
  801347:	78 31                	js     80137a <dup+0xd1>
		goto err;

	return newfdnum;
  801349:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80134c:	89 d8                	mov    %ebx,%eax
  80134e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5f                   	pop    %edi
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801356:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80135d:	83 ec 0c             	sub    $0xc,%esp
  801360:	25 07 0e 00 00       	and    $0xe07,%eax
  801365:	50                   	push   %eax
  801366:	57                   	push   %edi
  801367:	6a 00                	push   $0x0
  801369:	53                   	push   %ebx
  80136a:	6a 00                	push   $0x0
  80136c:	e8 a9 fa ff ff       	call   800e1a <sys_page_map>
  801371:	89 c3                	mov    %eax,%ebx
  801373:	83 c4 20             	add    $0x20,%esp
  801376:	85 c0                	test   %eax,%eax
  801378:	79 a3                	jns    80131d <dup+0x74>
	sys_page_unmap(0, newfd);
  80137a:	83 ec 08             	sub    $0x8,%esp
  80137d:	56                   	push   %esi
  80137e:	6a 00                	push   $0x0
  801380:	e8 d7 fa ff ff       	call   800e5c <sys_page_unmap>
	sys_page_unmap(0, nva);
  801385:	83 c4 08             	add    $0x8,%esp
  801388:	57                   	push   %edi
  801389:	6a 00                	push   $0x0
  80138b:	e8 cc fa ff ff       	call   800e5c <sys_page_unmap>
	return r;
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	eb b7                	jmp    80134c <dup+0xa3>

00801395 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	53                   	push   %ebx
  801399:	83 ec 1c             	sub    $0x1c,%esp
  80139c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a2:	50                   	push   %eax
  8013a3:	53                   	push   %ebx
  8013a4:	e8 7c fd ff ff       	call   801125 <fd_lookup>
  8013a9:	83 c4 10             	add    $0x10,%esp
  8013ac:	85 c0                	test   %eax,%eax
  8013ae:	78 3f                	js     8013ef <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b0:	83 ec 08             	sub    $0x8,%esp
  8013b3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013b6:	50                   	push   %eax
  8013b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ba:	ff 30                	pushl  (%eax)
  8013bc:	e8 b4 fd ff ff       	call   801175 <dev_lookup>
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	85 c0                	test   %eax,%eax
  8013c6:	78 27                	js     8013ef <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013cb:	8b 42 08             	mov    0x8(%edx),%eax
  8013ce:	83 e0 03             	and    $0x3,%eax
  8013d1:	83 f8 01             	cmp    $0x1,%eax
  8013d4:	74 1e                	je     8013f4 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d9:	8b 40 08             	mov    0x8(%eax),%eax
  8013dc:	85 c0                	test   %eax,%eax
  8013de:	74 35                	je     801415 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013e0:	83 ec 04             	sub    $0x4,%esp
  8013e3:	ff 75 10             	pushl  0x10(%ebp)
  8013e6:	ff 75 0c             	pushl  0xc(%ebp)
  8013e9:	52                   	push   %edx
  8013ea:	ff d0                	call   *%eax
  8013ec:	83 c4 10             	add    $0x10,%esp
}
  8013ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013f2:	c9                   	leave  
  8013f3:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013f4:	a1 08 40 80 00       	mov    0x804008,%eax
  8013f9:	8b 40 48             	mov    0x48(%eax),%eax
  8013fc:	83 ec 04             	sub    $0x4,%esp
  8013ff:	53                   	push   %ebx
  801400:	50                   	push   %eax
  801401:	68 55 2a 80 00       	push   $0x802a55
  801406:	e8 7b ee ff ff       	call   800286 <cprintf>
		return -E_INVAL;
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801413:	eb da                	jmp    8013ef <read+0x5a>
		return -E_NOT_SUPP;
  801415:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80141a:	eb d3                	jmp    8013ef <read+0x5a>

0080141c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80141c:	55                   	push   %ebp
  80141d:	89 e5                	mov    %esp,%ebp
  80141f:	57                   	push   %edi
  801420:	56                   	push   %esi
  801421:	53                   	push   %ebx
  801422:	83 ec 0c             	sub    $0xc,%esp
  801425:	8b 7d 08             	mov    0x8(%ebp),%edi
  801428:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80142b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801430:	39 f3                	cmp    %esi,%ebx
  801432:	73 23                	jae    801457 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	89 f0                	mov    %esi,%eax
  801439:	29 d8                	sub    %ebx,%eax
  80143b:	50                   	push   %eax
  80143c:	89 d8                	mov    %ebx,%eax
  80143e:	03 45 0c             	add    0xc(%ebp),%eax
  801441:	50                   	push   %eax
  801442:	57                   	push   %edi
  801443:	e8 4d ff ff ff       	call   801395 <read>
		if (m < 0)
  801448:	83 c4 10             	add    $0x10,%esp
  80144b:	85 c0                	test   %eax,%eax
  80144d:	78 06                	js     801455 <readn+0x39>
			return m;
		if (m == 0)
  80144f:	74 06                	je     801457 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801451:	01 c3                	add    %eax,%ebx
  801453:	eb db                	jmp    801430 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801455:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801457:	89 d8                	mov    %ebx,%eax
  801459:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80145c:	5b                   	pop    %ebx
  80145d:	5e                   	pop    %esi
  80145e:	5f                   	pop    %edi
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    

00801461 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801461:	55                   	push   %ebp
  801462:	89 e5                	mov    %esp,%ebp
  801464:	53                   	push   %ebx
  801465:	83 ec 1c             	sub    $0x1c,%esp
  801468:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146e:	50                   	push   %eax
  80146f:	53                   	push   %ebx
  801470:	e8 b0 fc ff ff       	call   801125 <fd_lookup>
  801475:	83 c4 10             	add    $0x10,%esp
  801478:	85 c0                	test   %eax,%eax
  80147a:	78 3a                	js     8014b6 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80147c:	83 ec 08             	sub    $0x8,%esp
  80147f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801486:	ff 30                	pushl  (%eax)
  801488:	e8 e8 fc ff ff       	call   801175 <dev_lookup>
  80148d:	83 c4 10             	add    $0x10,%esp
  801490:	85 c0                	test   %eax,%eax
  801492:	78 22                	js     8014b6 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801494:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801497:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80149b:	74 1e                	je     8014bb <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80149d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014a0:	8b 52 0c             	mov    0xc(%edx),%edx
  8014a3:	85 d2                	test   %edx,%edx
  8014a5:	74 35                	je     8014dc <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014a7:	83 ec 04             	sub    $0x4,%esp
  8014aa:	ff 75 10             	pushl  0x10(%ebp)
  8014ad:	ff 75 0c             	pushl  0xc(%ebp)
  8014b0:	50                   	push   %eax
  8014b1:	ff d2                	call   *%edx
  8014b3:	83 c4 10             	add    $0x10,%esp
}
  8014b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014b9:	c9                   	leave  
  8014ba:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014bb:	a1 08 40 80 00       	mov    0x804008,%eax
  8014c0:	8b 40 48             	mov    0x48(%eax),%eax
  8014c3:	83 ec 04             	sub    $0x4,%esp
  8014c6:	53                   	push   %ebx
  8014c7:	50                   	push   %eax
  8014c8:	68 71 2a 80 00       	push   $0x802a71
  8014cd:	e8 b4 ed ff ff       	call   800286 <cprintf>
		return -E_INVAL;
  8014d2:	83 c4 10             	add    $0x10,%esp
  8014d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014da:	eb da                	jmp    8014b6 <write+0x55>
		return -E_NOT_SUPP;
  8014dc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014e1:	eb d3                	jmp    8014b6 <write+0x55>

008014e3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014ec:	50                   	push   %eax
  8014ed:	ff 75 08             	pushl  0x8(%ebp)
  8014f0:	e8 30 fc ff ff       	call   801125 <fd_lookup>
  8014f5:	83 c4 10             	add    $0x10,%esp
  8014f8:	85 c0                	test   %eax,%eax
  8014fa:	78 0e                	js     80150a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801502:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801505:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80150a:	c9                   	leave  
  80150b:	c3                   	ret    

0080150c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80150c:	55                   	push   %ebp
  80150d:	89 e5                	mov    %esp,%ebp
  80150f:	53                   	push   %ebx
  801510:	83 ec 1c             	sub    $0x1c,%esp
  801513:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801516:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801519:	50                   	push   %eax
  80151a:	53                   	push   %ebx
  80151b:	e8 05 fc ff ff       	call   801125 <fd_lookup>
  801520:	83 c4 10             	add    $0x10,%esp
  801523:	85 c0                	test   %eax,%eax
  801525:	78 37                	js     80155e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801527:	83 ec 08             	sub    $0x8,%esp
  80152a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152d:	50                   	push   %eax
  80152e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801531:	ff 30                	pushl  (%eax)
  801533:	e8 3d fc ff ff       	call   801175 <dev_lookup>
  801538:	83 c4 10             	add    $0x10,%esp
  80153b:	85 c0                	test   %eax,%eax
  80153d:	78 1f                	js     80155e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80153f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801542:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801546:	74 1b                	je     801563 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801548:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80154b:	8b 52 18             	mov    0x18(%edx),%edx
  80154e:	85 d2                	test   %edx,%edx
  801550:	74 32                	je     801584 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801552:	83 ec 08             	sub    $0x8,%esp
  801555:	ff 75 0c             	pushl  0xc(%ebp)
  801558:	50                   	push   %eax
  801559:	ff d2                	call   *%edx
  80155b:	83 c4 10             	add    $0x10,%esp
}
  80155e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801561:	c9                   	leave  
  801562:	c3                   	ret    
			thisenv->env_id, fdnum);
  801563:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801568:	8b 40 48             	mov    0x48(%eax),%eax
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	53                   	push   %ebx
  80156f:	50                   	push   %eax
  801570:	68 34 2a 80 00       	push   $0x802a34
  801575:	e8 0c ed ff ff       	call   800286 <cprintf>
		return -E_INVAL;
  80157a:	83 c4 10             	add    $0x10,%esp
  80157d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801582:	eb da                	jmp    80155e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801584:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801589:	eb d3                	jmp    80155e <ftruncate+0x52>

0080158b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80158b:	55                   	push   %ebp
  80158c:	89 e5                	mov    %esp,%ebp
  80158e:	53                   	push   %ebx
  80158f:	83 ec 1c             	sub    $0x1c,%esp
  801592:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801595:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801598:	50                   	push   %eax
  801599:	ff 75 08             	pushl  0x8(%ebp)
  80159c:	e8 84 fb ff ff       	call   801125 <fd_lookup>
  8015a1:	83 c4 10             	add    $0x10,%esp
  8015a4:	85 c0                	test   %eax,%eax
  8015a6:	78 4b                	js     8015f3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015a8:	83 ec 08             	sub    $0x8,%esp
  8015ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ae:	50                   	push   %eax
  8015af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b2:	ff 30                	pushl  (%eax)
  8015b4:	e8 bc fb ff ff       	call   801175 <dev_lookup>
  8015b9:	83 c4 10             	add    $0x10,%esp
  8015bc:	85 c0                	test   %eax,%eax
  8015be:	78 33                	js     8015f3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c3:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015c7:	74 2f                	je     8015f8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015c9:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015d3:	00 00 00 
	stat->st_isdir = 0;
  8015d6:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015dd:	00 00 00 
	stat->st_dev = dev;
  8015e0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015e6:	83 ec 08             	sub    $0x8,%esp
  8015e9:	53                   	push   %ebx
  8015ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8015ed:	ff 50 14             	call   *0x14(%eax)
  8015f0:	83 c4 10             	add    $0x10,%esp
}
  8015f3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f6:	c9                   	leave  
  8015f7:	c3                   	ret    
		return -E_NOT_SUPP;
  8015f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015fd:	eb f4                	jmp    8015f3 <fstat+0x68>

008015ff <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015ff:	55                   	push   %ebp
  801600:	89 e5                	mov    %esp,%ebp
  801602:	56                   	push   %esi
  801603:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801604:	83 ec 08             	sub    $0x8,%esp
  801607:	6a 00                	push   $0x0
  801609:	ff 75 08             	pushl  0x8(%ebp)
  80160c:	e8 22 02 00 00       	call   801833 <open>
  801611:	89 c3                	mov    %eax,%ebx
  801613:	83 c4 10             	add    $0x10,%esp
  801616:	85 c0                	test   %eax,%eax
  801618:	78 1b                	js     801635 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80161a:	83 ec 08             	sub    $0x8,%esp
  80161d:	ff 75 0c             	pushl  0xc(%ebp)
  801620:	50                   	push   %eax
  801621:	e8 65 ff ff ff       	call   80158b <fstat>
  801626:	89 c6                	mov    %eax,%esi
	close(fd);
  801628:	89 1c 24             	mov    %ebx,(%esp)
  80162b:	e8 27 fc ff ff       	call   801257 <close>
	return r;
  801630:	83 c4 10             	add    $0x10,%esp
  801633:	89 f3                	mov    %esi,%ebx
}
  801635:	89 d8                	mov    %ebx,%eax
  801637:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5e                   	pop    %esi
  80163c:	5d                   	pop    %ebp
  80163d:	c3                   	ret    

0080163e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80163e:	55                   	push   %ebp
  80163f:	89 e5                	mov    %esp,%ebp
  801641:	56                   	push   %esi
  801642:	53                   	push   %ebx
  801643:	89 c6                	mov    %eax,%esi
  801645:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801647:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80164e:	74 27                	je     801677 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801650:	6a 07                	push   $0x7
  801652:	68 00 50 80 00       	push   $0x805000
  801657:	56                   	push   %esi
  801658:	ff 35 00 40 80 00    	pushl  0x804000
  80165e:	e8 69 0c 00 00       	call   8022cc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801663:	83 c4 0c             	add    $0xc,%esp
  801666:	6a 00                	push   $0x0
  801668:	53                   	push   %ebx
  801669:	6a 00                	push   $0x0
  80166b:	e8 f3 0b 00 00       	call   802263 <ipc_recv>
}
  801670:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801673:	5b                   	pop    %ebx
  801674:	5e                   	pop    %esi
  801675:	5d                   	pop    %ebp
  801676:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801677:	83 ec 0c             	sub    $0xc,%esp
  80167a:	6a 01                	push   $0x1
  80167c:	e8 a3 0c 00 00       	call   802324 <ipc_find_env>
  801681:	a3 00 40 80 00       	mov    %eax,0x804000
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	eb c5                	jmp    801650 <fsipc+0x12>

0080168b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801691:	8b 45 08             	mov    0x8(%ebp),%eax
  801694:	8b 40 0c             	mov    0xc(%eax),%eax
  801697:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80169c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80169f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a9:	b8 02 00 00 00       	mov    $0x2,%eax
  8016ae:	e8 8b ff ff ff       	call   80163e <fsipc>
}
  8016b3:	c9                   	leave  
  8016b4:	c3                   	ret    

008016b5 <devfile_flush>:
{
  8016b5:	55                   	push   %ebp
  8016b6:	89 e5                	mov    %esp,%ebp
  8016b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c1:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cb:	b8 06 00 00 00       	mov    $0x6,%eax
  8016d0:	e8 69 ff ff ff       	call   80163e <fsipc>
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <devfile_stat>:
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	53                   	push   %ebx
  8016db:	83 ec 04             	sub    $0x4,%esp
  8016de:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e7:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f1:	b8 05 00 00 00       	mov    $0x5,%eax
  8016f6:	e8 43 ff ff ff       	call   80163e <fsipc>
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 2c                	js     80172b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016ff:	83 ec 08             	sub    $0x8,%esp
  801702:	68 00 50 80 00       	push   $0x805000
  801707:	53                   	push   %ebx
  801708:	e8 d8 f2 ff ff       	call   8009e5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80170d:	a1 80 50 80 00       	mov    0x805080,%eax
  801712:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801718:	a1 84 50 80 00       	mov    0x805084,%eax
  80171d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801723:	83 c4 10             	add    $0x10,%esp
  801726:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80172b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <devfile_write>:
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
  801733:	53                   	push   %ebx
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80173a:	8b 45 08             	mov    0x8(%ebp),%eax
  80173d:	8b 40 0c             	mov    0xc(%eax),%eax
  801740:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801745:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80174b:	53                   	push   %ebx
  80174c:	ff 75 0c             	pushl  0xc(%ebp)
  80174f:	68 08 50 80 00       	push   $0x805008
  801754:	e8 7c f4 ff ff       	call   800bd5 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  801759:	ba 00 00 00 00       	mov    $0x0,%edx
  80175e:	b8 04 00 00 00       	mov    $0x4,%eax
  801763:	e8 d6 fe ff ff       	call   80163e <fsipc>
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	85 c0                	test   %eax,%eax
  80176d:	78 0b                	js     80177a <devfile_write+0x4a>
	assert(r <= n);
  80176f:	39 d8                	cmp    %ebx,%eax
  801771:	77 0c                	ja     80177f <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801773:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801778:	7f 1e                	jg     801798 <devfile_write+0x68>
}
  80177a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    
	assert(r <= n);
  80177f:	68 a4 2a 80 00       	push   $0x802aa4
  801784:	68 ab 2a 80 00       	push   $0x802aab
  801789:	68 98 00 00 00       	push   $0x98
  80178e:	68 c0 2a 80 00       	push   $0x802ac0
  801793:	e8 6a 0a 00 00       	call   802202 <_panic>
	assert(r <= PGSIZE);
  801798:	68 cb 2a 80 00       	push   $0x802acb
  80179d:	68 ab 2a 80 00       	push   $0x802aab
  8017a2:	68 99 00 00 00       	push   $0x99
  8017a7:	68 c0 2a 80 00       	push   $0x802ac0
  8017ac:	e8 51 0a 00 00       	call   802202 <_panic>

008017b1 <devfile_read>:
{
  8017b1:	55                   	push   %ebp
  8017b2:	89 e5                	mov    %esp,%ebp
  8017b4:	56                   	push   %esi
  8017b5:	53                   	push   %ebx
  8017b6:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8017bf:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017c4:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cf:	b8 03 00 00 00       	mov    $0x3,%eax
  8017d4:	e8 65 fe ff ff       	call   80163e <fsipc>
  8017d9:	89 c3                	mov    %eax,%ebx
  8017db:	85 c0                	test   %eax,%eax
  8017dd:	78 1f                	js     8017fe <devfile_read+0x4d>
	assert(r <= n);
  8017df:	39 f0                	cmp    %esi,%eax
  8017e1:	77 24                	ja     801807 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017e3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017e8:	7f 33                	jg     80181d <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017ea:	83 ec 04             	sub    $0x4,%esp
  8017ed:	50                   	push   %eax
  8017ee:	68 00 50 80 00       	push   $0x805000
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	e8 78 f3 ff ff       	call   800b73 <memmove>
	return r;
  8017fb:	83 c4 10             	add    $0x10,%esp
}
  8017fe:	89 d8                	mov    %ebx,%eax
  801800:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801803:	5b                   	pop    %ebx
  801804:	5e                   	pop    %esi
  801805:	5d                   	pop    %ebp
  801806:	c3                   	ret    
	assert(r <= n);
  801807:	68 a4 2a 80 00       	push   $0x802aa4
  80180c:	68 ab 2a 80 00       	push   $0x802aab
  801811:	6a 7c                	push   $0x7c
  801813:	68 c0 2a 80 00       	push   $0x802ac0
  801818:	e8 e5 09 00 00       	call   802202 <_panic>
	assert(r <= PGSIZE);
  80181d:	68 cb 2a 80 00       	push   $0x802acb
  801822:	68 ab 2a 80 00       	push   $0x802aab
  801827:	6a 7d                	push   $0x7d
  801829:	68 c0 2a 80 00       	push   $0x802ac0
  80182e:	e8 cf 09 00 00       	call   802202 <_panic>

00801833 <open>:
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	56                   	push   %esi
  801837:	53                   	push   %ebx
  801838:	83 ec 1c             	sub    $0x1c,%esp
  80183b:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80183e:	56                   	push   %esi
  80183f:	e8 68 f1 ff ff       	call   8009ac <strlen>
  801844:	83 c4 10             	add    $0x10,%esp
  801847:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80184c:	7f 6c                	jg     8018ba <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80184e:	83 ec 0c             	sub    $0xc,%esp
  801851:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801854:	50                   	push   %eax
  801855:	e8 79 f8 ff ff       	call   8010d3 <fd_alloc>
  80185a:	89 c3                	mov    %eax,%ebx
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	85 c0                	test   %eax,%eax
  801861:	78 3c                	js     80189f <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801863:	83 ec 08             	sub    $0x8,%esp
  801866:	56                   	push   %esi
  801867:	68 00 50 80 00       	push   $0x805000
  80186c:	e8 74 f1 ff ff       	call   8009e5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801871:	8b 45 0c             	mov    0xc(%ebp),%eax
  801874:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801879:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80187c:	b8 01 00 00 00       	mov    $0x1,%eax
  801881:	e8 b8 fd ff ff       	call   80163e <fsipc>
  801886:	89 c3                	mov    %eax,%ebx
  801888:	83 c4 10             	add    $0x10,%esp
  80188b:	85 c0                	test   %eax,%eax
  80188d:	78 19                	js     8018a8 <open+0x75>
	return fd2num(fd);
  80188f:	83 ec 0c             	sub    $0xc,%esp
  801892:	ff 75 f4             	pushl  -0xc(%ebp)
  801895:	e8 12 f8 ff ff       	call   8010ac <fd2num>
  80189a:	89 c3                	mov    %eax,%ebx
  80189c:	83 c4 10             	add    $0x10,%esp
}
  80189f:	89 d8                	mov    %ebx,%eax
  8018a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018a4:	5b                   	pop    %ebx
  8018a5:	5e                   	pop    %esi
  8018a6:	5d                   	pop    %ebp
  8018a7:	c3                   	ret    
		fd_close(fd, 0);
  8018a8:	83 ec 08             	sub    $0x8,%esp
  8018ab:	6a 00                	push   $0x0
  8018ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b0:	e8 1b f9 ff ff       	call   8011d0 <fd_close>
		return r;
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	eb e5                	jmp    80189f <open+0x6c>
		return -E_BAD_PATH;
  8018ba:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018bf:	eb de                	jmp    80189f <open+0x6c>

008018c1 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018cc:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d1:	e8 68 fd ff ff       	call   80163e <fsipc>
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8018de:	68 d7 2a 80 00       	push   $0x802ad7
  8018e3:	ff 75 0c             	pushl  0xc(%ebp)
  8018e6:	e8 fa f0 ff ff       	call   8009e5 <strcpy>
	return 0;
}
  8018eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <devsock_close>:
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	53                   	push   %ebx
  8018f6:	83 ec 10             	sub    $0x10,%esp
  8018f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018fc:	53                   	push   %ebx
  8018fd:	e8 5d 0a 00 00       	call   80235f <pageref>
  801902:	83 c4 10             	add    $0x10,%esp
		return 0;
  801905:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80190a:	83 f8 01             	cmp    $0x1,%eax
  80190d:	74 07                	je     801916 <devsock_close+0x24>
}
  80190f:	89 d0                	mov    %edx,%eax
  801911:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801914:	c9                   	leave  
  801915:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801916:	83 ec 0c             	sub    $0xc,%esp
  801919:	ff 73 0c             	pushl  0xc(%ebx)
  80191c:	e8 b9 02 00 00       	call   801bda <nsipc_close>
  801921:	89 c2                	mov    %eax,%edx
  801923:	83 c4 10             	add    $0x10,%esp
  801926:	eb e7                	jmp    80190f <devsock_close+0x1d>

00801928 <devsock_write>:
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
  80192b:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80192e:	6a 00                	push   $0x0
  801930:	ff 75 10             	pushl  0x10(%ebp)
  801933:	ff 75 0c             	pushl  0xc(%ebp)
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	ff 70 0c             	pushl  0xc(%eax)
  80193c:	e8 76 03 00 00       	call   801cb7 <nsipc_send>
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <devsock_read>:
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801949:	6a 00                	push   $0x0
  80194b:	ff 75 10             	pushl  0x10(%ebp)
  80194e:	ff 75 0c             	pushl  0xc(%ebp)
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	ff 70 0c             	pushl  0xc(%eax)
  801957:	e8 ef 02 00 00       	call   801c4b <nsipc_recv>
}
  80195c:	c9                   	leave  
  80195d:	c3                   	ret    

0080195e <fd2sockid>:
{
  80195e:	55                   	push   %ebp
  80195f:	89 e5                	mov    %esp,%ebp
  801961:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801964:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801967:	52                   	push   %edx
  801968:	50                   	push   %eax
  801969:	e8 b7 f7 ff ff       	call   801125 <fd_lookup>
  80196e:	83 c4 10             	add    $0x10,%esp
  801971:	85 c0                	test   %eax,%eax
  801973:	78 10                	js     801985 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801975:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801978:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80197e:	39 08                	cmp    %ecx,(%eax)
  801980:	75 05                	jne    801987 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801982:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    
		return -E_NOT_SUPP;
  801987:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80198c:	eb f7                	jmp    801985 <fd2sockid+0x27>

0080198e <alloc_sockfd>:
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	56                   	push   %esi
  801992:	53                   	push   %ebx
  801993:	83 ec 1c             	sub    $0x1c,%esp
  801996:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801998:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80199b:	50                   	push   %eax
  80199c:	e8 32 f7 ff ff       	call   8010d3 <fd_alloc>
  8019a1:	89 c3                	mov    %eax,%ebx
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	78 43                	js     8019ed <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	68 07 04 00 00       	push   $0x407
  8019b2:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b5:	6a 00                	push   $0x0
  8019b7:	e8 1b f4 ff ff       	call   800dd7 <sys_page_alloc>
  8019bc:	89 c3                	mov    %eax,%ebx
  8019be:	83 c4 10             	add    $0x10,%esp
  8019c1:	85 c0                	test   %eax,%eax
  8019c3:	78 28                	js     8019ed <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019ce:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019d3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019da:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019dd:	83 ec 0c             	sub    $0xc,%esp
  8019e0:	50                   	push   %eax
  8019e1:	e8 c6 f6 ff ff       	call   8010ac <fd2num>
  8019e6:	89 c3                	mov    %eax,%ebx
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	eb 0c                	jmp    8019f9 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019ed:	83 ec 0c             	sub    $0xc,%esp
  8019f0:	56                   	push   %esi
  8019f1:	e8 e4 01 00 00       	call   801bda <nsipc_close>
		return r;
  8019f6:	83 c4 10             	add    $0x10,%esp
}
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    

00801a02 <accept>:
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	e8 4e ff ff ff       	call   80195e <fd2sockid>
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 1b                	js     801a2f <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a14:	83 ec 04             	sub    $0x4,%esp
  801a17:	ff 75 10             	pushl  0x10(%ebp)
  801a1a:	ff 75 0c             	pushl  0xc(%ebp)
  801a1d:	50                   	push   %eax
  801a1e:	e8 0e 01 00 00       	call   801b31 <nsipc_accept>
  801a23:	83 c4 10             	add    $0x10,%esp
  801a26:	85 c0                	test   %eax,%eax
  801a28:	78 05                	js     801a2f <accept+0x2d>
	return alloc_sockfd(r);
  801a2a:	e8 5f ff ff ff       	call   80198e <alloc_sockfd>
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <bind>:
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
  801a34:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	e8 1f ff ff ff       	call   80195e <fd2sockid>
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 12                	js     801a55 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a43:	83 ec 04             	sub    $0x4,%esp
  801a46:	ff 75 10             	pushl  0x10(%ebp)
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	50                   	push   %eax
  801a4d:	e8 31 01 00 00       	call   801b83 <nsipc_bind>
  801a52:	83 c4 10             	add    $0x10,%esp
}
  801a55:	c9                   	leave  
  801a56:	c3                   	ret    

00801a57 <shutdown>:
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	e8 f9 fe ff ff       	call   80195e <fd2sockid>
  801a65:	85 c0                	test   %eax,%eax
  801a67:	78 0f                	js     801a78 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a69:	83 ec 08             	sub    $0x8,%esp
  801a6c:	ff 75 0c             	pushl  0xc(%ebp)
  801a6f:	50                   	push   %eax
  801a70:	e8 43 01 00 00       	call   801bb8 <nsipc_shutdown>
  801a75:	83 c4 10             	add    $0x10,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <connect>:
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
  801a7d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	e8 d6 fe ff ff       	call   80195e <fd2sockid>
  801a88:	85 c0                	test   %eax,%eax
  801a8a:	78 12                	js     801a9e <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	ff 75 10             	pushl  0x10(%ebp)
  801a92:	ff 75 0c             	pushl  0xc(%ebp)
  801a95:	50                   	push   %eax
  801a96:	e8 59 01 00 00       	call   801bf4 <nsipc_connect>
  801a9b:	83 c4 10             	add    $0x10,%esp
}
  801a9e:	c9                   	leave  
  801a9f:	c3                   	ret    

00801aa0 <listen>:
{
  801aa0:	55                   	push   %ebp
  801aa1:	89 e5                	mov    %esp,%ebp
  801aa3:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	e8 b0 fe ff ff       	call   80195e <fd2sockid>
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 0f                	js     801ac1 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ab2:	83 ec 08             	sub    $0x8,%esp
  801ab5:	ff 75 0c             	pushl  0xc(%ebp)
  801ab8:	50                   	push   %eax
  801ab9:	e8 6b 01 00 00       	call   801c29 <nsipc_listen>
  801abe:	83 c4 10             	add    $0x10,%esp
}
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
  801ac6:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801ac9:	ff 75 10             	pushl  0x10(%ebp)
  801acc:	ff 75 0c             	pushl  0xc(%ebp)
  801acf:	ff 75 08             	pushl  0x8(%ebp)
  801ad2:	e8 3e 02 00 00       	call   801d15 <nsipc_socket>
  801ad7:	83 c4 10             	add    $0x10,%esp
  801ada:	85 c0                	test   %eax,%eax
  801adc:	78 05                	js     801ae3 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801ade:	e8 ab fe ff ff       	call   80198e <alloc_sockfd>
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	53                   	push   %ebx
  801ae9:	83 ec 04             	sub    $0x4,%esp
  801aec:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aee:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801af5:	74 26                	je     801b1d <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801af7:	6a 07                	push   $0x7
  801af9:	68 00 60 80 00       	push   $0x806000
  801afe:	53                   	push   %ebx
  801aff:	ff 35 04 40 80 00    	pushl  0x804004
  801b05:	e8 c2 07 00 00       	call   8022cc <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b0a:	83 c4 0c             	add    $0xc,%esp
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	e8 4b 07 00 00       	call   802263 <ipc_recv>
}
  801b18:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b1b:	c9                   	leave  
  801b1c:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	6a 02                	push   $0x2
  801b22:	e8 fd 07 00 00       	call   802324 <ipc_find_env>
  801b27:	a3 04 40 80 00       	mov    %eax,0x804004
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	eb c6                	jmp    801af7 <nsipc+0x12>

00801b31 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b31:	55                   	push   %ebp
  801b32:	89 e5                	mov    %esp,%ebp
  801b34:	56                   	push   %esi
  801b35:	53                   	push   %ebx
  801b36:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b39:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b41:	8b 06                	mov    (%esi),%eax
  801b43:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b48:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4d:	e8 93 ff ff ff       	call   801ae5 <nsipc>
  801b52:	89 c3                	mov    %eax,%ebx
  801b54:	85 c0                	test   %eax,%eax
  801b56:	79 09                	jns    801b61 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b58:	89 d8                	mov    %ebx,%eax
  801b5a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b5d:	5b                   	pop    %ebx
  801b5e:	5e                   	pop    %esi
  801b5f:	5d                   	pop    %ebp
  801b60:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b61:	83 ec 04             	sub    $0x4,%esp
  801b64:	ff 35 10 60 80 00    	pushl  0x806010
  801b6a:	68 00 60 80 00       	push   $0x806000
  801b6f:	ff 75 0c             	pushl  0xc(%ebp)
  801b72:	e8 fc ef ff ff       	call   800b73 <memmove>
		*addrlen = ret->ret_addrlen;
  801b77:	a1 10 60 80 00       	mov    0x806010,%eax
  801b7c:	89 06                	mov    %eax,(%esi)
  801b7e:	83 c4 10             	add    $0x10,%esp
	return r;
  801b81:	eb d5                	jmp    801b58 <nsipc_accept+0x27>

00801b83 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
  801b86:	53                   	push   %ebx
  801b87:	83 ec 08             	sub    $0x8,%esp
  801b8a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b90:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b95:	53                   	push   %ebx
  801b96:	ff 75 0c             	pushl  0xc(%ebp)
  801b99:	68 04 60 80 00       	push   $0x806004
  801b9e:	e8 d0 ef ff ff       	call   800b73 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ba3:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801ba9:	b8 02 00 00 00       	mov    $0x2,%eax
  801bae:	e8 32 ff ff ff       	call   801ae5 <nsipc>
}
  801bb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb6:	c9                   	leave  
  801bb7:	c3                   	ret    

00801bb8 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc1:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc9:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bce:	b8 03 00 00 00       	mov    $0x3,%eax
  801bd3:	e8 0d ff ff ff       	call   801ae5 <nsipc>
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <nsipc_close>:

int
nsipc_close(int s)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801be8:	b8 04 00 00 00       	mov    $0x4,%eax
  801bed:	e8 f3 fe ff ff       	call   801ae5 <nsipc>
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
  801bf7:	53                   	push   %ebx
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  801c01:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c06:	53                   	push   %ebx
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	68 04 60 80 00       	push   $0x806004
  801c0f:	e8 5f ef ff ff       	call   800b73 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c14:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c1a:	b8 05 00 00 00       	mov    $0x5,%eax
  801c1f:	e8 c1 fe ff ff       	call   801ae5 <nsipc>
}
  801c24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c32:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c3a:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c3f:	b8 06 00 00 00       	mov    $0x6,%eax
  801c44:	e8 9c fe ff ff       	call   801ae5 <nsipc>
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c53:	8b 45 08             	mov    0x8(%ebp),%eax
  801c56:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c5b:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c61:	8b 45 14             	mov    0x14(%ebp),%eax
  801c64:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c69:	b8 07 00 00 00       	mov    $0x7,%eax
  801c6e:	e8 72 fe ff ff       	call   801ae5 <nsipc>
  801c73:	89 c3                	mov    %eax,%ebx
  801c75:	85 c0                	test   %eax,%eax
  801c77:	78 1f                	js     801c98 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c79:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c7e:	7f 21                	jg     801ca1 <nsipc_recv+0x56>
  801c80:	39 c6                	cmp    %eax,%esi
  801c82:	7c 1d                	jl     801ca1 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c84:	83 ec 04             	sub    $0x4,%esp
  801c87:	50                   	push   %eax
  801c88:	68 00 60 80 00       	push   $0x806000
  801c8d:	ff 75 0c             	pushl  0xc(%ebp)
  801c90:	e8 de ee ff ff       	call   800b73 <memmove>
  801c95:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c98:	89 d8                	mov    %ebx,%eax
  801c9a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9d:	5b                   	pop    %ebx
  801c9e:	5e                   	pop    %esi
  801c9f:	5d                   	pop    %ebp
  801ca0:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ca1:	68 e3 2a 80 00       	push   $0x802ae3
  801ca6:	68 ab 2a 80 00       	push   $0x802aab
  801cab:	6a 62                	push   $0x62
  801cad:	68 f8 2a 80 00       	push   $0x802af8
  801cb2:	e8 4b 05 00 00       	call   802202 <_panic>

00801cb7 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cb7:	55                   	push   %ebp
  801cb8:	89 e5                	mov    %esp,%ebp
  801cba:	53                   	push   %ebx
  801cbb:	83 ec 04             	sub    $0x4,%esp
  801cbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc4:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801cc9:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801ccf:	7f 2e                	jg     801cff <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	53                   	push   %ebx
  801cd5:	ff 75 0c             	pushl  0xc(%ebp)
  801cd8:	68 0c 60 80 00       	push   $0x80600c
  801cdd:	e8 91 ee ff ff       	call   800b73 <memmove>
	nsipcbuf.send.req_size = size;
  801ce2:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  801ceb:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801cf0:	b8 08 00 00 00       	mov    $0x8,%eax
  801cf5:	e8 eb fd ff ff       	call   801ae5 <nsipc>
}
  801cfa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    
	assert(size < 1600);
  801cff:	68 04 2b 80 00       	push   $0x802b04
  801d04:	68 ab 2a 80 00       	push   $0x802aab
  801d09:	6a 6d                	push   $0x6d
  801d0b:	68 f8 2a 80 00       	push   $0x802af8
  801d10:	e8 ed 04 00 00       	call   802202 <_panic>

00801d15 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d15:	55                   	push   %ebp
  801d16:	89 e5                	mov    %esp,%ebp
  801d18:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d26:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d2b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d2e:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d33:	b8 09 00 00 00       	mov    $0x9,%eax
  801d38:	e8 a8 fd ff ff       	call   801ae5 <nsipc>
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	56                   	push   %esi
  801d43:	53                   	push   %ebx
  801d44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	ff 75 08             	pushl  0x8(%ebp)
  801d4d:	e8 6a f3 ff ff       	call   8010bc <fd2data>
  801d52:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d54:	83 c4 08             	add    $0x8,%esp
  801d57:	68 10 2b 80 00       	push   $0x802b10
  801d5c:	53                   	push   %ebx
  801d5d:	e8 83 ec ff ff       	call   8009e5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d62:	8b 46 04             	mov    0x4(%esi),%eax
  801d65:	2b 06                	sub    (%esi),%eax
  801d67:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d6d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d74:	00 00 00 
	stat->st_dev = &devpipe;
  801d77:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d7e:	30 80 00 
	return 0;
}
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
  801d86:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d89:	5b                   	pop    %ebx
  801d8a:	5e                   	pop    %esi
  801d8b:	5d                   	pop    %ebp
  801d8c:	c3                   	ret    

00801d8d <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	53                   	push   %ebx
  801d91:	83 ec 0c             	sub    $0xc,%esp
  801d94:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d97:	53                   	push   %ebx
  801d98:	6a 00                	push   $0x0
  801d9a:	e8 bd f0 ff ff       	call   800e5c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d9f:	89 1c 24             	mov    %ebx,(%esp)
  801da2:	e8 15 f3 ff ff       	call   8010bc <fd2data>
  801da7:	83 c4 08             	add    $0x8,%esp
  801daa:	50                   	push   %eax
  801dab:	6a 00                	push   $0x0
  801dad:	e8 aa f0 ff ff       	call   800e5c <sys_page_unmap>
}
  801db2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <_pipeisclosed>:
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	57                   	push   %edi
  801dbb:	56                   	push   %esi
  801dbc:	53                   	push   %ebx
  801dbd:	83 ec 1c             	sub    $0x1c,%esp
  801dc0:	89 c7                	mov    %eax,%edi
  801dc2:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801dc4:	a1 08 40 80 00       	mov    0x804008,%eax
  801dc9:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dcc:	83 ec 0c             	sub    $0xc,%esp
  801dcf:	57                   	push   %edi
  801dd0:	e8 8a 05 00 00       	call   80235f <pageref>
  801dd5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dd8:	89 34 24             	mov    %esi,(%esp)
  801ddb:	e8 7f 05 00 00       	call   80235f <pageref>
		nn = thisenv->env_runs;
  801de0:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801de6:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801de9:	83 c4 10             	add    $0x10,%esp
  801dec:	39 cb                	cmp    %ecx,%ebx
  801dee:	74 1b                	je     801e0b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801df0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801df3:	75 cf                	jne    801dc4 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801df5:	8b 42 58             	mov    0x58(%edx),%eax
  801df8:	6a 01                	push   $0x1
  801dfa:	50                   	push   %eax
  801dfb:	53                   	push   %ebx
  801dfc:	68 17 2b 80 00       	push   $0x802b17
  801e01:	e8 80 e4 ff ff       	call   800286 <cprintf>
  801e06:	83 c4 10             	add    $0x10,%esp
  801e09:	eb b9                	jmp    801dc4 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e0b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e0e:	0f 94 c0             	sete   %al
  801e11:	0f b6 c0             	movzbl %al,%eax
}
  801e14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    

00801e1c <devpipe_write>:
{
  801e1c:	55                   	push   %ebp
  801e1d:	89 e5                	mov    %esp,%ebp
  801e1f:	57                   	push   %edi
  801e20:	56                   	push   %esi
  801e21:	53                   	push   %ebx
  801e22:	83 ec 28             	sub    $0x28,%esp
  801e25:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e28:	56                   	push   %esi
  801e29:	e8 8e f2 ff ff       	call   8010bc <fd2data>
  801e2e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e30:	83 c4 10             	add    $0x10,%esp
  801e33:	bf 00 00 00 00       	mov    $0x0,%edi
  801e38:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e3b:	74 4f                	je     801e8c <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e3d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e40:	8b 0b                	mov    (%ebx),%ecx
  801e42:	8d 51 20             	lea    0x20(%ecx),%edx
  801e45:	39 d0                	cmp    %edx,%eax
  801e47:	72 14                	jb     801e5d <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e49:	89 da                	mov    %ebx,%edx
  801e4b:	89 f0                	mov    %esi,%eax
  801e4d:	e8 65 ff ff ff       	call   801db7 <_pipeisclosed>
  801e52:	85 c0                	test   %eax,%eax
  801e54:	75 3b                	jne    801e91 <devpipe_write+0x75>
			sys_yield();
  801e56:	e8 5d ef ff ff       	call   800db8 <sys_yield>
  801e5b:	eb e0                	jmp    801e3d <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e60:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e64:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e67:	89 c2                	mov    %eax,%edx
  801e69:	c1 fa 1f             	sar    $0x1f,%edx
  801e6c:	89 d1                	mov    %edx,%ecx
  801e6e:	c1 e9 1b             	shr    $0x1b,%ecx
  801e71:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e74:	83 e2 1f             	and    $0x1f,%edx
  801e77:	29 ca                	sub    %ecx,%edx
  801e79:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e7d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e81:	83 c0 01             	add    $0x1,%eax
  801e84:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e87:	83 c7 01             	add    $0x1,%edi
  801e8a:	eb ac                	jmp    801e38 <devpipe_write+0x1c>
	return i;
  801e8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801e8f:	eb 05                	jmp    801e96 <devpipe_write+0x7a>
				return 0;
  801e91:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e96:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e99:	5b                   	pop    %ebx
  801e9a:	5e                   	pop    %esi
  801e9b:	5f                   	pop    %edi
  801e9c:	5d                   	pop    %ebp
  801e9d:	c3                   	ret    

00801e9e <devpipe_read>:
{
  801e9e:	55                   	push   %ebp
  801e9f:	89 e5                	mov    %esp,%ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 18             	sub    $0x18,%esp
  801ea7:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801eaa:	57                   	push   %edi
  801eab:	e8 0c f2 ff ff       	call   8010bc <fd2data>
  801eb0:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801eb2:	83 c4 10             	add    $0x10,%esp
  801eb5:	be 00 00 00 00       	mov    $0x0,%esi
  801eba:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ebd:	75 14                	jne    801ed3 <devpipe_read+0x35>
	return i;
  801ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec2:	eb 02                	jmp    801ec6 <devpipe_read+0x28>
				return i;
  801ec4:	89 f0                	mov    %esi,%eax
}
  801ec6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ec9:	5b                   	pop    %ebx
  801eca:	5e                   	pop    %esi
  801ecb:	5f                   	pop    %edi
  801ecc:	5d                   	pop    %ebp
  801ecd:	c3                   	ret    
			sys_yield();
  801ece:	e8 e5 ee ff ff       	call   800db8 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ed3:	8b 03                	mov    (%ebx),%eax
  801ed5:	3b 43 04             	cmp    0x4(%ebx),%eax
  801ed8:	75 18                	jne    801ef2 <devpipe_read+0x54>
			if (i > 0)
  801eda:	85 f6                	test   %esi,%esi
  801edc:	75 e6                	jne    801ec4 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ede:	89 da                	mov    %ebx,%edx
  801ee0:	89 f8                	mov    %edi,%eax
  801ee2:	e8 d0 fe ff ff       	call   801db7 <_pipeisclosed>
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	74 e3                	je     801ece <devpipe_read+0x30>
				return 0;
  801eeb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef0:	eb d4                	jmp    801ec6 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ef2:	99                   	cltd   
  801ef3:	c1 ea 1b             	shr    $0x1b,%edx
  801ef6:	01 d0                	add    %edx,%eax
  801ef8:	83 e0 1f             	and    $0x1f,%eax
  801efb:	29 d0                	sub    %edx,%eax
  801efd:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f05:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f08:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f0b:	83 c6 01             	add    $0x1,%esi
  801f0e:	eb aa                	jmp    801eba <devpipe_read+0x1c>

00801f10 <pipe>:
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	56                   	push   %esi
  801f14:	53                   	push   %ebx
  801f15:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f18:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f1b:	50                   	push   %eax
  801f1c:	e8 b2 f1 ff ff       	call   8010d3 <fd_alloc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	83 c4 10             	add    $0x10,%esp
  801f26:	85 c0                	test   %eax,%eax
  801f28:	0f 88 23 01 00 00    	js     802051 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f2e:	83 ec 04             	sub    $0x4,%esp
  801f31:	68 07 04 00 00       	push   $0x407
  801f36:	ff 75 f4             	pushl  -0xc(%ebp)
  801f39:	6a 00                	push   $0x0
  801f3b:	e8 97 ee ff ff       	call   800dd7 <sys_page_alloc>
  801f40:	89 c3                	mov    %eax,%ebx
  801f42:	83 c4 10             	add    $0x10,%esp
  801f45:	85 c0                	test   %eax,%eax
  801f47:	0f 88 04 01 00 00    	js     802051 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f4d:	83 ec 0c             	sub    $0xc,%esp
  801f50:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f53:	50                   	push   %eax
  801f54:	e8 7a f1 ff ff       	call   8010d3 <fd_alloc>
  801f59:	89 c3                	mov    %eax,%ebx
  801f5b:	83 c4 10             	add    $0x10,%esp
  801f5e:	85 c0                	test   %eax,%eax
  801f60:	0f 88 db 00 00 00    	js     802041 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f66:	83 ec 04             	sub    $0x4,%esp
  801f69:	68 07 04 00 00       	push   $0x407
  801f6e:	ff 75 f0             	pushl  -0x10(%ebp)
  801f71:	6a 00                	push   $0x0
  801f73:	e8 5f ee ff ff       	call   800dd7 <sys_page_alloc>
  801f78:	89 c3                	mov    %eax,%ebx
  801f7a:	83 c4 10             	add    $0x10,%esp
  801f7d:	85 c0                	test   %eax,%eax
  801f7f:	0f 88 bc 00 00 00    	js     802041 <pipe+0x131>
	va = fd2data(fd0);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8b:	e8 2c f1 ff ff       	call   8010bc <fd2data>
  801f90:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f92:	83 c4 0c             	add    $0xc,%esp
  801f95:	68 07 04 00 00       	push   $0x407
  801f9a:	50                   	push   %eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	e8 35 ee ff ff       	call   800dd7 <sys_page_alloc>
  801fa2:	89 c3                	mov    %eax,%ebx
  801fa4:	83 c4 10             	add    $0x10,%esp
  801fa7:	85 c0                	test   %eax,%eax
  801fa9:	0f 88 82 00 00 00    	js     802031 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	ff 75 f0             	pushl  -0x10(%ebp)
  801fb5:	e8 02 f1 ff ff       	call   8010bc <fd2data>
  801fba:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fc1:	50                   	push   %eax
  801fc2:	6a 00                	push   $0x0
  801fc4:	56                   	push   %esi
  801fc5:	6a 00                	push   $0x0
  801fc7:	e8 4e ee ff ff       	call   800e1a <sys_page_map>
  801fcc:	89 c3                	mov    %eax,%ebx
  801fce:	83 c4 20             	add    $0x20,%esp
  801fd1:	85 c0                	test   %eax,%eax
  801fd3:	78 4e                	js     802023 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801fd5:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdd:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801fdf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fe2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801fe9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fec:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ff8:	83 ec 0c             	sub    $0xc,%esp
  801ffb:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffe:	e8 a9 f0 ff ff       	call   8010ac <fd2num>
  802003:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802006:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802008:	83 c4 04             	add    $0x4,%esp
  80200b:	ff 75 f0             	pushl  -0x10(%ebp)
  80200e:	e8 99 f0 ff ff       	call   8010ac <fd2num>
  802013:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802016:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802019:	83 c4 10             	add    $0x10,%esp
  80201c:	bb 00 00 00 00       	mov    $0x0,%ebx
  802021:	eb 2e                	jmp    802051 <pipe+0x141>
	sys_page_unmap(0, va);
  802023:	83 ec 08             	sub    $0x8,%esp
  802026:	56                   	push   %esi
  802027:	6a 00                	push   $0x0
  802029:	e8 2e ee ff ff       	call   800e5c <sys_page_unmap>
  80202e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802031:	83 ec 08             	sub    $0x8,%esp
  802034:	ff 75 f0             	pushl  -0x10(%ebp)
  802037:	6a 00                	push   $0x0
  802039:	e8 1e ee ff ff       	call   800e5c <sys_page_unmap>
  80203e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802041:	83 ec 08             	sub    $0x8,%esp
  802044:	ff 75 f4             	pushl  -0xc(%ebp)
  802047:	6a 00                	push   $0x0
  802049:	e8 0e ee ff ff       	call   800e5c <sys_page_unmap>
  80204e:	83 c4 10             	add    $0x10,%esp
}
  802051:	89 d8                	mov    %ebx,%eax
  802053:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802056:	5b                   	pop    %ebx
  802057:	5e                   	pop    %esi
  802058:	5d                   	pop    %ebp
  802059:	c3                   	ret    

0080205a <pipeisclosed>:
{
  80205a:	55                   	push   %ebp
  80205b:	89 e5                	mov    %esp,%ebp
  80205d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802060:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802063:	50                   	push   %eax
  802064:	ff 75 08             	pushl  0x8(%ebp)
  802067:	e8 b9 f0 ff ff       	call   801125 <fd_lookup>
  80206c:	83 c4 10             	add    $0x10,%esp
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 18                	js     80208b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802073:	83 ec 0c             	sub    $0xc,%esp
  802076:	ff 75 f4             	pushl  -0xc(%ebp)
  802079:	e8 3e f0 ff ff       	call   8010bc <fd2data>
	return _pipeisclosed(fd, p);
  80207e:	89 c2                	mov    %eax,%edx
  802080:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802083:	e8 2f fd ff ff       	call   801db7 <_pipeisclosed>
  802088:	83 c4 10             	add    $0x10,%esp
}
  80208b:	c9                   	leave  
  80208c:	c3                   	ret    

0080208d <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  80208d:	b8 00 00 00 00       	mov    $0x0,%eax
  802092:	c3                   	ret    

00802093 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802099:	68 2f 2b 80 00       	push   $0x802b2f
  80209e:	ff 75 0c             	pushl  0xc(%ebp)
  8020a1:	e8 3f e9 ff ff       	call   8009e5 <strcpy>
	return 0;
}
  8020a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <devcons_write>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	57                   	push   %edi
  8020b1:	56                   	push   %esi
  8020b2:	53                   	push   %ebx
  8020b3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020b9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020be:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020c4:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020c7:	73 31                	jae    8020fa <devcons_write+0x4d>
		m = n - tot;
  8020c9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020cc:	29 f3                	sub    %esi,%ebx
  8020ce:	83 fb 7f             	cmp    $0x7f,%ebx
  8020d1:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020d6:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020d9:	83 ec 04             	sub    $0x4,%esp
  8020dc:	53                   	push   %ebx
  8020dd:	89 f0                	mov    %esi,%eax
  8020df:	03 45 0c             	add    0xc(%ebp),%eax
  8020e2:	50                   	push   %eax
  8020e3:	57                   	push   %edi
  8020e4:	e8 8a ea ff ff       	call   800b73 <memmove>
		sys_cputs(buf, m);
  8020e9:	83 c4 08             	add    $0x8,%esp
  8020ec:	53                   	push   %ebx
  8020ed:	57                   	push   %edi
  8020ee:	e8 28 ec ff ff       	call   800d1b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020f3:	01 de                	add    %ebx,%esi
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	eb ca                	jmp    8020c4 <devcons_write+0x17>
}
  8020fa:	89 f0                	mov    %esi,%eax
  8020fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020ff:	5b                   	pop    %ebx
  802100:	5e                   	pop    %esi
  802101:	5f                   	pop    %edi
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <devcons_read>:
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	83 ec 08             	sub    $0x8,%esp
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  80210f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802113:	74 21                	je     802136 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802115:	e8 1f ec ff ff       	call   800d39 <sys_cgetc>
  80211a:	85 c0                	test   %eax,%eax
  80211c:	75 07                	jne    802125 <devcons_read+0x21>
		sys_yield();
  80211e:	e8 95 ec ff ff       	call   800db8 <sys_yield>
  802123:	eb f0                	jmp    802115 <devcons_read+0x11>
	if (c < 0)
  802125:	78 0f                	js     802136 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802127:	83 f8 04             	cmp    $0x4,%eax
  80212a:	74 0c                	je     802138 <devcons_read+0x34>
	*(char*)vbuf = c;
  80212c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212f:	88 02                	mov    %al,(%edx)
	return 1;
  802131:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802136:	c9                   	leave  
  802137:	c3                   	ret    
		return 0;
  802138:	b8 00 00 00 00       	mov    $0x0,%eax
  80213d:	eb f7                	jmp    802136 <devcons_read+0x32>

0080213f <cputchar>:
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802145:	8b 45 08             	mov    0x8(%ebp),%eax
  802148:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80214b:	6a 01                	push   $0x1
  80214d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802150:	50                   	push   %eax
  802151:	e8 c5 eb ff ff       	call   800d1b <sys_cputs>
}
  802156:	83 c4 10             	add    $0x10,%esp
  802159:	c9                   	leave  
  80215a:	c3                   	ret    

0080215b <getchar>:
{
  80215b:	55                   	push   %ebp
  80215c:	89 e5                	mov    %esp,%ebp
  80215e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802161:	6a 01                	push   $0x1
  802163:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802166:	50                   	push   %eax
  802167:	6a 00                	push   $0x0
  802169:	e8 27 f2 ff ff       	call   801395 <read>
	if (r < 0)
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	85 c0                	test   %eax,%eax
  802173:	78 06                	js     80217b <getchar+0x20>
	if (r < 1)
  802175:	74 06                	je     80217d <getchar+0x22>
	return c;
  802177:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    
		return -E_EOF;
  80217d:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802182:	eb f7                	jmp    80217b <getchar+0x20>

00802184 <iscons>:
{
  802184:	55                   	push   %ebp
  802185:	89 e5                	mov    %esp,%ebp
  802187:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80218a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80218d:	50                   	push   %eax
  80218e:	ff 75 08             	pushl  0x8(%ebp)
  802191:	e8 8f ef ff ff       	call   801125 <fd_lookup>
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	85 c0                	test   %eax,%eax
  80219b:	78 11                	js     8021ae <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80219d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a0:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021a6:	39 10                	cmp    %edx,(%eax)
  8021a8:	0f 94 c0             	sete   %al
  8021ab:	0f b6 c0             	movzbl %al,%eax
}
  8021ae:	c9                   	leave  
  8021af:	c3                   	ret    

008021b0 <opencons>:
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b9:	50                   	push   %eax
  8021ba:	e8 14 ef ff ff       	call   8010d3 <fd_alloc>
  8021bf:	83 c4 10             	add    $0x10,%esp
  8021c2:	85 c0                	test   %eax,%eax
  8021c4:	78 3a                	js     802200 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021c6:	83 ec 04             	sub    $0x4,%esp
  8021c9:	68 07 04 00 00       	push   $0x407
  8021ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d1:	6a 00                	push   $0x0
  8021d3:	e8 ff eb ff ff       	call   800dd7 <sys_page_alloc>
  8021d8:	83 c4 10             	add    $0x10,%esp
  8021db:	85 c0                	test   %eax,%eax
  8021dd:	78 21                	js     802200 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021e8:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ed:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021f4:	83 ec 0c             	sub    $0xc,%esp
  8021f7:	50                   	push   %eax
  8021f8:	e8 af ee ff ff       	call   8010ac <fd2num>
  8021fd:	83 c4 10             	add    $0x10,%esp
}
  802200:	c9                   	leave  
  802201:	c3                   	ret    

00802202 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	56                   	push   %esi
  802206:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802207:	a1 08 40 80 00       	mov    0x804008,%eax
  80220c:	8b 40 48             	mov    0x48(%eax),%eax
  80220f:	83 ec 04             	sub    $0x4,%esp
  802212:	68 60 2b 80 00       	push   $0x802b60
  802217:	50                   	push   %eax
  802218:	68 5d 26 80 00       	push   $0x80265d
  80221d:	e8 64 e0 ff ff       	call   800286 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802222:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802225:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80222b:	e8 69 eb ff ff       	call   800d99 <sys_getenvid>
  802230:	83 c4 04             	add    $0x4,%esp
  802233:	ff 75 0c             	pushl  0xc(%ebp)
  802236:	ff 75 08             	pushl  0x8(%ebp)
  802239:	56                   	push   %esi
  80223a:	50                   	push   %eax
  80223b:	68 3c 2b 80 00       	push   $0x802b3c
  802240:	e8 41 e0 ff ff       	call   800286 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802245:	83 c4 18             	add    $0x18,%esp
  802248:	53                   	push   %ebx
  802249:	ff 75 10             	pushl  0x10(%ebp)
  80224c:	e8 e4 df ff ff       	call   800235 <vcprintf>
	cprintf("\n");
  802251:	c7 04 24 21 26 80 00 	movl   $0x802621,(%esp)
  802258:	e8 29 e0 ff ff       	call   800286 <cprintf>
  80225d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802260:	cc                   	int3   
  802261:	eb fd                	jmp    802260 <_panic+0x5e>

00802263 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	56                   	push   %esi
  802267:	53                   	push   %ebx
  802268:	8b 75 08             	mov    0x8(%ebp),%esi
  80226b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226e:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  802271:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802273:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802278:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80227b:	83 ec 0c             	sub    $0xc,%esp
  80227e:	50                   	push   %eax
  80227f:	e8 03 ed ff ff       	call   800f87 <sys_ipc_recv>
	if(ret < 0){
  802284:	83 c4 10             	add    $0x10,%esp
  802287:	85 c0                	test   %eax,%eax
  802289:	78 2b                	js     8022b6 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80228b:	85 f6                	test   %esi,%esi
  80228d:	74 0a                	je     802299 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  80228f:	a1 08 40 80 00       	mov    0x804008,%eax
  802294:	8b 40 74             	mov    0x74(%eax),%eax
  802297:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802299:	85 db                	test   %ebx,%ebx
  80229b:	74 0a                	je     8022a7 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80229d:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a2:	8b 40 78             	mov    0x78(%eax),%eax
  8022a5:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8022a7:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ac:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022af:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b2:	5b                   	pop    %ebx
  8022b3:	5e                   	pop    %esi
  8022b4:	5d                   	pop    %ebp
  8022b5:	c3                   	ret    
		if(from_env_store)
  8022b6:	85 f6                	test   %esi,%esi
  8022b8:	74 06                	je     8022c0 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022ba:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022c0:	85 db                	test   %ebx,%ebx
  8022c2:	74 eb                	je     8022af <ipc_recv+0x4c>
			*perm_store = 0;
  8022c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022ca:	eb e3                	jmp    8022af <ipc_recv+0x4c>

008022cc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022cc:	55                   	push   %ebp
  8022cd:	89 e5                	mov    %esp,%ebp
  8022cf:	57                   	push   %edi
  8022d0:	56                   	push   %esi
  8022d1:	53                   	push   %ebx
  8022d2:	83 ec 0c             	sub    $0xc,%esp
  8022d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022d8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022db:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022de:	85 db                	test   %ebx,%ebx
  8022e0:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022e5:	0f 44 d8             	cmove  %eax,%ebx
  8022e8:	eb 05                	jmp    8022ef <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022ea:	e8 c9 ea ff ff       	call   800db8 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022ef:	ff 75 14             	pushl  0x14(%ebp)
  8022f2:	53                   	push   %ebx
  8022f3:	56                   	push   %esi
  8022f4:	57                   	push   %edi
  8022f5:	e8 6a ec ff ff       	call   800f64 <sys_ipc_try_send>
  8022fa:	83 c4 10             	add    $0x10,%esp
  8022fd:	85 c0                	test   %eax,%eax
  8022ff:	74 1b                	je     80231c <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802301:	79 e7                	jns    8022ea <ipc_send+0x1e>
  802303:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802306:	74 e2                	je     8022ea <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802308:	83 ec 04             	sub    $0x4,%esp
  80230b:	68 67 2b 80 00       	push   $0x802b67
  802310:	6a 4a                	push   $0x4a
  802312:	68 7c 2b 80 00       	push   $0x802b7c
  802317:	e8 e6 fe ff ff       	call   802202 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80231c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80231f:	5b                   	pop    %ebx
  802320:	5e                   	pop    %esi
  802321:	5f                   	pop    %edi
  802322:	5d                   	pop    %ebp
  802323:	c3                   	ret    

00802324 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80232a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80232f:	89 c2                	mov    %eax,%edx
  802331:	c1 e2 07             	shl    $0x7,%edx
  802334:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80233a:	8b 52 50             	mov    0x50(%edx),%edx
  80233d:	39 ca                	cmp    %ecx,%edx
  80233f:	74 11                	je     802352 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802341:	83 c0 01             	add    $0x1,%eax
  802344:	3d 00 04 00 00       	cmp    $0x400,%eax
  802349:	75 e4                	jne    80232f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80234b:	b8 00 00 00 00       	mov    $0x0,%eax
  802350:	eb 0b                	jmp    80235d <ipc_find_env+0x39>
			return envs[i].env_id;
  802352:	c1 e0 07             	shl    $0x7,%eax
  802355:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80235a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80235d:	5d                   	pop    %ebp
  80235e:	c3                   	ret    

0080235f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802365:	89 d0                	mov    %edx,%eax
  802367:	c1 e8 16             	shr    $0x16,%eax
  80236a:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802371:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802376:	f6 c1 01             	test   $0x1,%cl
  802379:	74 1d                	je     802398 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80237b:	c1 ea 0c             	shr    $0xc,%edx
  80237e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802385:	f6 c2 01             	test   $0x1,%dl
  802388:	74 0e                	je     802398 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80238a:	c1 ea 0c             	shr    $0xc,%edx
  80238d:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802394:	ef 
  802395:	0f b7 c0             	movzwl %ax,%eax
}
  802398:	5d                   	pop    %ebp
  802399:	c3                   	ret    
  80239a:	66 90                	xchg   %ax,%ax
  80239c:	66 90                	xchg   %ax,%ax
  80239e:	66 90                	xchg   %ax,%ax

008023a0 <__udivdi3>:
  8023a0:	55                   	push   %ebp
  8023a1:	57                   	push   %edi
  8023a2:	56                   	push   %esi
  8023a3:	53                   	push   %ebx
  8023a4:	83 ec 1c             	sub    $0x1c,%esp
  8023a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8023ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8023af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8023b7:	85 d2                	test   %edx,%edx
  8023b9:	75 4d                	jne    802408 <__udivdi3+0x68>
  8023bb:	39 f3                	cmp    %esi,%ebx
  8023bd:	76 19                	jbe    8023d8 <__udivdi3+0x38>
  8023bf:	31 ff                	xor    %edi,%edi
  8023c1:	89 e8                	mov    %ebp,%eax
  8023c3:	89 f2                	mov    %esi,%edx
  8023c5:	f7 f3                	div    %ebx
  8023c7:	89 fa                	mov    %edi,%edx
  8023c9:	83 c4 1c             	add    $0x1c,%esp
  8023cc:	5b                   	pop    %ebx
  8023cd:	5e                   	pop    %esi
  8023ce:	5f                   	pop    %edi
  8023cf:	5d                   	pop    %ebp
  8023d0:	c3                   	ret    
  8023d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023d8:	89 d9                	mov    %ebx,%ecx
  8023da:	85 db                	test   %ebx,%ebx
  8023dc:	75 0b                	jne    8023e9 <__udivdi3+0x49>
  8023de:	b8 01 00 00 00       	mov    $0x1,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f3                	div    %ebx
  8023e7:	89 c1                	mov    %eax,%ecx
  8023e9:	31 d2                	xor    %edx,%edx
  8023eb:	89 f0                	mov    %esi,%eax
  8023ed:	f7 f1                	div    %ecx
  8023ef:	89 c6                	mov    %eax,%esi
  8023f1:	89 e8                	mov    %ebp,%eax
  8023f3:	89 f7                	mov    %esi,%edi
  8023f5:	f7 f1                	div    %ecx
  8023f7:	89 fa                	mov    %edi,%edx
  8023f9:	83 c4 1c             	add    $0x1c,%esp
  8023fc:	5b                   	pop    %ebx
  8023fd:	5e                   	pop    %esi
  8023fe:	5f                   	pop    %edi
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    
  802401:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802408:	39 f2                	cmp    %esi,%edx
  80240a:	77 1c                	ja     802428 <__udivdi3+0x88>
  80240c:	0f bd fa             	bsr    %edx,%edi
  80240f:	83 f7 1f             	xor    $0x1f,%edi
  802412:	75 2c                	jne    802440 <__udivdi3+0xa0>
  802414:	39 f2                	cmp    %esi,%edx
  802416:	72 06                	jb     80241e <__udivdi3+0x7e>
  802418:	31 c0                	xor    %eax,%eax
  80241a:	39 eb                	cmp    %ebp,%ebx
  80241c:	77 a9                	ja     8023c7 <__udivdi3+0x27>
  80241e:	b8 01 00 00 00       	mov    $0x1,%eax
  802423:	eb a2                	jmp    8023c7 <__udivdi3+0x27>
  802425:	8d 76 00             	lea    0x0(%esi),%esi
  802428:	31 ff                	xor    %edi,%edi
  80242a:	31 c0                	xor    %eax,%eax
  80242c:	89 fa                	mov    %edi,%edx
  80242e:	83 c4 1c             	add    $0x1c,%esp
  802431:	5b                   	pop    %ebx
  802432:	5e                   	pop    %esi
  802433:	5f                   	pop    %edi
  802434:	5d                   	pop    %ebp
  802435:	c3                   	ret    
  802436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80243d:	8d 76 00             	lea    0x0(%esi),%esi
  802440:	89 f9                	mov    %edi,%ecx
  802442:	b8 20 00 00 00       	mov    $0x20,%eax
  802447:	29 f8                	sub    %edi,%eax
  802449:	d3 e2                	shl    %cl,%edx
  80244b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80244f:	89 c1                	mov    %eax,%ecx
  802451:	89 da                	mov    %ebx,%edx
  802453:	d3 ea                	shr    %cl,%edx
  802455:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802459:	09 d1                	or     %edx,%ecx
  80245b:	89 f2                	mov    %esi,%edx
  80245d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802461:	89 f9                	mov    %edi,%ecx
  802463:	d3 e3                	shl    %cl,%ebx
  802465:	89 c1                	mov    %eax,%ecx
  802467:	d3 ea                	shr    %cl,%edx
  802469:	89 f9                	mov    %edi,%ecx
  80246b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80246f:	89 eb                	mov    %ebp,%ebx
  802471:	d3 e6                	shl    %cl,%esi
  802473:	89 c1                	mov    %eax,%ecx
  802475:	d3 eb                	shr    %cl,%ebx
  802477:	09 de                	or     %ebx,%esi
  802479:	89 f0                	mov    %esi,%eax
  80247b:	f7 74 24 08          	divl   0x8(%esp)
  80247f:	89 d6                	mov    %edx,%esi
  802481:	89 c3                	mov    %eax,%ebx
  802483:	f7 64 24 0c          	mull   0xc(%esp)
  802487:	39 d6                	cmp    %edx,%esi
  802489:	72 15                	jb     8024a0 <__udivdi3+0x100>
  80248b:	89 f9                	mov    %edi,%ecx
  80248d:	d3 e5                	shl    %cl,%ebp
  80248f:	39 c5                	cmp    %eax,%ebp
  802491:	73 04                	jae    802497 <__udivdi3+0xf7>
  802493:	39 d6                	cmp    %edx,%esi
  802495:	74 09                	je     8024a0 <__udivdi3+0x100>
  802497:	89 d8                	mov    %ebx,%eax
  802499:	31 ff                	xor    %edi,%edi
  80249b:	e9 27 ff ff ff       	jmp    8023c7 <__udivdi3+0x27>
  8024a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8024a3:	31 ff                	xor    %edi,%edi
  8024a5:	e9 1d ff ff ff       	jmp    8023c7 <__udivdi3+0x27>
  8024aa:	66 90                	xchg   %ax,%ax
  8024ac:	66 90                	xchg   %ax,%ax
  8024ae:	66 90                	xchg   %ax,%ax

008024b0 <__umoddi3>:
  8024b0:	55                   	push   %ebp
  8024b1:	57                   	push   %edi
  8024b2:	56                   	push   %esi
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 1c             	sub    $0x1c,%esp
  8024b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8024bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8024bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8024c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024c7:	89 da                	mov    %ebx,%edx
  8024c9:	85 c0                	test   %eax,%eax
  8024cb:	75 43                	jne    802510 <__umoddi3+0x60>
  8024cd:	39 df                	cmp    %ebx,%edi
  8024cf:	76 17                	jbe    8024e8 <__umoddi3+0x38>
  8024d1:	89 f0                	mov    %esi,%eax
  8024d3:	f7 f7                	div    %edi
  8024d5:	89 d0                	mov    %edx,%eax
  8024d7:	31 d2                	xor    %edx,%edx
  8024d9:	83 c4 1c             	add    $0x1c,%esp
  8024dc:	5b                   	pop    %ebx
  8024dd:	5e                   	pop    %esi
  8024de:	5f                   	pop    %edi
  8024df:	5d                   	pop    %ebp
  8024e0:	c3                   	ret    
  8024e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024e8:	89 fd                	mov    %edi,%ebp
  8024ea:	85 ff                	test   %edi,%edi
  8024ec:	75 0b                	jne    8024f9 <__umoddi3+0x49>
  8024ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f3:	31 d2                	xor    %edx,%edx
  8024f5:	f7 f7                	div    %edi
  8024f7:	89 c5                	mov    %eax,%ebp
  8024f9:	89 d8                	mov    %ebx,%eax
  8024fb:	31 d2                	xor    %edx,%edx
  8024fd:	f7 f5                	div    %ebp
  8024ff:	89 f0                	mov    %esi,%eax
  802501:	f7 f5                	div    %ebp
  802503:	89 d0                	mov    %edx,%eax
  802505:	eb d0                	jmp    8024d7 <__umoddi3+0x27>
  802507:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80250e:	66 90                	xchg   %ax,%ax
  802510:	89 f1                	mov    %esi,%ecx
  802512:	39 d8                	cmp    %ebx,%eax
  802514:	76 0a                	jbe    802520 <__umoddi3+0x70>
  802516:	89 f0                	mov    %esi,%eax
  802518:	83 c4 1c             	add    $0x1c,%esp
  80251b:	5b                   	pop    %ebx
  80251c:	5e                   	pop    %esi
  80251d:	5f                   	pop    %edi
  80251e:	5d                   	pop    %ebp
  80251f:	c3                   	ret    
  802520:	0f bd e8             	bsr    %eax,%ebp
  802523:	83 f5 1f             	xor    $0x1f,%ebp
  802526:	75 20                	jne    802548 <__umoddi3+0x98>
  802528:	39 d8                	cmp    %ebx,%eax
  80252a:	0f 82 b0 00 00 00    	jb     8025e0 <__umoddi3+0x130>
  802530:	39 f7                	cmp    %esi,%edi
  802532:	0f 86 a8 00 00 00    	jbe    8025e0 <__umoddi3+0x130>
  802538:	89 c8                	mov    %ecx,%eax
  80253a:	83 c4 1c             	add    $0x1c,%esp
  80253d:	5b                   	pop    %ebx
  80253e:	5e                   	pop    %esi
  80253f:	5f                   	pop    %edi
  802540:	5d                   	pop    %ebp
  802541:	c3                   	ret    
  802542:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802548:	89 e9                	mov    %ebp,%ecx
  80254a:	ba 20 00 00 00       	mov    $0x20,%edx
  80254f:	29 ea                	sub    %ebp,%edx
  802551:	d3 e0                	shl    %cl,%eax
  802553:	89 44 24 08          	mov    %eax,0x8(%esp)
  802557:	89 d1                	mov    %edx,%ecx
  802559:	89 f8                	mov    %edi,%eax
  80255b:	d3 e8                	shr    %cl,%eax
  80255d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802561:	89 54 24 04          	mov    %edx,0x4(%esp)
  802565:	8b 54 24 04          	mov    0x4(%esp),%edx
  802569:	09 c1                	or     %eax,%ecx
  80256b:	89 d8                	mov    %ebx,%eax
  80256d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802571:	89 e9                	mov    %ebp,%ecx
  802573:	d3 e7                	shl    %cl,%edi
  802575:	89 d1                	mov    %edx,%ecx
  802577:	d3 e8                	shr    %cl,%eax
  802579:	89 e9                	mov    %ebp,%ecx
  80257b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80257f:	d3 e3                	shl    %cl,%ebx
  802581:	89 c7                	mov    %eax,%edi
  802583:	89 d1                	mov    %edx,%ecx
  802585:	89 f0                	mov    %esi,%eax
  802587:	d3 e8                	shr    %cl,%eax
  802589:	89 e9                	mov    %ebp,%ecx
  80258b:	89 fa                	mov    %edi,%edx
  80258d:	d3 e6                	shl    %cl,%esi
  80258f:	09 d8                	or     %ebx,%eax
  802591:	f7 74 24 08          	divl   0x8(%esp)
  802595:	89 d1                	mov    %edx,%ecx
  802597:	89 f3                	mov    %esi,%ebx
  802599:	f7 64 24 0c          	mull   0xc(%esp)
  80259d:	89 c6                	mov    %eax,%esi
  80259f:	89 d7                	mov    %edx,%edi
  8025a1:	39 d1                	cmp    %edx,%ecx
  8025a3:	72 06                	jb     8025ab <__umoddi3+0xfb>
  8025a5:	75 10                	jne    8025b7 <__umoddi3+0x107>
  8025a7:	39 c3                	cmp    %eax,%ebx
  8025a9:	73 0c                	jae    8025b7 <__umoddi3+0x107>
  8025ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8025af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8025b3:	89 d7                	mov    %edx,%edi
  8025b5:	89 c6                	mov    %eax,%esi
  8025b7:	89 ca                	mov    %ecx,%edx
  8025b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8025be:	29 f3                	sub    %esi,%ebx
  8025c0:	19 fa                	sbb    %edi,%edx
  8025c2:	89 d0                	mov    %edx,%eax
  8025c4:	d3 e0                	shl    %cl,%eax
  8025c6:	89 e9                	mov    %ebp,%ecx
  8025c8:	d3 eb                	shr    %cl,%ebx
  8025ca:	d3 ea                	shr    %cl,%edx
  8025cc:	09 d8                	or     %ebx,%eax
  8025ce:	83 c4 1c             	add    $0x1c,%esp
  8025d1:	5b                   	pop    %ebx
  8025d2:	5e                   	pop    %esi
  8025d3:	5f                   	pop    %edi
  8025d4:	5d                   	pop    %ebp
  8025d5:	c3                   	ret    
  8025d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8025dd:	8d 76 00             	lea    0x0(%esi),%esi
  8025e0:	89 da                	mov    %ebx,%edx
  8025e2:	29 fe                	sub    %edi,%esi
  8025e4:	19 c2                	sbb    %eax,%edx
  8025e6:	89 f1                	mov    %esi,%ecx
  8025e8:	89 c8                	mov    %ecx,%eax
  8025ea:	e9 4b ff ff ff       	jmp    80253a <__umoddi3+0x8a>
