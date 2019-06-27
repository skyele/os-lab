
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
  800060:	e8 2d 0a 00 00       	call   800a92 <strcmp>
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
  80008e:	e8 f0 13 00 00       	call   801483 <write>
  800093:	83 c4 10             	add    $0x10,%esp
		write(1, argv[i], strlen(argv[i]));
  800096:	83 ec 0c             	sub    $0xc,%esp
  800099:	ff 34 9e             	pushl  (%esi,%ebx,4)
  80009c:	e8 0d 09 00 00       	call   8009ae <strlen>
  8000a1:	83 c4 0c             	add    $0xc,%esp
  8000a4:	50                   	push   %eax
  8000a5:	ff 34 9e             	pushl  (%esi,%ebx,4)
  8000a8:	6a 01                	push   $0x1
  8000aa:	e8 d4 13 00 00       	call   801483 <write>
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
  8000da:	e8 a4 13 00 00       	call   801483 <write>
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
  8000f7:	e8 9f 0c 00 00       	call   800d9b <sys_getenvid>
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
  80011c:	74 23                	je     800141 <libmain+0x5d>
		if(envs[i].env_id == find)
  80011e:	69 ca 84 00 00 00    	imul   $0x84,%edx,%ecx
  800124:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80012a:	8b 49 48             	mov    0x48(%ecx),%ecx
  80012d:	39 c1                	cmp    %eax,%ecx
  80012f:	75 e2                	jne    800113 <libmain+0x2f>
  800131:	69 da 84 00 00 00    	imul   $0x84,%edx,%ebx
  800137:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80013d:	89 fe                	mov    %edi,%esi
  80013f:	eb d2                	jmp    800113 <libmain+0x2f>
  800141:	89 f0                	mov    %esi,%eax
  800143:	84 c0                	test   %al,%al
  800145:	74 06                	je     80014d <libmain+0x69>
  800147:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80014d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800151:	7e 0a                	jle    80015d <libmain+0x79>
		binaryname = argv[0];
  800153:	8b 45 0c             	mov    0xc(%ebp),%eax
  800156:	8b 00                	mov    (%eax),%eax
  800158:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  80015d:	a1 08 40 80 00       	mov    0x804008,%eax
  800162:	8b 40 48             	mov    0x48(%eax),%eax
  800165:	83 ec 08             	sub    $0x8,%esp
  800168:	50                   	push   %eax
  800169:	68 25 26 80 00       	push   $0x802625
  80016e:	e8 15 01 00 00       	call   800288 <cprintf>
	cprintf("before umain\n");
  800173:	c7 04 24 43 26 80 00 	movl   $0x802643,(%esp)
  80017a:	e8 09 01 00 00       	call   800288 <cprintf>
	// call user main routine
	umain(argc, argv);
  80017f:	83 c4 08             	add    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 a6 fe ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  80018d:	c7 04 24 51 26 80 00 	movl   $0x802651,(%esp)
  800194:	e8 ef 00 00 00       	call   800288 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800199:	a1 08 40 80 00       	mov    0x804008,%eax
  80019e:	8b 40 48             	mov    0x48(%eax),%eax
  8001a1:	83 c4 08             	add    $0x8,%esp
  8001a4:	50                   	push   %eax
  8001a5:	68 5e 26 80 00       	push   $0x80265e
  8001aa:	e8 d9 00 00 00       	call   800288 <cprintf>
	// exit gracefully
	exit();
  8001af:	e8 0b 00 00 00       	call   8001bf <exit>
}
  8001b4:	83 c4 10             	add    $0x10,%esp
  8001b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ba:	5b                   	pop    %ebx
  8001bb:	5e                   	pop    %esi
  8001bc:	5f                   	pop    %edi
  8001bd:	5d                   	pop    %ebp
  8001be:	c3                   	ret    

008001bf <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001bf:	55                   	push   %ebp
  8001c0:	89 e5                	mov    %esp,%ebp
  8001c2:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8001c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8001ca:	8b 40 48             	mov    0x48(%eax),%eax
  8001cd:	68 88 26 80 00       	push   $0x802688
  8001d2:	50                   	push   %eax
  8001d3:	68 7d 26 80 00       	push   $0x80267d
  8001d8:	e8 ab 00 00 00       	call   800288 <cprintf>
	close_all();
  8001dd:	e8 c4 10 00 00       	call   8012a6 <close_all>
	sys_env_destroy(0);
  8001e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001e9:	e8 6c 0b 00 00       	call   800d5a <sys_env_destroy>
}
  8001ee:	83 c4 10             	add    $0x10,%esp
  8001f1:	c9                   	leave  
  8001f2:	c3                   	ret    

008001f3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	53                   	push   %ebx
  8001f7:	83 ec 04             	sub    $0x4,%esp
  8001fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001fd:	8b 13                	mov    (%ebx),%edx
  8001ff:	8d 42 01             	lea    0x1(%edx),%eax
  800202:	89 03                	mov    %eax,(%ebx)
  800204:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800207:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80020b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800210:	74 09                	je     80021b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800212:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800216:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800219:	c9                   	leave  
  80021a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	68 ff 00 00 00       	push   $0xff
  800223:	8d 43 08             	lea    0x8(%ebx),%eax
  800226:	50                   	push   %eax
  800227:	e8 f1 0a 00 00       	call   800d1d <sys_cputs>
		b->idx = 0;
  80022c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800232:	83 c4 10             	add    $0x10,%esp
  800235:	eb db                	jmp    800212 <putch+0x1f>

00800237 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800240:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800247:	00 00 00 
	b.cnt = 0;
  80024a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800251:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800254:	ff 75 0c             	pushl  0xc(%ebp)
  800257:	ff 75 08             	pushl  0x8(%ebp)
  80025a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800260:	50                   	push   %eax
  800261:	68 f3 01 80 00       	push   $0x8001f3
  800266:	e8 4a 01 00 00       	call   8003b5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026b:	83 c4 08             	add    $0x8,%esp
  80026e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800274:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80027a:	50                   	push   %eax
  80027b:	e8 9d 0a 00 00       	call   800d1d <sys_cputs>

	return b.cnt;
}
  800280:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800286:	c9                   	leave  
  800287:	c3                   	ret    

00800288 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80028e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800291:	50                   	push   %eax
  800292:	ff 75 08             	pushl  0x8(%ebp)
  800295:	e8 9d ff ff ff       	call   800237 <vcprintf>
	va_end(ap);

	return cnt;
}
  80029a:	c9                   	leave  
  80029b:	c3                   	ret    

0080029c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80029c:	55                   	push   %ebp
  80029d:	89 e5                	mov    %esp,%ebp
  80029f:	57                   	push   %edi
  8002a0:	56                   	push   %esi
  8002a1:	53                   	push   %ebx
  8002a2:	83 ec 1c             	sub    $0x1c,%esp
  8002a5:	89 c6                	mov    %eax,%esi
  8002a7:	89 d7                	mov    %edx,%edi
  8002a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8002b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8002b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8002bb:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8002bf:	74 2c                	je     8002ed <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8002c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8002cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002ce:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8002d1:	39 c2                	cmp    %eax,%edx
  8002d3:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8002d6:	73 43                	jae    80031b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8002d8:	83 eb 01             	sub    $0x1,%ebx
  8002db:	85 db                	test   %ebx,%ebx
  8002dd:	7e 6c                	jle    80034b <printnum+0xaf>
				putch(padc, putdat);
  8002df:	83 ec 08             	sub    $0x8,%esp
  8002e2:	57                   	push   %edi
  8002e3:	ff 75 18             	pushl  0x18(%ebp)
  8002e6:	ff d6                	call   *%esi
  8002e8:	83 c4 10             	add    $0x10,%esp
  8002eb:	eb eb                	jmp    8002d8 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8002ed:	83 ec 0c             	sub    $0xc,%esp
  8002f0:	6a 20                	push   $0x20
  8002f2:	6a 00                	push   $0x0
  8002f4:	50                   	push   %eax
  8002f5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002f8:	ff 75 e0             	pushl  -0x20(%ebp)
  8002fb:	89 fa                	mov    %edi,%edx
  8002fd:	89 f0                	mov    %esi,%eax
  8002ff:	e8 98 ff ff ff       	call   80029c <printnum>
		while (--width > 0)
  800304:	83 c4 20             	add    $0x20,%esp
  800307:	83 eb 01             	sub    $0x1,%ebx
  80030a:	85 db                	test   %ebx,%ebx
  80030c:	7e 65                	jle    800373 <printnum+0xd7>
			putch(padc, putdat);
  80030e:	83 ec 08             	sub    $0x8,%esp
  800311:	57                   	push   %edi
  800312:	6a 20                	push   $0x20
  800314:	ff d6                	call   *%esi
  800316:	83 c4 10             	add    $0x10,%esp
  800319:	eb ec                	jmp    800307 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	ff 75 18             	pushl  0x18(%ebp)
  800321:	83 eb 01             	sub    $0x1,%ebx
  800324:	53                   	push   %ebx
  800325:	50                   	push   %eax
  800326:	83 ec 08             	sub    $0x8,%esp
  800329:	ff 75 dc             	pushl  -0x24(%ebp)
  80032c:	ff 75 d8             	pushl  -0x28(%ebp)
  80032f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800332:	ff 75 e0             	pushl  -0x20(%ebp)
  800335:	e8 86 20 00 00       	call   8023c0 <__udivdi3>
  80033a:	83 c4 18             	add    $0x18,%esp
  80033d:	52                   	push   %edx
  80033e:	50                   	push   %eax
  80033f:	89 fa                	mov    %edi,%edx
  800341:	89 f0                	mov    %esi,%eax
  800343:	e8 54 ff ff ff       	call   80029c <printnum>
  800348:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	57                   	push   %edi
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	ff 75 dc             	pushl  -0x24(%ebp)
  800355:	ff 75 d8             	pushl  -0x28(%ebp)
  800358:	ff 75 e4             	pushl  -0x1c(%ebp)
  80035b:	ff 75 e0             	pushl  -0x20(%ebp)
  80035e:	e8 6d 21 00 00       	call   8024d0 <__umoddi3>
  800363:	83 c4 14             	add    $0x14,%esp
  800366:	0f be 80 8d 26 80 00 	movsbl 0x80268d(%eax),%eax
  80036d:	50                   	push   %eax
  80036e:	ff d6                	call   *%esi
  800370:	83 c4 10             	add    $0x10,%esp
	}
}
  800373:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800376:	5b                   	pop    %ebx
  800377:	5e                   	pop    %esi
  800378:	5f                   	pop    %edi
  800379:	5d                   	pop    %ebp
  80037a:	c3                   	ret    

0080037b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800381:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800385:	8b 10                	mov    (%eax),%edx
  800387:	3b 50 04             	cmp    0x4(%eax),%edx
  80038a:	73 0a                	jae    800396 <sprintputch+0x1b>
		*b->buf++ = ch;
  80038c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80038f:	89 08                	mov    %ecx,(%eax)
  800391:	8b 45 08             	mov    0x8(%ebp),%eax
  800394:	88 02                	mov    %al,(%edx)
}
  800396:	5d                   	pop    %ebp
  800397:	c3                   	ret    

00800398 <printfmt>:
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80039e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8003a1:	50                   	push   %eax
  8003a2:	ff 75 10             	pushl  0x10(%ebp)
  8003a5:	ff 75 0c             	pushl  0xc(%ebp)
  8003a8:	ff 75 08             	pushl  0x8(%ebp)
  8003ab:	e8 05 00 00 00       	call   8003b5 <vprintfmt>
}
  8003b0:	83 c4 10             	add    $0x10,%esp
  8003b3:	c9                   	leave  
  8003b4:	c3                   	ret    

008003b5 <vprintfmt>:
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	57                   	push   %edi
  8003b9:	56                   	push   %esi
  8003ba:	53                   	push   %ebx
  8003bb:	83 ec 3c             	sub    $0x3c,%esp
  8003be:	8b 75 08             	mov    0x8(%ebp),%esi
  8003c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8003c4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003c7:	e9 32 04 00 00       	jmp    8007fe <vprintfmt+0x449>
		padc = ' ';
  8003cc:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8003d0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8003d7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8003de:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8003e5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8003ec:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8003f3:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003f8:	8d 47 01             	lea    0x1(%edi),%eax
  8003fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003fe:	0f b6 17             	movzbl (%edi),%edx
  800401:	8d 42 dd             	lea    -0x23(%edx),%eax
  800404:	3c 55                	cmp    $0x55,%al
  800406:	0f 87 12 05 00 00    	ja     80091e <vprintfmt+0x569>
  80040c:	0f b6 c0             	movzbl %al,%eax
  80040f:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
  800416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800419:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80041d:	eb d9                	jmp    8003f8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80041f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800422:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800426:	eb d0                	jmp    8003f8 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800428:	0f b6 d2             	movzbl %dl,%edx
  80042b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80042e:	b8 00 00 00 00       	mov    $0x0,%eax
  800433:	89 75 08             	mov    %esi,0x8(%ebp)
  800436:	eb 03                	jmp    80043b <vprintfmt+0x86>
  800438:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80043b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80043e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800442:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800445:	8d 72 d0             	lea    -0x30(%edx),%esi
  800448:	83 fe 09             	cmp    $0x9,%esi
  80044b:	76 eb                	jbe    800438 <vprintfmt+0x83>
  80044d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800450:	8b 75 08             	mov    0x8(%ebp),%esi
  800453:	eb 14                	jmp    800469 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	8b 00                	mov    (%eax),%eax
  80045a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80045d:	8b 45 14             	mov    0x14(%ebp),%eax
  800460:	8d 40 04             	lea    0x4(%eax),%eax
  800463:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800466:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800469:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80046d:	79 89                	jns    8003f8 <vprintfmt+0x43>
				width = precision, precision = -1;
  80046f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800472:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800475:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80047c:	e9 77 ff ff ff       	jmp    8003f8 <vprintfmt+0x43>
  800481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800484:	85 c0                	test   %eax,%eax
  800486:	0f 48 c1             	cmovs  %ecx,%eax
  800489:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80048c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80048f:	e9 64 ff ff ff       	jmp    8003f8 <vprintfmt+0x43>
  800494:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800497:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80049e:	e9 55 ff ff ff       	jmp    8003f8 <vprintfmt+0x43>
			lflag++;
  8004a3:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8004aa:	e9 49 ff ff ff       	jmp    8003f8 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8d 78 04             	lea    0x4(%eax),%edi
  8004b5:	83 ec 08             	sub    $0x8,%esp
  8004b8:	53                   	push   %ebx
  8004b9:	ff 30                	pushl  (%eax)
  8004bb:	ff d6                	call   *%esi
			break;
  8004bd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8004c0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8004c3:	e9 33 03 00 00       	jmp    8007fb <vprintfmt+0x446>
			err = va_arg(ap, int);
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8d 78 04             	lea    0x4(%eax),%edi
  8004ce:	8b 00                	mov    (%eax),%eax
  8004d0:	99                   	cltd   
  8004d1:	31 d0                	xor    %edx,%eax
  8004d3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8004d5:	83 f8 11             	cmp    $0x11,%eax
  8004d8:	7f 23                	jg     8004fd <vprintfmt+0x148>
  8004da:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  8004e1:	85 d2                	test   %edx,%edx
  8004e3:	74 18                	je     8004fd <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8004e5:	52                   	push   %edx
  8004e6:	68 dd 2a 80 00       	push   $0x802add
  8004eb:	53                   	push   %ebx
  8004ec:	56                   	push   %esi
  8004ed:	e8 a6 fe ff ff       	call   800398 <printfmt>
  8004f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004f5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004f8:	e9 fe 02 00 00       	jmp    8007fb <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8004fd:	50                   	push   %eax
  8004fe:	68 a5 26 80 00       	push   $0x8026a5
  800503:	53                   	push   %ebx
  800504:	56                   	push   %esi
  800505:	e8 8e fe ff ff       	call   800398 <printfmt>
  80050a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80050d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800510:	e9 e6 02 00 00       	jmp    8007fb <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800515:	8b 45 14             	mov    0x14(%ebp),%eax
  800518:	83 c0 04             	add    $0x4,%eax
  80051b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80051e:	8b 45 14             	mov    0x14(%ebp),%eax
  800521:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800523:	85 c9                	test   %ecx,%ecx
  800525:	b8 9e 26 80 00       	mov    $0x80269e,%eax
  80052a:	0f 45 c1             	cmovne %ecx,%eax
  80052d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800530:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800534:	7e 06                	jle    80053c <vprintfmt+0x187>
  800536:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80053a:	75 0d                	jne    800549 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80053c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80053f:	89 c7                	mov    %eax,%edi
  800541:	03 45 e0             	add    -0x20(%ebp),%eax
  800544:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800547:	eb 53                	jmp    80059c <vprintfmt+0x1e7>
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 d8             	pushl  -0x28(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 71 04 00 00       	call   8009c6 <strnlen>
  800555:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800558:	29 c1                	sub    %eax,%ecx
  80055a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800562:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800566:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800569:	eb 0f                	jmp    80057a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	53                   	push   %ebx
  80056f:	ff 75 e0             	pushl  -0x20(%ebp)
  800572:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800574:	83 ef 01             	sub    $0x1,%edi
  800577:	83 c4 10             	add    $0x10,%esp
  80057a:	85 ff                	test   %edi,%edi
  80057c:	7f ed                	jg     80056b <vprintfmt+0x1b6>
  80057e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800581:	85 c9                	test   %ecx,%ecx
  800583:	b8 00 00 00 00       	mov    $0x0,%eax
  800588:	0f 49 c1             	cmovns %ecx,%eax
  80058b:	29 c1                	sub    %eax,%ecx
  80058d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800590:	eb aa                	jmp    80053c <vprintfmt+0x187>
					putch(ch, putdat);
  800592:	83 ec 08             	sub    $0x8,%esp
  800595:	53                   	push   %ebx
  800596:	52                   	push   %edx
  800597:	ff d6                	call   *%esi
  800599:	83 c4 10             	add    $0x10,%esp
  80059c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80059f:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005a1:	83 c7 01             	add    $0x1,%edi
  8005a4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8005a8:	0f be d0             	movsbl %al,%edx
  8005ab:	85 d2                	test   %edx,%edx
  8005ad:	74 4b                	je     8005fa <vprintfmt+0x245>
  8005af:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8005b3:	78 06                	js     8005bb <vprintfmt+0x206>
  8005b5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8005b9:	78 1e                	js     8005d9 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8005bb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8005bf:	74 d1                	je     800592 <vprintfmt+0x1dd>
  8005c1:	0f be c0             	movsbl %al,%eax
  8005c4:	83 e8 20             	sub    $0x20,%eax
  8005c7:	83 f8 5e             	cmp    $0x5e,%eax
  8005ca:	76 c6                	jbe    800592 <vprintfmt+0x1dd>
					putch('?', putdat);
  8005cc:	83 ec 08             	sub    $0x8,%esp
  8005cf:	53                   	push   %ebx
  8005d0:	6a 3f                	push   $0x3f
  8005d2:	ff d6                	call   *%esi
  8005d4:	83 c4 10             	add    $0x10,%esp
  8005d7:	eb c3                	jmp    80059c <vprintfmt+0x1e7>
  8005d9:	89 cf                	mov    %ecx,%edi
  8005db:	eb 0e                	jmp    8005eb <vprintfmt+0x236>
				putch(' ', putdat);
  8005dd:	83 ec 08             	sub    $0x8,%esp
  8005e0:	53                   	push   %ebx
  8005e1:	6a 20                	push   $0x20
  8005e3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005e5:	83 ef 01             	sub    $0x1,%edi
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	85 ff                	test   %edi,%edi
  8005ed:	7f ee                	jg     8005dd <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8005ef:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
  8005f5:	e9 01 02 00 00       	jmp    8007fb <vprintfmt+0x446>
  8005fa:	89 cf                	mov    %ecx,%edi
  8005fc:	eb ed                	jmp    8005eb <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8005fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800601:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800608:	e9 eb fd ff ff       	jmp    8003f8 <vprintfmt+0x43>
	if (lflag >= 2)
  80060d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800611:	7f 21                	jg     800634 <vprintfmt+0x27f>
	else if (lflag)
  800613:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800617:	74 68                	je     800681 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8b 00                	mov    (%eax),%eax
  80061e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800621:	89 c1                	mov    %eax,%ecx
  800623:	c1 f9 1f             	sar    $0x1f,%ecx
  800626:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800629:	8b 45 14             	mov    0x14(%ebp),%eax
  80062c:	8d 40 04             	lea    0x4(%eax),%eax
  80062f:	89 45 14             	mov    %eax,0x14(%ebp)
  800632:	eb 17                	jmp    80064b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 50 04             	mov    0x4(%eax),%edx
  80063a:	8b 00                	mov    (%eax),%eax
  80063c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80063f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8d 40 08             	lea    0x8(%eax),%eax
  800648:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80064b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80064e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800651:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800654:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800657:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80065b:	78 3f                	js     80069c <vprintfmt+0x2e7>
			base = 10;
  80065d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800662:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800666:	0f 84 71 01 00 00    	je     8007dd <vprintfmt+0x428>
				putch('+', putdat);
  80066c:	83 ec 08             	sub    $0x8,%esp
  80066f:	53                   	push   %ebx
  800670:	6a 2b                	push   $0x2b
  800672:	ff d6                	call   *%esi
  800674:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800677:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067c:	e9 5c 01 00 00       	jmp    8007dd <vprintfmt+0x428>
		return va_arg(*ap, int);
  800681:	8b 45 14             	mov    0x14(%ebp),%eax
  800684:	8b 00                	mov    (%eax),%eax
  800686:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800689:	89 c1                	mov    %eax,%ecx
  80068b:	c1 f9 1f             	sar    $0x1f,%ecx
  80068e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	8d 40 04             	lea    0x4(%eax),%eax
  800697:	89 45 14             	mov    %eax,0x14(%ebp)
  80069a:	eb af                	jmp    80064b <vprintfmt+0x296>
				putch('-', putdat);
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	53                   	push   %ebx
  8006a0:	6a 2d                	push   $0x2d
  8006a2:	ff d6                	call   *%esi
				num = -(long long) num;
  8006a4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8006aa:	f7 d8                	neg    %eax
  8006ac:	83 d2 00             	adc    $0x0,%edx
  8006af:	f7 da                	neg    %edx
  8006b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8006ba:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006bf:	e9 19 01 00 00       	jmp    8007dd <vprintfmt+0x428>
	if (lflag >= 2)
  8006c4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006c8:	7f 29                	jg     8006f3 <vprintfmt+0x33e>
	else if (lflag)
  8006ca:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006ce:	74 44                	je     800714 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8006d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d3:	8b 00                	mov    (%eax),%eax
  8006d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8006da:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006dd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e3:	8d 40 04             	lea    0x4(%eax),%eax
  8006e6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006e9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006ee:	e9 ea 00 00 00       	jmp    8007dd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 50 04             	mov    0x4(%eax),%edx
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006fe:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800701:	8b 45 14             	mov    0x14(%ebp),%eax
  800704:	8d 40 08             	lea    0x8(%eax),%eax
  800707:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80070a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80070f:	e9 c9 00 00 00       	jmp    8007dd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 00                	mov    (%eax),%eax
  800719:	ba 00 00 00 00       	mov    $0x0,%edx
  80071e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800721:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80072d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800732:	e9 a6 00 00 00       	jmp    8007dd <vprintfmt+0x428>
			putch('0', putdat);
  800737:	83 ec 08             	sub    $0x8,%esp
  80073a:	53                   	push   %ebx
  80073b:	6a 30                	push   $0x30
  80073d:	ff d6                	call   *%esi
	if (lflag >= 2)
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800746:	7f 26                	jg     80076e <vprintfmt+0x3b9>
	else if (lflag)
  800748:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80074c:	74 3e                	je     80078c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	ba 00 00 00 00       	mov    $0x0,%edx
  800758:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80075b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800767:	b8 08 00 00 00       	mov    $0x8,%eax
  80076c:	eb 6f                	jmp    8007dd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8b 50 04             	mov    0x4(%eax),%edx
  800774:	8b 00                	mov    (%eax),%eax
  800776:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800779:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8d 40 08             	lea    0x8(%eax),%eax
  800782:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800785:	b8 08 00 00 00       	mov    $0x8,%eax
  80078a:	eb 51                	jmp    8007dd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80078c:	8b 45 14             	mov    0x14(%ebp),%eax
  80078f:	8b 00                	mov    (%eax),%eax
  800791:	ba 00 00 00 00       	mov    $0x0,%edx
  800796:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800799:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8d 40 04             	lea    0x4(%eax),%eax
  8007a2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a5:	b8 08 00 00 00       	mov    $0x8,%eax
  8007aa:	eb 31                	jmp    8007dd <vprintfmt+0x428>
			putch('0', putdat);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	53                   	push   %ebx
  8007b0:	6a 30                	push   $0x30
  8007b2:	ff d6                	call   *%esi
			putch('x', putdat);
  8007b4:	83 c4 08             	add    $0x8,%esp
  8007b7:	53                   	push   %ebx
  8007b8:	6a 78                	push   $0x78
  8007ba:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007bc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bf:	8b 00                	mov    (%eax),%eax
  8007c1:	ba 00 00 00 00       	mov    $0x0,%edx
  8007c6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8007cc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 40 04             	lea    0x4(%eax),%eax
  8007d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007d8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007dd:	83 ec 0c             	sub    $0xc,%esp
  8007e0:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8007e4:	52                   	push   %edx
  8007e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8007e8:	50                   	push   %eax
  8007e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8007ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8007ef:	89 da                	mov    %ebx,%edx
  8007f1:	89 f0                	mov    %esi,%eax
  8007f3:	e8 a4 fa ff ff       	call   80029c <printnum>
			break;
  8007f8:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8007fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007fe:	83 c7 01             	add    $0x1,%edi
  800801:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800805:	83 f8 25             	cmp    $0x25,%eax
  800808:	0f 84 be fb ff ff    	je     8003cc <vprintfmt+0x17>
			if (ch == '\0')
  80080e:	85 c0                	test   %eax,%eax
  800810:	0f 84 28 01 00 00    	je     80093e <vprintfmt+0x589>
			putch(ch, putdat);
  800816:	83 ec 08             	sub    $0x8,%esp
  800819:	53                   	push   %ebx
  80081a:	50                   	push   %eax
  80081b:	ff d6                	call   *%esi
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb dc                	jmp    8007fe <vprintfmt+0x449>
	if (lflag >= 2)
  800822:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800826:	7f 26                	jg     80084e <vprintfmt+0x499>
	else if (lflag)
  800828:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80082c:	74 41                	je     80086f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80082e:	8b 45 14             	mov    0x14(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	ba 00 00 00 00       	mov    $0x0,%edx
  800838:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80083b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80083e:	8b 45 14             	mov    0x14(%ebp),%eax
  800841:	8d 40 04             	lea    0x4(%eax),%eax
  800844:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800847:	b8 10 00 00 00       	mov    $0x10,%eax
  80084c:	eb 8f                	jmp    8007dd <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80084e:	8b 45 14             	mov    0x14(%ebp),%eax
  800851:	8b 50 04             	mov    0x4(%eax),%edx
  800854:	8b 00                	mov    (%eax),%eax
  800856:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800859:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80085c:	8b 45 14             	mov    0x14(%ebp),%eax
  80085f:	8d 40 08             	lea    0x8(%eax),%eax
  800862:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800865:	b8 10 00 00 00       	mov    $0x10,%eax
  80086a:	e9 6e ff ff ff       	jmp    8007dd <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80086f:	8b 45 14             	mov    0x14(%ebp),%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	ba 00 00 00 00       	mov    $0x0,%edx
  800879:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80087c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 40 04             	lea    0x4(%eax),%eax
  800885:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800888:	b8 10 00 00 00       	mov    $0x10,%eax
  80088d:	e9 4b ff ff ff       	jmp    8007dd <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	8b 00                	mov    (%eax),%eax
  8008a0:	85 c0                	test   %eax,%eax
  8008a2:	74 14                	je     8008b8 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8008a4:	8b 13                	mov    (%ebx),%edx
  8008a6:	83 fa 7f             	cmp    $0x7f,%edx
  8008a9:	7f 37                	jg     8008e2 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8008ab:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8008ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	e9 43 ff ff ff       	jmp    8007fb <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8008b8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008bd:	bf c1 27 80 00       	mov    $0x8027c1,%edi
							putch(ch, putdat);
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	53                   	push   %ebx
  8008c6:	50                   	push   %eax
  8008c7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008c9:	83 c7 01             	add    $0x1,%edi
  8008cc:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008d0:	83 c4 10             	add    $0x10,%esp
  8008d3:	85 c0                	test   %eax,%eax
  8008d5:	75 eb                	jne    8008c2 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8008d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8008da:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dd:	e9 19 ff ff ff       	jmp    8007fb <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8008e2:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8008e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e9:	bf f9 27 80 00       	mov    $0x8027f9,%edi
							putch(ch, putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	53                   	push   %ebx
  8008f2:	50                   	push   %eax
  8008f3:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8008f5:	83 c7 01             	add    $0x1,%edi
  8008f8:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	85 c0                	test   %eax,%eax
  800901:	75 eb                	jne    8008ee <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800906:	89 45 14             	mov    %eax,0x14(%ebp)
  800909:	e9 ed fe ff ff       	jmp    8007fb <vprintfmt+0x446>
			putch(ch, putdat);
  80090e:	83 ec 08             	sub    $0x8,%esp
  800911:	53                   	push   %ebx
  800912:	6a 25                	push   $0x25
  800914:	ff d6                	call   *%esi
			break;
  800916:	83 c4 10             	add    $0x10,%esp
  800919:	e9 dd fe ff ff       	jmp    8007fb <vprintfmt+0x446>
			putch('%', putdat);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	53                   	push   %ebx
  800922:	6a 25                	push   $0x25
  800924:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	89 f8                	mov    %edi,%eax
  80092b:	eb 03                	jmp    800930 <vprintfmt+0x57b>
  80092d:	83 e8 01             	sub    $0x1,%eax
  800930:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800934:	75 f7                	jne    80092d <vprintfmt+0x578>
  800936:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800939:	e9 bd fe ff ff       	jmp    8007fb <vprintfmt+0x446>
}
  80093e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800941:	5b                   	pop    %ebx
  800942:	5e                   	pop    %esi
  800943:	5f                   	pop    %edi
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 18             	sub    $0x18,%esp
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800952:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800955:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800959:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80095c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800963:	85 c0                	test   %eax,%eax
  800965:	74 26                	je     80098d <vsnprintf+0x47>
  800967:	85 d2                	test   %edx,%edx
  800969:	7e 22                	jle    80098d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80096b:	ff 75 14             	pushl  0x14(%ebp)
  80096e:	ff 75 10             	pushl  0x10(%ebp)
  800971:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800974:	50                   	push   %eax
  800975:	68 7b 03 80 00       	push   $0x80037b
  80097a:	e8 36 fa ff ff       	call   8003b5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80097f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800982:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800985:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800988:	83 c4 10             	add    $0x10,%esp
}
  80098b:	c9                   	leave  
  80098c:	c3                   	ret    
		return -E_INVAL;
  80098d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800992:	eb f7                	jmp    80098b <vsnprintf+0x45>

00800994 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80099a:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80099d:	50                   	push   %eax
  80099e:	ff 75 10             	pushl  0x10(%ebp)
  8009a1:	ff 75 0c             	pushl  0xc(%ebp)
  8009a4:	ff 75 08             	pushl  0x8(%ebp)
  8009a7:	e8 9a ff ff ff       	call   800946 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009ac:	c9                   	leave  
  8009ad:	c3                   	ret    

008009ae <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8009b9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009bd:	74 05                	je     8009c4 <strlen+0x16>
		n++;
  8009bf:	83 c0 01             	add    $0x1,%eax
  8009c2:	eb f5                	jmp    8009b9 <strlen+0xb>
	return n;
}
  8009c4:	5d                   	pop    %ebp
  8009c5:	c3                   	ret    

008009c6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009c6:	55                   	push   %ebp
  8009c7:	89 e5                	mov    %esp,%ebp
  8009c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009cc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8009d4:	39 c2                	cmp    %eax,%edx
  8009d6:	74 0d                	je     8009e5 <strnlen+0x1f>
  8009d8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8009dc:	74 05                	je     8009e3 <strnlen+0x1d>
		n++;
  8009de:	83 c2 01             	add    $0x1,%edx
  8009e1:	eb f1                	jmp    8009d4 <strnlen+0xe>
  8009e3:	89 d0                	mov    %edx,%eax
	return n;
}
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	53                   	push   %ebx
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f6:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009fa:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009fd:	83 c2 01             	add    $0x1,%edx
  800a00:	84 c9                	test   %cl,%cl
  800a02:	75 f2                	jne    8009f6 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a04:	5b                   	pop    %ebx
  800a05:	5d                   	pop    %ebp
  800a06:	c3                   	ret    

00800a07 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	53                   	push   %ebx
  800a0b:	83 ec 10             	sub    $0x10,%esp
  800a0e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800a11:	53                   	push   %ebx
  800a12:	e8 97 ff ff ff       	call   8009ae <strlen>
  800a17:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800a1a:	ff 75 0c             	pushl  0xc(%ebp)
  800a1d:	01 d8                	add    %ebx,%eax
  800a1f:	50                   	push   %eax
  800a20:	e8 c2 ff ff ff       	call   8009e7 <strcpy>
	return dst;
}
  800a25:	89 d8                	mov    %ebx,%eax
  800a27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a2a:	c9                   	leave  
  800a2b:	c3                   	ret    

00800a2c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	56                   	push   %esi
  800a30:	53                   	push   %ebx
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a37:	89 c6                	mov    %eax,%esi
  800a39:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3c:	89 c2                	mov    %eax,%edx
  800a3e:	39 f2                	cmp    %esi,%edx
  800a40:	74 11                	je     800a53 <strncpy+0x27>
		*dst++ = *src;
  800a42:	83 c2 01             	add    $0x1,%edx
  800a45:	0f b6 19             	movzbl (%ecx),%ebx
  800a48:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a4b:	80 fb 01             	cmp    $0x1,%bl
  800a4e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800a51:	eb eb                	jmp    800a3e <strncpy+0x12>
	}
	return ret;
}
  800a53:	5b                   	pop    %ebx
  800a54:	5e                   	pop    %esi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	56                   	push   %esi
  800a5b:	53                   	push   %ebx
  800a5c:	8b 75 08             	mov    0x8(%ebp),%esi
  800a5f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a62:	8b 55 10             	mov    0x10(%ebp),%edx
  800a65:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a67:	85 d2                	test   %edx,%edx
  800a69:	74 21                	je     800a8c <strlcpy+0x35>
  800a6b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  800a6f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800a71:	39 c2                	cmp    %eax,%edx
  800a73:	74 14                	je     800a89 <strlcpy+0x32>
  800a75:	0f b6 19             	movzbl (%ecx),%ebx
  800a78:	84 db                	test   %bl,%bl
  800a7a:	74 0b                	je     800a87 <strlcpy+0x30>
			*dst++ = *src++;
  800a7c:	83 c1 01             	add    $0x1,%ecx
  800a7f:	83 c2 01             	add    $0x1,%edx
  800a82:	88 5a ff             	mov    %bl,-0x1(%edx)
  800a85:	eb ea                	jmp    800a71 <strlcpy+0x1a>
  800a87:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800a89:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a8c:	29 f0                	sub    %esi,%eax
}
  800a8e:	5b                   	pop    %ebx
  800a8f:	5e                   	pop    %esi
  800a90:	5d                   	pop    %ebp
  800a91:	c3                   	ret    

00800a92 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a9b:	0f b6 01             	movzbl (%ecx),%eax
  800a9e:	84 c0                	test   %al,%al
  800aa0:	74 0c                	je     800aae <strcmp+0x1c>
  800aa2:	3a 02                	cmp    (%edx),%al
  800aa4:	75 08                	jne    800aae <strcmp+0x1c>
		p++, q++;
  800aa6:	83 c1 01             	add    $0x1,%ecx
  800aa9:	83 c2 01             	add    $0x1,%edx
  800aac:	eb ed                	jmp    800a9b <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800aae:	0f b6 c0             	movzbl %al,%eax
  800ab1:	0f b6 12             	movzbl (%edx),%edx
  800ab4:	29 d0                	sub    %edx,%eax
}
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	53                   	push   %ebx
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ac2:	89 c3                	mov    %eax,%ebx
  800ac4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800ac7:	eb 06                	jmp    800acf <strncmp+0x17>
		n--, p++, q++;
  800ac9:	83 c0 01             	add    $0x1,%eax
  800acc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800acf:	39 d8                	cmp    %ebx,%eax
  800ad1:	74 16                	je     800ae9 <strncmp+0x31>
  800ad3:	0f b6 08             	movzbl (%eax),%ecx
  800ad6:	84 c9                	test   %cl,%cl
  800ad8:	74 04                	je     800ade <strncmp+0x26>
  800ada:	3a 0a                	cmp    (%edx),%cl
  800adc:	74 eb                	je     800ac9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ade:	0f b6 00             	movzbl (%eax),%eax
  800ae1:	0f b6 12             	movzbl (%edx),%edx
  800ae4:	29 d0                	sub    %edx,%eax
}
  800ae6:	5b                   	pop    %ebx
  800ae7:	5d                   	pop    %ebp
  800ae8:	c3                   	ret    
		return 0;
  800ae9:	b8 00 00 00 00       	mov    $0x0,%eax
  800aee:	eb f6                	jmp    800ae6 <strncmp+0x2e>

00800af0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800af0:	55                   	push   %ebp
  800af1:	89 e5                	mov    %esp,%ebp
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800afa:	0f b6 10             	movzbl (%eax),%edx
  800afd:	84 d2                	test   %dl,%dl
  800aff:	74 09                	je     800b0a <strchr+0x1a>
		if (*s == c)
  800b01:	38 ca                	cmp    %cl,%dl
  800b03:	74 0a                	je     800b0f <strchr+0x1f>
	for (; *s; s++)
  800b05:	83 c0 01             	add    $0x1,%eax
  800b08:	eb f0                	jmp    800afa <strchr+0xa>
			return (char *) s;
	return 0;
  800b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b1b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800b1e:	38 ca                	cmp    %cl,%dl
  800b20:	74 09                	je     800b2b <strfind+0x1a>
  800b22:	84 d2                	test   %dl,%dl
  800b24:	74 05                	je     800b2b <strfind+0x1a>
	for (; *s; s++)
  800b26:	83 c0 01             	add    $0x1,%eax
  800b29:	eb f0                	jmp    800b1b <strfind+0xa>
			break;
	return (char *) s;
}
  800b2b:	5d                   	pop    %ebp
  800b2c:	c3                   	ret    

00800b2d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b2d:	55                   	push   %ebp
  800b2e:	89 e5                	mov    %esp,%ebp
  800b30:	57                   	push   %edi
  800b31:	56                   	push   %esi
  800b32:	53                   	push   %ebx
  800b33:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b36:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b39:	85 c9                	test   %ecx,%ecx
  800b3b:	74 31                	je     800b6e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b3d:	89 f8                	mov    %edi,%eax
  800b3f:	09 c8                	or     %ecx,%eax
  800b41:	a8 03                	test   $0x3,%al
  800b43:	75 23                	jne    800b68 <memset+0x3b>
		c &= 0xFF;
  800b45:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b49:	89 d3                	mov    %edx,%ebx
  800b4b:	c1 e3 08             	shl    $0x8,%ebx
  800b4e:	89 d0                	mov    %edx,%eax
  800b50:	c1 e0 18             	shl    $0x18,%eax
  800b53:	89 d6                	mov    %edx,%esi
  800b55:	c1 e6 10             	shl    $0x10,%esi
  800b58:	09 f0                	or     %esi,%eax
  800b5a:	09 c2                	or     %eax,%edx
  800b5c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800b5e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800b61:	89 d0                	mov    %edx,%eax
  800b63:	fc                   	cld    
  800b64:	f3 ab                	rep stos %eax,%es:(%edi)
  800b66:	eb 06                	jmp    800b6e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6b:	fc                   	cld    
  800b6c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b6e:	89 f8                	mov    %edi,%eax
  800b70:	5b                   	pop    %ebx
  800b71:	5e                   	pop    %esi
  800b72:	5f                   	pop    %edi
  800b73:	5d                   	pop    %ebp
  800b74:	c3                   	ret    

00800b75 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b75:	55                   	push   %ebp
  800b76:	89 e5                	mov    %esp,%ebp
  800b78:	57                   	push   %edi
  800b79:	56                   	push   %esi
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b80:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b83:	39 c6                	cmp    %eax,%esi
  800b85:	73 32                	jae    800bb9 <memmove+0x44>
  800b87:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b8a:	39 c2                	cmp    %eax,%edx
  800b8c:	76 2b                	jbe    800bb9 <memmove+0x44>
		s += n;
		d += n;
  800b8e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b91:	89 fe                	mov    %edi,%esi
  800b93:	09 ce                	or     %ecx,%esi
  800b95:	09 d6                	or     %edx,%esi
  800b97:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9d:	75 0e                	jne    800bad <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b9f:	83 ef 04             	sub    $0x4,%edi
  800ba2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ba8:	fd                   	std    
  800ba9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bab:	eb 09                	jmp    800bb6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800bad:	83 ef 01             	sub    $0x1,%edi
  800bb0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800bb3:	fd                   	std    
  800bb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb6:	fc                   	cld    
  800bb7:	eb 1a                	jmp    800bd3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb9:	89 c2                	mov    %eax,%edx
  800bbb:	09 ca                	or     %ecx,%edx
  800bbd:	09 f2                	or     %esi,%edx
  800bbf:	f6 c2 03             	test   $0x3,%dl
  800bc2:	75 0a                	jne    800bce <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800bc4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800bc7:	89 c7                	mov    %eax,%edi
  800bc9:	fc                   	cld    
  800bca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800bcc:	eb 05                	jmp    800bd3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800bce:	89 c7                	mov    %eax,%edi
  800bd0:	fc                   	cld    
  800bd1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd3:	5e                   	pop    %esi
  800bd4:	5f                   	pop    %edi
  800bd5:	5d                   	pop    %ebp
  800bd6:	c3                   	ret    

00800bd7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bdd:	ff 75 10             	pushl  0x10(%ebp)
  800be0:	ff 75 0c             	pushl  0xc(%ebp)
  800be3:	ff 75 08             	pushl  0x8(%ebp)
  800be6:	e8 8a ff ff ff       	call   800b75 <memmove>
}
  800beb:	c9                   	leave  
  800bec:	c3                   	ret    

00800bed <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	56                   	push   %esi
  800bf1:	53                   	push   %ebx
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf8:	89 c6                	mov    %eax,%esi
  800bfa:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bfd:	39 f0                	cmp    %esi,%eax
  800bff:	74 1c                	je     800c1d <memcmp+0x30>
		if (*s1 != *s2)
  800c01:	0f b6 08             	movzbl (%eax),%ecx
  800c04:	0f b6 1a             	movzbl (%edx),%ebx
  800c07:	38 d9                	cmp    %bl,%cl
  800c09:	75 08                	jne    800c13 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800c0b:	83 c0 01             	add    $0x1,%eax
  800c0e:	83 c2 01             	add    $0x1,%edx
  800c11:	eb ea                	jmp    800bfd <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800c13:	0f b6 c1             	movzbl %cl,%eax
  800c16:	0f b6 db             	movzbl %bl,%ebx
  800c19:	29 d8                	sub    %ebx,%eax
  800c1b:	eb 05                	jmp    800c22 <memcmp+0x35>
	}

	return 0;
  800c1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c22:	5b                   	pop    %ebx
  800c23:	5e                   	pop    %esi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    

00800c26 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800c2f:	89 c2                	mov    %eax,%edx
  800c31:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c34:	39 d0                	cmp    %edx,%eax
  800c36:	73 09                	jae    800c41 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c38:	38 08                	cmp    %cl,(%eax)
  800c3a:	74 05                	je     800c41 <memfind+0x1b>
	for (; s < ends; s++)
  800c3c:	83 c0 01             	add    $0x1,%eax
  800c3f:	eb f3                	jmp    800c34 <memfind+0xe>
			break;
	return (void *) s;
}
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	57                   	push   %edi
  800c47:	56                   	push   %esi
  800c48:	53                   	push   %ebx
  800c49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c4c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4f:	eb 03                	jmp    800c54 <strtol+0x11>
		s++;
  800c51:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800c54:	0f b6 01             	movzbl (%ecx),%eax
  800c57:	3c 20                	cmp    $0x20,%al
  800c59:	74 f6                	je     800c51 <strtol+0xe>
  800c5b:	3c 09                	cmp    $0x9,%al
  800c5d:	74 f2                	je     800c51 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800c5f:	3c 2b                	cmp    $0x2b,%al
  800c61:	74 2a                	je     800c8d <strtol+0x4a>
	int neg = 0;
  800c63:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800c68:	3c 2d                	cmp    $0x2d,%al
  800c6a:	74 2b                	je     800c97 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c6c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800c72:	75 0f                	jne    800c83 <strtol+0x40>
  800c74:	80 39 30             	cmpb   $0x30,(%ecx)
  800c77:	74 28                	je     800ca1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c79:	85 db                	test   %ebx,%ebx
  800c7b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c80:	0f 44 d8             	cmove  %eax,%ebx
  800c83:	b8 00 00 00 00       	mov    $0x0,%eax
  800c88:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800c8b:	eb 50                	jmp    800cdd <strtol+0x9a>
		s++;
  800c8d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800c90:	bf 00 00 00 00       	mov    $0x0,%edi
  800c95:	eb d5                	jmp    800c6c <strtol+0x29>
		s++, neg = 1;
  800c97:	83 c1 01             	add    $0x1,%ecx
  800c9a:	bf 01 00 00 00       	mov    $0x1,%edi
  800c9f:	eb cb                	jmp    800c6c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ca5:	74 0e                	je     800cb5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ca7:	85 db                	test   %ebx,%ebx
  800ca9:	75 d8                	jne    800c83 <strtol+0x40>
		s++, base = 8;
  800cab:	83 c1 01             	add    $0x1,%ecx
  800cae:	bb 08 00 00 00       	mov    $0x8,%ebx
  800cb3:	eb ce                	jmp    800c83 <strtol+0x40>
		s += 2, base = 16;
  800cb5:	83 c1 02             	add    $0x2,%ecx
  800cb8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800cbd:	eb c4                	jmp    800c83 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800cbf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800cc2:	89 f3                	mov    %esi,%ebx
  800cc4:	80 fb 19             	cmp    $0x19,%bl
  800cc7:	77 29                	ja     800cf2 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800cc9:	0f be d2             	movsbl %dl,%edx
  800ccc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ccf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800cd2:	7d 30                	jge    800d04 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800cd4:	83 c1 01             	add    $0x1,%ecx
  800cd7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800cdb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800cdd:	0f b6 11             	movzbl (%ecx),%edx
  800ce0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800ce3:	89 f3                	mov    %esi,%ebx
  800ce5:	80 fb 09             	cmp    $0x9,%bl
  800ce8:	77 d5                	ja     800cbf <strtol+0x7c>
			dig = *s - '0';
  800cea:	0f be d2             	movsbl %dl,%edx
  800ced:	83 ea 30             	sub    $0x30,%edx
  800cf0:	eb dd                	jmp    800ccf <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800cf2:	8d 72 bf             	lea    -0x41(%edx),%esi
  800cf5:	89 f3                	mov    %esi,%ebx
  800cf7:	80 fb 19             	cmp    $0x19,%bl
  800cfa:	77 08                	ja     800d04 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800cfc:	0f be d2             	movsbl %dl,%edx
  800cff:	83 ea 37             	sub    $0x37,%edx
  800d02:	eb cb                	jmp    800ccf <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d08:	74 05                	je     800d0f <strtol+0xcc>
		*endptr = (char *) s;
  800d0a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d0d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800d0f:	89 c2                	mov    %eax,%edx
  800d11:	f7 da                	neg    %edx
  800d13:	85 ff                	test   %edi,%edi
  800d15:	0f 45 c2             	cmovne %edx,%eax
}
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    

00800d1d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	57                   	push   %edi
  800d21:	56                   	push   %esi
  800d22:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d23:	b8 00 00 00 00       	mov    $0x0,%eax
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2e:	89 c3                	mov    %eax,%ebx
  800d30:	89 c7                	mov    %eax,%edi
  800d32:	89 c6                	mov    %eax,%esi
  800d34:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d36:	5b                   	pop    %ebx
  800d37:	5e                   	pop    %esi
  800d38:	5f                   	pop    %edi
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <sys_cgetc>:

int
sys_cgetc(void)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	57                   	push   %edi
  800d3f:	56                   	push   %esi
  800d40:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d41:	ba 00 00 00 00       	mov    $0x0,%edx
  800d46:	b8 01 00 00 00       	mov    $0x1,%eax
  800d4b:	89 d1                	mov    %edx,%ecx
  800d4d:	89 d3                	mov    %edx,%ebx
  800d4f:	89 d7                	mov    %edx,%edi
  800d51:	89 d6                	mov    %edx,%esi
  800d53:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    

00800d5a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	57                   	push   %edi
  800d5e:	56                   	push   %esi
  800d5f:	53                   	push   %ebx
  800d60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d63:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d68:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6b:	b8 03 00 00 00       	mov    $0x3,%eax
  800d70:	89 cb                	mov    %ecx,%ebx
  800d72:	89 cf                	mov    %ecx,%edi
  800d74:	89 ce                	mov    %ecx,%esi
  800d76:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d78:	85 c0                	test   %eax,%eax
  800d7a:	7f 08                	jg     800d84 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d84:	83 ec 0c             	sub    $0xc,%esp
  800d87:	50                   	push   %eax
  800d88:	6a 03                	push   $0x3
  800d8a:	68 08 2a 80 00       	push   $0x802a08
  800d8f:	6a 43                	push   $0x43
  800d91:	68 25 2a 80 00       	push   $0x802a25
  800d96:	e8 89 14 00 00       	call   802224 <_panic>

00800d9b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	57                   	push   %edi
  800d9f:	56                   	push   %esi
  800da0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da1:	ba 00 00 00 00       	mov    $0x0,%edx
  800da6:	b8 02 00 00 00       	mov    $0x2,%eax
  800dab:	89 d1                	mov    %edx,%ecx
  800dad:	89 d3                	mov    %edx,%ebx
  800daf:	89 d7                	mov    %edx,%edi
  800db1:	89 d6                	mov    %edx,%esi
  800db3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <sys_yield>:

void
sys_yield(void)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
  800dbd:	57                   	push   %edi
  800dbe:	56                   	push   %esi
  800dbf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc0:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dca:	89 d1                	mov    %edx,%ecx
  800dcc:	89 d3                	mov    %edx,%ebx
  800dce:	89 d7                	mov    %edx,%edi
  800dd0:	89 d6                	mov    %edx,%esi
  800dd2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dd4:	5b                   	pop    %ebx
  800dd5:	5e                   	pop    %esi
  800dd6:	5f                   	pop    %edi
  800dd7:	5d                   	pop    %ebp
  800dd8:	c3                   	ret    

00800dd9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800dd9:	55                   	push   %ebp
  800dda:	89 e5                	mov    %esp,%ebp
  800ddc:	57                   	push   %edi
  800ddd:	56                   	push   %esi
  800dde:	53                   	push   %ebx
  800ddf:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800de2:	be 00 00 00 00       	mov    $0x0,%esi
  800de7:	8b 55 08             	mov    0x8(%ebp),%edx
  800dea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ded:	b8 04 00 00 00       	mov    $0x4,%eax
  800df2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df5:	89 f7                	mov    %esi,%edi
  800df7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	7f 08                	jg     800e05 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800dfd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e00:	5b                   	pop    %ebx
  800e01:	5e                   	pop    %esi
  800e02:	5f                   	pop    %edi
  800e03:	5d                   	pop    %ebp
  800e04:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e05:	83 ec 0c             	sub    $0xc,%esp
  800e08:	50                   	push   %eax
  800e09:	6a 04                	push   $0x4
  800e0b:	68 08 2a 80 00       	push   $0x802a08
  800e10:	6a 43                	push   $0x43
  800e12:	68 25 2a 80 00       	push   $0x802a25
  800e17:	e8 08 14 00 00       	call   802224 <_panic>

00800e1c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	56                   	push   %esi
  800e21:	53                   	push   %ebx
  800e22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e25:	8b 55 08             	mov    0x8(%ebp),%edx
  800e28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e2b:	b8 05 00 00 00       	mov    $0x5,%eax
  800e30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e36:	8b 75 18             	mov    0x18(%ebp),%esi
  800e39:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	7f 08                	jg     800e47 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800e3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e42:	5b                   	pop    %ebx
  800e43:	5e                   	pop    %esi
  800e44:	5f                   	pop    %edi
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e47:	83 ec 0c             	sub    $0xc,%esp
  800e4a:	50                   	push   %eax
  800e4b:	6a 05                	push   $0x5
  800e4d:	68 08 2a 80 00       	push   $0x802a08
  800e52:	6a 43                	push   $0x43
  800e54:	68 25 2a 80 00       	push   $0x802a25
  800e59:	e8 c6 13 00 00       	call   802224 <_panic>

00800e5e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	57                   	push   %edi
  800e62:	56                   	push   %esi
  800e63:	53                   	push   %ebx
  800e64:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e67:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	b8 06 00 00 00       	mov    $0x6,%eax
  800e77:	89 df                	mov    %ebx,%edi
  800e79:	89 de                	mov    %ebx,%esi
  800e7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e7d:	85 c0                	test   %eax,%eax
  800e7f:	7f 08                	jg     800e89 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800e81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e84:	5b                   	pop    %ebx
  800e85:	5e                   	pop    %esi
  800e86:	5f                   	pop    %edi
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e89:	83 ec 0c             	sub    $0xc,%esp
  800e8c:	50                   	push   %eax
  800e8d:	6a 06                	push   $0x6
  800e8f:	68 08 2a 80 00       	push   $0x802a08
  800e94:	6a 43                	push   $0x43
  800e96:	68 25 2a 80 00       	push   $0x802a25
  800e9b:	e8 84 13 00 00       	call   802224 <_panic>

00800ea0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ea0:	55                   	push   %ebp
  800ea1:	89 e5                	mov    %esp,%ebp
  800ea3:	57                   	push   %edi
  800ea4:	56                   	push   %esi
  800ea5:	53                   	push   %ebx
  800ea6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eae:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb4:	b8 08 00 00 00       	mov    $0x8,%eax
  800eb9:	89 df                	mov    %ebx,%edi
  800ebb:	89 de                	mov    %ebx,%esi
  800ebd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7f 08                	jg     800ecb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ec3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec6:	5b                   	pop    %ebx
  800ec7:	5e                   	pop    %esi
  800ec8:	5f                   	pop    %edi
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ecb:	83 ec 0c             	sub    $0xc,%esp
  800ece:	50                   	push   %eax
  800ecf:	6a 08                	push   $0x8
  800ed1:	68 08 2a 80 00       	push   $0x802a08
  800ed6:	6a 43                	push   $0x43
  800ed8:	68 25 2a 80 00       	push   $0x802a25
  800edd:	e8 42 13 00 00       	call   802224 <_panic>

00800ee2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ee2:	55                   	push   %ebp
  800ee3:	89 e5                	mov    %esp,%ebp
  800ee5:	57                   	push   %edi
  800ee6:	56                   	push   %esi
  800ee7:	53                   	push   %ebx
  800ee8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eeb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	b8 09 00 00 00       	mov    $0x9,%eax
  800efb:	89 df                	mov    %ebx,%edi
  800efd:	89 de                	mov    %ebx,%esi
  800eff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f01:	85 c0                	test   %eax,%eax
  800f03:	7f 08                	jg     800f0d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800f11:	6a 09                	push   $0x9
  800f13:	68 08 2a 80 00       	push   $0x802a08
  800f18:	6a 43                	push   $0x43
  800f1a:	68 25 2a 80 00       	push   $0x802a25
  800f1f:	e8 00 13 00 00       	call   802224 <_panic>

00800f24 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f24:	55                   	push   %ebp
  800f25:	89 e5                	mov    %esp,%ebp
  800f27:	57                   	push   %edi
  800f28:	56                   	push   %esi
  800f29:	53                   	push   %ebx
  800f2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f38:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f3d:	89 df                	mov    %ebx,%edi
  800f3f:	89 de                	mov    %ebx,%esi
  800f41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f43:	85 c0                	test   %eax,%eax
  800f45:	7f 08                	jg     800f4f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5e                   	pop    %esi
  800f4c:	5f                   	pop    %edi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f4f:	83 ec 0c             	sub    $0xc,%esp
  800f52:	50                   	push   %eax
  800f53:	6a 0a                	push   $0xa
  800f55:	68 08 2a 80 00       	push   $0x802a08
  800f5a:	6a 43                	push   $0x43
  800f5c:	68 25 2a 80 00       	push   $0x802a25
  800f61:	e8 be 12 00 00       	call   802224 <_panic>

00800f66 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f66:	55                   	push   %ebp
  800f67:	89 e5                	mov    %esp,%ebp
  800f69:	57                   	push   %edi
  800f6a:	56                   	push   %esi
  800f6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f77:	be 00 00 00 00       	mov    $0x0,%esi
  800f7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f82:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	57                   	push   %edi
  800f8d:	56                   	push   %esi
  800f8e:	53                   	push   %ebx
  800f8f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f92:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f97:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f9f:	89 cb                	mov    %ecx,%ebx
  800fa1:	89 cf                	mov    %ecx,%edi
  800fa3:	89 ce                	mov    %ecx,%esi
  800fa5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fa7:	85 c0                	test   %eax,%eax
  800fa9:	7f 08                	jg     800fb3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb3:	83 ec 0c             	sub    $0xc,%esp
  800fb6:	50                   	push   %eax
  800fb7:	6a 0d                	push   $0xd
  800fb9:	68 08 2a 80 00       	push   $0x802a08
  800fbe:	6a 43                	push   $0x43
  800fc0:	68 25 2a 80 00       	push   $0x802a25
  800fc5:	e8 5a 12 00 00       	call   802224 <_panic>

00800fca <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800fca:	55                   	push   %ebp
  800fcb:	89 e5                	mov    %esp,%ebp
  800fcd:	57                   	push   %edi
  800fce:	56                   	push   %esi
  800fcf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fd0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fe0:	89 df                	mov    %ebx,%edi
  800fe2:	89 de                	mov    %ebx,%esi
  800fe4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    

00800feb <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	57                   	push   %edi
  800fef:	56                   	push   %esi
  800ff0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ff1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ff6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff9:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ffe:	89 cb                	mov    %ecx,%ebx
  801000:	89 cf                	mov    %ecx,%edi
  801002:	89 ce                	mov    %ecx,%esi
  801004:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	57                   	push   %edi
  80100f:	56                   	push   %esi
  801010:	53                   	push   %ebx
	asm volatile("int %1\n"
  801011:	ba 00 00 00 00       	mov    $0x0,%edx
  801016:	b8 10 00 00 00       	mov    $0x10,%eax
  80101b:	89 d1                	mov    %edx,%ecx
  80101d:	89 d3                	mov    %edx,%ebx
  80101f:	89 d7                	mov    %edx,%edi
  801021:	89 d6                	mov    %edx,%esi
  801023:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801030:	bb 00 00 00 00       	mov    $0x0,%ebx
  801035:	8b 55 08             	mov    0x8(%ebp),%edx
  801038:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80103b:	b8 11 00 00 00       	mov    $0x11,%eax
  801040:	89 df                	mov    %ebx,%edi
  801042:	89 de                	mov    %ebx,%esi
  801044:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5f                   	pop    %edi
  801049:	5d                   	pop    %ebp
  80104a:	c3                   	ret    

0080104b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  80104b:	55                   	push   %ebp
  80104c:	89 e5                	mov    %esp,%ebp
  80104e:	57                   	push   %edi
  80104f:	56                   	push   %esi
  801050:	53                   	push   %ebx
	asm volatile("int %1\n"
  801051:	bb 00 00 00 00       	mov    $0x0,%ebx
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80105c:	b8 12 00 00 00       	mov    $0x12,%eax
  801061:	89 df                	mov    %ebx,%edi
  801063:	89 de                	mov    %ebx,%esi
  801065:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  801067:	5b                   	pop    %ebx
  801068:	5e                   	pop    %esi
  801069:	5f                   	pop    %edi
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	57                   	push   %edi
  801070:	56                   	push   %esi
  801071:	53                   	push   %ebx
  801072:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801075:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107a:	8b 55 08             	mov    0x8(%ebp),%edx
  80107d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801080:	b8 13 00 00 00       	mov    $0x13,%eax
  801085:	89 df                	mov    %ebx,%edi
  801087:	89 de                	mov    %ebx,%esi
  801089:	cd 30                	int    $0x30
	if(check && ret > 0)
  80108b:	85 c0                	test   %eax,%eax
  80108d:	7f 08                	jg     801097 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80108f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801092:	5b                   	pop    %ebx
  801093:	5e                   	pop    %esi
  801094:	5f                   	pop    %edi
  801095:	5d                   	pop    %ebp
  801096:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801097:	83 ec 0c             	sub    $0xc,%esp
  80109a:	50                   	push   %eax
  80109b:	6a 13                	push   $0x13
  80109d:	68 08 2a 80 00       	push   $0x802a08
  8010a2:	6a 43                	push   $0x43
  8010a4:	68 25 2a 80 00       	push   $0x802a25
  8010a9:	e8 76 11 00 00       	call   802224 <_panic>

008010ae <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	57                   	push   %edi
  8010b2:	56                   	push   %esi
  8010b3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010b4:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8010bc:	b8 14 00 00 00       	mov    $0x14,%eax
  8010c1:	89 cb                	mov    %ecx,%ebx
  8010c3:	89 cf                	mov    %ecx,%edi
  8010c5:	89 ce                	mov    %ecx,%esi
  8010c7:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  8010c9:	5b                   	pop    %ebx
  8010ca:	5e                   	pop    %esi
  8010cb:	5f                   	pop    %edi
  8010cc:	5d                   	pop    %ebp
  8010cd:	c3                   	ret    

008010ce <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010ce:	55                   	push   %ebp
  8010cf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d4:	05 00 00 00 30       	add    $0x30000000,%eax
  8010d9:	c1 e8 0c             	shr    $0xc,%eax
}
  8010dc:	5d                   	pop    %ebp
  8010dd:	c3                   	ret    

008010de <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010de:	55                   	push   %ebp
  8010df:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010e9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010ee:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010f3:	5d                   	pop    %ebp
  8010f4:	c3                   	ret    

008010f5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010f5:	55                   	push   %ebp
  8010f6:	89 e5                	mov    %esp,%ebp
  8010f8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010fd:	89 c2                	mov    %eax,%edx
  8010ff:	c1 ea 16             	shr    $0x16,%edx
  801102:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801109:	f6 c2 01             	test   $0x1,%dl
  80110c:	74 2d                	je     80113b <fd_alloc+0x46>
  80110e:	89 c2                	mov    %eax,%edx
  801110:	c1 ea 0c             	shr    $0xc,%edx
  801113:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80111a:	f6 c2 01             	test   $0x1,%dl
  80111d:	74 1c                	je     80113b <fd_alloc+0x46>
  80111f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801124:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801129:	75 d2                	jne    8010fd <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80112b:	8b 45 08             	mov    0x8(%ebp),%eax
  80112e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801134:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801139:	eb 0a                	jmp    801145 <fd_alloc+0x50>
			*fd_store = fd;
  80113b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80113e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801140:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801145:	5d                   	pop    %ebp
  801146:	c3                   	ret    

00801147 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801147:	55                   	push   %ebp
  801148:	89 e5                	mov    %esp,%ebp
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80114d:	83 f8 1f             	cmp    $0x1f,%eax
  801150:	77 30                	ja     801182 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801152:	c1 e0 0c             	shl    $0xc,%eax
  801155:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80115a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801160:	f6 c2 01             	test   $0x1,%dl
  801163:	74 24                	je     801189 <fd_lookup+0x42>
  801165:	89 c2                	mov    %eax,%edx
  801167:	c1 ea 0c             	shr    $0xc,%edx
  80116a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801171:	f6 c2 01             	test   $0x1,%dl
  801174:	74 1a                	je     801190 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801176:	8b 55 0c             	mov    0xc(%ebp),%edx
  801179:	89 02                	mov    %eax,(%edx)
	return 0;
  80117b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801180:	5d                   	pop    %ebp
  801181:	c3                   	ret    
		return -E_INVAL;
  801182:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801187:	eb f7                	jmp    801180 <fd_lookup+0x39>
		return -E_INVAL;
  801189:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80118e:	eb f0                	jmp    801180 <fd_lookup+0x39>
  801190:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801195:	eb e9                	jmp    801180 <fd_lookup+0x39>

00801197 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
  80119a:	83 ec 08             	sub    $0x8,%esp
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8011a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8011a5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011aa:	39 08                	cmp    %ecx,(%eax)
  8011ac:	74 38                	je     8011e6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8011ae:	83 c2 01             	add    $0x1,%edx
  8011b1:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  8011b8:	85 c0                	test   %eax,%eax
  8011ba:	75 ee                	jne    8011aa <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8011c1:	8b 40 48             	mov    0x48(%eax),%eax
  8011c4:	83 ec 04             	sub    $0x4,%esp
  8011c7:	51                   	push   %ecx
  8011c8:	50                   	push   %eax
  8011c9:	68 34 2a 80 00       	push   $0x802a34
  8011ce:	e8 b5 f0 ff ff       	call   800288 <cprintf>
	*dev = 0;
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    
			*dev = devtab[i];
  8011e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f0:	eb f2                	jmp    8011e4 <dev_lookup+0x4d>

008011f2 <fd_close>:
{
  8011f2:	55                   	push   %ebp
  8011f3:	89 e5                	mov    %esp,%ebp
  8011f5:	57                   	push   %edi
  8011f6:	56                   	push   %esi
  8011f7:	53                   	push   %ebx
  8011f8:	83 ec 24             	sub    $0x24,%esp
  8011fb:	8b 75 08             	mov    0x8(%ebp),%esi
  8011fe:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801201:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801204:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801205:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80120b:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80120e:	50                   	push   %eax
  80120f:	e8 33 ff ff ff       	call   801147 <fd_lookup>
  801214:	89 c3                	mov    %eax,%ebx
  801216:	83 c4 10             	add    $0x10,%esp
  801219:	85 c0                	test   %eax,%eax
  80121b:	78 05                	js     801222 <fd_close+0x30>
	    || fd != fd2)
  80121d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801220:	74 16                	je     801238 <fd_close+0x46>
		return (must_exist ? r : 0);
  801222:	89 f8                	mov    %edi,%eax
  801224:	84 c0                	test   %al,%al
  801226:	b8 00 00 00 00       	mov    $0x0,%eax
  80122b:	0f 44 d8             	cmove  %eax,%ebx
}
  80122e:	89 d8                	mov    %ebx,%eax
  801230:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801233:	5b                   	pop    %ebx
  801234:	5e                   	pop    %esi
  801235:	5f                   	pop    %edi
  801236:	5d                   	pop    %ebp
  801237:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801238:	83 ec 08             	sub    $0x8,%esp
  80123b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80123e:	50                   	push   %eax
  80123f:	ff 36                	pushl  (%esi)
  801241:	e8 51 ff ff ff       	call   801197 <dev_lookup>
  801246:	89 c3                	mov    %eax,%ebx
  801248:	83 c4 10             	add    $0x10,%esp
  80124b:	85 c0                	test   %eax,%eax
  80124d:	78 1a                	js     801269 <fd_close+0x77>
		if (dev->dev_close)
  80124f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801252:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801255:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80125a:	85 c0                	test   %eax,%eax
  80125c:	74 0b                	je     801269 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	56                   	push   %esi
  801262:	ff d0                	call   *%eax
  801264:	89 c3                	mov    %eax,%ebx
  801266:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801269:	83 ec 08             	sub    $0x8,%esp
  80126c:	56                   	push   %esi
  80126d:	6a 00                	push   $0x0
  80126f:	e8 ea fb ff ff       	call   800e5e <sys_page_unmap>
	return r;
  801274:	83 c4 10             	add    $0x10,%esp
  801277:	eb b5                	jmp    80122e <fd_close+0x3c>

00801279 <close>:

int
close(int fdnum)
{
  801279:	55                   	push   %ebp
  80127a:	89 e5                	mov    %esp,%ebp
  80127c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80127f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801282:	50                   	push   %eax
  801283:	ff 75 08             	pushl  0x8(%ebp)
  801286:	e8 bc fe ff ff       	call   801147 <fd_lookup>
  80128b:	83 c4 10             	add    $0x10,%esp
  80128e:	85 c0                	test   %eax,%eax
  801290:	79 02                	jns    801294 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801292:	c9                   	leave  
  801293:	c3                   	ret    
		return fd_close(fd, 1);
  801294:	83 ec 08             	sub    $0x8,%esp
  801297:	6a 01                	push   $0x1
  801299:	ff 75 f4             	pushl  -0xc(%ebp)
  80129c:	e8 51 ff ff ff       	call   8011f2 <fd_close>
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	eb ec                	jmp    801292 <close+0x19>

008012a6 <close_all>:

void
close_all(void)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	53                   	push   %ebx
  8012aa:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012ad:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	53                   	push   %ebx
  8012b6:	e8 be ff ff ff       	call   801279 <close>
	for (i = 0; i < MAXFD; i++)
  8012bb:	83 c3 01             	add    $0x1,%ebx
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 fb 20             	cmp    $0x20,%ebx
  8012c4:	75 ec                	jne    8012b2 <close_all+0xc>
}
  8012c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 67 fe ff ff       	call   801147 <fd_lookup>
  8012e0:	89 c3                	mov    %eax,%ebx
  8012e2:	83 c4 10             	add    $0x10,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	0f 88 81 00 00 00    	js     80136e <dup+0xa3>
		return r;
	close(newfdnum);
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	e8 81 ff ff ff       	call   801279 <close>

	newfd = INDEX2FD(newfdnum);
  8012f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012fb:	c1 e6 0c             	shl    $0xc,%esi
  8012fe:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801304:	83 c4 04             	add    $0x4,%esp
  801307:	ff 75 e4             	pushl  -0x1c(%ebp)
  80130a:	e8 cf fd ff ff       	call   8010de <fd2data>
  80130f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801311:	89 34 24             	mov    %esi,(%esp)
  801314:	e8 c5 fd ff ff       	call   8010de <fd2data>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80131e:	89 d8                	mov    %ebx,%eax
  801320:	c1 e8 16             	shr    $0x16,%eax
  801323:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80132a:	a8 01                	test   $0x1,%al
  80132c:	74 11                	je     80133f <dup+0x74>
  80132e:	89 d8                	mov    %ebx,%eax
  801330:	c1 e8 0c             	shr    $0xc,%eax
  801333:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80133a:	f6 c2 01             	test   $0x1,%dl
  80133d:	75 39                	jne    801378 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801342:	89 d0                	mov    %edx,%eax
  801344:	c1 e8 0c             	shr    $0xc,%eax
  801347:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	25 07 0e 00 00       	and    $0xe07,%eax
  801356:	50                   	push   %eax
  801357:	56                   	push   %esi
  801358:	6a 00                	push   $0x0
  80135a:	52                   	push   %edx
  80135b:	6a 00                	push   $0x0
  80135d:	e8 ba fa ff ff       	call   800e1c <sys_page_map>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 20             	add    $0x20,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 31                	js     80139c <dup+0xd1>
		goto err;

	return newfdnum;
  80136b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80136e:	89 d8                	mov    %ebx,%eax
  801370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801373:	5b                   	pop    %ebx
  801374:	5e                   	pop    %esi
  801375:	5f                   	pop    %edi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801378:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	25 07 0e 00 00       	and    $0xe07,%eax
  801387:	50                   	push   %eax
  801388:	57                   	push   %edi
  801389:	6a 00                	push   $0x0
  80138b:	53                   	push   %ebx
  80138c:	6a 00                	push   $0x0
  80138e:	e8 89 fa ff ff       	call   800e1c <sys_page_map>
  801393:	89 c3                	mov    %eax,%ebx
  801395:	83 c4 20             	add    $0x20,%esp
  801398:	85 c0                	test   %eax,%eax
  80139a:	79 a3                	jns    80133f <dup+0x74>
	sys_page_unmap(0, newfd);
  80139c:	83 ec 08             	sub    $0x8,%esp
  80139f:	56                   	push   %esi
  8013a0:	6a 00                	push   $0x0
  8013a2:	e8 b7 fa ff ff       	call   800e5e <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	57                   	push   %edi
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 ac fa ff ff       	call   800e5e <sys_page_unmap>
	return r;
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	eb b7                	jmp    80136e <dup+0xa3>

008013b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
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
  8013c6:	e8 7c fd ff ff       	call   801147 <fd_lookup>
  8013cb:	83 c4 10             	add    $0x10,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 3f                	js     801411 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dc:	ff 30                	pushl  (%eax)
  8013de:	e8 b4 fd ff ff       	call   801197 <dev_lookup>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 27                	js     801411 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ed:	8b 42 08             	mov    0x8(%edx),%eax
  8013f0:	83 e0 03             	and    $0x3,%eax
  8013f3:	83 f8 01             	cmp    $0x1,%eax
  8013f6:	74 1e                	je     801416 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fb:	8b 40 08             	mov    0x8(%eax),%eax
  8013fe:	85 c0                	test   %eax,%eax
  801400:	74 35                	je     801437 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	ff 75 10             	pushl  0x10(%ebp)
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	52                   	push   %edx
  80140c:	ff d0                	call   *%eax
  80140e:	83 c4 10             	add    $0x10,%esp
}
  801411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801414:	c9                   	leave  
  801415:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801416:	a1 08 40 80 00       	mov    0x804008,%eax
  80141b:	8b 40 48             	mov    0x48(%eax),%eax
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	53                   	push   %ebx
  801422:	50                   	push   %eax
  801423:	68 75 2a 80 00       	push   $0x802a75
  801428:	e8 5b ee ff ff       	call   800288 <cprintf>
		return -E_INVAL;
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801435:	eb da                	jmp    801411 <read+0x5a>
		return -E_NOT_SUPP;
  801437:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143c:	eb d3                	jmp    801411 <read+0x5a>

0080143e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	57                   	push   %edi
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	8b 7d 08             	mov    0x8(%ebp),%edi
  80144a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80144d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801452:	39 f3                	cmp    %esi,%ebx
  801454:	73 23                	jae    801479 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	89 f0                	mov    %esi,%eax
  80145b:	29 d8                	sub    %ebx,%eax
  80145d:	50                   	push   %eax
  80145e:	89 d8                	mov    %ebx,%eax
  801460:	03 45 0c             	add    0xc(%ebp),%eax
  801463:	50                   	push   %eax
  801464:	57                   	push   %edi
  801465:	e8 4d ff ff ff       	call   8013b7 <read>
		if (m < 0)
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 06                	js     801477 <readn+0x39>
			return m;
		if (m == 0)
  801471:	74 06                	je     801479 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801473:	01 c3                	add    %eax,%ebx
  801475:	eb db                	jmp    801452 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801477:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801479:	89 d8                	mov    %ebx,%eax
  80147b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147e:	5b                   	pop    %ebx
  80147f:	5e                   	pop    %esi
  801480:	5f                   	pop    %edi
  801481:	5d                   	pop    %ebp
  801482:	c3                   	ret    

00801483 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801483:	55                   	push   %ebp
  801484:	89 e5                	mov    %esp,%ebp
  801486:	53                   	push   %ebx
  801487:	83 ec 1c             	sub    $0x1c,%esp
  80148a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	53                   	push   %ebx
  801492:	e8 b0 fc ff ff       	call   801147 <fd_lookup>
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	85 c0                	test   %eax,%eax
  80149c:	78 3a                	js     8014d8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a4:	50                   	push   %eax
  8014a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014a8:	ff 30                	pushl  (%eax)
  8014aa:	e8 e8 fc ff ff       	call   801197 <dev_lookup>
  8014af:	83 c4 10             	add    $0x10,%esp
  8014b2:	85 c0                	test   %eax,%eax
  8014b4:	78 22                	js     8014d8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014bd:	74 1e                	je     8014dd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c2:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c5:	85 d2                	test   %edx,%edx
  8014c7:	74 35                	je     8014fe <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014c9:	83 ec 04             	sub    $0x4,%esp
  8014cc:	ff 75 10             	pushl  0x10(%ebp)
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	50                   	push   %eax
  8014d3:	ff d2                	call   *%edx
  8014d5:	83 c4 10             	add    $0x10,%esp
}
  8014d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014db:	c9                   	leave  
  8014dc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014dd:	a1 08 40 80 00       	mov    0x804008,%eax
  8014e2:	8b 40 48             	mov    0x48(%eax),%eax
  8014e5:	83 ec 04             	sub    $0x4,%esp
  8014e8:	53                   	push   %ebx
  8014e9:	50                   	push   %eax
  8014ea:	68 91 2a 80 00       	push   $0x802a91
  8014ef:	e8 94 ed ff ff       	call   800288 <cprintf>
		return -E_INVAL;
  8014f4:	83 c4 10             	add    $0x10,%esp
  8014f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fc:	eb da                	jmp    8014d8 <write+0x55>
		return -E_NOT_SUPP;
  8014fe:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801503:	eb d3                	jmp    8014d8 <write+0x55>

00801505 <seek>:

int
seek(int fdnum, off_t offset)
{
  801505:	55                   	push   %ebp
  801506:	89 e5                	mov    %esp,%ebp
  801508:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80150b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150e:	50                   	push   %eax
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 30 fc ff ff       	call   801147 <fd_lookup>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	85 c0                	test   %eax,%eax
  80151c:	78 0e                	js     80152c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80151e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801524:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	53                   	push   %ebx
  801532:	83 ec 1c             	sub    $0x1c,%esp
  801535:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801538:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	53                   	push   %ebx
  80153d:	e8 05 fc ff ff       	call   801147 <fd_lookup>
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	85 c0                	test   %eax,%eax
  801547:	78 37                	js     801580 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801549:	83 ec 08             	sub    $0x8,%esp
  80154c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154f:	50                   	push   %eax
  801550:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801553:	ff 30                	pushl  (%eax)
  801555:	e8 3d fc ff ff       	call   801197 <dev_lookup>
  80155a:	83 c4 10             	add    $0x10,%esp
  80155d:	85 c0                	test   %eax,%eax
  80155f:	78 1f                	js     801580 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801564:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801568:	74 1b                	je     801585 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80156a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156d:	8b 52 18             	mov    0x18(%edx),%edx
  801570:	85 d2                	test   %edx,%edx
  801572:	74 32                	je     8015a6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801574:	83 ec 08             	sub    $0x8,%esp
  801577:	ff 75 0c             	pushl  0xc(%ebp)
  80157a:	50                   	push   %eax
  80157b:	ff d2                	call   *%edx
  80157d:	83 c4 10             	add    $0x10,%esp
}
  801580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801583:	c9                   	leave  
  801584:	c3                   	ret    
			thisenv->env_id, fdnum);
  801585:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80158a:	8b 40 48             	mov    0x48(%eax),%eax
  80158d:	83 ec 04             	sub    $0x4,%esp
  801590:	53                   	push   %ebx
  801591:	50                   	push   %eax
  801592:	68 54 2a 80 00       	push   $0x802a54
  801597:	e8 ec ec ff ff       	call   800288 <cprintf>
		return -E_INVAL;
  80159c:	83 c4 10             	add    $0x10,%esp
  80159f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a4:	eb da                	jmp    801580 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ab:	eb d3                	jmp    801580 <ftruncate+0x52>

008015ad <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015ad:	55                   	push   %ebp
  8015ae:	89 e5                	mov    %esp,%ebp
  8015b0:	53                   	push   %ebx
  8015b1:	83 ec 1c             	sub    $0x1c,%esp
  8015b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015ba:	50                   	push   %eax
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 84 fb ff ff       	call   801147 <fd_lookup>
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 4b                	js     801615 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d0:	50                   	push   %eax
  8015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d4:	ff 30                	pushl  (%eax)
  8015d6:	e8 bc fb ff ff       	call   801197 <dev_lookup>
  8015db:	83 c4 10             	add    $0x10,%esp
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 33                	js     801615 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015e9:	74 2f                	je     80161a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015eb:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015ee:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015f5:	00 00 00 
	stat->st_isdir = 0;
  8015f8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015ff:	00 00 00 
	stat->st_dev = dev;
  801602:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	53                   	push   %ebx
  80160c:	ff 75 f0             	pushl  -0x10(%ebp)
  80160f:	ff 50 14             	call   *0x14(%eax)
  801612:	83 c4 10             	add    $0x10,%esp
}
  801615:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801618:	c9                   	leave  
  801619:	c3                   	ret    
		return -E_NOT_SUPP;
  80161a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161f:	eb f4                	jmp    801615 <fstat+0x68>

00801621 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	56                   	push   %esi
  801625:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801626:	83 ec 08             	sub    $0x8,%esp
  801629:	6a 00                	push   $0x0
  80162b:	ff 75 08             	pushl  0x8(%ebp)
  80162e:	e8 22 02 00 00       	call   801855 <open>
  801633:	89 c3                	mov    %eax,%ebx
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	85 c0                	test   %eax,%eax
  80163a:	78 1b                	js     801657 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	ff 75 0c             	pushl  0xc(%ebp)
  801642:	50                   	push   %eax
  801643:	e8 65 ff ff ff       	call   8015ad <fstat>
  801648:	89 c6                	mov    %eax,%esi
	close(fd);
  80164a:	89 1c 24             	mov    %ebx,(%esp)
  80164d:	e8 27 fc ff ff       	call   801279 <close>
	return r;
  801652:	83 c4 10             	add    $0x10,%esp
  801655:	89 f3                	mov    %esi,%ebx
}
  801657:	89 d8                	mov    %ebx,%eax
  801659:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165c:	5b                   	pop    %ebx
  80165d:	5e                   	pop    %esi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    

00801660 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
  801663:	56                   	push   %esi
  801664:	53                   	push   %ebx
  801665:	89 c6                	mov    %eax,%esi
  801667:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801669:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801670:	74 27                	je     801699 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801672:	6a 07                	push   $0x7
  801674:	68 00 50 80 00       	push   $0x805000
  801679:	56                   	push   %esi
  80167a:	ff 35 00 40 80 00    	pushl  0x804000
  801680:	e8 69 0c 00 00       	call   8022ee <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801685:	83 c4 0c             	add    $0xc,%esp
  801688:	6a 00                	push   $0x0
  80168a:	53                   	push   %ebx
  80168b:	6a 00                	push   $0x0
  80168d:	e8 f3 0b 00 00       	call   802285 <ipc_recv>
}
  801692:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801695:	5b                   	pop    %ebx
  801696:	5e                   	pop    %esi
  801697:	5d                   	pop    %ebp
  801698:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801699:	83 ec 0c             	sub    $0xc,%esp
  80169c:	6a 01                	push   $0x1
  80169e:	e8 a3 0c 00 00       	call   802346 <ipc_find_env>
  8016a3:	a3 00 40 80 00       	mov    %eax,0x804000
  8016a8:	83 c4 10             	add    $0x10,%esp
  8016ab:	eb c5                	jmp    801672 <fsipc+0x12>

008016ad <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
  8016b0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cb:	b8 02 00 00 00       	mov    $0x2,%eax
  8016d0:	e8 8b ff ff ff       	call   801660 <fsipc>
}
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    

008016d7 <devfile_flush>:
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e0:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ed:	b8 06 00 00 00       	mov    $0x6,%eax
  8016f2:	e8 69 ff ff ff       	call   801660 <fsipc>
}
  8016f7:	c9                   	leave  
  8016f8:	c3                   	ret    

008016f9 <devfile_stat>:
{
  8016f9:	55                   	push   %ebp
  8016fa:	89 e5                	mov    %esp,%ebp
  8016fc:	53                   	push   %ebx
  8016fd:	83 ec 04             	sub    $0x4,%esp
  801700:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	8b 40 0c             	mov    0xc(%eax),%eax
  801709:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80170e:	ba 00 00 00 00       	mov    $0x0,%edx
  801713:	b8 05 00 00 00       	mov    $0x5,%eax
  801718:	e8 43 ff ff ff       	call   801660 <fsipc>
  80171d:	85 c0                	test   %eax,%eax
  80171f:	78 2c                	js     80174d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801721:	83 ec 08             	sub    $0x8,%esp
  801724:	68 00 50 80 00       	push   $0x805000
  801729:	53                   	push   %ebx
  80172a:	e8 b8 f2 ff ff       	call   8009e7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80172f:	a1 80 50 80 00       	mov    0x805080,%eax
  801734:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80173a:	a1 84 50 80 00       	mov    0x805084,%eax
  80173f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801750:	c9                   	leave  
  801751:	c3                   	ret    

00801752 <devfile_write>:
{
  801752:	55                   	push   %ebp
  801753:	89 e5                	mov    %esp,%ebp
  801755:	53                   	push   %ebx
  801756:	83 ec 08             	sub    $0x8,%esp
  801759:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80175c:	8b 45 08             	mov    0x8(%ebp),%eax
  80175f:	8b 40 0c             	mov    0xc(%eax),%eax
  801762:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801767:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80176d:	53                   	push   %ebx
  80176e:	ff 75 0c             	pushl  0xc(%ebp)
  801771:	68 08 50 80 00       	push   $0x805008
  801776:	e8 5c f4 ff ff       	call   800bd7 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	b8 04 00 00 00       	mov    $0x4,%eax
  801785:	e8 d6 fe ff ff       	call   801660 <fsipc>
  80178a:	83 c4 10             	add    $0x10,%esp
  80178d:	85 c0                	test   %eax,%eax
  80178f:	78 0b                	js     80179c <devfile_write+0x4a>
	assert(r <= n);
  801791:	39 d8                	cmp    %ebx,%eax
  801793:	77 0c                	ja     8017a1 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801795:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80179a:	7f 1e                	jg     8017ba <devfile_write+0x68>
}
  80179c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80179f:	c9                   	leave  
  8017a0:	c3                   	ret    
	assert(r <= n);
  8017a1:	68 c4 2a 80 00       	push   $0x802ac4
  8017a6:	68 cb 2a 80 00       	push   $0x802acb
  8017ab:	68 98 00 00 00       	push   $0x98
  8017b0:	68 e0 2a 80 00       	push   $0x802ae0
  8017b5:	e8 6a 0a 00 00       	call   802224 <_panic>
	assert(r <= PGSIZE);
  8017ba:	68 eb 2a 80 00       	push   $0x802aeb
  8017bf:	68 cb 2a 80 00       	push   $0x802acb
  8017c4:	68 99 00 00 00       	push   $0x99
  8017c9:	68 e0 2a 80 00       	push   $0x802ae0
  8017ce:	e8 51 0a 00 00       	call   802224 <_panic>

008017d3 <devfile_read>:
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	56                   	push   %esi
  8017d7:	53                   	push   %ebx
  8017d8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017db:	8b 45 08             	mov    0x8(%ebp),%eax
  8017de:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017e6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	b8 03 00 00 00       	mov    $0x3,%eax
  8017f6:	e8 65 fe ff ff       	call   801660 <fsipc>
  8017fb:	89 c3                	mov    %eax,%ebx
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	78 1f                	js     801820 <devfile_read+0x4d>
	assert(r <= n);
  801801:	39 f0                	cmp    %esi,%eax
  801803:	77 24                	ja     801829 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801805:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80180a:	7f 33                	jg     80183f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	50                   	push   %eax
  801810:	68 00 50 80 00       	push   $0x805000
  801815:	ff 75 0c             	pushl  0xc(%ebp)
  801818:	e8 58 f3 ff ff       	call   800b75 <memmove>
	return r;
  80181d:	83 c4 10             	add    $0x10,%esp
}
  801820:	89 d8                	mov    %ebx,%eax
  801822:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801825:	5b                   	pop    %ebx
  801826:	5e                   	pop    %esi
  801827:	5d                   	pop    %ebp
  801828:	c3                   	ret    
	assert(r <= n);
  801829:	68 c4 2a 80 00       	push   $0x802ac4
  80182e:	68 cb 2a 80 00       	push   $0x802acb
  801833:	6a 7c                	push   $0x7c
  801835:	68 e0 2a 80 00       	push   $0x802ae0
  80183a:	e8 e5 09 00 00       	call   802224 <_panic>
	assert(r <= PGSIZE);
  80183f:	68 eb 2a 80 00       	push   $0x802aeb
  801844:	68 cb 2a 80 00       	push   $0x802acb
  801849:	6a 7d                	push   $0x7d
  80184b:	68 e0 2a 80 00       	push   $0x802ae0
  801850:	e8 cf 09 00 00       	call   802224 <_panic>

00801855 <open>:
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	56                   	push   %esi
  801859:	53                   	push   %ebx
  80185a:	83 ec 1c             	sub    $0x1c,%esp
  80185d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801860:	56                   	push   %esi
  801861:	e8 48 f1 ff ff       	call   8009ae <strlen>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80186e:	7f 6c                	jg     8018dc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801870:	83 ec 0c             	sub    $0xc,%esp
  801873:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801876:	50                   	push   %eax
  801877:	e8 79 f8 ff ff       	call   8010f5 <fd_alloc>
  80187c:	89 c3                	mov    %eax,%ebx
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	78 3c                	js     8018c1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801885:	83 ec 08             	sub    $0x8,%esp
  801888:	56                   	push   %esi
  801889:	68 00 50 80 00       	push   $0x805000
  80188e:	e8 54 f1 ff ff       	call   8009e7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801893:	8b 45 0c             	mov    0xc(%ebp),%eax
  801896:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80189b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80189e:	b8 01 00 00 00       	mov    $0x1,%eax
  8018a3:	e8 b8 fd ff ff       	call   801660 <fsipc>
  8018a8:	89 c3                	mov    %eax,%ebx
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	78 19                	js     8018ca <open+0x75>
	return fd2num(fd);
  8018b1:	83 ec 0c             	sub    $0xc,%esp
  8018b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b7:	e8 12 f8 ff ff       	call   8010ce <fd2num>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 10             	add    $0x10,%esp
}
  8018c1:	89 d8                	mov    %ebx,%eax
  8018c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018c6:	5b                   	pop    %ebx
  8018c7:	5e                   	pop    %esi
  8018c8:	5d                   	pop    %ebp
  8018c9:	c3                   	ret    
		fd_close(fd, 0);
  8018ca:	83 ec 08             	sub    $0x8,%esp
  8018cd:	6a 00                	push   $0x0
  8018cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8018d2:	e8 1b f9 ff ff       	call   8011f2 <fd_close>
		return r;
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	eb e5                	jmp    8018c1 <open+0x6c>
		return -E_BAD_PATH;
  8018dc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018e1:	eb de                	jmp    8018c1 <open+0x6c>

008018e3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ee:	b8 08 00 00 00       	mov    $0x8,%eax
  8018f3:	e8 68 fd ff ff       	call   801660 <fsipc>
}
  8018f8:	c9                   	leave  
  8018f9:	c3                   	ret    

008018fa <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8018fa:	55                   	push   %ebp
  8018fb:	89 e5                	mov    %esp,%ebp
  8018fd:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801900:	68 f7 2a 80 00       	push   $0x802af7
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	e8 da f0 ff ff       	call   8009e7 <strcpy>
	return 0;
}
  80190d:	b8 00 00 00 00       	mov    $0x0,%eax
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <devsock_close>:
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	53                   	push   %ebx
  801918:	83 ec 10             	sub    $0x10,%esp
  80191b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80191e:	53                   	push   %ebx
  80191f:	e8 61 0a 00 00       	call   802385 <pageref>
  801924:	83 c4 10             	add    $0x10,%esp
		return 0;
  801927:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80192c:	83 f8 01             	cmp    $0x1,%eax
  80192f:	74 07                	je     801938 <devsock_close+0x24>
}
  801931:	89 d0                	mov    %edx,%eax
  801933:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801936:	c9                   	leave  
  801937:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801938:	83 ec 0c             	sub    $0xc,%esp
  80193b:	ff 73 0c             	pushl  0xc(%ebx)
  80193e:	e8 b9 02 00 00       	call   801bfc <nsipc_close>
  801943:	89 c2                	mov    %eax,%edx
  801945:	83 c4 10             	add    $0x10,%esp
  801948:	eb e7                	jmp    801931 <devsock_close+0x1d>

0080194a <devsock_write>:
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801950:	6a 00                	push   $0x0
  801952:	ff 75 10             	pushl  0x10(%ebp)
  801955:	ff 75 0c             	pushl  0xc(%ebp)
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	ff 70 0c             	pushl  0xc(%eax)
  80195e:	e8 76 03 00 00       	call   801cd9 <nsipc_send>
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <devsock_read>:
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	ff 75 10             	pushl  0x10(%ebp)
  801970:	ff 75 0c             	pushl  0xc(%ebp)
  801973:	8b 45 08             	mov    0x8(%ebp),%eax
  801976:	ff 70 0c             	pushl  0xc(%eax)
  801979:	e8 ef 02 00 00       	call   801c6d <nsipc_recv>
}
  80197e:	c9                   	leave  
  80197f:	c3                   	ret    

00801980 <fd2sockid>:
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801986:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	e8 b7 f7 ff ff       	call   801147 <fd_lookup>
  801990:	83 c4 10             	add    $0x10,%esp
  801993:	85 c0                	test   %eax,%eax
  801995:	78 10                	js     8019a7 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199a:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8019a0:	39 08                	cmp    %ecx,(%eax)
  8019a2:	75 05                	jne    8019a9 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8019a4:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8019a7:	c9                   	leave  
  8019a8:	c3                   	ret    
		return -E_NOT_SUPP;
  8019a9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ae:	eb f7                	jmp    8019a7 <fd2sockid+0x27>

008019b0 <alloc_sockfd>:
{
  8019b0:	55                   	push   %ebp
  8019b1:	89 e5                	mov    %esp,%ebp
  8019b3:	56                   	push   %esi
  8019b4:	53                   	push   %ebx
  8019b5:	83 ec 1c             	sub    $0x1c,%esp
  8019b8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8019ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bd:	50                   	push   %eax
  8019be:	e8 32 f7 ff ff       	call   8010f5 <fd_alloc>
  8019c3:	89 c3                	mov    %eax,%ebx
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	85 c0                	test   %eax,%eax
  8019ca:	78 43                	js     801a0f <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8019cc:	83 ec 04             	sub    $0x4,%esp
  8019cf:	68 07 04 00 00       	push   $0x407
  8019d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8019d7:	6a 00                	push   $0x0
  8019d9:	e8 fb f3 ff ff       	call   800dd9 <sys_page_alloc>
  8019de:	89 c3                	mov    %eax,%ebx
  8019e0:	83 c4 10             	add    $0x10,%esp
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 28                	js     801a0f <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8019e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ea:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8019f0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8019f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019f5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8019fc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8019ff:	83 ec 0c             	sub    $0xc,%esp
  801a02:	50                   	push   %eax
  801a03:	e8 c6 f6 ff ff       	call   8010ce <fd2num>
  801a08:	89 c3                	mov    %eax,%ebx
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	eb 0c                	jmp    801a1b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801a0f:	83 ec 0c             	sub    $0xc,%esp
  801a12:	56                   	push   %esi
  801a13:	e8 e4 01 00 00       	call   801bfc <nsipc_close>
		return r;
  801a18:	83 c4 10             	add    $0x10,%esp
}
  801a1b:	89 d8                	mov    %ebx,%eax
  801a1d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a20:	5b                   	pop    %ebx
  801a21:	5e                   	pop    %esi
  801a22:	5d                   	pop    %ebp
  801a23:	c3                   	ret    

00801a24 <accept>:
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	e8 4e ff ff ff       	call   801980 <fd2sockid>
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 1b                	js     801a51 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801a36:	83 ec 04             	sub    $0x4,%esp
  801a39:	ff 75 10             	pushl  0x10(%ebp)
  801a3c:	ff 75 0c             	pushl  0xc(%ebp)
  801a3f:	50                   	push   %eax
  801a40:	e8 0e 01 00 00       	call   801b53 <nsipc_accept>
  801a45:	83 c4 10             	add    $0x10,%esp
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 05                	js     801a51 <accept+0x2d>
	return alloc_sockfd(r);
  801a4c:	e8 5f ff ff ff       	call   8019b0 <alloc_sockfd>
}
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <bind>:
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
  801a56:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a59:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5c:	e8 1f ff ff ff       	call   801980 <fd2sockid>
  801a61:	85 c0                	test   %eax,%eax
  801a63:	78 12                	js     801a77 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801a65:	83 ec 04             	sub    $0x4,%esp
  801a68:	ff 75 10             	pushl  0x10(%ebp)
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	e8 31 01 00 00       	call   801ba5 <nsipc_bind>
  801a74:	83 c4 10             	add    $0x10,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <shutdown>:
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a82:	e8 f9 fe ff ff       	call   801980 <fd2sockid>
  801a87:	85 c0                	test   %eax,%eax
  801a89:	78 0f                	js     801a9a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a8b:	83 ec 08             	sub    $0x8,%esp
  801a8e:	ff 75 0c             	pushl  0xc(%ebp)
  801a91:	50                   	push   %eax
  801a92:	e8 43 01 00 00       	call   801bda <nsipc_shutdown>
  801a97:	83 c4 10             	add    $0x10,%esp
}
  801a9a:	c9                   	leave  
  801a9b:	c3                   	ret    

00801a9c <connect>:
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	e8 d6 fe ff ff       	call   801980 <fd2sockid>
  801aaa:	85 c0                	test   %eax,%eax
  801aac:	78 12                	js     801ac0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801aae:	83 ec 04             	sub    $0x4,%esp
  801ab1:	ff 75 10             	pushl  0x10(%ebp)
  801ab4:	ff 75 0c             	pushl  0xc(%ebp)
  801ab7:	50                   	push   %eax
  801ab8:	e8 59 01 00 00       	call   801c16 <nsipc_connect>
  801abd:	83 c4 10             	add    $0x10,%esp
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <listen>:
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
  801ac5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  801acb:	e8 b0 fe ff ff       	call   801980 <fd2sockid>
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	78 0f                	js     801ae3 <listen+0x21>
	return nsipc_listen(r, backlog);
  801ad4:	83 ec 08             	sub    $0x8,%esp
  801ad7:	ff 75 0c             	pushl  0xc(%ebp)
  801ada:	50                   	push   %eax
  801adb:	e8 6b 01 00 00       	call   801c4b <nsipc_listen>
  801ae0:	83 c4 10             	add    $0x10,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <socket>:

int
socket(int domain, int type, int protocol)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801aeb:	ff 75 10             	pushl  0x10(%ebp)
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	ff 75 08             	pushl  0x8(%ebp)
  801af4:	e8 3e 02 00 00       	call   801d37 <nsipc_socket>
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	85 c0                	test   %eax,%eax
  801afe:	78 05                	js     801b05 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801b00:	e8 ab fe ff ff       	call   8019b0 <alloc_sockfd>
}
  801b05:	c9                   	leave  
  801b06:	c3                   	ret    

00801b07 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	53                   	push   %ebx
  801b0b:	83 ec 04             	sub    $0x4,%esp
  801b0e:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801b10:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801b17:	74 26                	je     801b3f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801b19:	6a 07                	push   $0x7
  801b1b:	68 00 60 80 00       	push   $0x806000
  801b20:	53                   	push   %ebx
  801b21:	ff 35 04 40 80 00    	pushl  0x804004
  801b27:	e8 c2 07 00 00       	call   8022ee <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801b2c:	83 c4 0c             	add    $0xc,%esp
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	e8 4b 07 00 00       	call   802285 <ipc_recv>
}
  801b3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	6a 02                	push   $0x2
  801b44:	e8 fd 07 00 00       	call   802346 <ipc_find_env>
  801b49:	a3 04 40 80 00       	mov    %eax,0x804004
  801b4e:	83 c4 10             	add    $0x10,%esp
  801b51:	eb c6                	jmp    801b19 <nsipc+0x12>

00801b53 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	56                   	push   %esi
  801b57:	53                   	push   %ebx
  801b58:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801b63:	8b 06                	mov    (%esi),%eax
  801b65:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801b6a:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6f:	e8 93 ff ff ff       	call   801b07 <nsipc>
  801b74:	89 c3                	mov    %eax,%ebx
  801b76:	85 c0                	test   %eax,%eax
  801b78:	79 09                	jns    801b83 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b7a:	89 d8                	mov    %ebx,%eax
  801b7c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b83:	83 ec 04             	sub    $0x4,%esp
  801b86:	ff 35 10 60 80 00    	pushl  0x806010
  801b8c:	68 00 60 80 00       	push   $0x806000
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	e8 dc ef ff ff       	call   800b75 <memmove>
		*addrlen = ret->ret_addrlen;
  801b99:	a1 10 60 80 00       	mov    0x806010,%eax
  801b9e:	89 06                	mov    %eax,(%esi)
  801ba0:	83 c4 10             	add    $0x10,%esp
	return r;
  801ba3:	eb d5                	jmp    801b7a <nsipc_accept+0x27>

00801ba5 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
  801ba8:	53                   	push   %ebx
  801ba9:	83 ec 08             	sub    $0x8,%esp
  801bac:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801baf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801bb7:	53                   	push   %ebx
  801bb8:	ff 75 0c             	pushl  0xc(%ebp)
  801bbb:	68 04 60 80 00       	push   $0x806004
  801bc0:	e8 b0 ef ff ff       	call   800b75 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801bc5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801bcb:	b8 02 00 00 00       	mov    $0x2,%eax
  801bd0:	e8 32 ff ff ff       	call   801b07 <nsipc>
}
  801bd5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801be8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801beb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801bf0:	b8 03 00 00 00       	mov    $0x3,%eax
  801bf5:	e8 0d ff ff ff       	call   801b07 <nsipc>
}
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <nsipc_close>:

int
nsipc_close(int s)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801c02:	8b 45 08             	mov    0x8(%ebp),%eax
  801c05:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801c0a:	b8 04 00 00 00       	mov    $0x4,%eax
  801c0f:	e8 f3 fe ff ff       	call   801b07 <nsipc>
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	53                   	push   %ebx
  801c1a:	83 ec 08             	sub    $0x8,%esp
  801c1d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801c20:	8b 45 08             	mov    0x8(%ebp),%eax
  801c23:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801c28:	53                   	push   %ebx
  801c29:	ff 75 0c             	pushl  0xc(%ebp)
  801c2c:	68 04 60 80 00       	push   $0x806004
  801c31:	e8 3f ef ff ff       	call   800b75 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801c36:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801c3c:	b8 05 00 00 00       	mov    $0x5,%eax
  801c41:	e8 c1 fe ff ff       	call   801b07 <nsipc>
}
  801c46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
  801c4e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801c51:	8b 45 08             	mov    0x8(%ebp),%eax
  801c54:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801c59:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801c61:	b8 06 00 00 00       	mov    $0x6,%eax
  801c66:	e8 9c fe ff ff       	call   801b07 <nsipc>
}
  801c6b:	c9                   	leave  
  801c6c:	c3                   	ret    

00801c6d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	56                   	push   %esi
  801c71:	53                   	push   %ebx
  801c72:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c75:	8b 45 08             	mov    0x8(%ebp),%eax
  801c78:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c7d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c83:	8b 45 14             	mov    0x14(%ebp),%eax
  801c86:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c8b:	b8 07 00 00 00       	mov    $0x7,%eax
  801c90:	e8 72 fe ff ff       	call   801b07 <nsipc>
  801c95:	89 c3                	mov    %eax,%ebx
  801c97:	85 c0                	test   %eax,%eax
  801c99:	78 1f                	js     801cba <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c9b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801ca0:	7f 21                	jg     801cc3 <nsipc_recv+0x56>
  801ca2:	39 c6                	cmp    %eax,%esi
  801ca4:	7c 1d                	jl     801cc3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801ca6:	83 ec 04             	sub    $0x4,%esp
  801ca9:	50                   	push   %eax
  801caa:	68 00 60 80 00       	push   $0x806000
  801caf:	ff 75 0c             	pushl  0xc(%ebp)
  801cb2:	e8 be ee ff ff       	call   800b75 <memmove>
  801cb7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801cba:	89 d8                	mov    %ebx,%eax
  801cbc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cbf:	5b                   	pop    %ebx
  801cc0:	5e                   	pop    %esi
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801cc3:	68 03 2b 80 00       	push   $0x802b03
  801cc8:	68 cb 2a 80 00       	push   $0x802acb
  801ccd:	6a 62                	push   $0x62
  801ccf:	68 18 2b 80 00       	push   $0x802b18
  801cd4:	e8 4b 05 00 00       	call   802224 <_panic>

00801cd9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cd9:	55                   	push   %ebp
  801cda:	89 e5                	mov    %esp,%ebp
  801cdc:	53                   	push   %ebx
  801cdd:	83 ec 04             	sub    $0x4,%esp
  801ce0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801ceb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801cf1:	7f 2e                	jg     801d21 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801cf3:	83 ec 04             	sub    $0x4,%esp
  801cf6:	53                   	push   %ebx
  801cf7:	ff 75 0c             	pushl  0xc(%ebp)
  801cfa:	68 0c 60 80 00       	push   $0x80600c
  801cff:	e8 71 ee ff ff       	call   800b75 <memmove>
	nsipcbuf.send.req_size = size;
  801d04:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801d0a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d0d:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801d12:	b8 08 00 00 00       	mov    $0x8,%eax
  801d17:	e8 eb fd ff ff       	call   801b07 <nsipc>
}
  801d1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    
	assert(size < 1600);
  801d21:	68 24 2b 80 00       	push   $0x802b24
  801d26:	68 cb 2a 80 00       	push   $0x802acb
  801d2b:	6a 6d                	push   $0x6d
  801d2d:	68 18 2b 80 00       	push   $0x802b18
  801d32:	e8 ed 04 00 00       	call   802224 <_panic>

00801d37 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d48:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801d4d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d50:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801d55:	b8 09 00 00 00       	mov    $0x9,%eax
  801d5a:	e8 a8 fd ff ff       	call   801b07 <nsipc>
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	56                   	push   %esi
  801d65:	53                   	push   %ebx
  801d66:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d69:	83 ec 0c             	sub    $0xc,%esp
  801d6c:	ff 75 08             	pushl  0x8(%ebp)
  801d6f:	e8 6a f3 ff ff       	call   8010de <fd2data>
  801d74:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d76:	83 c4 08             	add    $0x8,%esp
  801d79:	68 30 2b 80 00       	push   $0x802b30
  801d7e:	53                   	push   %ebx
  801d7f:	e8 63 ec ff ff       	call   8009e7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d84:	8b 46 04             	mov    0x4(%esi),%eax
  801d87:	2b 06                	sub    (%esi),%eax
  801d89:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d8f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d96:	00 00 00 
	stat->st_dev = &devpipe;
  801d99:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801da0:	30 80 00 
	return 0;
}
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
  801da8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    

00801daf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	53                   	push   %ebx
  801db3:	83 ec 0c             	sub    $0xc,%esp
  801db6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801db9:	53                   	push   %ebx
  801dba:	6a 00                	push   $0x0
  801dbc:	e8 9d f0 ff ff       	call   800e5e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801dc1:	89 1c 24             	mov    %ebx,(%esp)
  801dc4:	e8 15 f3 ff ff       	call   8010de <fd2data>
  801dc9:	83 c4 08             	add    $0x8,%esp
  801dcc:	50                   	push   %eax
  801dcd:	6a 00                	push   $0x0
  801dcf:	e8 8a f0 ff ff       	call   800e5e <sys_page_unmap>
}
  801dd4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dd7:	c9                   	leave  
  801dd8:	c3                   	ret    

00801dd9 <_pipeisclosed>:
{
  801dd9:	55                   	push   %ebp
  801dda:	89 e5                	mov    %esp,%ebp
  801ddc:	57                   	push   %edi
  801ddd:	56                   	push   %esi
  801dde:	53                   	push   %ebx
  801ddf:	83 ec 1c             	sub    $0x1c,%esp
  801de2:	89 c7                	mov    %eax,%edi
  801de4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801de6:	a1 08 40 80 00       	mov    0x804008,%eax
  801deb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dee:	83 ec 0c             	sub    $0xc,%esp
  801df1:	57                   	push   %edi
  801df2:	e8 8e 05 00 00       	call   802385 <pageref>
  801df7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dfa:	89 34 24             	mov    %esi,(%esp)
  801dfd:	e8 83 05 00 00       	call   802385 <pageref>
		nn = thisenv->env_runs;
  801e02:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801e08:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e0b:	83 c4 10             	add    $0x10,%esp
  801e0e:	39 cb                	cmp    %ecx,%ebx
  801e10:	74 1b                	je     801e2d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e12:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e15:	75 cf                	jne    801de6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e17:	8b 42 58             	mov    0x58(%edx),%eax
  801e1a:	6a 01                	push   $0x1
  801e1c:	50                   	push   %eax
  801e1d:	53                   	push   %ebx
  801e1e:	68 37 2b 80 00       	push   $0x802b37
  801e23:	e8 60 e4 ff ff       	call   800288 <cprintf>
  801e28:	83 c4 10             	add    $0x10,%esp
  801e2b:	eb b9                	jmp    801de6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e2d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e30:	0f 94 c0             	sete   %al
  801e33:	0f b6 c0             	movzbl %al,%eax
}
  801e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e39:	5b                   	pop    %ebx
  801e3a:	5e                   	pop    %esi
  801e3b:	5f                   	pop    %edi
  801e3c:	5d                   	pop    %ebp
  801e3d:	c3                   	ret    

00801e3e <devpipe_write>:
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	57                   	push   %edi
  801e42:	56                   	push   %esi
  801e43:	53                   	push   %ebx
  801e44:	83 ec 28             	sub    $0x28,%esp
  801e47:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e4a:	56                   	push   %esi
  801e4b:	e8 8e f2 ff ff       	call   8010de <fd2data>
  801e50:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	bf 00 00 00 00       	mov    $0x0,%edi
  801e5a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e5d:	74 4f                	je     801eae <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e5f:	8b 43 04             	mov    0x4(%ebx),%eax
  801e62:	8b 0b                	mov    (%ebx),%ecx
  801e64:	8d 51 20             	lea    0x20(%ecx),%edx
  801e67:	39 d0                	cmp    %edx,%eax
  801e69:	72 14                	jb     801e7f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e6b:	89 da                	mov    %ebx,%edx
  801e6d:	89 f0                	mov    %esi,%eax
  801e6f:	e8 65 ff ff ff       	call   801dd9 <_pipeisclosed>
  801e74:	85 c0                	test   %eax,%eax
  801e76:	75 3b                	jne    801eb3 <devpipe_write+0x75>
			sys_yield();
  801e78:	e8 3d ef ff ff       	call   800dba <sys_yield>
  801e7d:	eb e0                	jmp    801e5f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e82:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e86:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e89:	89 c2                	mov    %eax,%edx
  801e8b:	c1 fa 1f             	sar    $0x1f,%edx
  801e8e:	89 d1                	mov    %edx,%ecx
  801e90:	c1 e9 1b             	shr    $0x1b,%ecx
  801e93:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e96:	83 e2 1f             	and    $0x1f,%edx
  801e99:	29 ca                	sub    %ecx,%edx
  801e9b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e9f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801ea3:	83 c0 01             	add    $0x1,%eax
  801ea6:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ea9:	83 c7 01             	add    $0x1,%edi
  801eac:	eb ac                	jmp    801e5a <devpipe_write+0x1c>
	return i;
  801eae:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb1:	eb 05                	jmp    801eb8 <devpipe_write+0x7a>
				return 0;
  801eb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	5f                   	pop    %edi
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    

00801ec0 <devpipe_read>:
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	57                   	push   %edi
  801ec4:	56                   	push   %esi
  801ec5:	53                   	push   %ebx
  801ec6:	83 ec 18             	sub    $0x18,%esp
  801ec9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801ecc:	57                   	push   %edi
  801ecd:	e8 0c f2 ff ff       	call   8010de <fd2data>
  801ed2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ed4:	83 c4 10             	add    $0x10,%esp
  801ed7:	be 00 00 00 00       	mov    $0x0,%esi
  801edc:	3b 75 10             	cmp    0x10(%ebp),%esi
  801edf:	75 14                	jne    801ef5 <devpipe_read+0x35>
	return i;
  801ee1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee4:	eb 02                	jmp    801ee8 <devpipe_read+0x28>
				return i;
  801ee6:	89 f0                	mov    %esi,%eax
}
  801ee8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5e                   	pop    %esi
  801eed:	5f                   	pop    %edi
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    
			sys_yield();
  801ef0:	e8 c5 ee ff ff       	call   800dba <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801ef5:	8b 03                	mov    (%ebx),%eax
  801ef7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801efa:	75 18                	jne    801f14 <devpipe_read+0x54>
			if (i > 0)
  801efc:	85 f6                	test   %esi,%esi
  801efe:	75 e6                	jne    801ee6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801f00:	89 da                	mov    %ebx,%edx
  801f02:	89 f8                	mov    %edi,%eax
  801f04:	e8 d0 fe ff ff       	call   801dd9 <_pipeisclosed>
  801f09:	85 c0                	test   %eax,%eax
  801f0b:	74 e3                	je     801ef0 <devpipe_read+0x30>
				return 0;
  801f0d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f12:	eb d4                	jmp    801ee8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f14:	99                   	cltd   
  801f15:	c1 ea 1b             	shr    $0x1b,%edx
  801f18:	01 d0                	add    %edx,%eax
  801f1a:	83 e0 1f             	and    $0x1f,%eax
  801f1d:	29 d0                	sub    %edx,%eax
  801f1f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f27:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801f2a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801f2d:	83 c6 01             	add    $0x1,%esi
  801f30:	eb aa                	jmp    801edc <devpipe_read+0x1c>

00801f32 <pipe>:
{
  801f32:	55                   	push   %ebp
  801f33:	89 e5                	mov    %esp,%ebp
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f3a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f3d:	50                   	push   %eax
  801f3e:	e8 b2 f1 ff ff       	call   8010f5 <fd_alloc>
  801f43:	89 c3                	mov    %eax,%ebx
  801f45:	83 c4 10             	add    $0x10,%esp
  801f48:	85 c0                	test   %eax,%eax
  801f4a:	0f 88 23 01 00 00    	js     802073 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f50:	83 ec 04             	sub    $0x4,%esp
  801f53:	68 07 04 00 00       	push   $0x407
  801f58:	ff 75 f4             	pushl  -0xc(%ebp)
  801f5b:	6a 00                	push   $0x0
  801f5d:	e8 77 ee ff ff       	call   800dd9 <sys_page_alloc>
  801f62:	89 c3                	mov    %eax,%ebx
  801f64:	83 c4 10             	add    $0x10,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	0f 88 04 01 00 00    	js     802073 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f6f:	83 ec 0c             	sub    $0xc,%esp
  801f72:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	e8 7a f1 ff ff       	call   8010f5 <fd_alloc>
  801f7b:	89 c3                	mov    %eax,%ebx
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	0f 88 db 00 00 00    	js     802063 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f88:	83 ec 04             	sub    $0x4,%esp
  801f8b:	68 07 04 00 00       	push   $0x407
  801f90:	ff 75 f0             	pushl  -0x10(%ebp)
  801f93:	6a 00                	push   $0x0
  801f95:	e8 3f ee ff ff       	call   800dd9 <sys_page_alloc>
  801f9a:	89 c3                	mov    %eax,%ebx
  801f9c:	83 c4 10             	add    $0x10,%esp
  801f9f:	85 c0                	test   %eax,%eax
  801fa1:	0f 88 bc 00 00 00    	js     802063 <pipe+0x131>
	va = fd2data(fd0);
  801fa7:	83 ec 0c             	sub    $0xc,%esp
  801faa:	ff 75 f4             	pushl  -0xc(%ebp)
  801fad:	e8 2c f1 ff ff       	call   8010de <fd2data>
  801fb2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb4:	83 c4 0c             	add    $0xc,%esp
  801fb7:	68 07 04 00 00       	push   $0x407
  801fbc:	50                   	push   %eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	e8 15 ee ff ff       	call   800dd9 <sys_page_alloc>
  801fc4:	89 c3                	mov    %eax,%ebx
  801fc6:	83 c4 10             	add    $0x10,%esp
  801fc9:	85 c0                	test   %eax,%eax
  801fcb:	0f 88 82 00 00 00    	js     802053 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fd1:	83 ec 0c             	sub    $0xc,%esp
  801fd4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd7:	e8 02 f1 ff ff       	call   8010de <fd2data>
  801fdc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fe3:	50                   	push   %eax
  801fe4:	6a 00                	push   $0x0
  801fe6:	56                   	push   %esi
  801fe7:	6a 00                	push   $0x0
  801fe9:	e8 2e ee ff ff       	call   800e1c <sys_page_map>
  801fee:	89 c3                	mov    %eax,%ebx
  801ff0:	83 c4 20             	add    $0x20,%esp
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	78 4e                	js     802045 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ff7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801ffc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fff:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  802001:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802004:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  80200b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80200e:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  802010:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802013:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80201a:	83 ec 0c             	sub    $0xc,%esp
  80201d:	ff 75 f4             	pushl  -0xc(%ebp)
  802020:	e8 a9 f0 ff ff       	call   8010ce <fd2num>
  802025:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802028:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80202a:	83 c4 04             	add    $0x4,%esp
  80202d:	ff 75 f0             	pushl  -0x10(%ebp)
  802030:	e8 99 f0 ff ff       	call   8010ce <fd2num>
  802035:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802038:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80203b:	83 c4 10             	add    $0x10,%esp
  80203e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802043:	eb 2e                	jmp    802073 <pipe+0x141>
	sys_page_unmap(0, va);
  802045:	83 ec 08             	sub    $0x8,%esp
  802048:	56                   	push   %esi
  802049:	6a 00                	push   $0x0
  80204b:	e8 0e ee ff ff       	call   800e5e <sys_page_unmap>
  802050:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802053:	83 ec 08             	sub    $0x8,%esp
  802056:	ff 75 f0             	pushl  -0x10(%ebp)
  802059:	6a 00                	push   $0x0
  80205b:	e8 fe ed ff ff       	call   800e5e <sys_page_unmap>
  802060:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802063:	83 ec 08             	sub    $0x8,%esp
  802066:	ff 75 f4             	pushl  -0xc(%ebp)
  802069:	6a 00                	push   $0x0
  80206b:	e8 ee ed ff ff       	call   800e5e <sys_page_unmap>
  802070:	83 c4 10             	add    $0x10,%esp
}
  802073:	89 d8                	mov    %ebx,%eax
  802075:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802078:	5b                   	pop    %ebx
  802079:	5e                   	pop    %esi
  80207a:	5d                   	pop    %ebp
  80207b:	c3                   	ret    

0080207c <pipeisclosed>:
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802082:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802085:	50                   	push   %eax
  802086:	ff 75 08             	pushl  0x8(%ebp)
  802089:	e8 b9 f0 ff ff       	call   801147 <fd_lookup>
  80208e:	83 c4 10             	add    $0x10,%esp
  802091:	85 c0                	test   %eax,%eax
  802093:	78 18                	js     8020ad <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802095:	83 ec 0c             	sub    $0xc,%esp
  802098:	ff 75 f4             	pushl  -0xc(%ebp)
  80209b:	e8 3e f0 ff ff       	call   8010de <fd2data>
	return _pipeisclosed(fd, p);
  8020a0:	89 c2                	mov    %eax,%edx
  8020a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a5:	e8 2f fd ff ff       	call   801dd9 <_pipeisclosed>
  8020aa:	83 c4 10             	add    $0x10,%esp
}
  8020ad:	c9                   	leave  
  8020ae:	c3                   	ret    

008020af <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  8020af:	b8 00 00 00 00       	mov    $0x0,%eax
  8020b4:	c3                   	ret    

008020b5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8020b5:	55                   	push   %ebp
  8020b6:	89 e5                	mov    %esp,%ebp
  8020b8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  8020bb:	68 4f 2b 80 00       	push   $0x802b4f
  8020c0:	ff 75 0c             	pushl  0xc(%ebp)
  8020c3:	e8 1f e9 ff ff       	call   8009e7 <strcpy>
	return 0;
}
  8020c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8020cd:	c9                   	leave  
  8020ce:	c3                   	ret    

008020cf <devcons_write>:
{
  8020cf:	55                   	push   %ebp
  8020d0:	89 e5                	mov    %esp,%ebp
  8020d2:	57                   	push   %edi
  8020d3:	56                   	push   %esi
  8020d4:	53                   	push   %ebx
  8020d5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020db:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020e0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020e6:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020e9:	73 31                	jae    80211c <devcons_write+0x4d>
		m = n - tot;
  8020eb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020ee:	29 f3                	sub    %esi,%ebx
  8020f0:	83 fb 7f             	cmp    $0x7f,%ebx
  8020f3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  8020f8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  8020fb:	83 ec 04             	sub    $0x4,%esp
  8020fe:	53                   	push   %ebx
  8020ff:	89 f0                	mov    %esi,%eax
  802101:	03 45 0c             	add    0xc(%ebp),%eax
  802104:	50                   	push   %eax
  802105:	57                   	push   %edi
  802106:	e8 6a ea ff ff       	call   800b75 <memmove>
		sys_cputs(buf, m);
  80210b:	83 c4 08             	add    $0x8,%esp
  80210e:	53                   	push   %ebx
  80210f:	57                   	push   %edi
  802110:	e8 08 ec ff ff       	call   800d1d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802115:	01 de                	add    %ebx,%esi
  802117:	83 c4 10             	add    $0x10,%esp
  80211a:	eb ca                	jmp    8020e6 <devcons_write+0x17>
}
  80211c:	89 f0                	mov    %esi,%eax
  80211e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5f                   	pop    %edi
  802124:	5d                   	pop    %ebp
  802125:	c3                   	ret    

00802126 <devcons_read>:
{
  802126:	55                   	push   %ebp
  802127:	89 e5                	mov    %esp,%ebp
  802129:	83 ec 08             	sub    $0x8,%esp
  80212c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802131:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802135:	74 21                	je     802158 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802137:	e8 ff eb ff ff       	call   800d3b <sys_cgetc>
  80213c:	85 c0                	test   %eax,%eax
  80213e:	75 07                	jne    802147 <devcons_read+0x21>
		sys_yield();
  802140:	e8 75 ec ff ff       	call   800dba <sys_yield>
  802145:	eb f0                	jmp    802137 <devcons_read+0x11>
	if (c < 0)
  802147:	78 0f                	js     802158 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802149:	83 f8 04             	cmp    $0x4,%eax
  80214c:	74 0c                	je     80215a <devcons_read+0x34>
	*(char*)vbuf = c;
  80214e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802151:	88 02                	mov    %al,(%edx)
	return 1;
  802153:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802158:	c9                   	leave  
  802159:	c3                   	ret    
		return 0;
  80215a:	b8 00 00 00 00       	mov    $0x0,%eax
  80215f:	eb f7                	jmp    802158 <devcons_read+0x32>

00802161 <cputchar>:
{
  802161:	55                   	push   %ebp
  802162:	89 e5                	mov    %esp,%ebp
  802164:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802167:	8b 45 08             	mov    0x8(%ebp),%eax
  80216a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80216d:	6a 01                	push   $0x1
  80216f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802172:	50                   	push   %eax
  802173:	e8 a5 eb ff ff       	call   800d1d <sys_cputs>
}
  802178:	83 c4 10             	add    $0x10,%esp
  80217b:	c9                   	leave  
  80217c:	c3                   	ret    

0080217d <getchar>:
{
  80217d:	55                   	push   %ebp
  80217e:	89 e5                	mov    %esp,%ebp
  802180:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802183:	6a 01                	push   $0x1
  802185:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802188:	50                   	push   %eax
  802189:	6a 00                	push   $0x0
  80218b:	e8 27 f2 ff ff       	call   8013b7 <read>
	if (r < 0)
  802190:	83 c4 10             	add    $0x10,%esp
  802193:	85 c0                	test   %eax,%eax
  802195:	78 06                	js     80219d <getchar+0x20>
	if (r < 1)
  802197:	74 06                	je     80219f <getchar+0x22>
	return c;
  802199:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    
		return -E_EOF;
  80219f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8021a4:	eb f7                	jmp    80219d <getchar+0x20>

008021a6 <iscons>:
{
  8021a6:	55                   	push   %ebp
  8021a7:	89 e5                	mov    %esp,%ebp
  8021a9:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8021ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021af:	50                   	push   %eax
  8021b0:	ff 75 08             	pushl  0x8(%ebp)
  8021b3:	e8 8f ef ff ff       	call   801147 <fd_lookup>
  8021b8:	83 c4 10             	add    $0x10,%esp
  8021bb:	85 c0                	test   %eax,%eax
  8021bd:	78 11                	js     8021d0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8021c8:	39 10                	cmp    %edx,(%eax)
  8021ca:	0f 94 c0             	sete   %al
  8021cd:	0f b6 c0             	movzbl %al,%eax
}
  8021d0:	c9                   	leave  
  8021d1:	c3                   	ret    

008021d2 <opencons>:
{
  8021d2:	55                   	push   %ebp
  8021d3:	89 e5                	mov    %esp,%ebp
  8021d5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021db:	50                   	push   %eax
  8021dc:	e8 14 ef ff ff       	call   8010f5 <fd_alloc>
  8021e1:	83 c4 10             	add    $0x10,%esp
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	78 3a                	js     802222 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021e8:	83 ec 04             	sub    $0x4,%esp
  8021eb:	68 07 04 00 00       	push   $0x407
  8021f0:	ff 75 f4             	pushl  -0xc(%ebp)
  8021f3:	6a 00                	push   $0x0
  8021f5:	e8 df eb ff ff       	call   800dd9 <sys_page_alloc>
  8021fa:	83 c4 10             	add    $0x10,%esp
  8021fd:	85 c0                	test   %eax,%eax
  8021ff:	78 21                	js     802222 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80220a:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80220c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220f:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802216:	83 ec 0c             	sub    $0xc,%esp
  802219:	50                   	push   %eax
  80221a:	e8 af ee ff ff       	call   8010ce <fd2num>
  80221f:	83 c4 10             	add    $0x10,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	56                   	push   %esi
  802228:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802229:	a1 08 40 80 00       	mov    0x804008,%eax
  80222e:	8b 40 48             	mov    0x48(%eax),%eax
  802231:	83 ec 04             	sub    $0x4,%esp
  802234:	68 80 2b 80 00       	push   $0x802b80
  802239:	50                   	push   %eax
  80223a:	68 7d 26 80 00       	push   $0x80267d
  80223f:	e8 44 e0 ff ff       	call   800288 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802244:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802247:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80224d:	e8 49 eb ff ff       	call   800d9b <sys_getenvid>
  802252:	83 c4 04             	add    $0x4,%esp
  802255:	ff 75 0c             	pushl  0xc(%ebp)
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	56                   	push   %esi
  80225c:	50                   	push   %eax
  80225d:	68 5c 2b 80 00       	push   $0x802b5c
  802262:	e8 21 e0 ff ff       	call   800288 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802267:	83 c4 18             	add    $0x18,%esp
  80226a:	53                   	push   %ebx
  80226b:	ff 75 10             	pushl  0x10(%ebp)
  80226e:	e8 c4 df ff ff       	call   800237 <vcprintf>
	cprintf("\n");
  802273:	c7 04 24 41 26 80 00 	movl   $0x802641,(%esp)
  80227a:	e8 09 e0 ff ff       	call   800288 <cprintf>
  80227f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802282:	cc                   	int3   
  802283:	eb fd                	jmp    802282 <_panic+0x5e>

00802285 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	56                   	push   %esi
  802289:	53                   	push   %ebx
  80228a:	8b 75 08             	mov    0x8(%ebp),%esi
  80228d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802290:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802293:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802295:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80229a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80229d:	83 ec 0c             	sub    $0xc,%esp
  8022a0:	50                   	push   %eax
  8022a1:	e8 e3 ec ff ff       	call   800f89 <sys_ipc_recv>
	if(ret < 0){
  8022a6:	83 c4 10             	add    $0x10,%esp
  8022a9:	85 c0                	test   %eax,%eax
  8022ab:	78 2b                	js     8022d8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022ad:	85 f6                	test   %esi,%esi
  8022af:	74 0a                	je     8022bb <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022b1:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b6:	8b 40 78             	mov    0x78(%eax),%eax
  8022b9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022bb:	85 db                	test   %ebx,%ebx
  8022bd:	74 0a                	je     8022c9 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022bf:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c4:	8b 40 7c             	mov    0x7c(%eax),%eax
  8022c7:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022c9:	a1 08 40 80 00       	mov    0x804008,%eax
  8022ce:	8b 40 74             	mov    0x74(%eax),%eax
}
  8022d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d4:	5b                   	pop    %ebx
  8022d5:	5e                   	pop    %esi
  8022d6:	5d                   	pop    %ebp
  8022d7:	c3                   	ret    
		if(from_env_store)
  8022d8:	85 f6                	test   %esi,%esi
  8022da:	74 06                	je     8022e2 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022dc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022e2:	85 db                	test   %ebx,%ebx
  8022e4:	74 eb                	je     8022d1 <ipc_recv+0x4c>
			*perm_store = 0;
  8022e6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022ec:	eb e3                	jmp    8022d1 <ipc_recv+0x4c>

008022ee <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	57                   	push   %edi
  8022f2:	56                   	push   %esi
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 0c             	sub    $0xc,%esp
  8022f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022fa:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022fd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802300:	85 db                	test   %ebx,%ebx
  802302:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  802307:	0f 44 d8             	cmove  %eax,%ebx
  80230a:	eb 05                	jmp    802311 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80230c:	e8 a9 ea ff ff       	call   800dba <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802311:	ff 75 14             	pushl  0x14(%ebp)
  802314:	53                   	push   %ebx
  802315:	56                   	push   %esi
  802316:	57                   	push   %edi
  802317:	e8 4a ec ff ff       	call   800f66 <sys_ipc_try_send>
  80231c:	83 c4 10             	add    $0x10,%esp
  80231f:	85 c0                	test   %eax,%eax
  802321:	74 1b                	je     80233e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802323:	79 e7                	jns    80230c <ipc_send+0x1e>
  802325:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802328:	74 e2                	je     80230c <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80232a:	83 ec 04             	sub    $0x4,%esp
  80232d:	68 87 2b 80 00       	push   $0x802b87
  802332:	6a 46                	push   $0x46
  802334:	68 9c 2b 80 00       	push   $0x802b9c
  802339:	e8 e6 fe ff ff       	call   802224 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80233e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    

00802346 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802346:	55                   	push   %ebp
  802347:	89 e5                	mov    %esp,%ebp
  802349:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80234c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802351:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802357:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80235d:	8b 52 50             	mov    0x50(%edx),%edx
  802360:	39 ca                	cmp    %ecx,%edx
  802362:	74 11                	je     802375 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802364:	83 c0 01             	add    $0x1,%eax
  802367:	3d 00 04 00 00       	cmp    $0x400,%eax
  80236c:	75 e3                	jne    802351 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80236e:	b8 00 00 00 00       	mov    $0x0,%eax
  802373:	eb 0e                	jmp    802383 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802375:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80237b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802380:	8b 40 48             	mov    0x48(%eax),%eax
}
  802383:	5d                   	pop    %ebp
  802384:	c3                   	ret    

00802385 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80238b:	89 d0                	mov    %edx,%eax
  80238d:	c1 e8 16             	shr    $0x16,%eax
  802390:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802397:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80239c:	f6 c1 01             	test   $0x1,%cl
  80239f:	74 1d                	je     8023be <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023a1:	c1 ea 0c             	shr    $0xc,%edx
  8023a4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023ab:	f6 c2 01             	test   $0x1,%dl
  8023ae:	74 0e                	je     8023be <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023b0:	c1 ea 0c             	shr    $0xc,%edx
  8023b3:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023ba:	ef 
  8023bb:	0f b7 c0             	movzwl %ax,%eax
}
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    

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
