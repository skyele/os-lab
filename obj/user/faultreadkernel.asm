
obj/user/faultreadkernel.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
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
	cprintf("I read %08x from location 0xf0100000!\n", *(unsigned*)0xf0100000);
  800039:	ff 35 00 00 10 f0    	pushl  0xf0100000
  80003f:	68 80 25 80 00       	push   $0x802580
  800044:	e8 a7 01 00 00       	call   8001f0 <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	57                   	push   %edi
  800052:	56                   	push   %esi
  800053:	53                   	push   %ebx
  800054:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800057:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  80005e:	00 00 00 
	envid_t find = sys_getenvid();
  800061:	e8 9d 0c 00 00       	call   800d03 <sys_getenvid>
  800066:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  80006c:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800071:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  800076:	bf 01 00 00 00       	mov    $0x1,%edi
  80007b:	eb 0b                	jmp    800088 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  80007d:	83 c2 01             	add    $0x1,%edx
  800080:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  800086:	74 21                	je     8000a9 <libmain+0x5b>
		if(envs[i].env_id == find)
  800088:	89 d1                	mov    %edx,%ecx
  80008a:	c1 e1 07             	shl    $0x7,%ecx
  80008d:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800093:	8b 49 48             	mov    0x48(%ecx),%ecx
  800096:	39 c1                	cmp    %eax,%ecx
  800098:	75 e3                	jne    80007d <libmain+0x2f>
  80009a:	89 d3                	mov    %edx,%ebx
  80009c:	c1 e3 07             	shl    $0x7,%ebx
  80009f:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000a5:	89 fe                	mov    %edi,%esi
  8000a7:	eb d4                	jmp    80007d <libmain+0x2f>
  8000a9:	89 f0                	mov    %esi,%eax
  8000ab:	84 c0                	test   %al,%al
  8000ad:	74 06                	je     8000b5 <libmain+0x67>
  8000af:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b9:	7e 0a                	jle    8000c5 <libmain+0x77>
		binaryname = argv[0];
  8000bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000be:	8b 00                	mov    (%eax),%eax
  8000c0:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000c5:	a1 08 40 80 00       	mov    0x804008,%eax
  8000ca:	8b 40 48             	mov    0x48(%eax),%eax
  8000cd:	83 ec 08             	sub    $0x8,%esp
  8000d0:	50                   	push   %eax
  8000d1:	68 a7 25 80 00       	push   $0x8025a7
  8000d6:	e8 15 01 00 00       	call   8001f0 <cprintf>
	cprintf("before umain\n");
  8000db:	c7 04 24 c5 25 80 00 	movl   $0x8025c5,(%esp)
  8000e2:	e8 09 01 00 00       	call   8001f0 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e7:	83 c4 08             	add    $0x8,%esp
  8000ea:	ff 75 0c             	pushl  0xc(%ebp)
  8000ed:	ff 75 08             	pushl  0x8(%ebp)
  8000f0:	e8 3e ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000f5:	c7 04 24 d3 25 80 00 	movl   $0x8025d3,(%esp)
  8000fc:	e8 ef 00 00 00       	call   8001f0 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800101:	a1 08 40 80 00       	mov    0x804008,%eax
  800106:	8b 40 48             	mov    0x48(%eax),%eax
  800109:	83 c4 08             	add    $0x8,%esp
  80010c:	50                   	push   %eax
  80010d:	68 e0 25 80 00       	push   $0x8025e0
  800112:	e8 d9 00 00 00       	call   8001f0 <cprintf>
	// exit gracefully
	exit();
  800117:	e8 0b 00 00 00       	call   800127 <exit>
}
  80011c:	83 c4 10             	add    $0x10,%esp
  80011f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800122:	5b                   	pop    %ebx
  800123:	5e                   	pop    %esi
  800124:	5f                   	pop    %edi
  800125:	5d                   	pop    %ebp
  800126:	c3                   	ret    

00800127 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800127:	55                   	push   %ebp
  800128:	89 e5                	mov    %esp,%ebp
  80012a:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80012d:	a1 08 40 80 00       	mov    0x804008,%eax
  800132:	8b 40 48             	mov    0x48(%eax),%eax
  800135:	68 0c 26 80 00       	push   $0x80260c
  80013a:	50                   	push   %eax
  80013b:	68 ff 25 80 00       	push   $0x8025ff
  800140:	e8 ab 00 00 00       	call   8001f0 <cprintf>
	close_all();
  800145:	e8 c4 10 00 00       	call   80120e <close_all>
	sys_env_destroy(0);
  80014a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800151:	e8 6c 0b 00 00       	call   800cc2 <sys_env_destroy>
}
  800156:	83 c4 10             	add    $0x10,%esp
  800159:	c9                   	leave  
  80015a:	c3                   	ret    

0080015b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80015b:	55                   	push   %ebp
  80015c:	89 e5                	mov    %esp,%ebp
  80015e:	53                   	push   %ebx
  80015f:	83 ec 04             	sub    $0x4,%esp
  800162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800165:	8b 13                	mov    (%ebx),%edx
  800167:	8d 42 01             	lea    0x1(%edx),%eax
  80016a:	89 03                	mov    %eax,(%ebx)
  80016c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80016f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800173:	3d ff 00 00 00       	cmp    $0xff,%eax
  800178:	74 09                	je     800183 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80017a:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80017e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800181:	c9                   	leave  
  800182:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800183:	83 ec 08             	sub    $0x8,%esp
  800186:	68 ff 00 00 00       	push   $0xff
  80018b:	8d 43 08             	lea    0x8(%ebx),%eax
  80018e:	50                   	push   %eax
  80018f:	e8 f1 0a 00 00       	call   800c85 <sys_cputs>
		b->idx = 0;
  800194:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80019a:	83 c4 10             	add    $0x10,%esp
  80019d:	eb db                	jmp    80017a <putch+0x1f>

0080019f <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80019f:	55                   	push   %ebp
  8001a0:	89 e5                	mov    %esp,%ebp
  8001a2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001a8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001af:	00 00 00 
	b.cnt = 0;
  8001b2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001b9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001bc:	ff 75 0c             	pushl  0xc(%ebp)
  8001bf:	ff 75 08             	pushl  0x8(%ebp)
  8001c2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001c8:	50                   	push   %eax
  8001c9:	68 5b 01 80 00       	push   $0x80015b
  8001ce:	e8 4a 01 00 00       	call   80031d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001d3:	83 c4 08             	add    $0x8,%esp
  8001d6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001dc:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001e2:	50                   	push   %eax
  8001e3:	e8 9d 0a 00 00       	call   800c85 <sys_cputs>

	return b.cnt;
}
  8001e8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ee:	c9                   	leave  
  8001ef:	c3                   	ret    

008001f0 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001f0:	55                   	push   %ebp
  8001f1:	89 e5                	mov    %esp,%ebp
  8001f3:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001f6:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001f9:	50                   	push   %eax
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	e8 9d ff ff ff       	call   80019f <vcprintf>
	va_end(ap);

	return cnt;
}
  800202:	c9                   	leave  
  800203:	c3                   	ret    

00800204 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	57                   	push   %edi
  800208:	56                   	push   %esi
  800209:	53                   	push   %ebx
  80020a:	83 ec 1c             	sub    $0x1c,%esp
  80020d:	89 c6                	mov    %eax,%esi
  80020f:	89 d7                	mov    %edx,%edi
  800211:	8b 45 08             	mov    0x8(%ebp),%eax
  800214:	8b 55 0c             	mov    0xc(%ebp),%edx
  800217:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80021a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80021d:	8b 45 10             	mov    0x10(%ebp),%eax
  800220:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800223:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800227:	74 2c                	je     800255 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800229:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80022c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800233:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800236:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800239:	39 c2                	cmp    %eax,%edx
  80023b:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80023e:	73 43                	jae    800283 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  800240:	83 eb 01             	sub    $0x1,%ebx
  800243:	85 db                	test   %ebx,%ebx
  800245:	7e 6c                	jle    8002b3 <printnum+0xaf>
				putch(padc, putdat);
  800247:	83 ec 08             	sub    $0x8,%esp
  80024a:	57                   	push   %edi
  80024b:	ff 75 18             	pushl  0x18(%ebp)
  80024e:	ff d6                	call   *%esi
  800250:	83 c4 10             	add    $0x10,%esp
  800253:	eb eb                	jmp    800240 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800255:	83 ec 0c             	sub    $0xc,%esp
  800258:	6a 20                	push   $0x20
  80025a:	6a 00                	push   $0x0
  80025c:	50                   	push   %eax
  80025d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800260:	ff 75 e0             	pushl  -0x20(%ebp)
  800263:	89 fa                	mov    %edi,%edx
  800265:	89 f0                	mov    %esi,%eax
  800267:	e8 98 ff ff ff       	call   800204 <printnum>
		while (--width > 0)
  80026c:	83 c4 20             	add    $0x20,%esp
  80026f:	83 eb 01             	sub    $0x1,%ebx
  800272:	85 db                	test   %ebx,%ebx
  800274:	7e 65                	jle    8002db <printnum+0xd7>
			putch(padc, putdat);
  800276:	83 ec 08             	sub    $0x8,%esp
  800279:	57                   	push   %edi
  80027a:	6a 20                	push   $0x20
  80027c:	ff d6                	call   *%esi
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	eb ec                	jmp    80026f <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800283:	83 ec 0c             	sub    $0xc,%esp
  800286:	ff 75 18             	pushl  0x18(%ebp)
  800289:	83 eb 01             	sub    $0x1,%ebx
  80028c:	53                   	push   %ebx
  80028d:	50                   	push   %eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 dc             	pushl  -0x24(%ebp)
  800294:	ff 75 d8             	pushl  -0x28(%ebp)
  800297:	ff 75 e4             	pushl  -0x1c(%ebp)
  80029a:	ff 75 e0             	pushl  -0x20(%ebp)
  80029d:	e8 8e 20 00 00       	call   802330 <__udivdi3>
  8002a2:	83 c4 18             	add    $0x18,%esp
  8002a5:	52                   	push   %edx
  8002a6:	50                   	push   %eax
  8002a7:	89 fa                	mov    %edi,%edx
  8002a9:	89 f0                	mov    %esi,%eax
  8002ab:	e8 54 ff ff ff       	call   800204 <printnum>
  8002b0:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002b3:	83 ec 08             	sub    $0x8,%esp
  8002b6:	57                   	push   %edi
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	ff 75 dc             	pushl  -0x24(%ebp)
  8002bd:	ff 75 d8             	pushl  -0x28(%ebp)
  8002c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c6:	e8 75 21 00 00       	call   802440 <__umoddi3>
  8002cb:	83 c4 14             	add    $0x14,%esp
  8002ce:	0f be 80 11 26 80 00 	movsbl 0x802611(%eax),%eax
  8002d5:	50                   	push   %eax
  8002d6:	ff d6                	call   *%esi
  8002d8:	83 c4 10             	add    $0x10,%esp
	}
}
  8002db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002de:	5b                   	pop    %ebx
  8002df:	5e                   	pop    %esi
  8002e0:	5f                   	pop    %edi
  8002e1:	5d                   	pop    %ebp
  8002e2:	c3                   	ret    

008002e3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002e9:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002ed:	8b 10                	mov    (%eax),%edx
  8002ef:	3b 50 04             	cmp    0x4(%eax),%edx
  8002f2:	73 0a                	jae    8002fe <sprintputch+0x1b>
		*b->buf++ = ch;
  8002f4:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002f7:	89 08                	mov    %ecx,(%eax)
  8002f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002fc:	88 02                	mov    %al,(%edx)
}
  8002fe:	5d                   	pop    %ebp
  8002ff:	c3                   	ret    

00800300 <printfmt>:
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800306:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800309:	50                   	push   %eax
  80030a:	ff 75 10             	pushl  0x10(%ebp)
  80030d:	ff 75 0c             	pushl  0xc(%ebp)
  800310:	ff 75 08             	pushl  0x8(%ebp)
  800313:	e8 05 00 00 00       	call   80031d <vprintfmt>
}
  800318:	83 c4 10             	add    $0x10,%esp
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <vprintfmt>:
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	57                   	push   %edi
  800321:	56                   	push   %esi
  800322:	53                   	push   %ebx
  800323:	83 ec 3c             	sub    $0x3c,%esp
  800326:	8b 75 08             	mov    0x8(%ebp),%esi
  800329:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80032c:	8b 7d 10             	mov    0x10(%ebp),%edi
  80032f:	e9 32 04 00 00       	jmp    800766 <vprintfmt+0x449>
		padc = ' ';
  800334:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800338:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80033f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800346:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80034d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800354:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  80035b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800360:	8d 47 01             	lea    0x1(%edi),%eax
  800363:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800366:	0f b6 17             	movzbl (%edi),%edx
  800369:	8d 42 dd             	lea    -0x23(%edx),%eax
  80036c:	3c 55                	cmp    $0x55,%al
  80036e:	0f 87 12 05 00 00    	ja     800886 <vprintfmt+0x569>
  800374:	0f b6 c0             	movzbl %al,%eax
  800377:	ff 24 85 e0 27 80 00 	jmp    *0x8027e0(,%eax,4)
  80037e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800381:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800385:	eb d9                	jmp    800360 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800387:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80038a:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80038e:	eb d0                	jmp    800360 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800390:	0f b6 d2             	movzbl %dl,%edx
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800396:	b8 00 00 00 00       	mov    $0x0,%eax
  80039b:	89 75 08             	mov    %esi,0x8(%ebp)
  80039e:	eb 03                	jmp    8003a3 <vprintfmt+0x86>
  8003a0:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  8003a3:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003a6:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  8003aa:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003ad:	8d 72 d0             	lea    -0x30(%edx),%esi
  8003b0:	83 fe 09             	cmp    $0x9,%esi
  8003b3:	76 eb                	jbe    8003a0 <vprintfmt+0x83>
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003bb:	eb 14                	jmp    8003d1 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c0:	8b 00                	mov    (%eax),%eax
  8003c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c8:	8d 40 04             	lea    0x4(%eax),%eax
  8003cb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003d1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003d5:	79 89                	jns    800360 <vprintfmt+0x43>
				width = precision, precision = -1;
  8003d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003da:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003dd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003e4:	e9 77 ff ff ff       	jmp    800360 <vprintfmt+0x43>
  8003e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003ec:	85 c0                	test   %eax,%eax
  8003ee:	0f 48 c1             	cmovs  %ecx,%eax
  8003f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f7:	e9 64 ff ff ff       	jmp    800360 <vprintfmt+0x43>
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ff:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  800406:	e9 55 ff ff ff       	jmp    800360 <vprintfmt+0x43>
			lflag++;
  80040b:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80040f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800412:	e9 49 ff ff ff       	jmp    800360 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800417:	8b 45 14             	mov    0x14(%ebp),%eax
  80041a:	8d 78 04             	lea    0x4(%eax),%edi
  80041d:	83 ec 08             	sub    $0x8,%esp
  800420:	53                   	push   %ebx
  800421:	ff 30                	pushl  (%eax)
  800423:	ff d6                	call   *%esi
			break;
  800425:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800428:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80042b:	e9 33 03 00 00       	jmp    800763 <vprintfmt+0x446>
			err = va_arg(ap, int);
  800430:	8b 45 14             	mov    0x14(%ebp),%eax
  800433:	8d 78 04             	lea    0x4(%eax),%edi
  800436:	8b 00                	mov    (%eax),%eax
  800438:	99                   	cltd   
  800439:	31 d0                	xor    %edx,%eax
  80043b:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80043d:	83 f8 11             	cmp    $0x11,%eax
  800440:	7f 23                	jg     800465 <vprintfmt+0x148>
  800442:	8b 14 85 40 29 80 00 	mov    0x802940(,%eax,4),%edx
  800449:	85 d2                	test   %edx,%edx
  80044b:	74 18                	je     800465 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80044d:	52                   	push   %edx
  80044e:	68 5d 2a 80 00       	push   $0x802a5d
  800453:	53                   	push   %ebx
  800454:	56                   	push   %esi
  800455:	e8 a6 fe ff ff       	call   800300 <printfmt>
  80045a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800460:	e9 fe 02 00 00       	jmp    800763 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800465:	50                   	push   %eax
  800466:	68 29 26 80 00       	push   $0x802629
  80046b:	53                   	push   %ebx
  80046c:	56                   	push   %esi
  80046d:	e8 8e fe ff ff       	call   800300 <printfmt>
  800472:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800475:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800478:	e9 e6 02 00 00       	jmp    800763 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80047d:	8b 45 14             	mov    0x14(%ebp),%eax
  800480:	83 c0 04             	add    $0x4,%eax
  800483:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800486:	8b 45 14             	mov    0x14(%ebp),%eax
  800489:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  80048b:	85 c9                	test   %ecx,%ecx
  80048d:	b8 22 26 80 00       	mov    $0x802622,%eax
  800492:	0f 45 c1             	cmovne %ecx,%eax
  800495:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800498:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80049c:	7e 06                	jle    8004a4 <vprintfmt+0x187>
  80049e:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  8004a2:	75 0d                	jne    8004b1 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004a7:	89 c7                	mov    %eax,%edi
  8004a9:	03 45 e0             	add    -0x20(%ebp),%eax
  8004ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004af:	eb 53                	jmp    800504 <vprintfmt+0x1e7>
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8004b7:	50                   	push   %eax
  8004b8:	e8 71 04 00 00       	call   80092e <strnlen>
  8004bd:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004c0:	29 c1                	sub    %eax,%ecx
  8004c2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004c5:	83 c4 10             	add    $0x10,%esp
  8004c8:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004ca:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004ce:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d1:	eb 0f                	jmp    8004e2 <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	53                   	push   %ebx
  8004d7:	ff 75 e0             	pushl  -0x20(%ebp)
  8004da:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004dc:	83 ef 01             	sub    $0x1,%edi
  8004df:	83 c4 10             	add    $0x10,%esp
  8004e2:	85 ff                	test   %edi,%edi
  8004e4:	7f ed                	jg     8004d3 <vprintfmt+0x1b6>
  8004e6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004e9:	85 c9                	test   %ecx,%ecx
  8004eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f0:	0f 49 c1             	cmovns %ecx,%eax
  8004f3:	29 c1                	sub    %eax,%ecx
  8004f5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f8:	eb aa                	jmp    8004a4 <vprintfmt+0x187>
					putch(ch, putdat);
  8004fa:	83 ec 08             	sub    $0x8,%esp
  8004fd:	53                   	push   %ebx
  8004fe:	52                   	push   %edx
  8004ff:	ff d6                	call   *%esi
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800507:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800509:	83 c7 01             	add    $0x1,%edi
  80050c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800510:	0f be d0             	movsbl %al,%edx
  800513:	85 d2                	test   %edx,%edx
  800515:	74 4b                	je     800562 <vprintfmt+0x245>
  800517:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80051b:	78 06                	js     800523 <vprintfmt+0x206>
  80051d:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  800521:	78 1e                	js     800541 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800523:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800527:	74 d1                	je     8004fa <vprintfmt+0x1dd>
  800529:	0f be c0             	movsbl %al,%eax
  80052c:	83 e8 20             	sub    $0x20,%eax
  80052f:	83 f8 5e             	cmp    $0x5e,%eax
  800532:	76 c6                	jbe    8004fa <vprintfmt+0x1dd>
					putch('?', putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	53                   	push   %ebx
  800538:	6a 3f                	push   $0x3f
  80053a:	ff d6                	call   *%esi
  80053c:	83 c4 10             	add    $0x10,%esp
  80053f:	eb c3                	jmp    800504 <vprintfmt+0x1e7>
  800541:	89 cf                	mov    %ecx,%edi
  800543:	eb 0e                	jmp    800553 <vprintfmt+0x236>
				putch(' ', putdat);
  800545:	83 ec 08             	sub    $0x8,%esp
  800548:	53                   	push   %ebx
  800549:	6a 20                	push   $0x20
  80054b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80054d:	83 ef 01             	sub    $0x1,%edi
  800550:	83 c4 10             	add    $0x10,%esp
  800553:	85 ff                	test   %edi,%edi
  800555:	7f ee                	jg     800545 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800557:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80055a:	89 45 14             	mov    %eax,0x14(%ebp)
  80055d:	e9 01 02 00 00       	jmp    800763 <vprintfmt+0x446>
  800562:	89 cf                	mov    %ecx,%edi
  800564:	eb ed                	jmp    800553 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800569:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800570:	e9 eb fd ff ff       	jmp    800360 <vprintfmt+0x43>
	if (lflag >= 2)
  800575:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800579:	7f 21                	jg     80059c <vprintfmt+0x27f>
	else if (lflag)
  80057b:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80057f:	74 68                	je     8005e9 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800581:	8b 45 14             	mov    0x14(%ebp),%eax
  800584:	8b 00                	mov    (%eax),%eax
  800586:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800589:	89 c1                	mov    %eax,%ecx
  80058b:	c1 f9 1f             	sar    $0x1f,%ecx
  80058e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8d 40 04             	lea    0x4(%eax),%eax
  800597:	89 45 14             	mov    %eax,0x14(%ebp)
  80059a:	eb 17                	jmp    8005b3 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 50 04             	mov    0x4(%eax),%edx
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005a7:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  8005aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ad:	8d 40 08             	lea    0x8(%eax),%eax
  8005b0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005bc:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005bf:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005c3:	78 3f                	js     800604 <vprintfmt+0x2e7>
			base = 10;
  8005c5:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005ca:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005ce:	0f 84 71 01 00 00    	je     800745 <vprintfmt+0x428>
				putch('+', putdat);
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	53                   	push   %ebx
  8005d8:	6a 2b                	push   $0x2b
  8005da:	ff d6                	call   *%esi
  8005dc:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005df:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e4:	e9 5c 01 00 00       	jmp    800745 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ec:	8b 00                	mov    (%eax),%eax
  8005ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005f1:	89 c1                	mov    %eax,%ecx
  8005f3:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 40 04             	lea    0x4(%eax),%eax
  8005ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800602:	eb af                	jmp    8005b3 <vprintfmt+0x296>
				putch('-', putdat);
  800604:	83 ec 08             	sub    $0x8,%esp
  800607:	53                   	push   %ebx
  800608:	6a 2d                	push   $0x2d
  80060a:	ff d6                	call   *%esi
				num = -(long long) num;
  80060c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80060f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800612:	f7 d8                	neg    %eax
  800614:	83 d2 00             	adc    $0x0,%edx
  800617:	f7 da                	neg    %edx
  800619:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80061c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80061f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800622:	b8 0a 00 00 00       	mov    $0xa,%eax
  800627:	e9 19 01 00 00       	jmp    800745 <vprintfmt+0x428>
	if (lflag >= 2)
  80062c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800630:	7f 29                	jg     80065b <vprintfmt+0x33e>
	else if (lflag)
  800632:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800636:	74 44                	je     80067c <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800638:	8b 45 14             	mov    0x14(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	ba 00 00 00 00       	mov    $0x0,%edx
  800642:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800645:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800651:	b8 0a 00 00 00       	mov    $0xa,%eax
  800656:	e9 ea 00 00 00       	jmp    800745 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 50 04             	mov    0x4(%eax),%edx
  800661:	8b 00                	mov    (%eax),%eax
  800663:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800666:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 40 08             	lea    0x8(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800672:	b8 0a 00 00 00       	mov    $0xa,%eax
  800677:	e9 c9 00 00 00       	jmp    800745 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80067c:	8b 45 14             	mov    0x14(%ebp),%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 04             	lea    0x4(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800695:	b8 0a 00 00 00       	mov    $0xa,%eax
  80069a:	e9 a6 00 00 00       	jmp    800745 <vprintfmt+0x428>
			putch('0', putdat);
  80069f:	83 ec 08             	sub    $0x8,%esp
  8006a2:	53                   	push   %ebx
  8006a3:	6a 30                	push   $0x30
  8006a5:	ff d6                	call   *%esi
	if (lflag >= 2)
  8006a7:	83 c4 10             	add    $0x10,%esp
  8006aa:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8006ae:	7f 26                	jg     8006d6 <vprintfmt+0x3b9>
	else if (lflag)
  8006b0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006b4:	74 3e                	je     8006f4 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c9:	8d 40 04             	lea    0x4(%eax),%eax
  8006cc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006cf:	b8 08 00 00 00       	mov    $0x8,%eax
  8006d4:	eb 6f                	jmp    800745 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d9:	8b 50 04             	mov    0x4(%eax),%edx
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f2:	eb 51                	jmp    800745 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800701:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800704:	8b 45 14             	mov    0x14(%ebp),%eax
  800707:	8d 40 04             	lea    0x4(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80070d:	b8 08 00 00 00       	mov    $0x8,%eax
  800712:	eb 31                	jmp    800745 <vprintfmt+0x428>
			putch('0', putdat);
  800714:	83 ec 08             	sub    $0x8,%esp
  800717:	53                   	push   %ebx
  800718:	6a 30                	push   $0x30
  80071a:	ff d6                	call   *%esi
			putch('x', putdat);
  80071c:	83 c4 08             	add    $0x8,%esp
  80071f:	53                   	push   %ebx
  800720:	6a 78                	push   $0x78
  800722:	ff d6                	call   *%esi
			num = (unsigned long long)
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	ba 00 00 00 00       	mov    $0x0,%edx
  80072e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800731:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800734:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800737:	8b 45 14             	mov    0x14(%ebp),%eax
  80073a:	8d 40 04             	lea    0x4(%eax),%eax
  80073d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800740:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800745:	83 ec 0c             	sub    $0xc,%esp
  800748:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  80074c:	52                   	push   %edx
  80074d:	ff 75 e0             	pushl  -0x20(%ebp)
  800750:	50                   	push   %eax
  800751:	ff 75 dc             	pushl  -0x24(%ebp)
  800754:	ff 75 d8             	pushl  -0x28(%ebp)
  800757:	89 da                	mov    %ebx,%edx
  800759:	89 f0                	mov    %esi,%eax
  80075b:	e8 a4 fa ff ff       	call   800204 <printnum>
			break;
  800760:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800763:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800766:	83 c7 01             	add    $0x1,%edi
  800769:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80076d:	83 f8 25             	cmp    $0x25,%eax
  800770:	0f 84 be fb ff ff    	je     800334 <vprintfmt+0x17>
			if (ch == '\0')
  800776:	85 c0                	test   %eax,%eax
  800778:	0f 84 28 01 00 00    	je     8008a6 <vprintfmt+0x589>
			putch(ch, putdat);
  80077e:	83 ec 08             	sub    $0x8,%esp
  800781:	53                   	push   %ebx
  800782:	50                   	push   %eax
  800783:	ff d6                	call   *%esi
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	eb dc                	jmp    800766 <vprintfmt+0x449>
	if (lflag >= 2)
  80078a:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80078e:	7f 26                	jg     8007b6 <vprintfmt+0x499>
	else if (lflag)
  800790:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800794:	74 41                	je     8007d7 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	ba 00 00 00 00       	mov    $0x0,%edx
  8007a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a9:	8d 40 04             	lea    0x4(%eax),%eax
  8007ac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007af:	b8 10 00 00 00       	mov    $0x10,%eax
  8007b4:	eb 8f                	jmp    800745 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b9:	8b 50 04             	mov    0x4(%eax),%edx
  8007bc:	8b 00                	mov    (%eax),%eax
  8007be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007c1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 40 08             	lea    0x8(%eax),%eax
  8007ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007cd:	b8 10 00 00 00       	mov    $0x10,%eax
  8007d2:	e9 6e ff ff ff       	jmp    800745 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007da:	8b 00                	mov    (%eax),%eax
  8007dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8007e1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007e4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 40 04             	lea    0x4(%eax),%eax
  8007ed:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007f0:	b8 10 00 00 00       	mov    $0x10,%eax
  8007f5:	e9 4b ff ff ff       	jmp    800745 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fd:	83 c0 04             	add    $0x4,%eax
  800800:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800803:	8b 45 14             	mov    0x14(%ebp),%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	85 c0                	test   %eax,%eax
  80080a:	74 14                	je     800820 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  80080c:	8b 13                	mov    (%ebx),%edx
  80080e:	83 fa 7f             	cmp    $0x7f,%edx
  800811:	7f 37                	jg     80084a <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800813:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800815:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800818:	89 45 14             	mov    %eax,0x14(%ebp)
  80081b:	e9 43 ff ff ff       	jmp    800763 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  800820:	b8 0a 00 00 00       	mov    $0xa,%eax
  800825:	bf 45 27 80 00       	mov    $0x802745,%edi
							putch(ch, putdat);
  80082a:	83 ec 08             	sub    $0x8,%esp
  80082d:	53                   	push   %ebx
  80082e:	50                   	push   %eax
  80082f:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800831:	83 c7 01             	add    $0x1,%edi
  800834:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	85 c0                	test   %eax,%eax
  80083d:	75 eb                	jne    80082a <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80083f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800842:	89 45 14             	mov    %eax,0x14(%ebp)
  800845:	e9 19 ff ff ff       	jmp    800763 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  80084a:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  80084c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800851:	bf 7d 27 80 00       	mov    $0x80277d,%edi
							putch(ch, putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	53                   	push   %ebx
  80085a:	50                   	push   %eax
  80085b:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80085d:	83 c7 01             	add    $0x1,%edi
  800860:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800864:	83 c4 10             	add    $0x10,%esp
  800867:	85 c0                	test   %eax,%eax
  800869:	75 eb                	jne    800856 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  80086b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80086e:	89 45 14             	mov    %eax,0x14(%ebp)
  800871:	e9 ed fe ff ff       	jmp    800763 <vprintfmt+0x446>
			putch(ch, putdat);
  800876:	83 ec 08             	sub    $0x8,%esp
  800879:	53                   	push   %ebx
  80087a:	6a 25                	push   $0x25
  80087c:	ff d6                	call   *%esi
			break;
  80087e:	83 c4 10             	add    $0x10,%esp
  800881:	e9 dd fe ff ff       	jmp    800763 <vprintfmt+0x446>
			putch('%', putdat);
  800886:	83 ec 08             	sub    $0x8,%esp
  800889:	53                   	push   %ebx
  80088a:	6a 25                	push   $0x25
  80088c:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 f8                	mov    %edi,%eax
  800893:	eb 03                	jmp    800898 <vprintfmt+0x57b>
  800895:	83 e8 01             	sub    $0x1,%eax
  800898:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80089c:	75 f7                	jne    800895 <vprintfmt+0x578>
  80089e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008a1:	e9 bd fe ff ff       	jmp    800763 <vprintfmt+0x446>
}
  8008a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a9:	5b                   	pop    %ebx
  8008aa:	5e                   	pop    %esi
  8008ab:	5f                   	pop    %edi
  8008ac:	5d                   	pop    %ebp
  8008ad:	c3                   	ret    

008008ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ae:	55                   	push   %ebp
  8008af:	89 e5                	mov    %esp,%ebp
  8008b1:	83 ec 18             	sub    $0x18,%esp
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008bd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008c1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008cb:	85 c0                	test   %eax,%eax
  8008cd:	74 26                	je     8008f5 <vsnprintf+0x47>
  8008cf:	85 d2                	test   %edx,%edx
  8008d1:	7e 22                	jle    8008f5 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d3:	ff 75 14             	pushl  0x14(%ebp)
  8008d6:	ff 75 10             	pushl  0x10(%ebp)
  8008d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008dc:	50                   	push   %eax
  8008dd:	68 e3 02 80 00       	push   $0x8002e3
  8008e2:	e8 36 fa ff ff       	call   80031d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008ea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008f0:	83 c4 10             	add    $0x10,%esp
}
  8008f3:	c9                   	leave  
  8008f4:	c3                   	ret    
		return -E_INVAL;
  8008f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fa:	eb f7                	jmp    8008f3 <vsnprintf+0x45>

008008fc <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800902:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800905:	50                   	push   %eax
  800906:	ff 75 10             	pushl  0x10(%ebp)
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	ff 75 08             	pushl  0x8(%ebp)
  80090f:	e8 9a ff ff ff       	call   8008ae <vsnprintf>
	va_end(ap);

	return rc;
}
  800914:	c9                   	leave  
  800915:	c3                   	ret    

00800916 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800916:	55                   	push   %ebp
  800917:	89 e5                	mov    %esp,%ebp
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091c:	b8 00 00 00 00       	mov    $0x0,%eax
  800921:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800925:	74 05                	je     80092c <strlen+0x16>
		n++;
  800927:	83 c0 01             	add    $0x1,%eax
  80092a:	eb f5                	jmp    800921 <strlen+0xb>
	return n;
}
  80092c:	5d                   	pop    %ebp
  80092d:	c3                   	ret    

0080092e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092e:	55                   	push   %ebp
  80092f:	89 e5                	mov    %esp,%ebp
  800931:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800934:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800937:	ba 00 00 00 00       	mov    $0x0,%edx
  80093c:	39 c2                	cmp    %eax,%edx
  80093e:	74 0d                	je     80094d <strnlen+0x1f>
  800940:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800944:	74 05                	je     80094b <strnlen+0x1d>
		n++;
  800946:	83 c2 01             	add    $0x1,%edx
  800949:	eb f1                	jmp    80093c <strnlen+0xe>
  80094b:	89 d0                	mov    %edx,%eax
	return n;
}
  80094d:	5d                   	pop    %ebp
  80094e:	c3                   	ret    

0080094f <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094f:	55                   	push   %ebp
  800950:	89 e5                	mov    %esp,%ebp
  800952:	53                   	push   %ebx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800959:	ba 00 00 00 00       	mov    $0x0,%edx
  80095e:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800962:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800965:	83 c2 01             	add    $0x1,%edx
  800968:	84 c9                	test   %cl,%cl
  80096a:	75 f2                	jne    80095e <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  80096c:	5b                   	pop    %ebx
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <strcat>:

char *
strcat(char *dst, const char *src)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	53                   	push   %ebx
  800973:	83 ec 10             	sub    $0x10,%esp
  800976:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800979:	53                   	push   %ebx
  80097a:	e8 97 ff ff ff       	call   800916 <strlen>
  80097f:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	01 d8                	add    %ebx,%eax
  800987:	50                   	push   %eax
  800988:	e8 c2 ff ff ff       	call   80094f <strcpy>
	return dst;
}
  80098d:	89 d8                	mov    %ebx,%eax
  80098f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	56                   	push   %esi
  800998:	53                   	push   %ebx
  800999:	8b 45 08             	mov    0x8(%ebp),%eax
  80099c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80099f:	89 c6                	mov    %eax,%esi
  8009a1:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009a4:	89 c2                	mov    %eax,%edx
  8009a6:	39 f2                	cmp    %esi,%edx
  8009a8:	74 11                	je     8009bb <strncpy+0x27>
		*dst++ = *src;
  8009aa:	83 c2 01             	add    $0x1,%edx
  8009ad:	0f b6 19             	movzbl (%ecx),%ebx
  8009b0:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009b3:	80 fb 01             	cmp    $0x1,%bl
  8009b6:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009b9:	eb eb                	jmp    8009a6 <strncpy+0x12>
	}
	return ret;
}
  8009bb:	5b                   	pop    %ebx
  8009bc:	5e                   	pop    %esi
  8009bd:	5d                   	pop    %ebp
  8009be:	c3                   	ret    

008009bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
  8009c2:	56                   	push   %esi
  8009c3:	53                   	push   %ebx
  8009c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009ca:	8b 55 10             	mov    0x10(%ebp),%edx
  8009cd:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009cf:	85 d2                	test   %edx,%edx
  8009d1:	74 21                	je     8009f4 <strlcpy+0x35>
  8009d3:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009d7:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009d9:	39 c2                	cmp    %eax,%edx
  8009db:	74 14                	je     8009f1 <strlcpy+0x32>
  8009dd:	0f b6 19             	movzbl (%ecx),%ebx
  8009e0:	84 db                	test   %bl,%bl
  8009e2:	74 0b                	je     8009ef <strlcpy+0x30>
			*dst++ = *src++;
  8009e4:	83 c1 01             	add    $0x1,%ecx
  8009e7:	83 c2 01             	add    $0x1,%edx
  8009ea:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009ed:	eb ea                	jmp    8009d9 <strlcpy+0x1a>
  8009ef:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009f4:	29 f0                	sub    %esi,%eax
}
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a03:	0f b6 01             	movzbl (%ecx),%eax
  800a06:	84 c0                	test   %al,%al
  800a08:	74 0c                	je     800a16 <strcmp+0x1c>
  800a0a:	3a 02                	cmp    (%edx),%al
  800a0c:	75 08                	jne    800a16 <strcmp+0x1c>
		p++, q++;
  800a0e:	83 c1 01             	add    $0x1,%ecx
  800a11:	83 c2 01             	add    $0x1,%edx
  800a14:	eb ed                	jmp    800a03 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a16:	0f b6 c0             	movzbl %al,%eax
  800a19:	0f b6 12             	movzbl (%edx),%edx
  800a1c:	29 d0                	sub    %edx,%eax
}
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	53                   	push   %ebx
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a2a:	89 c3                	mov    %eax,%ebx
  800a2c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a2f:	eb 06                	jmp    800a37 <strncmp+0x17>
		n--, p++, q++;
  800a31:	83 c0 01             	add    $0x1,%eax
  800a34:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a37:	39 d8                	cmp    %ebx,%eax
  800a39:	74 16                	je     800a51 <strncmp+0x31>
  800a3b:	0f b6 08             	movzbl (%eax),%ecx
  800a3e:	84 c9                	test   %cl,%cl
  800a40:	74 04                	je     800a46 <strncmp+0x26>
  800a42:	3a 0a                	cmp    (%edx),%cl
  800a44:	74 eb                	je     800a31 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a46:	0f b6 00             	movzbl (%eax),%eax
  800a49:	0f b6 12             	movzbl (%edx),%edx
  800a4c:	29 d0                	sub    %edx,%eax
}
  800a4e:	5b                   	pop    %ebx
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    
		return 0;
  800a51:	b8 00 00 00 00       	mov    $0x0,%eax
  800a56:	eb f6                	jmp    800a4e <strncmp+0x2e>

00800a58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a58:	55                   	push   %ebp
  800a59:	89 e5                	mov    %esp,%ebp
  800a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5e:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a62:	0f b6 10             	movzbl (%eax),%edx
  800a65:	84 d2                	test   %dl,%dl
  800a67:	74 09                	je     800a72 <strchr+0x1a>
		if (*s == c)
  800a69:	38 ca                	cmp    %cl,%dl
  800a6b:	74 0a                	je     800a77 <strchr+0x1f>
	for (; *s; s++)
  800a6d:	83 c0 01             	add    $0x1,%eax
  800a70:	eb f0                	jmp    800a62 <strchr+0xa>
			return (char *) s;
	return 0;
  800a72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a77:	5d                   	pop    %ebp
  800a78:	c3                   	ret    

00800a79 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a79:	55                   	push   %ebp
  800a7a:	89 e5                	mov    %esp,%ebp
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a83:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a86:	38 ca                	cmp    %cl,%dl
  800a88:	74 09                	je     800a93 <strfind+0x1a>
  800a8a:	84 d2                	test   %dl,%dl
  800a8c:	74 05                	je     800a93 <strfind+0x1a>
	for (; *s; s++)
  800a8e:	83 c0 01             	add    $0x1,%eax
  800a91:	eb f0                	jmp    800a83 <strfind+0xa>
			break;
	return (char *) s;
}
  800a93:	5d                   	pop    %ebp
  800a94:	c3                   	ret    

00800a95 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a95:	55                   	push   %ebp
  800a96:	89 e5                	mov    %esp,%ebp
  800a98:	57                   	push   %edi
  800a99:	56                   	push   %esi
  800a9a:	53                   	push   %ebx
  800a9b:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800aa1:	85 c9                	test   %ecx,%ecx
  800aa3:	74 31                	je     800ad6 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aa5:	89 f8                	mov    %edi,%eax
  800aa7:	09 c8                	or     %ecx,%eax
  800aa9:	a8 03                	test   $0x3,%al
  800aab:	75 23                	jne    800ad0 <memset+0x3b>
		c &= 0xFF;
  800aad:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ab1:	89 d3                	mov    %edx,%ebx
  800ab3:	c1 e3 08             	shl    $0x8,%ebx
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	c1 e0 18             	shl    $0x18,%eax
  800abb:	89 d6                	mov    %edx,%esi
  800abd:	c1 e6 10             	shl    $0x10,%esi
  800ac0:	09 f0                	or     %esi,%eax
  800ac2:	09 c2                	or     %eax,%edx
  800ac4:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ac6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ac9:	89 d0                	mov    %edx,%eax
  800acb:	fc                   	cld    
  800acc:	f3 ab                	rep stos %eax,%es:(%edi)
  800ace:	eb 06                	jmp    800ad6 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad3:	fc                   	cld    
  800ad4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ad6:	89 f8                	mov    %edi,%eax
  800ad8:	5b                   	pop    %ebx
  800ad9:	5e                   	pop    %esi
  800ada:	5f                   	pop    %edi
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	57                   	push   %edi
  800ae1:	56                   	push   %esi
  800ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae8:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800aeb:	39 c6                	cmp    %eax,%esi
  800aed:	73 32                	jae    800b21 <memmove+0x44>
  800aef:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800af2:	39 c2                	cmp    %eax,%edx
  800af4:	76 2b                	jbe    800b21 <memmove+0x44>
		s += n;
		d += n;
  800af6:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800af9:	89 fe                	mov    %edi,%esi
  800afb:	09 ce                	or     %ecx,%esi
  800afd:	09 d6                	or     %edx,%esi
  800aff:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b05:	75 0e                	jne    800b15 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b07:	83 ef 04             	sub    $0x4,%edi
  800b0a:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b0d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b10:	fd                   	std    
  800b11:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b13:	eb 09                	jmp    800b1e <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b15:	83 ef 01             	sub    $0x1,%edi
  800b18:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b1b:	fd                   	std    
  800b1c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b1e:	fc                   	cld    
  800b1f:	eb 1a                	jmp    800b3b <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b21:	89 c2                	mov    %eax,%edx
  800b23:	09 ca                	or     %ecx,%edx
  800b25:	09 f2                	or     %esi,%edx
  800b27:	f6 c2 03             	test   $0x3,%dl
  800b2a:	75 0a                	jne    800b36 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b2c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b2f:	89 c7                	mov    %eax,%edi
  800b31:	fc                   	cld    
  800b32:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b34:	eb 05                	jmp    800b3b <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b36:	89 c7                	mov    %eax,%edi
  800b38:	fc                   	cld    
  800b39:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b3b:	5e                   	pop    %esi
  800b3c:	5f                   	pop    %edi
  800b3d:	5d                   	pop    %ebp
  800b3e:	c3                   	ret    

00800b3f <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b3f:	55                   	push   %ebp
  800b40:	89 e5                	mov    %esp,%ebp
  800b42:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b45:	ff 75 10             	pushl  0x10(%ebp)
  800b48:	ff 75 0c             	pushl  0xc(%ebp)
  800b4b:	ff 75 08             	pushl  0x8(%ebp)
  800b4e:	e8 8a ff ff ff       	call   800add <memmove>
}
  800b53:	c9                   	leave  
  800b54:	c3                   	ret    

00800b55 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	56                   	push   %esi
  800b59:	53                   	push   %ebx
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 c6                	mov    %eax,%esi
  800b62:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b65:	39 f0                	cmp    %esi,%eax
  800b67:	74 1c                	je     800b85 <memcmp+0x30>
		if (*s1 != *s2)
  800b69:	0f b6 08             	movzbl (%eax),%ecx
  800b6c:	0f b6 1a             	movzbl (%edx),%ebx
  800b6f:	38 d9                	cmp    %bl,%cl
  800b71:	75 08                	jne    800b7b <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b73:	83 c0 01             	add    $0x1,%eax
  800b76:	83 c2 01             	add    $0x1,%edx
  800b79:	eb ea                	jmp    800b65 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b7b:	0f b6 c1             	movzbl %cl,%eax
  800b7e:	0f b6 db             	movzbl %bl,%ebx
  800b81:	29 d8                	sub    %ebx,%eax
  800b83:	eb 05                	jmp    800b8a <memcmp+0x35>
	}

	return 0;
  800b85:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b8a:	5b                   	pop    %ebx
  800b8b:	5e                   	pop    %esi
  800b8c:	5d                   	pop    %ebp
  800b8d:	c3                   	ret    

00800b8e <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b8e:	55                   	push   %ebp
  800b8f:	89 e5                	mov    %esp,%ebp
  800b91:	8b 45 08             	mov    0x8(%ebp),%eax
  800b94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b97:	89 c2                	mov    %eax,%edx
  800b99:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b9c:	39 d0                	cmp    %edx,%eax
  800b9e:	73 09                	jae    800ba9 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ba0:	38 08                	cmp    %cl,(%eax)
  800ba2:	74 05                	je     800ba9 <memfind+0x1b>
	for (; s < ends; s++)
  800ba4:	83 c0 01             	add    $0x1,%eax
  800ba7:	eb f3                	jmp    800b9c <memfind+0xe>
			break;
	return (void *) s;
}
  800ba9:	5d                   	pop    %ebp
  800baa:	c3                   	ret    

00800bab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bab:	55                   	push   %ebp
  800bac:	89 e5                	mov    %esp,%ebp
  800bae:	57                   	push   %edi
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bb7:	eb 03                	jmp    800bbc <strtol+0x11>
		s++;
  800bb9:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800bbc:	0f b6 01             	movzbl (%ecx),%eax
  800bbf:	3c 20                	cmp    $0x20,%al
  800bc1:	74 f6                	je     800bb9 <strtol+0xe>
  800bc3:	3c 09                	cmp    $0x9,%al
  800bc5:	74 f2                	je     800bb9 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bc7:	3c 2b                	cmp    $0x2b,%al
  800bc9:	74 2a                	je     800bf5 <strtol+0x4a>
	int neg = 0;
  800bcb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bd0:	3c 2d                	cmp    $0x2d,%al
  800bd2:	74 2b                	je     800bff <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd4:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bda:	75 0f                	jne    800beb <strtol+0x40>
  800bdc:	80 39 30             	cmpb   $0x30,(%ecx)
  800bdf:	74 28                	je     800c09 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800be1:	85 db                	test   %ebx,%ebx
  800be3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800be8:	0f 44 d8             	cmove  %eax,%ebx
  800beb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf0:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800bf3:	eb 50                	jmp    800c45 <strtol+0x9a>
		s++;
  800bf5:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800bf8:	bf 00 00 00 00       	mov    $0x0,%edi
  800bfd:	eb d5                	jmp    800bd4 <strtol+0x29>
		s++, neg = 1;
  800bff:	83 c1 01             	add    $0x1,%ecx
  800c02:	bf 01 00 00 00       	mov    $0x1,%edi
  800c07:	eb cb                	jmp    800bd4 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c09:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c0d:	74 0e                	je     800c1d <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800c0f:	85 db                	test   %ebx,%ebx
  800c11:	75 d8                	jne    800beb <strtol+0x40>
		s++, base = 8;
  800c13:	83 c1 01             	add    $0x1,%ecx
  800c16:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c1b:	eb ce                	jmp    800beb <strtol+0x40>
		s += 2, base = 16;
  800c1d:	83 c1 02             	add    $0x2,%ecx
  800c20:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c25:	eb c4                	jmp    800beb <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c27:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c2a:	89 f3                	mov    %esi,%ebx
  800c2c:	80 fb 19             	cmp    $0x19,%bl
  800c2f:	77 29                	ja     800c5a <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c31:	0f be d2             	movsbl %dl,%edx
  800c34:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c37:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c3a:	7d 30                	jge    800c6c <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c3c:	83 c1 01             	add    $0x1,%ecx
  800c3f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c43:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c45:	0f b6 11             	movzbl (%ecx),%edx
  800c48:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c4b:	89 f3                	mov    %esi,%ebx
  800c4d:	80 fb 09             	cmp    $0x9,%bl
  800c50:	77 d5                	ja     800c27 <strtol+0x7c>
			dig = *s - '0';
  800c52:	0f be d2             	movsbl %dl,%edx
  800c55:	83 ea 30             	sub    $0x30,%edx
  800c58:	eb dd                	jmp    800c37 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c5a:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c5d:	89 f3                	mov    %esi,%ebx
  800c5f:	80 fb 19             	cmp    $0x19,%bl
  800c62:	77 08                	ja     800c6c <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c64:	0f be d2             	movsbl %dl,%edx
  800c67:	83 ea 37             	sub    $0x37,%edx
  800c6a:	eb cb                	jmp    800c37 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c70:	74 05                	je     800c77 <strtol+0xcc>
		*endptr = (char *) s;
  800c72:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c75:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c77:	89 c2                	mov    %eax,%edx
  800c79:	f7 da                	neg    %edx
  800c7b:	85 ff                	test   %edi,%edi
  800c7d:	0f 45 c2             	cmovne %edx,%eax
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	57                   	push   %edi
  800c89:	56                   	push   %esi
  800c8a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c8b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c90:	8b 55 08             	mov    0x8(%ebp),%edx
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	89 c3                	mov    %eax,%ebx
  800c98:	89 c7                	mov    %eax,%edi
  800c9a:	89 c6                	mov    %eax,%esi
  800c9c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c9e:	5b                   	pop    %ebx
  800c9f:	5e                   	pop    %esi
  800ca0:	5f                   	pop    %edi
  800ca1:	5d                   	pop    %ebp
  800ca2:	c3                   	ret    

00800ca3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cae:	b8 01 00 00 00       	mov    $0x1,%eax
  800cb3:	89 d1                	mov    %edx,%ecx
  800cb5:	89 d3                	mov    %edx,%ebx
  800cb7:	89 d7                	mov    %edx,%edi
  800cb9:	89 d6                	mov    %edx,%esi
  800cbb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800cbd:	5b                   	pop    %ebx
  800cbe:	5e                   	pop    %esi
  800cbf:	5f                   	pop    %edi
  800cc0:	5d                   	pop    %ebp
  800cc1:	c3                   	ret    

00800cc2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd3:	b8 03 00 00 00       	mov    $0x3,%eax
  800cd8:	89 cb                	mov    %ecx,%ebx
  800cda:	89 cf                	mov    %ecx,%edi
  800cdc:	89 ce                	mov    %ecx,%esi
  800cde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce0:	85 c0                	test   %eax,%eax
  800ce2:	7f 08                	jg     800cec <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	50                   	push   %eax
  800cf0:	6a 03                	push   $0x3
  800cf2:	68 88 29 80 00       	push   $0x802988
  800cf7:	6a 43                	push   $0x43
  800cf9:	68 a5 29 80 00       	push   $0x8029a5
  800cfe:	e8 89 14 00 00       	call   80218c <_panic>

00800d03 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d09:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0e:	b8 02 00 00 00       	mov    $0x2,%eax
  800d13:	89 d1                	mov    %edx,%ecx
  800d15:	89 d3                	mov    %edx,%ebx
  800d17:	89 d7                	mov    %edx,%edi
  800d19:	89 d6                	mov    %edx,%esi
  800d1b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d1d:	5b                   	pop    %ebx
  800d1e:	5e                   	pop    %esi
  800d1f:	5f                   	pop    %edi
  800d20:	5d                   	pop    %ebp
  800d21:	c3                   	ret    

00800d22 <sys_yield>:

void
sys_yield(void)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	57                   	push   %edi
  800d26:	56                   	push   %esi
  800d27:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d28:	ba 00 00 00 00       	mov    $0x0,%edx
  800d2d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d32:	89 d1                	mov    %edx,%ecx
  800d34:	89 d3                	mov    %edx,%ebx
  800d36:	89 d7                	mov    %edx,%edi
  800d38:	89 d6                	mov    %edx,%esi
  800d3a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d3c:	5b                   	pop    %ebx
  800d3d:	5e                   	pop    %esi
  800d3e:	5f                   	pop    %edi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	57                   	push   %edi
  800d45:	56                   	push   %esi
  800d46:	53                   	push   %ebx
  800d47:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4a:	be 00 00 00 00       	mov    $0x0,%esi
  800d4f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d55:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5d:	89 f7                	mov    %esi,%edi
  800d5f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d61:	85 c0                	test   %eax,%eax
  800d63:	7f 08                	jg     800d6d <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d65:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d68:	5b                   	pop    %ebx
  800d69:	5e                   	pop    %esi
  800d6a:	5f                   	pop    %edi
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6d:	83 ec 0c             	sub    $0xc,%esp
  800d70:	50                   	push   %eax
  800d71:	6a 04                	push   $0x4
  800d73:	68 88 29 80 00       	push   $0x802988
  800d78:	6a 43                	push   $0x43
  800d7a:	68 a5 29 80 00       	push   $0x8029a5
  800d7f:	e8 08 14 00 00       	call   80218c <_panic>

00800d84 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
  800d8a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d93:	b8 05 00 00 00       	mov    $0x5,%eax
  800d98:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d9b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d9e:	8b 75 18             	mov    0x18(%ebp),%esi
  800da1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da3:	85 c0                	test   %eax,%eax
  800da5:	7f 08                	jg     800daf <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800daa:	5b                   	pop    %ebx
  800dab:	5e                   	pop    %esi
  800dac:	5f                   	pop    %edi
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800daf:	83 ec 0c             	sub    $0xc,%esp
  800db2:	50                   	push   %eax
  800db3:	6a 05                	push   $0x5
  800db5:	68 88 29 80 00       	push   $0x802988
  800dba:	6a 43                	push   $0x43
  800dbc:	68 a5 29 80 00       	push   $0x8029a5
  800dc1:	e8 c6 13 00 00       	call   80218c <_panic>

00800dc6 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	57                   	push   %edi
  800dca:	56                   	push   %esi
  800dcb:	53                   	push   %ebx
  800dcc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dda:	b8 06 00 00 00       	mov    $0x6,%eax
  800ddf:	89 df                	mov    %ebx,%edi
  800de1:	89 de                	mov    %ebx,%esi
  800de3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	7f 08                	jg     800df1 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800de9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dec:	5b                   	pop    %ebx
  800ded:	5e                   	pop    %esi
  800dee:	5f                   	pop    %edi
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df1:	83 ec 0c             	sub    $0xc,%esp
  800df4:	50                   	push   %eax
  800df5:	6a 06                	push   $0x6
  800df7:	68 88 29 80 00       	push   $0x802988
  800dfc:	6a 43                	push   $0x43
  800dfe:	68 a5 29 80 00       	push   $0x8029a5
  800e03:	e8 84 13 00 00       	call   80218c <_panic>

00800e08 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e08:	55                   	push   %ebp
  800e09:	89 e5                	mov    %esp,%ebp
  800e0b:	57                   	push   %edi
  800e0c:	56                   	push   %esi
  800e0d:	53                   	push   %ebx
  800e0e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e16:	8b 55 08             	mov    0x8(%ebp),%edx
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	b8 08 00 00 00       	mov    $0x8,%eax
  800e21:	89 df                	mov    %ebx,%edi
  800e23:	89 de                	mov    %ebx,%esi
  800e25:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e27:	85 c0                	test   %eax,%eax
  800e29:	7f 08                	jg     800e33 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e2e:	5b                   	pop    %ebx
  800e2f:	5e                   	pop    %esi
  800e30:	5f                   	pop    %edi
  800e31:	5d                   	pop    %ebp
  800e32:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	50                   	push   %eax
  800e37:	6a 08                	push   $0x8
  800e39:	68 88 29 80 00       	push   $0x802988
  800e3e:	6a 43                	push   $0x43
  800e40:	68 a5 29 80 00       	push   $0x8029a5
  800e45:	e8 42 13 00 00       	call   80218c <_panic>

00800e4a <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	57                   	push   %edi
  800e4e:	56                   	push   %esi
  800e4f:	53                   	push   %ebx
  800e50:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e53:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e58:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e5e:	b8 09 00 00 00       	mov    $0x9,%eax
  800e63:	89 df                	mov    %ebx,%edi
  800e65:	89 de                	mov    %ebx,%esi
  800e67:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e69:	85 c0                	test   %eax,%eax
  800e6b:	7f 08                	jg     800e75 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e75:	83 ec 0c             	sub    $0xc,%esp
  800e78:	50                   	push   %eax
  800e79:	6a 09                	push   $0x9
  800e7b:	68 88 29 80 00       	push   $0x802988
  800e80:	6a 43                	push   $0x43
  800e82:	68 a5 29 80 00       	push   $0x8029a5
  800e87:	e8 00 13 00 00       	call   80218c <_panic>

00800e8c <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e8c:	55                   	push   %ebp
  800e8d:	89 e5                	mov    %esp,%ebp
  800e8f:	57                   	push   %edi
  800e90:	56                   	push   %esi
  800e91:	53                   	push   %ebx
  800e92:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ea5:	89 df                	mov    %ebx,%edi
  800ea7:	89 de                	mov    %ebx,%esi
  800ea9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eab:	85 c0                	test   %eax,%eax
  800ead:	7f 08                	jg     800eb7 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800eaf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800eb2:	5b                   	pop    %ebx
  800eb3:	5e                   	pop    %esi
  800eb4:	5f                   	pop    %edi
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	83 ec 0c             	sub    $0xc,%esp
  800eba:	50                   	push   %eax
  800ebb:	6a 0a                	push   $0xa
  800ebd:	68 88 29 80 00       	push   $0x802988
  800ec2:	6a 43                	push   $0x43
  800ec4:	68 a5 29 80 00       	push   $0x8029a5
  800ec9:	e8 be 12 00 00       	call   80218c <_panic>

00800ece <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
  800ed1:	57                   	push   %edi
  800ed2:	56                   	push   %esi
  800ed3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	b8 0c 00 00 00       	mov    $0xc,%eax
  800edf:	be 00 00 00 00       	mov    $0x0,%esi
  800ee4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ee7:	8b 7d 14             	mov    0x14(%ebp),%edi
  800eea:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800eec:	5b                   	pop    %ebx
  800eed:	5e                   	pop    %esi
  800eee:	5f                   	pop    %edi
  800eef:	5d                   	pop    %ebp
  800ef0:	c3                   	ret    

00800ef1 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	57                   	push   %edi
  800ef5:	56                   	push   %esi
  800ef6:	53                   	push   %ebx
  800ef7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eff:	8b 55 08             	mov    0x8(%ebp),%edx
  800f02:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f07:	89 cb                	mov    %ecx,%ebx
  800f09:	89 cf                	mov    %ecx,%edi
  800f0b:	89 ce                	mov    %ecx,%esi
  800f0d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7f 08                	jg     800f1b <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	50                   	push   %eax
  800f1f:	6a 0d                	push   $0xd
  800f21:	68 88 29 80 00       	push   $0x802988
  800f26:	6a 43                	push   $0x43
  800f28:	68 a5 29 80 00       	push   $0x8029a5
  800f2d:	e8 5a 12 00 00       	call   80218c <_panic>

00800f32 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	57                   	push   %edi
  800f36:	56                   	push   %esi
  800f37:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f40:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f43:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f48:	89 df                	mov    %ebx,%edi
  800f4a:	89 de                	mov    %ebx,%esi
  800f4c:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f4e:	5b                   	pop    %ebx
  800f4f:	5e                   	pop    %esi
  800f50:	5f                   	pop    %edi
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f59:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f61:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f66:	89 cb                	mov    %ecx,%ebx
  800f68:	89 cf                	mov    %ecx,%edi
  800f6a:	89 ce                	mov    %ecx,%esi
  800f6c:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f6e:	5b                   	pop    %ebx
  800f6f:	5e                   	pop    %esi
  800f70:	5f                   	pop    %edi
  800f71:	5d                   	pop    %ebp
  800f72:	c3                   	ret    

00800f73 <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f79:	ba 00 00 00 00       	mov    $0x0,%edx
  800f7e:	b8 10 00 00 00       	mov    $0x10,%eax
  800f83:	89 d1                	mov    %edx,%ecx
  800f85:	89 d3                	mov    %edx,%ebx
  800f87:	89 d7                	mov    %edx,%edi
  800f89:	89 d6                	mov    %edx,%esi
  800f8b:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa3:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa8:	89 df                	mov    %ebx,%edi
  800faa:	89 de                	mov    %ebx,%esi
  800fac:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fae:	5b                   	pop    %ebx
  800faf:	5e                   	pop    %esi
  800fb0:	5f                   	pop    %edi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    

00800fb3 <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800fb3:	55                   	push   %ebp
  800fb4:	89 e5                	mov    %esp,%ebp
  800fb6:	57                   	push   %edi
  800fb7:	56                   	push   %esi
  800fb8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800fc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc4:	b8 12 00 00 00       	mov    $0x12,%eax
  800fc9:	89 df                	mov    %ebx,%edi
  800fcb:	89 de                	mov    %ebx,%esi
  800fcd:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800fcf:	5b                   	pop    %ebx
  800fd0:	5e                   	pop    %esi
  800fd1:	5f                   	pop    %edi
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    

00800fd4 <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	57                   	push   %edi
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	b8 13 00 00 00       	mov    $0x13,%eax
  800fed:	89 df                	mov    %ebx,%edi
  800fef:	89 de                	mov    %ebx,%esi
  800ff1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	7f 08                	jg     800fff <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffa:	5b                   	pop    %ebx
  800ffb:	5e                   	pop    %esi
  800ffc:	5f                   	pop    %edi
  800ffd:	5d                   	pop    %ebp
  800ffe:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fff:	83 ec 0c             	sub    $0xc,%esp
  801002:	50                   	push   %eax
  801003:	6a 13                	push   $0x13
  801005:	68 88 29 80 00       	push   $0x802988
  80100a:	6a 43                	push   $0x43
  80100c:	68 a5 29 80 00       	push   $0x8029a5
  801011:	e8 76 11 00 00       	call   80218c <_panic>

00801016 <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	57                   	push   %edi
  80101a:	56                   	push   %esi
  80101b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80101c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801021:	8b 55 08             	mov    0x8(%ebp),%edx
  801024:	b8 14 00 00 00       	mov    $0x14,%eax
  801029:	89 cb                	mov    %ecx,%ebx
  80102b:	89 cf                	mov    %ecx,%edi
  80102d:	89 ce                	mov    %ecx,%esi
  80102f:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  801031:	5b                   	pop    %ebx
  801032:	5e                   	pop    %esi
  801033:	5f                   	pop    %edi
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	05 00 00 00 30       	add    $0x30000000,%eax
  801041:	c1 e8 0c             	shr    $0xc,%eax
}
  801044:	5d                   	pop    %ebp
  801045:	c3                   	ret    

00801046 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801046:	55                   	push   %ebp
  801047:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801051:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801056:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801065:	89 c2                	mov    %eax,%edx
  801067:	c1 ea 16             	shr    $0x16,%edx
  80106a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801071:	f6 c2 01             	test   $0x1,%dl
  801074:	74 2d                	je     8010a3 <fd_alloc+0x46>
  801076:	89 c2                	mov    %eax,%edx
  801078:	c1 ea 0c             	shr    $0xc,%edx
  80107b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801082:	f6 c2 01             	test   $0x1,%dl
  801085:	74 1c                	je     8010a3 <fd_alloc+0x46>
  801087:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80108c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801091:	75 d2                	jne    801065 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801093:	8b 45 08             	mov    0x8(%ebp),%eax
  801096:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80109c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010a1:	eb 0a                	jmp    8010ad <fd_alloc+0x50>
			*fd_store = fd;
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010b5:	83 f8 1f             	cmp    $0x1f,%eax
  8010b8:	77 30                	ja     8010ea <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010ba:	c1 e0 0c             	shl    $0xc,%eax
  8010bd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010c2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010c8:	f6 c2 01             	test   $0x1,%dl
  8010cb:	74 24                	je     8010f1 <fd_lookup+0x42>
  8010cd:	89 c2                	mov    %eax,%edx
  8010cf:	c1 ea 0c             	shr    $0xc,%edx
  8010d2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010d9:	f6 c2 01             	test   $0x1,%dl
  8010dc:	74 1a                	je     8010f8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010e1:	89 02                	mov    %eax,(%edx)
	return 0;
  8010e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e8:	5d                   	pop    %ebp
  8010e9:	c3                   	ret    
		return -E_INVAL;
  8010ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ef:	eb f7                	jmp    8010e8 <fd_lookup+0x39>
		return -E_INVAL;
  8010f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010f6:	eb f0                	jmp    8010e8 <fd_lookup+0x39>
  8010f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fd:	eb e9                	jmp    8010e8 <fd_lookup+0x39>

008010ff <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010ff:	55                   	push   %ebp
  801100:	89 e5                	mov    %esp,%ebp
  801102:	83 ec 08             	sub    $0x8,%esp
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801108:	ba 00 00 00 00       	mov    $0x0,%edx
  80110d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801112:	39 08                	cmp    %ecx,(%eax)
  801114:	74 38                	je     80114e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801116:	83 c2 01             	add    $0x1,%edx
  801119:	8b 04 95 30 2a 80 00 	mov    0x802a30(,%edx,4),%eax
  801120:	85 c0                	test   %eax,%eax
  801122:	75 ee                	jne    801112 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801124:	a1 08 40 80 00       	mov    0x804008,%eax
  801129:	8b 40 48             	mov    0x48(%eax),%eax
  80112c:	83 ec 04             	sub    $0x4,%esp
  80112f:	51                   	push   %ecx
  801130:	50                   	push   %eax
  801131:	68 b4 29 80 00       	push   $0x8029b4
  801136:	e8 b5 f0 ff ff       	call   8001f0 <cprintf>
	*dev = 0;
  80113b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801144:	83 c4 10             	add    $0x10,%esp
  801147:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    
			*dev = devtab[i];
  80114e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801151:	89 01                	mov    %eax,(%ecx)
			return 0;
  801153:	b8 00 00 00 00       	mov    $0x0,%eax
  801158:	eb f2                	jmp    80114c <dev_lookup+0x4d>

0080115a <fd_close>:
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	57                   	push   %edi
  80115e:	56                   	push   %esi
  80115f:	53                   	push   %ebx
  801160:	83 ec 24             	sub    $0x24,%esp
  801163:	8b 75 08             	mov    0x8(%ebp),%esi
  801166:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801169:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80116c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80116d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801173:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801176:	50                   	push   %eax
  801177:	e8 33 ff ff ff       	call   8010af <fd_lookup>
  80117c:	89 c3                	mov    %eax,%ebx
  80117e:	83 c4 10             	add    $0x10,%esp
  801181:	85 c0                	test   %eax,%eax
  801183:	78 05                	js     80118a <fd_close+0x30>
	    || fd != fd2)
  801185:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801188:	74 16                	je     8011a0 <fd_close+0x46>
		return (must_exist ? r : 0);
  80118a:	89 f8                	mov    %edi,%eax
  80118c:	84 c0                	test   %al,%al
  80118e:	b8 00 00 00 00       	mov    $0x0,%eax
  801193:	0f 44 d8             	cmove  %eax,%ebx
}
  801196:	89 d8                	mov    %ebx,%eax
  801198:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80119b:	5b                   	pop    %ebx
  80119c:	5e                   	pop    %esi
  80119d:	5f                   	pop    %edi
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011a0:	83 ec 08             	sub    $0x8,%esp
  8011a3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	ff 36                	pushl  (%esi)
  8011a9:	e8 51 ff ff ff       	call   8010ff <dev_lookup>
  8011ae:	89 c3                	mov    %eax,%ebx
  8011b0:	83 c4 10             	add    $0x10,%esp
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	78 1a                	js     8011d1 <fd_close+0x77>
		if (dev->dev_close)
  8011b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011ba:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011bd:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011c2:	85 c0                	test   %eax,%eax
  8011c4:	74 0b                	je     8011d1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011c6:	83 ec 0c             	sub    $0xc,%esp
  8011c9:	56                   	push   %esi
  8011ca:	ff d0                	call   *%eax
  8011cc:	89 c3                	mov    %eax,%ebx
  8011ce:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011d1:	83 ec 08             	sub    $0x8,%esp
  8011d4:	56                   	push   %esi
  8011d5:	6a 00                	push   $0x0
  8011d7:	e8 ea fb ff ff       	call   800dc6 <sys_page_unmap>
	return r;
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	eb b5                	jmp    801196 <fd_close+0x3c>

008011e1 <close>:

int
close(int fdnum)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ea:	50                   	push   %eax
  8011eb:	ff 75 08             	pushl  0x8(%ebp)
  8011ee:	e8 bc fe ff ff       	call   8010af <fd_lookup>
  8011f3:	83 c4 10             	add    $0x10,%esp
  8011f6:	85 c0                	test   %eax,%eax
  8011f8:	79 02                	jns    8011fc <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    
		return fd_close(fd, 1);
  8011fc:	83 ec 08             	sub    $0x8,%esp
  8011ff:	6a 01                	push   $0x1
  801201:	ff 75 f4             	pushl  -0xc(%ebp)
  801204:	e8 51 ff ff ff       	call   80115a <fd_close>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	eb ec                	jmp    8011fa <close+0x19>

0080120e <close_all>:

void
close_all(void)
{
  80120e:	55                   	push   %ebp
  80120f:	89 e5                	mov    %esp,%ebp
  801211:	53                   	push   %ebx
  801212:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801215:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80121a:	83 ec 0c             	sub    $0xc,%esp
  80121d:	53                   	push   %ebx
  80121e:	e8 be ff ff ff       	call   8011e1 <close>
	for (i = 0; i < MAXFD; i++)
  801223:	83 c3 01             	add    $0x1,%ebx
  801226:	83 c4 10             	add    $0x10,%esp
  801229:	83 fb 20             	cmp    $0x20,%ebx
  80122c:	75 ec                	jne    80121a <close_all+0xc>
}
  80122e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801231:	c9                   	leave  
  801232:	c3                   	ret    

00801233 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801233:	55                   	push   %ebp
  801234:	89 e5                	mov    %esp,%ebp
  801236:	57                   	push   %edi
  801237:	56                   	push   %esi
  801238:	53                   	push   %ebx
  801239:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80123c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80123f:	50                   	push   %eax
  801240:	ff 75 08             	pushl  0x8(%ebp)
  801243:	e8 67 fe ff ff       	call   8010af <fd_lookup>
  801248:	89 c3                	mov    %eax,%ebx
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	0f 88 81 00 00 00    	js     8012d6 <dup+0xa3>
		return r;
	close(newfdnum);
  801255:	83 ec 0c             	sub    $0xc,%esp
  801258:	ff 75 0c             	pushl  0xc(%ebp)
  80125b:	e8 81 ff ff ff       	call   8011e1 <close>

	newfd = INDEX2FD(newfdnum);
  801260:	8b 75 0c             	mov    0xc(%ebp),%esi
  801263:	c1 e6 0c             	shl    $0xc,%esi
  801266:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80126c:	83 c4 04             	add    $0x4,%esp
  80126f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801272:	e8 cf fd ff ff       	call   801046 <fd2data>
  801277:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801279:	89 34 24             	mov    %esi,(%esp)
  80127c:	e8 c5 fd ff ff       	call   801046 <fd2data>
  801281:	83 c4 10             	add    $0x10,%esp
  801284:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801286:	89 d8                	mov    %ebx,%eax
  801288:	c1 e8 16             	shr    $0x16,%eax
  80128b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801292:	a8 01                	test   $0x1,%al
  801294:	74 11                	je     8012a7 <dup+0x74>
  801296:	89 d8                	mov    %ebx,%eax
  801298:	c1 e8 0c             	shr    $0xc,%eax
  80129b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012a2:	f6 c2 01             	test   $0x1,%dl
  8012a5:	75 39                	jne    8012e0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012aa:	89 d0                	mov    %edx,%eax
  8012ac:	c1 e8 0c             	shr    $0xc,%eax
  8012af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012b6:	83 ec 0c             	sub    $0xc,%esp
  8012b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8012be:	50                   	push   %eax
  8012bf:	56                   	push   %esi
  8012c0:	6a 00                	push   $0x0
  8012c2:	52                   	push   %edx
  8012c3:	6a 00                	push   $0x0
  8012c5:	e8 ba fa ff ff       	call   800d84 <sys_page_map>
  8012ca:	89 c3                	mov    %eax,%ebx
  8012cc:	83 c4 20             	add    $0x20,%esp
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	78 31                	js     801304 <dup+0xd1>
		goto err;

	return newfdnum;
  8012d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012d6:	89 d8                	mov    %ebx,%eax
  8012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012db:	5b                   	pop    %ebx
  8012dc:	5e                   	pop    %esi
  8012dd:	5f                   	pop    %edi
  8012de:	5d                   	pop    %ebp
  8012df:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e7:	83 ec 0c             	sub    $0xc,%esp
  8012ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ef:	50                   	push   %eax
  8012f0:	57                   	push   %edi
  8012f1:	6a 00                	push   $0x0
  8012f3:	53                   	push   %ebx
  8012f4:	6a 00                	push   $0x0
  8012f6:	e8 89 fa ff ff       	call   800d84 <sys_page_map>
  8012fb:	89 c3                	mov    %eax,%ebx
  8012fd:	83 c4 20             	add    $0x20,%esp
  801300:	85 c0                	test   %eax,%eax
  801302:	79 a3                	jns    8012a7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801304:	83 ec 08             	sub    $0x8,%esp
  801307:	56                   	push   %esi
  801308:	6a 00                	push   $0x0
  80130a:	e8 b7 fa ff ff       	call   800dc6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80130f:	83 c4 08             	add    $0x8,%esp
  801312:	57                   	push   %edi
  801313:	6a 00                	push   $0x0
  801315:	e8 ac fa ff ff       	call   800dc6 <sys_page_unmap>
	return r;
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	eb b7                	jmp    8012d6 <dup+0xa3>

0080131f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80131f:	55                   	push   %ebp
  801320:	89 e5                	mov    %esp,%ebp
  801322:	53                   	push   %ebx
  801323:	83 ec 1c             	sub    $0x1c,%esp
  801326:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801329:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132c:	50                   	push   %eax
  80132d:	53                   	push   %ebx
  80132e:	e8 7c fd ff ff       	call   8010af <fd_lookup>
  801333:	83 c4 10             	add    $0x10,%esp
  801336:	85 c0                	test   %eax,%eax
  801338:	78 3f                	js     801379 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80133a:	83 ec 08             	sub    $0x8,%esp
  80133d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	ff 30                	pushl  (%eax)
  801346:	e8 b4 fd ff ff       	call   8010ff <dev_lookup>
  80134b:	83 c4 10             	add    $0x10,%esp
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 27                	js     801379 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801352:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801355:	8b 42 08             	mov    0x8(%edx),%eax
  801358:	83 e0 03             	and    $0x3,%eax
  80135b:	83 f8 01             	cmp    $0x1,%eax
  80135e:	74 1e                	je     80137e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8b 40 08             	mov    0x8(%eax),%eax
  801366:	85 c0                	test   %eax,%eax
  801368:	74 35                	je     80139f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80136a:	83 ec 04             	sub    $0x4,%esp
  80136d:	ff 75 10             	pushl  0x10(%ebp)
  801370:	ff 75 0c             	pushl  0xc(%ebp)
  801373:	52                   	push   %edx
  801374:	ff d0                	call   *%eax
  801376:	83 c4 10             	add    $0x10,%esp
}
  801379:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80137c:	c9                   	leave  
  80137d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80137e:	a1 08 40 80 00       	mov    0x804008,%eax
  801383:	8b 40 48             	mov    0x48(%eax),%eax
  801386:	83 ec 04             	sub    $0x4,%esp
  801389:	53                   	push   %ebx
  80138a:	50                   	push   %eax
  80138b:	68 f5 29 80 00       	push   $0x8029f5
  801390:	e8 5b ee ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801395:	83 c4 10             	add    $0x10,%esp
  801398:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80139d:	eb da                	jmp    801379 <read+0x5a>
		return -E_NOT_SUPP;
  80139f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a4:	eb d3                	jmp    801379 <read+0x5a>

008013a6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
  8013a9:	57                   	push   %edi
  8013aa:	56                   	push   %esi
  8013ab:	53                   	push   %ebx
  8013ac:	83 ec 0c             	sub    $0xc,%esp
  8013af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013b2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013ba:	39 f3                	cmp    %esi,%ebx
  8013bc:	73 23                	jae    8013e1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	89 f0                	mov    %esi,%eax
  8013c3:	29 d8                	sub    %ebx,%eax
  8013c5:	50                   	push   %eax
  8013c6:	89 d8                	mov    %ebx,%eax
  8013c8:	03 45 0c             	add    0xc(%ebp),%eax
  8013cb:	50                   	push   %eax
  8013cc:	57                   	push   %edi
  8013cd:	e8 4d ff ff ff       	call   80131f <read>
		if (m < 0)
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	85 c0                	test   %eax,%eax
  8013d7:	78 06                	js     8013df <readn+0x39>
			return m;
		if (m == 0)
  8013d9:	74 06                	je     8013e1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013db:	01 c3                	add    %eax,%ebx
  8013dd:	eb db                	jmp    8013ba <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013df:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013e1:	89 d8                	mov    %ebx,%eax
  8013e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013e6:	5b                   	pop    %ebx
  8013e7:	5e                   	pop    %esi
  8013e8:	5f                   	pop    %edi
  8013e9:	5d                   	pop    %ebp
  8013ea:	c3                   	ret    

008013eb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013eb:	55                   	push   %ebp
  8013ec:	89 e5                	mov    %esp,%ebp
  8013ee:	53                   	push   %ebx
  8013ef:	83 ec 1c             	sub    $0x1c,%esp
  8013f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f8:	50                   	push   %eax
  8013f9:	53                   	push   %ebx
  8013fa:	e8 b0 fc ff ff       	call   8010af <fd_lookup>
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	85 c0                	test   %eax,%eax
  801404:	78 3a                	js     801440 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801406:	83 ec 08             	sub    $0x8,%esp
  801409:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80140c:	50                   	push   %eax
  80140d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801410:	ff 30                	pushl  (%eax)
  801412:	e8 e8 fc ff ff       	call   8010ff <dev_lookup>
  801417:	83 c4 10             	add    $0x10,%esp
  80141a:	85 c0                	test   %eax,%eax
  80141c:	78 22                	js     801440 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80141e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801421:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801425:	74 1e                	je     801445 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801427:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80142a:	8b 52 0c             	mov    0xc(%edx),%edx
  80142d:	85 d2                	test   %edx,%edx
  80142f:	74 35                	je     801466 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	ff 75 10             	pushl  0x10(%ebp)
  801437:	ff 75 0c             	pushl  0xc(%ebp)
  80143a:	50                   	push   %eax
  80143b:	ff d2                	call   *%edx
  80143d:	83 c4 10             	add    $0x10,%esp
}
  801440:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801443:	c9                   	leave  
  801444:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801445:	a1 08 40 80 00       	mov    0x804008,%eax
  80144a:	8b 40 48             	mov    0x48(%eax),%eax
  80144d:	83 ec 04             	sub    $0x4,%esp
  801450:	53                   	push   %ebx
  801451:	50                   	push   %eax
  801452:	68 11 2a 80 00       	push   $0x802a11
  801457:	e8 94 ed ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  80145c:	83 c4 10             	add    $0x10,%esp
  80145f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801464:	eb da                	jmp    801440 <write+0x55>
		return -E_NOT_SUPP;
  801466:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146b:	eb d3                	jmp    801440 <write+0x55>

0080146d <seek>:

int
seek(int fdnum, off_t offset)
{
  80146d:	55                   	push   %ebp
  80146e:	89 e5                	mov    %esp,%ebp
  801470:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801473:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801476:	50                   	push   %eax
  801477:	ff 75 08             	pushl  0x8(%ebp)
  80147a:	e8 30 fc ff ff       	call   8010af <fd_lookup>
  80147f:	83 c4 10             	add    $0x10,%esp
  801482:	85 c0                	test   %eax,%eax
  801484:	78 0e                	js     801494 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801486:	8b 55 0c             	mov    0xc(%ebp),%edx
  801489:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80148c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80148f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	53                   	push   %ebx
  80149a:	83 ec 1c             	sub    $0x1c,%esp
  80149d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a3:	50                   	push   %eax
  8014a4:	53                   	push   %ebx
  8014a5:	e8 05 fc ff ff       	call   8010af <fd_lookup>
  8014aa:	83 c4 10             	add    $0x10,%esp
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	78 37                	js     8014e8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b1:	83 ec 08             	sub    $0x8,%esp
  8014b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014b7:	50                   	push   %eax
  8014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bb:	ff 30                	pushl  (%eax)
  8014bd:	e8 3d fc ff ff       	call   8010ff <dev_lookup>
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 c0                	test   %eax,%eax
  8014c7:	78 1f                	js     8014e8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014d0:	74 1b                	je     8014ed <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014d5:	8b 52 18             	mov    0x18(%edx),%edx
  8014d8:	85 d2                	test   %edx,%edx
  8014da:	74 32                	je     80150e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014dc:	83 ec 08             	sub    $0x8,%esp
  8014df:	ff 75 0c             	pushl  0xc(%ebp)
  8014e2:	50                   	push   %eax
  8014e3:	ff d2                	call   *%edx
  8014e5:	83 c4 10             	add    $0x10,%esp
}
  8014e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014eb:	c9                   	leave  
  8014ec:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014ed:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014f2:	8b 40 48             	mov    0x48(%eax),%eax
  8014f5:	83 ec 04             	sub    $0x4,%esp
  8014f8:	53                   	push   %ebx
  8014f9:	50                   	push   %eax
  8014fa:	68 d4 29 80 00       	push   $0x8029d4
  8014ff:	e8 ec ec ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801504:	83 c4 10             	add    $0x10,%esp
  801507:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80150c:	eb da                	jmp    8014e8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80150e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801513:	eb d3                	jmp    8014e8 <ftruncate+0x52>

00801515 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	53                   	push   %ebx
  801519:	83 ec 1c             	sub    $0x1c,%esp
  80151c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801522:	50                   	push   %eax
  801523:	ff 75 08             	pushl  0x8(%ebp)
  801526:	e8 84 fb ff ff       	call   8010af <fd_lookup>
  80152b:	83 c4 10             	add    $0x10,%esp
  80152e:	85 c0                	test   %eax,%eax
  801530:	78 4b                	js     80157d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801532:	83 ec 08             	sub    $0x8,%esp
  801535:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801538:	50                   	push   %eax
  801539:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153c:	ff 30                	pushl  (%eax)
  80153e:	e8 bc fb ff ff       	call   8010ff <dev_lookup>
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	78 33                	js     80157d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801551:	74 2f                	je     801582 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801553:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801556:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80155d:	00 00 00 
	stat->st_isdir = 0;
  801560:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801567:	00 00 00 
	stat->st_dev = dev;
  80156a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801570:	83 ec 08             	sub    $0x8,%esp
  801573:	53                   	push   %ebx
  801574:	ff 75 f0             	pushl  -0x10(%ebp)
  801577:	ff 50 14             	call   *0x14(%eax)
  80157a:	83 c4 10             	add    $0x10,%esp
}
  80157d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801580:	c9                   	leave  
  801581:	c3                   	ret    
		return -E_NOT_SUPP;
  801582:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801587:	eb f4                	jmp    80157d <fstat+0x68>

00801589 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801589:	55                   	push   %ebp
  80158a:	89 e5                	mov    %esp,%ebp
  80158c:	56                   	push   %esi
  80158d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80158e:	83 ec 08             	sub    $0x8,%esp
  801591:	6a 00                	push   $0x0
  801593:	ff 75 08             	pushl  0x8(%ebp)
  801596:	e8 22 02 00 00       	call   8017bd <open>
  80159b:	89 c3                	mov    %eax,%ebx
  80159d:	83 c4 10             	add    $0x10,%esp
  8015a0:	85 c0                	test   %eax,%eax
  8015a2:	78 1b                	js     8015bf <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015a4:	83 ec 08             	sub    $0x8,%esp
  8015a7:	ff 75 0c             	pushl  0xc(%ebp)
  8015aa:	50                   	push   %eax
  8015ab:	e8 65 ff ff ff       	call   801515 <fstat>
  8015b0:	89 c6                	mov    %eax,%esi
	close(fd);
  8015b2:	89 1c 24             	mov    %ebx,(%esp)
  8015b5:	e8 27 fc ff ff       	call   8011e1 <close>
	return r;
  8015ba:	83 c4 10             	add    $0x10,%esp
  8015bd:	89 f3                	mov    %esi,%ebx
}
  8015bf:	89 d8                	mov    %ebx,%eax
  8015c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c4:	5b                   	pop    %ebx
  8015c5:	5e                   	pop    %esi
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    

008015c8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015c8:	55                   	push   %ebp
  8015c9:	89 e5                	mov    %esp,%ebp
  8015cb:	56                   	push   %esi
  8015cc:	53                   	push   %ebx
  8015cd:	89 c6                	mov    %eax,%esi
  8015cf:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015d1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015d8:	74 27                	je     801601 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015da:	6a 07                	push   $0x7
  8015dc:	68 00 50 80 00       	push   $0x805000
  8015e1:	56                   	push   %esi
  8015e2:	ff 35 00 40 80 00    	pushl  0x804000
  8015e8:	e8 69 0c 00 00       	call   802256 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015ed:	83 c4 0c             	add    $0xc,%esp
  8015f0:	6a 00                	push   $0x0
  8015f2:	53                   	push   %ebx
  8015f3:	6a 00                	push   $0x0
  8015f5:	e8 f3 0b 00 00       	call   8021ed <ipc_recv>
}
  8015fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015fd:	5b                   	pop    %ebx
  8015fe:	5e                   	pop    %esi
  8015ff:	5d                   	pop    %ebp
  801600:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801601:	83 ec 0c             	sub    $0xc,%esp
  801604:	6a 01                	push   $0x1
  801606:	e8 a3 0c 00 00       	call   8022ae <ipc_find_env>
  80160b:	a3 00 40 80 00       	mov    %eax,0x804000
  801610:	83 c4 10             	add    $0x10,%esp
  801613:	eb c5                	jmp    8015da <fsipc+0x12>

00801615 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801615:	55                   	push   %ebp
  801616:	89 e5                	mov    %esp,%ebp
  801618:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80161b:	8b 45 08             	mov    0x8(%ebp),%eax
  80161e:	8b 40 0c             	mov    0xc(%eax),%eax
  801621:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801626:	8b 45 0c             	mov    0xc(%ebp),%eax
  801629:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80162e:	ba 00 00 00 00       	mov    $0x0,%edx
  801633:	b8 02 00 00 00       	mov    $0x2,%eax
  801638:	e8 8b ff ff ff       	call   8015c8 <fsipc>
}
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <devfile_flush>:
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801645:	8b 45 08             	mov    0x8(%ebp),%eax
  801648:	8b 40 0c             	mov    0xc(%eax),%eax
  80164b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801650:	ba 00 00 00 00       	mov    $0x0,%edx
  801655:	b8 06 00 00 00       	mov    $0x6,%eax
  80165a:	e8 69 ff ff ff       	call   8015c8 <fsipc>
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <devfile_stat>:
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
  801664:	53                   	push   %ebx
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8b 40 0c             	mov    0xc(%eax),%eax
  801671:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801676:	ba 00 00 00 00       	mov    $0x0,%edx
  80167b:	b8 05 00 00 00       	mov    $0x5,%eax
  801680:	e8 43 ff ff ff       	call   8015c8 <fsipc>
  801685:	85 c0                	test   %eax,%eax
  801687:	78 2c                	js     8016b5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	68 00 50 80 00       	push   $0x805000
  801691:	53                   	push   %ebx
  801692:	e8 b8 f2 ff ff       	call   80094f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801697:	a1 80 50 80 00       	mov    0x805080,%eax
  80169c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016a2:	a1 84 50 80 00       	mov    0x805084,%eax
  8016a7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016b8:	c9                   	leave  
  8016b9:	c3                   	ret    

008016ba <devfile_write>:
{
  8016ba:	55                   	push   %ebp
  8016bb:	89 e5                	mov    %esp,%ebp
  8016bd:	53                   	push   %ebx
  8016be:	83 ec 08             	sub    $0x8,%esp
  8016c1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016ca:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016cf:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016d5:	53                   	push   %ebx
  8016d6:	ff 75 0c             	pushl  0xc(%ebp)
  8016d9:	68 08 50 80 00       	push   $0x805008
  8016de:	e8 5c f4 ff ff       	call   800b3f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e8:	b8 04 00 00 00       	mov    $0x4,%eax
  8016ed:	e8 d6 fe ff ff       	call   8015c8 <fsipc>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	78 0b                	js     801704 <devfile_write+0x4a>
	assert(r <= n);
  8016f9:	39 d8                	cmp    %ebx,%eax
  8016fb:	77 0c                	ja     801709 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016fd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801702:	7f 1e                	jg     801722 <devfile_write+0x68>
}
  801704:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801707:	c9                   	leave  
  801708:	c3                   	ret    
	assert(r <= n);
  801709:	68 44 2a 80 00       	push   $0x802a44
  80170e:	68 4b 2a 80 00       	push   $0x802a4b
  801713:	68 98 00 00 00       	push   $0x98
  801718:	68 60 2a 80 00       	push   $0x802a60
  80171d:	e8 6a 0a 00 00       	call   80218c <_panic>
	assert(r <= PGSIZE);
  801722:	68 6b 2a 80 00       	push   $0x802a6b
  801727:	68 4b 2a 80 00       	push   $0x802a4b
  80172c:	68 99 00 00 00       	push   $0x99
  801731:	68 60 2a 80 00       	push   $0x802a60
  801736:	e8 51 0a 00 00       	call   80218c <_panic>

0080173b <devfile_read>:
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	56                   	push   %esi
  80173f:	53                   	push   %ebx
  801740:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	8b 40 0c             	mov    0xc(%eax),%eax
  801749:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80174e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801754:	ba 00 00 00 00       	mov    $0x0,%edx
  801759:	b8 03 00 00 00       	mov    $0x3,%eax
  80175e:	e8 65 fe ff ff       	call   8015c8 <fsipc>
  801763:	89 c3                	mov    %eax,%ebx
  801765:	85 c0                	test   %eax,%eax
  801767:	78 1f                	js     801788 <devfile_read+0x4d>
	assert(r <= n);
  801769:	39 f0                	cmp    %esi,%eax
  80176b:	77 24                	ja     801791 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80176d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801772:	7f 33                	jg     8017a7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801774:	83 ec 04             	sub    $0x4,%esp
  801777:	50                   	push   %eax
  801778:	68 00 50 80 00       	push   $0x805000
  80177d:	ff 75 0c             	pushl  0xc(%ebp)
  801780:	e8 58 f3 ff ff       	call   800add <memmove>
	return r;
  801785:	83 c4 10             	add    $0x10,%esp
}
  801788:	89 d8                	mov    %ebx,%eax
  80178a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80178d:	5b                   	pop    %ebx
  80178e:	5e                   	pop    %esi
  80178f:	5d                   	pop    %ebp
  801790:	c3                   	ret    
	assert(r <= n);
  801791:	68 44 2a 80 00       	push   $0x802a44
  801796:	68 4b 2a 80 00       	push   $0x802a4b
  80179b:	6a 7c                	push   $0x7c
  80179d:	68 60 2a 80 00       	push   $0x802a60
  8017a2:	e8 e5 09 00 00       	call   80218c <_panic>
	assert(r <= PGSIZE);
  8017a7:	68 6b 2a 80 00       	push   $0x802a6b
  8017ac:	68 4b 2a 80 00       	push   $0x802a4b
  8017b1:	6a 7d                	push   $0x7d
  8017b3:	68 60 2a 80 00       	push   $0x802a60
  8017b8:	e8 cf 09 00 00       	call   80218c <_panic>

008017bd <open>:
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 1c             	sub    $0x1c,%esp
  8017c5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017c8:	56                   	push   %esi
  8017c9:	e8 48 f1 ff ff       	call   800916 <strlen>
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017d6:	7f 6c                	jg     801844 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017d8:	83 ec 0c             	sub    $0xc,%esp
  8017db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017de:	50                   	push   %eax
  8017df:	e8 79 f8 ff ff       	call   80105d <fd_alloc>
  8017e4:	89 c3                	mov    %eax,%ebx
  8017e6:	83 c4 10             	add    $0x10,%esp
  8017e9:	85 c0                	test   %eax,%eax
  8017eb:	78 3c                	js     801829 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017ed:	83 ec 08             	sub    $0x8,%esp
  8017f0:	56                   	push   %esi
  8017f1:	68 00 50 80 00       	push   $0x805000
  8017f6:	e8 54 f1 ff ff       	call   80094f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017fe:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801803:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801806:	b8 01 00 00 00       	mov    $0x1,%eax
  80180b:	e8 b8 fd ff ff       	call   8015c8 <fsipc>
  801810:	89 c3                	mov    %eax,%ebx
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	85 c0                	test   %eax,%eax
  801817:	78 19                	js     801832 <open+0x75>
	return fd2num(fd);
  801819:	83 ec 0c             	sub    $0xc,%esp
  80181c:	ff 75 f4             	pushl  -0xc(%ebp)
  80181f:	e8 12 f8 ff ff       	call   801036 <fd2num>
  801824:	89 c3                	mov    %eax,%ebx
  801826:	83 c4 10             	add    $0x10,%esp
}
  801829:	89 d8                	mov    %ebx,%eax
  80182b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80182e:	5b                   	pop    %ebx
  80182f:	5e                   	pop    %esi
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    
		fd_close(fd, 0);
  801832:	83 ec 08             	sub    $0x8,%esp
  801835:	6a 00                	push   $0x0
  801837:	ff 75 f4             	pushl  -0xc(%ebp)
  80183a:	e8 1b f9 ff ff       	call   80115a <fd_close>
		return r;
  80183f:	83 c4 10             	add    $0x10,%esp
  801842:	eb e5                	jmp    801829 <open+0x6c>
		return -E_BAD_PATH;
  801844:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801849:	eb de                	jmp    801829 <open+0x6c>

0080184b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
  801856:	b8 08 00 00 00       	mov    $0x8,%eax
  80185b:	e8 68 fd ff ff       	call   8015c8 <fsipc>
}
  801860:	c9                   	leave  
  801861:	c3                   	ret    

00801862 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801868:	68 77 2a 80 00       	push   $0x802a77
  80186d:	ff 75 0c             	pushl  0xc(%ebp)
  801870:	e8 da f0 ff ff       	call   80094f <strcpy>
	return 0;
}
  801875:	b8 00 00 00 00       	mov    $0x0,%eax
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <devsock_close>:
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	53                   	push   %ebx
  801880:	83 ec 10             	sub    $0x10,%esp
  801883:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801886:	53                   	push   %ebx
  801887:	e8 5d 0a 00 00       	call   8022e9 <pageref>
  80188c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80188f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801894:	83 f8 01             	cmp    $0x1,%eax
  801897:	74 07                	je     8018a0 <devsock_close+0x24>
}
  801899:	89 d0                	mov    %edx,%eax
  80189b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80189e:	c9                   	leave  
  80189f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018a0:	83 ec 0c             	sub    $0xc,%esp
  8018a3:	ff 73 0c             	pushl  0xc(%ebx)
  8018a6:	e8 b9 02 00 00       	call   801b64 <nsipc_close>
  8018ab:	89 c2                	mov    %eax,%edx
  8018ad:	83 c4 10             	add    $0x10,%esp
  8018b0:	eb e7                	jmp    801899 <devsock_close+0x1d>

008018b2 <devsock_write>:
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018b8:	6a 00                	push   $0x0
  8018ba:	ff 75 10             	pushl  0x10(%ebp)
  8018bd:	ff 75 0c             	pushl  0xc(%ebp)
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	ff 70 0c             	pushl  0xc(%eax)
  8018c6:	e8 76 03 00 00       	call   801c41 <nsipc_send>
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <devsock_read>:
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
  8018d0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	ff 75 10             	pushl  0x10(%ebp)
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	ff 70 0c             	pushl  0xc(%eax)
  8018e1:	e8 ef 02 00 00       	call   801bd5 <nsipc_recv>
}
  8018e6:	c9                   	leave  
  8018e7:	c3                   	ret    

008018e8 <fd2sockid>:
{
  8018e8:	55                   	push   %ebp
  8018e9:	89 e5                	mov    %esp,%ebp
  8018eb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ee:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018f1:	52                   	push   %edx
  8018f2:	50                   	push   %eax
  8018f3:	e8 b7 f7 ff ff       	call   8010af <fd_lookup>
  8018f8:	83 c4 10             	add    $0x10,%esp
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	78 10                	js     80190f <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801902:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801908:	39 08                	cmp    %ecx,(%eax)
  80190a:	75 05                	jne    801911 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  80190c:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    
		return -E_NOT_SUPP;
  801911:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801916:	eb f7                	jmp    80190f <fd2sockid+0x27>

00801918 <alloc_sockfd>:
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	56                   	push   %esi
  80191c:	53                   	push   %ebx
  80191d:	83 ec 1c             	sub    $0x1c,%esp
  801920:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801922:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801925:	50                   	push   %eax
  801926:	e8 32 f7 ff ff       	call   80105d <fd_alloc>
  80192b:	89 c3                	mov    %eax,%ebx
  80192d:	83 c4 10             	add    $0x10,%esp
  801930:	85 c0                	test   %eax,%eax
  801932:	78 43                	js     801977 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	68 07 04 00 00       	push   $0x407
  80193c:	ff 75 f4             	pushl  -0xc(%ebp)
  80193f:	6a 00                	push   $0x0
  801941:	e8 fb f3 ff ff       	call   800d41 <sys_page_alloc>
  801946:	89 c3                	mov    %eax,%ebx
  801948:	83 c4 10             	add    $0x10,%esp
  80194b:	85 c0                	test   %eax,%eax
  80194d:	78 28                	js     801977 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80194f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801952:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801958:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80195a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801964:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801967:	83 ec 0c             	sub    $0xc,%esp
  80196a:	50                   	push   %eax
  80196b:	e8 c6 f6 ff ff       	call   801036 <fd2num>
  801970:	89 c3                	mov    %eax,%ebx
  801972:	83 c4 10             	add    $0x10,%esp
  801975:	eb 0c                	jmp    801983 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801977:	83 ec 0c             	sub    $0xc,%esp
  80197a:	56                   	push   %esi
  80197b:	e8 e4 01 00 00       	call   801b64 <nsipc_close>
		return r;
  801980:	83 c4 10             	add    $0x10,%esp
}
  801983:	89 d8                	mov    %ebx,%eax
  801985:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801988:	5b                   	pop    %ebx
  801989:	5e                   	pop    %esi
  80198a:	5d                   	pop    %ebp
  80198b:	c3                   	ret    

0080198c <accept>:
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	e8 4e ff ff ff       	call   8018e8 <fd2sockid>
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 1b                	js     8019b9 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	ff 75 10             	pushl  0x10(%ebp)
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	50                   	push   %eax
  8019a8:	e8 0e 01 00 00       	call   801abb <nsipc_accept>
  8019ad:	83 c4 10             	add    $0x10,%esp
  8019b0:	85 c0                	test   %eax,%eax
  8019b2:	78 05                	js     8019b9 <accept+0x2d>
	return alloc_sockfd(r);
  8019b4:	e8 5f ff ff ff       	call   801918 <alloc_sockfd>
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <bind>:
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c4:	e8 1f ff ff ff       	call   8018e8 <fd2sockid>
  8019c9:	85 c0                	test   %eax,%eax
  8019cb:	78 12                	js     8019df <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019cd:	83 ec 04             	sub    $0x4,%esp
  8019d0:	ff 75 10             	pushl  0x10(%ebp)
  8019d3:	ff 75 0c             	pushl  0xc(%ebp)
  8019d6:	50                   	push   %eax
  8019d7:	e8 31 01 00 00       	call   801b0d <nsipc_bind>
  8019dc:	83 c4 10             	add    $0x10,%esp
}
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <shutdown>:
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ea:	e8 f9 fe ff ff       	call   8018e8 <fd2sockid>
  8019ef:	85 c0                	test   %eax,%eax
  8019f1:	78 0f                	js     801a02 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019f3:	83 ec 08             	sub    $0x8,%esp
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	50                   	push   %eax
  8019fa:	e8 43 01 00 00       	call   801b42 <nsipc_shutdown>
  8019ff:	83 c4 10             	add    $0x10,%esp
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <connect>:
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	e8 d6 fe ff ff       	call   8018e8 <fd2sockid>
  801a12:	85 c0                	test   %eax,%eax
  801a14:	78 12                	js     801a28 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a16:	83 ec 04             	sub    $0x4,%esp
  801a19:	ff 75 10             	pushl  0x10(%ebp)
  801a1c:	ff 75 0c             	pushl  0xc(%ebp)
  801a1f:	50                   	push   %eax
  801a20:	e8 59 01 00 00       	call   801b7e <nsipc_connect>
  801a25:	83 c4 10             	add    $0x10,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <listen>:
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	e8 b0 fe ff ff       	call   8018e8 <fd2sockid>
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	78 0f                	js     801a4b <listen+0x21>
	return nsipc_listen(r, backlog);
  801a3c:	83 ec 08             	sub    $0x8,%esp
  801a3f:	ff 75 0c             	pushl  0xc(%ebp)
  801a42:	50                   	push   %eax
  801a43:	e8 6b 01 00 00       	call   801bb3 <nsipc_listen>
  801a48:	83 c4 10             	add    $0x10,%esp
}
  801a4b:	c9                   	leave  
  801a4c:	c3                   	ret    

00801a4d <socket>:

int
socket(int domain, int type, int protocol)
{
  801a4d:	55                   	push   %ebp
  801a4e:	89 e5                	mov    %esp,%ebp
  801a50:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a53:	ff 75 10             	pushl  0x10(%ebp)
  801a56:	ff 75 0c             	pushl  0xc(%ebp)
  801a59:	ff 75 08             	pushl  0x8(%ebp)
  801a5c:	e8 3e 02 00 00       	call   801c9f <nsipc_socket>
  801a61:	83 c4 10             	add    $0x10,%esp
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 05                	js     801a6d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a68:	e8 ab fe ff ff       	call   801918 <alloc_sockfd>
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	53                   	push   %ebx
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a78:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a7f:	74 26                	je     801aa7 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a81:	6a 07                	push   $0x7
  801a83:	68 00 60 80 00       	push   $0x806000
  801a88:	53                   	push   %ebx
  801a89:	ff 35 04 40 80 00    	pushl  0x804004
  801a8f:	e8 c2 07 00 00       	call   802256 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a94:	83 c4 0c             	add    $0xc,%esp
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	e8 4b 07 00 00       	call   8021ed <ipc_recv>
}
  801aa2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801aa7:	83 ec 0c             	sub    $0xc,%esp
  801aaa:	6a 02                	push   $0x2
  801aac:	e8 fd 07 00 00       	call   8022ae <ipc_find_env>
  801ab1:	a3 04 40 80 00       	mov    %eax,0x804004
  801ab6:	83 c4 10             	add    $0x10,%esp
  801ab9:	eb c6                	jmp    801a81 <nsipc+0x12>

00801abb <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	56                   	push   %esi
  801abf:	53                   	push   %ebx
  801ac0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801acb:	8b 06                	mov    (%esi),%eax
  801acd:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ad2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ad7:	e8 93 ff ff ff       	call   801a6f <nsipc>
  801adc:	89 c3                	mov    %eax,%ebx
  801ade:	85 c0                	test   %eax,%eax
  801ae0:	79 09                	jns    801aeb <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ae2:	89 d8                	mov    %ebx,%eax
  801ae4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ae7:	5b                   	pop    %ebx
  801ae8:	5e                   	pop    %esi
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801aeb:	83 ec 04             	sub    $0x4,%esp
  801aee:	ff 35 10 60 80 00    	pushl  0x806010
  801af4:	68 00 60 80 00       	push   $0x806000
  801af9:	ff 75 0c             	pushl  0xc(%ebp)
  801afc:	e8 dc ef ff ff       	call   800add <memmove>
		*addrlen = ret->ret_addrlen;
  801b01:	a1 10 60 80 00       	mov    0x806010,%eax
  801b06:	89 06                	mov    %eax,(%esi)
  801b08:	83 c4 10             	add    $0x10,%esp
	return r;
  801b0b:	eb d5                	jmp    801ae2 <nsipc_accept+0x27>

00801b0d <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
  801b11:	83 ec 08             	sub    $0x8,%esp
  801b14:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b17:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1a:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b1f:	53                   	push   %ebx
  801b20:	ff 75 0c             	pushl  0xc(%ebp)
  801b23:	68 04 60 80 00       	push   $0x806004
  801b28:	e8 b0 ef ff ff       	call   800add <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b2d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b33:	b8 02 00 00 00       	mov    $0x2,%eax
  801b38:	e8 32 ff ff ff       	call   801a6f <nsipc>
}
  801b3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b48:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b53:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b58:	b8 03 00 00 00       	mov    $0x3,%eax
  801b5d:	e8 0d ff ff ff       	call   801a6f <nsipc>
}
  801b62:	c9                   	leave  
  801b63:	c3                   	ret    

00801b64 <nsipc_close>:

int
nsipc_close(int s)
{
  801b64:	55                   	push   %ebp
  801b65:	89 e5                	mov    %esp,%ebp
  801b67:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b72:	b8 04 00 00 00       	mov    $0x4,%eax
  801b77:	e8 f3 fe ff ff       	call   801a6f <nsipc>
}
  801b7c:	c9                   	leave  
  801b7d:	c3                   	ret    

00801b7e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b7e:	55                   	push   %ebp
  801b7f:	89 e5                	mov    %esp,%ebp
  801b81:	53                   	push   %ebx
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b90:	53                   	push   %ebx
  801b91:	ff 75 0c             	pushl  0xc(%ebp)
  801b94:	68 04 60 80 00       	push   $0x806004
  801b99:	e8 3f ef ff ff       	call   800add <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b9e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801ba4:	b8 05 00 00 00       	mov    $0x5,%eax
  801ba9:	e8 c1 fe ff ff       	call   801a6f <nsipc>
}
  801bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bb1:	c9                   	leave  
  801bb2:	c3                   	ret    

00801bb3 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bbc:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bc9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bce:	e8 9c fe ff ff       	call   801a6f <nsipc>
}
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
  801bd8:	56                   	push   %esi
  801bd9:	53                   	push   %ebx
  801bda:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801be5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801beb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bee:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bf3:	b8 07 00 00 00       	mov    $0x7,%eax
  801bf8:	e8 72 fe ff ff       	call   801a6f <nsipc>
  801bfd:	89 c3                	mov    %eax,%ebx
  801bff:	85 c0                	test   %eax,%eax
  801c01:	78 1f                	js     801c22 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c03:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c08:	7f 21                	jg     801c2b <nsipc_recv+0x56>
  801c0a:	39 c6                	cmp    %eax,%esi
  801c0c:	7c 1d                	jl     801c2b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c0e:	83 ec 04             	sub    $0x4,%esp
  801c11:	50                   	push   %eax
  801c12:	68 00 60 80 00       	push   $0x806000
  801c17:	ff 75 0c             	pushl  0xc(%ebp)
  801c1a:	e8 be ee ff ff       	call   800add <memmove>
  801c1f:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c22:	89 d8                	mov    %ebx,%eax
  801c24:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c27:	5b                   	pop    %ebx
  801c28:	5e                   	pop    %esi
  801c29:	5d                   	pop    %ebp
  801c2a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c2b:	68 83 2a 80 00       	push   $0x802a83
  801c30:	68 4b 2a 80 00       	push   $0x802a4b
  801c35:	6a 62                	push   $0x62
  801c37:	68 98 2a 80 00       	push   $0x802a98
  801c3c:	e8 4b 05 00 00       	call   80218c <_panic>

00801c41 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	53                   	push   %ebx
  801c45:	83 ec 04             	sub    $0x4,%esp
  801c48:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c53:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c59:	7f 2e                	jg     801c89 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	53                   	push   %ebx
  801c5f:	ff 75 0c             	pushl  0xc(%ebp)
  801c62:	68 0c 60 80 00       	push   $0x80600c
  801c67:	e8 71 ee ff ff       	call   800add <memmove>
	nsipcbuf.send.req_size = size;
  801c6c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c72:	8b 45 14             	mov    0x14(%ebp),%eax
  801c75:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c7a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7f:	e8 eb fd ff ff       	call   801a6f <nsipc>
}
  801c84:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    
	assert(size < 1600);
  801c89:	68 a4 2a 80 00       	push   $0x802aa4
  801c8e:	68 4b 2a 80 00       	push   $0x802a4b
  801c93:	6a 6d                	push   $0x6d
  801c95:	68 98 2a 80 00       	push   $0x802a98
  801c9a:	e8 ed 04 00 00       	call   80218c <_panic>

00801c9f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cad:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb0:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cb5:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb8:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cbd:	b8 09 00 00 00       	mov    $0x9,%eax
  801cc2:	e8 a8 fd ff ff       	call   801a6f <nsipc>
}
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	56                   	push   %esi
  801ccd:	53                   	push   %ebx
  801cce:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cd1:	83 ec 0c             	sub    $0xc,%esp
  801cd4:	ff 75 08             	pushl  0x8(%ebp)
  801cd7:	e8 6a f3 ff ff       	call   801046 <fd2data>
  801cdc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cde:	83 c4 08             	add    $0x8,%esp
  801ce1:	68 b0 2a 80 00       	push   $0x802ab0
  801ce6:	53                   	push   %ebx
  801ce7:	e8 63 ec ff ff       	call   80094f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cec:	8b 46 04             	mov    0x4(%esi),%eax
  801cef:	2b 06                	sub    (%esi),%eax
  801cf1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cf7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cfe:	00 00 00 
	stat->st_dev = &devpipe;
  801d01:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d08:	30 80 00 
	return 0;
}
  801d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5e                   	pop    %esi
  801d15:	5d                   	pop    %ebp
  801d16:	c3                   	ret    

00801d17 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d17:	55                   	push   %ebp
  801d18:	89 e5                	mov    %esp,%ebp
  801d1a:	53                   	push   %ebx
  801d1b:	83 ec 0c             	sub    $0xc,%esp
  801d1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d21:	53                   	push   %ebx
  801d22:	6a 00                	push   $0x0
  801d24:	e8 9d f0 ff ff       	call   800dc6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d29:	89 1c 24             	mov    %ebx,(%esp)
  801d2c:	e8 15 f3 ff ff       	call   801046 <fd2data>
  801d31:	83 c4 08             	add    $0x8,%esp
  801d34:	50                   	push   %eax
  801d35:	6a 00                	push   $0x0
  801d37:	e8 8a f0 ff ff       	call   800dc6 <sys_page_unmap>
}
  801d3c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <_pipeisclosed>:
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
  801d44:	57                   	push   %edi
  801d45:	56                   	push   %esi
  801d46:	53                   	push   %ebx
  801d47:	83 ec 1c             	sub    $0x1c,%esp
  801d4a:	89 c7                	mov    %eax,%edi
  801d4c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d4e:	a1 08 40 80 00       	mov    0x804008,%eax
  801d53:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d56:	83 ec 0c             	sub    $0xc,%esp
  801d59:	57                   	push   %edi
  801d5a:	e8 8a 05 00 00       	call   8022e9 <pageref>
  801d5f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d62:	89 34 24             	mov    %esi,(%esp)
  801d65:	e8 7f 05 00 00       	call   8022e9 <pageref>
		nn = thisenv->env_runs;
  801d6a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d70:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	39 cb                	cmp    %ecx,%ebx
  801d78:	74 1b                	je     801d95 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d7a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d7d:	75 cf                	jne    801d4e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d7f:	8b 42 58             	mov    0x58(%edx),%eax
  801d82:	6a 01                	push   $0x1
  801d84:	50                   	push   %eax
  801d85:	53                   	push   %ebx
  801d86:	68 b7 2a 80 00       	push   $0x802ab7
  801d8b:	e8 60 e4 ff ff       	call   8001f0 <cprintf>
  801d90:	83 c4 10             	add    $0x10,%esp
  801d93:	eb b9                	jmp    801d4e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d95:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d98:	0f 94 c0             	sete   %al
  801d9b:	0f b6 c0             	movzbl %al,%eax
}
  801d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da1:	5b                   	pop    %ebx
  801da2:	5e                   	pop    %esi
  801da3:	5f                   	pop    %edi
  801da4:	5d                   	pop    %ebp
  801da5:	c3                   	ret    

00801da6 <devpipe_write>:
{
  801da6:	55                   	push   %ebp
  801da7:	89 e5                	mov    %esp,%ebp
  801da9:	57                   	push   %edi
  801daa:	56                   	push   %esi
  801dab:	53                   	push   %ebx
  801dac:	83 ec 28             	sub    $0x28,%esp
  801daf:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801db2:	56                   	push   %esi
  801db3:	e8 8e f2 ff ff       	call   801046 <fd2data>
  801db8:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dba:	83 c4 10             	add    $0x10,%esp
  801dbd:	bf 00 00 00 00       	mov    $0x0,%edi
  801dc2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dc5:	74 4f                	je     801e16 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dc7:	8b 43 04             	mov    0x4(%ebx),%eax
  801dca:	8b 0b                	mov    (%ebx),%ecx
  801dcc:	8d 51 20             	lea    0x20(%ecx),%edx
  801dcf:	39 d0                	cmp    %edx,%eax
  801dd1:	72 14                	jb     801de7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dd3:	89 da                	mov    %ebx,%edx
  801dd5:	89 f0                	mov    %esi,%eax
  801dd7:	e8 65 ff ff ff       	call   801d41 <_pipeisclosed>
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	75 3b                	jne    801e1b <devpipe_write+0x75>
			sys_yield();
  801de0:	e8 3d ef ff ff       	call   800d22 <sys_yield>
  801de5:	eb e0                	jmp    801dc7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801de7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dea:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dee:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801df1:	89 c2                	mov    %eax,%edx
  801df3:	c1 fa 1f             	sar    $0x1f,%edx
  801df6:	89 d1                	mov    %edx,%ecx
  801df8:	c1 e9 1b             	shr    $0x1b,%ecx
  801dfb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dfe:	83 e2 1f             	and    $0x1f,%edx
  801e01:	29 ca                	sub    %ecx,%edx
  801e03:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e07:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e0b:	83 c0 01             	add    $0x1,%eax
  801e0e:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e11:	83 c7 01             	add    $0x1,%edi
  801e14:	eb ac                	jmp    801dc2 <devpipe_write+0x1c>
	return i;
  801e16:	8b 45 10             	mov    0x10(%ebp),%eax
  801e19:	eb 05                	jmp    801e20 <devpipe_write+0x7a>
				return 0;
  801e1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e23:	5b                   	pop    %ebx
  801e24:	5e                   	pop    %esi
  801e25:	5f                   	pop    %edi
  801e26:	5d                   	pop    %ebp
  801e27:	c3                   	ret    

00801e28 <devpipe_read>:
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
  801e2b:	57                   	push   %edi
  801e2c:	56                   	push   %esi
  801e2d:	53                   	push   %ebx
  801e2e:	83 ec 18             	sub    $0x18,%esp
  801e31:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e34:	57                   	push   %edi
  801e35:	e8 0c f2 ff ff       	call   801046 <fd2data>
  801e3a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e3c:	83 c4 10             	add    $0x10,%esp
  801e3f:	be 00 00 00 00       	mov    $0x0,%esi
  801e44:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e47:	75 14                	jne    801e5d <devpipe_read+0x35>
	return i;
  801e49:	8b 45 10             	mov    0x10(%ebp),%eax
  801e4c:	eb 02                	jmp    801e50 <devpipe_read+0x28>
				return i;
  801e4e:	89 f0                	mov    %esi,%eax
}
  801e50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e53:	5b                   	pop    %ebx
  801e54:	5e                   	pop    %esi
  801e55:	5f                   	pop    %edi
  801e56:	5d                   	pop    %ebp
  801e57:	c3                   	ret    
			sys_yield();
  801e58:	e8 c5 ee ff ff       	call   800d22 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e5d:	8b 03                	mov    (%ebx),%eax
  801e5f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e62:	75 18                	jne    801e7c <devpipe_read+0x54>
			if (i > 0)
  801e64:	85 f6                	test   %esi,%esi
  801e66:	75 e6                	jne    801e4e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e68:	89 da                	mov    %ebx,%edx
  801e6a:	89 f8                	mov    %edi,%eax
  801e6c:	e8 d0 fe ff ff       	call   801d41 <_pipeisclosed>
  801e71:	85 c0                	test   %eax,%eax
  801e73:	74 e3                	je     801e58 <devpipe_read+0x30>
				return 0;
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	eb d4                	jmp    801e50 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e7c:	99                   	cltd   
  801e7d:	c1 ea 1b             	shr    $0x1b,%edx
  801e80:	01 d0                	add    %edx,%eax
  801e82:	83 e0 1f             	and    $0x1f,%eax
  801e85:	29 d0                	sub    %edx,%eax
  801e87:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e8c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e92:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e95:	83 c6 01             	add    $0x1,%esi
  801e98:	eb aa                	jmp    801e44 <devpipe_read+0x1c>

00801e9a <pipe>:
{
  801e9a:	55                   	push   %ebp
  801e9b:	89 e5                	mov    %esp,%ebp
  801e9d:	56                   	push   %esi
  801e9e:	53                   	push   %ebx
  801e9f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ea2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea5:	50                   	push   %eax
  801ea6:	e8 b2 f1 ff ff       	call   80105d <fd_alloc>
  801eab:	89 c3                	mov    %eax,%ebx
  801ead:	83 c4 10             	add    $0x10,%esp
  801eb0:	85 c0                	test   %eax,%eax
  801eb2:	0f 88 23 01 00 00    	js     801fdb <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb8:	83 ec 04             	sub    $0x4,%esp
  801ebb:	68 07 04 00 00       	push   $0x407
  801ec0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ec3:	6a 00                	push   $0x0
  801ec5:	e8 77 ee ff ff       	call   800d41 <sys_page_alloc>
  801eca:	89 c3                	mov    %eax,%ebx
  801ecc:	83 c4 10             	add    $0x10,%esp
  801ecf:	85 c0                	test   %eax,%eax
  801ed1:	0f 88 04 01 00 00    	js     801fdb <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ed7:	83 ec 0c             	sub    $0xc,%esp
  801eda:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801edd:	50                   	push   %eax
  801ede:	e8 7a f1 ff ff       	call   80105d <fd_alloc>
  801ee3:	89 c3                	mov    %eax,%ebx
  801ee5:	83 c4 10             	add    $0x10,%esp
  801ee8:	85 c0                	test   %eax,%eax
  801eea:	0f 88 db 00 00 00    	js     801fcb <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ef0:	83 ec 04             	sub    $0x4,%esp
  801ef3:	68 07 04 00 00       	push   $0x407
  801ef8:	ff 75 f0             	pushl  -0x10(%ebp)
  801efb:	6a 00                	push   $0x0
  801efd:	e8 3f ee ff ff       	call   800d41 <sys_page_alloc>
  801f02:	89 c3                	mov    %eax,%ebx
  801f04:	83 c4 10             	add    $0x10,%esp
  801f07:	85 c0                	test   %eax,%eax
  801f09:	0f 88 bc 00 00 00    	js     801fcb <pipe+0x131>
	va = fd2data(fd0);
  801f0f:	83 ec 0c             	sub    $0xc,%esp
  801f12:	ff 75 f4             	pushl  -0xc(%ebp)
  801f15:	e8 2c f1 ff ff       	call   801046 <fd2data>
  801f1a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1c:	83 c4 0c             	add    $0xc,%esp
  801f1f:	68 07 04 00 00       	push   $0x407
  801f24:	50                   	push   %eax
  801f25:	6a 00                	push   $0x0
  801f27:	e8 15 ee ff ff       	call   800d41 <sys_page_alloc>
  801f2c:	89 c3                	mov    %eax,%ebx
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	85 c0                	test   %eax,%eax
  801f33:	0f 88 82 00 00 00    	js     801fbb <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f39:	83 ec 0c             	sub    $0xc,%esp
  801f3c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f3f:	e8 02 f1 ff ff       	call   801046 <fd2data>
  801f44:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f4b:	50                   	push   %eax
  801f4c:	6a 00                	push   $0x0
  801f4e:	56                   	push   %esi
  801f4f:	6a 00                	push   $0x0
  801f51:	e8 2e ee ff ff       	call   800d84 <sys_page_map>
  801f56:	89 c3                	mov    %eax,%ebx
  801f58:	83 c4 20             	add    $0x20,%esp
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	78 4e                	js     801fad <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f5f:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f64:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f67:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f6c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f76:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f82:	83 ec 0c             	sub    $0xc,%esp
  801f85:	ff 75 f4             	pushl  -0xc(%ebp)
  801f88:	e8 a9 f0 ff ff       	call   801036 <fd2num>
  801f8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f90:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f92:	83 c4 04             	add    $0x4,%esp
  801f95:	ff 75 f0             	pushl  -0x10(%ebp)
  801f98:	e8 99 f0 ff ff       	call   801036 <fd2num>
  801f9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fa0:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fa3:	83 c4 10             	add    $0x10,%esp
  801fa6:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fab:	eb 2e                	jmp    801fdb <pipe+0x141>
	sys_page_unmap(0, va);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	56                   	push   %esi
  801fb1:	6a 00                	push   $0x0
  801fb3:	e8 0e ee ff ff       	call   800dc6 <sys_page_unmap>
  801fb8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fbb:	83 ec 08             	sub    $0x8,%esp
  801fbe:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc1:	6a 00                	push   $0x0
  801fc3:	e8 fe ed ff ff       	call   800dc6 <sys_page_unmap>
  801fc8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fcb:	83 ec 08             	sub    $0x8,%esp
  801fce:	ff 75 f4             	pushl  -0xc(%ebp)
  801fd1:	6a 00                	push   $0x0
  801fd3:	e8 ee ed ff ff       	call   800dc6 <sys_page_unmap>
  801fd8:	83 c4 10             	add    $0x10,%esp
}
  801fdb:	89 d8                	mov    %ebx,%eax
  801fdd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    

00801fe4 <pipeisclosed>:
{
  801fe4:	55                   	push   %ebp
  801fe5:	89 e5                	mov    %esp,%ebp
  801fe7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fed:	50                   	push   %eax
  801fee:	ff 75 08             	pushl  0x8(%ebp)
  801ff1:	e8 b9 f0 ff ff       	call   8010af <fd_lookup>
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	78 18                	js     802015 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ffd:	83 ec 0c             	sub    $0xc,%esp
  802000:	ff 75 f4             	pushl  -0xc(%ebp)
  802003:	e8 3e f0 ff ff       	call   801046 <fd2data>
	return _pipeisclosed(fd, p);
  802008:	89 c2                	mov    %eax,%edx
  80200a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200d:	e8 2f fd ff ff       	call   801d41 <_pipeisclosed>
  802012:	83 c4 10             	add    $0x10,%esp
}
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802017:	b8 00 00 00 00       	mov    $0x0,%eax
  80201c:	c3                   	ret    

0080201d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
  802020:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802023:	68 cf 2a 80 00       	push   $0x802acf
  802028:	ff 75 0c             	pushl  0xc(%ebp)
  80202b:	e8 1f e9 ff ff       	call   80094f <strcpy>
	return 0;
}
  802030:	b8 00 00 00 00       	mov    $0x0,%eax
  802035:	c9                   	leave  
  802036:	c3                   	ret    

00802037 <devcons_write>:
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	57                   	push   %edi
  80203b:	56                   	push   %esi
  80203c:	53                   	push   %ebx
  80203d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802043:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802048:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80204e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802051:	73 31                	jae    802084 <devcons_write+0x4d>
		m = n - tot;
  802053:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802056:	29 f3                	sub    %esi,%ebx
  802058:	83 fb 7f             	cmp    $0x7f,%ebx
  80205b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802060:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802063:	83 ec 04             	sub    $0x4,%esp
  802066:	53                   	push   %ebx
  802067:	89 f0                	mov    %esi,%eax
  802069:	03 45 0c             	add    0xc(%ebp),%eax
  80206c:	50                   	push   %eax
  80206d:	57                   	push   %edi
  80206e:	e8 6a ea ff ff       	call   800add <memmove>
		sys_cputs(buf, m);
  802073:	83 c4 08             	add    $0x8,%esp
  802076:	53                   	push   %ebx
  802077:	57                   	push   %edi
  802078:	e8 08 ec ff ff       	call   800c85 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80207d:	01 de                	add    %ebx,%esi
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	eb ca                	jmp    80204e <devcons_write+0x17>
}
  802084:	89 f0                	mov    %esi,%eax
  802086:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802089:	5b                   	pop    %ebx
  80208a:	5e                   	pop    %esi
  80208b:	5f                   	pop    %edi
  80208c:	5d                   	pop    %ebp
  80208d:	c3                   	ret    

0080208e <devcons_read>:
{
  80208e:	55                   	push   %ebp
  80208f:	89 e5                	mov    %esp,%ebp
  802091:	83 ec 08             	sub    $0x8,%esp
  802094:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802099:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80209d:	74 21                	je     8020c0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80209f:	e8 ff eb ff ff       	call   800ca3 <sys_cgetc>
  8020a4:	85 c0                	test   %eax,%eax
  8020a6:	75 07                	jne    8020af <devcons_read+0x21>
		sys_yield();
  8020a8:	e8 75 ec ff ff       	call   800d22 <sys_yield>
  8020ad:	eb f0                	jmp    80209f <devcons_read+0x11>
	if (c < 0)
  8020af:	78 0f                	js     8020c0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020b1:	83 f8 04             	cmp    $0x4,%eax
  8020b4:	74 0c                	je     8020c2 <devcons_read+0x34>
	*(char*)vbuf = c;
  8020b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b9:	88 02                	mov    %al,(%edx)
	return 1;
  8020bb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    
		return 0;
  8020c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c7:	eb f7                	jmp    8020c0 <devcons_read+0x32>

008020c9 <cputchar>:
{
  8020c9:	55                   	push   %ebp
  8020ca:	89 e5                	mov    %esp,%ebp
  8020cc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020d5:	6a 01                	push   $0x1
  8020d7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020da:	50                   	push   %eax
  8020db:	e8 a5 eb ff ff       	call   800c85 <sys_cputs>
}
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <getchar>:
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
  8020e8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020eb:	6a 01                	push   $0x1
  8020ed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020f0:	50                   	push   %eax
  8020f1:	6a 00                	push   $0x0
  8020f3:	e8 27 f2 ff ff       	call   80131f <read>
	if (r < 0)
  8020f8:	83 c4 10             	add    $0x10,%esp
  8020fb:	85 c0                	test   %eax,%eax
  8020fd:	78 06                	js     802105 <getchar+0x20>
	if (r < 1)
  8020ff:	74 06                	je     802107 <getchar+0x22>
	return c;
  802101:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802105:	c9                   	leave  
  802106:	c3                   	ret    
		return -E_EOF;
  802107:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80210c:	eb f7                	jmp    802105 <getchar+0x20>

0080210e <iscons>:
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802114:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802117:	50                   	push   %eax
  802118:	ff 75 08             	pushl  0x8(%ebp)
  80211b:	e8 8f ef ff ff       	call   8010af <fd_lookup>
  802120:	83 c4 10             	add    $0x10,%esp
  802123:	85 c0                	test   %eax,%eax
  802125:	78 11                	js     802138 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802127:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80212a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802130:	39 10                	cmp    %edx,(%eax)
  802132:	0f 94 c0             	sete   %al
  802135:	0f b6 c0             	movzbl %al,%eax
}
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <opencons>:
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802143:	50                   	push   %eax
  802144:	e8 14 ef ff ff       	call   80105d <fd_alloc>
  802149:	83 c4 10             	add    $0x10,%esp
  80214c:	85 c0                	test   %eax,%eax
  80214e:	78 3a                	js     80218a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	68 07 04 00 00       	push   $0x407
  802158:	ff 75 f4             	pushl  -0xc(%ebp)
  80215b:	6a 00                	push   $0x0
  80215d:	e8 df eb ff ff       	call   800d41 <sys_page_alloc>
  802162:	83 c4 10             	add    $0x10,%esp
  802165:	85 c0                	test   %eax,%eax
  802167:	78 21                	js     80218a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802172:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802177:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80217e:	83 ec 0c             	sub    $0xc,%esp
  802181:	50                   	push   %eax
  802182:	e8 af ee ff ff       	call   801036 <fd2num>
  802187:	83 c4 10             	add    $0x10,%esp
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	56                   	push   %esi
  802190:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802191:	a1 08 40 80 00       	mov    0x804008,%eax
  802196:	8b 40 48             	mov    0x48(%eax),%eax
  802199:	83 ec 04             	sub    $0x4,%esp
  80219c:	68 00 2b 80 00       	push   $0x802b00
  8021a1:	50                   	push   %eax
  8021a2:	68 ff 25 80 00       	push   $0x8025ff
  8021a7:	e8 44 e0 ff ff       	call   8001f0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021ac:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021af:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021b5:	e8 49 eb ff ff       	call   800d03 <sys_getenvid>
  8021ba:	83 c4 04             	add    $0x4,%esp
  8021bd:	ff 75 0c             	pushl  0xc(%ebp)
  8021c0:	ff 75 08             	pushl  0x8(%ebp)
  8021c3:	56                   	push   %esi
  8021c4:	50                   	push   %eax
  8021c5:	68 dc 2a 80 00       	push   $0x802adc
  8021ca:	e8 21 e0 ff ff       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021cf:	83 c4 18             	add    $0x18,%esp
  8021d2:	53                   	push   %ebx
  8021d3:	ff 75 10             	pushl  0x10(%ebp)
  8021d6:	e8 c4 df ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  8021db:	c7 04 24 c3 25 80 00 	movl   $0x8025c3,(%esp)
  8021e2:	e8 09 e0 ff ff       	call   8001f0 <cprintf>
  8021e7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021ea:	cc                   	int3   
  8021eb:	eb fd                	jmp    8021ea <_panic+0x5e>

008021ed <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	56                   	push   %esi
  8021f1:	53                   	push   %ebx
  8021f2:	8b 75 08             	mov    0x8(%ebp),%esi
  8021f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021fb:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021fd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802202:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802205:	83 ec 0c             	sub    $0xc,%esp
  802208:	50                   	push   %eax
  802209:	e8 e3 ec ff ff       	call   800ef1 <sys_ipc_recv>
	if(ret < 0){
  80220e:	83 c4 10             	add    $0x10,%esp
  802211:	85 c0                	test   %eax,%eax
  802213:	78 2b                	js     802240 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802215:	85 f6                	test   %esi,%esi
  802217:	74 0a                	je     802223 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802219:	a1 08 40 80 00       	mov    0x804008,%eax
  80221e:	8b 40 74             	mov    0x74(%eax),%eax
  802221:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802223:	85 db                	test   %ebx,%ebx
  802225:	74 0a                	je     802231 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802227:	a1 08 40 80 00       	mov    0x804008,%eax
  80222c:	8b 40 78             	mov    0x78(%eax),%eax
  80222f:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802231:	a1 08 40 80 00       	mov    0x804008,%eax
  802236:	8b 40 70             	mov    0x70(%eax),%eax
}
  802239:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80223c:	5b                   	pop    %ebx
  80223d:	5e                   	pop    %esi
  80223e:	5d                   	pop    %ebp
  80223f:	c3                   	ret    
		if(from_env_store)
  802240:	85 f6                	test   %esi,%esi
  802242:	74 06                	je     80224a <ipc_recv+0x5d>
			*from_env_store = 0;
  802244:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80224a:	85 db                	test   %ebx,%ebx
  80224c:	74 eb                	je     802239 <ipc_recv+0x4c>
			*perm_store = 0;
  80224e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802254:	eb e3                	jmp    802239 <ipc_recv+0x4c>

00802256 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	57                   	push   %edi
  80225a:	56                   	push   %esi
  80225b:	53                   	push   %ebx
  80225c:	83 ec 0c             	sub    $0xc,%esp
  80225f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802262:	8b 75 0c             	mov    0xc(%ebp),%esi
  802265:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802268:	85 db                	test   %ebx,%ebx
  80226a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80226f:	0f 44 d8             	cmove  %eax,%ebx
  802272:	eb 05                	jmp    802279 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802274:	e8 a9 ea ff ff       	call   800d22 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802279:	ff 75 14             	pushl  0x14(%ebp)
  80227c:	53                   	push   %ebx
  80227d:	56                   	push   %esi
  80227e:	57                   	push   %edi
  80227f:	e8 4a ec ff ff       	call   800ece <sys_ipc_try_send>
  802284:	83 c4 10             	add    $0x10,%esp
  802287:	85 c0                	test   %eax,%eax
  802289:	74 1b                	je     8022a6 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80228b:	79 e7                	jns    802274 <ipc_send+0x1e>
  80228d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802290:	74 e2                	je     802274 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802292:	83 ec 04             	sub    $0x4,%esp
  802295:	68 07 2b 80 00       	push   $0x802b07
  80229a:	6a 46                	push   $0x46
  80229c:	68 1c 2b 80 00       	push   $0x802b1c
  8022a1:	e8 e6 fe ff ff       	call   80218c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  8022a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022a9:	5b                   	pop    %ebx
  8022aa:	5e                   	pop    %esi
  8022ab:	5f                   	pop    %edi
  8022ac:	5d                   	pop    %ebp
  8022ad:	c3                   	ret    

008022ae <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ae:	55                   	push   %ebp
  8022af:	89 e5                	mov    %esp,%ebp
  8022b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022b9:	89 c2                	mov    %eax,%edx
  8022bb:	c1 e2 07             	shl    $0x7,%edx
  8022be:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022c4:	8b 52 50             	mov    0x50(%edx),%edx
  8022c7:	39 ca                	cmp    %ecx,%edx
  8022c9:	74 11                	je     8022dc <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022cb:	83 c0 01             	add    $0x1,%eax
  8022ce:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022d3:	75 e4                	jne    8022b9 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022da:	eb 0b                	jmp    8022e7 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022dc:	c1 e0 07             	shl    $0x7,%eax
  8022df:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022e4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022e7:	5d                   	pop    %ebp
  8022e8:	c3                   	ret    

008022e9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022e9:	55                   	push   %ebp
  8022ea:	89 e5                	mov    %esp,%ebp
  8022ec:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022ef:	89 d0                	mov    %edx,%eax
  8022f1:	c1 e8 16             	shr    $0x16,%eax
  8022f4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022fb:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802300:	f6 c1 01             	test   $0x1,%cl
  802303:	74 1d                	je     802322 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802305:	c1 ea 0c             	shr    $0xc,%edx
  802308:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80230f:	f6 c2 01             	test   $0x1,%dl
  802312:	74 0e                	je     802322 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802314:	c1 ea 0c             	shr    $0xc,%edx
  802317:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  80231e:	ef 
  80231f:	0f b7 c0             	movzwl %ax,%eax
}
  802322:	5d                   	pop    %ebp
  802323:	c3                   	ret    
  802324:	66 90                	xchg   %ax,%ax
  802326:	66 90                	xchg   %ax,%ax
  802328:	66 90                	xchg   %ax,%ax
  80232a:	66 90                	xchg   %ax,%ax
  80232c:	66 90                	xchg   %ax,%ax
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
