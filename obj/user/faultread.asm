
obj/user/faultread.debug:     file format elf32-i386


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
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800039:	ff 35 00 00 00 00    	pushl  0x0
  80003f:	68 60 25 80 00       	push   $0x802560
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
  8000d1:	68 7e 25 80 00       	push   $0x80257e
  8000d6:	e8 15 01 00 00       	call   8001f0 <cprintf>
	cprintf("before umain\n");
  8000db:	c7 04 24 9c 25 80 00 	movl   $0x80259c,(%esp)
  8000e2:	e8 09 01 00 00       	call   8001f0 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000e7:	83 c4 08             	add    $0x8,%esp
  8000ea:	ff 75 0c             	pushl  0xc(%ebp)
  8000ed:	ff 75 08             	pushl  0x8(%ebp)
  8000f0:	e8 3e ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000f5:	c7 04 24 aa 25 80 00 	movl   $0x8025aa,(%esp)
  8000fc:	e8 ef 00 00 00       	call   8001f0 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800101:	a1 08 40 80 00       	mov    0x804008,%eax
  800106:	8b 40 48             	mov    0x48(%eax),%eax
  800109:	83 c4 08             	add    $0x8,%esp
  80010c:	50                   	push   %eax
  80010d:	68 b7 25 80 00       	push   $0x8025b7
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
  800135:	68 e4 25 80 00       	push   $0x8025e4
  80013a:	50                   	push   %eax
  80013b:	68 d6 25 80 00       	push   $0x8025d6
  800140:	e8 ab 00 00 00       	call   8001f0 <cprintf>
	close_all();
  800145:	e8 a4 10 00 00       	call   8011ee <close_all>
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
  80029d:	e8 6e 20 00 00       	call   802310 <__udivdi3>
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
  8002c6:	e8 55 21 00 00       	call   802420 <__umoddi3>
  8002cb:	83 c4 14             	add    $0x14,%esp
  8002ce:	0f be 80 e9 25 80 00 	movsbl 0x8025e9(%eax),%eax
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
  800377:	ff 24 85 c0 27 80 00 	jmp    *0x8027c0(,%eax,4)
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
  800442:	8b 14 85 20 29 80 00 	mov    0x802920(,%eax,4),%edx
  800449:	85 d2                	test   %edx,%edx
  80044b:	74 18                	je     800465 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80044d:	52                   	push   %edx
  80044e:	68 3d 2a 80 00       	push   $0x802a3d
  800453:	53                   	push   %ebx
  800454:	56                   	push   %esi
  800455:	e8 a6 fe ff ff       	call   800300 <printfmt>
  80045a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80045d:	89 7d 14             	mov    %edi,0x14(%ebp)
  800460:	e9 fe 02 00 00       	jmp    800763 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800465:	50                   	push   %eax
  800466:	68 01 26 80 00       	push   $0x802601
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
  80048d:	b8 fa 25 80 00       	mov    $0x8025fa,%eax
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
  800825:	bf 1d 27 80 00       	mov    $0x80271d,%edi
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
  800851:	bf 55 27 80 00       	mov    $0x802755,%edi
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
  800cf2:	68 68 29 80 00       	push   $0x802968
  800cf7:	6a 43                	push   $0x43
  800cf9:	68 85 29 80 00       	push   $0x802985
  800cfe:	e8 69 14 00 00       	call   80216c <_panic>

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
  800d73:	68 68 29 80 00       	push   $0x802968
  800d78:	6a 43                	push   $0x43
  800d7a:	68 85 29 80 00       	push   $0x802985
  800d7f:	e8 e8 13 00 00       	call   80216c <_panic>

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
  800db5:	68 68 29 80 00       	push   $0x802968
  800dba:	6a 43                	push   $0x43
  800dbc:	68 85 29 80 00       	push   $0x802985
  800dc1:	e8 a6 13 00 00       	call   80216c <_panic>

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
  800df7:	68 68 29 80 00       	push   $0x802968
  800dfc:	6a 43                	push   $0x43
  800dfe:	68 85 29 80 00       	push   $0x802985
  800e03:	e8 64 13 00 00       	call   80216c <_panic>

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
  800e39:	68 68 29 80 00       	push   $0x802968
  800e3e:	6a 43                	push   $0x43
  800e40:	68 85 29 80 00       	push   $0x802985
  800e45:	e8 22 13 00 00       	call   80216c <_panic>

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
  800e7b:	68 68 29 80 00       	push   $0x802968
  800e80:	6a 43                	push   $0x43
  800e82:	68 85 29 80 00       	push   $0x802985
  800e87:	e8 e0 12 00 00       	call   80216c <_panic>

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
  800ebd:	68 68 29 80 00       	push   $0x802968
  800ec2:	6a 43                	push   $0x43
  800ec4:	68 85 29 80 00       	push   $0x802985
  800ec9:	e8 9e 12 00 00       	call   80216c <_panic>

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
  800f21:	68 68 29 80 00       	push   $0x802968
  800f26:	6a 43                	push   $0x43
  800f28:	68 85 29 80 00       	push   $0x802985
  800f2d:	e8 3a 12 00 00       	call   80216c <_panic>

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
  801005:	68 68 29 80 00       	push   $0x802968
  80100a:	6a 43                	push   $0x43
  80100c:	68 85 29 80 00       	push   $0x802985
  801011:	e8 56 11 00 00       	call   80216c <_panic>

00801016 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	05 00 00 00 30       	add    $0x30000000,%eax
  801021:	c1 e8 0c             	shr    $0xc,%eax
}
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801031:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801036:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801045:	89 c2                	mov    %eax,%edx
  801047:	c1 ea 16             	shr    $0x16,%edx
  80104a:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801051:	f6 c2 01             	test   $0x1,%dl
  801054:	74 2d                	je     801083 <fd_alloc+0x46>
  801056:	89 c2                	mov    %eax,%edx
  801058:	c1 ea 0c             	shr    $0xc,%edx
  80105b:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801062:	f6 c2 01             	test   $0x1,%dl
  801065:	74 1c                	je     801083 <fd_alloc+0x46>
  801067:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80106c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801071:	75 d2                	jne    801045 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  80107c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801081:	eb 0a                	jmp    80108d <fd_alloc+0x50>
			*fd_store = fd;
  801083:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801086:	89 01                	mov    %eax,(%ecx)
			return 0;
  801088:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80108d:	5d                   	pop    %ebp
  80108e:	c3                   	ret    

0080108f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801095:	83 f8 1f             	cmp    $0x1f,%eax
  801098:	77 30                	ja     8010ca <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80109a:	c1 e0 0c             	shl    $0xc,%eax
  80109d:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010a2:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010a8:	f6 c2 01             	test   $0x1,%dl
  8010ab:	74 24                	je     8010d1 <fd_lookup+0x42>
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	c1 ea 0c             	shr    $0xc,%edx
  8010b2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010b9:	f6 c2 01             	test   $0x1,%dl
  8010bc:	74 1a                	je     8010d8 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c1:	89 02                	mov    %eax,(%edx)
	return 0;
  8010c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    
		return -E_INVAL;
  8010ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010cf:	eb f7                	jmp    8010c8 <fd_lookup+0x39>
		return -E_INVAL;
  8010d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010d6:	eb f0                	jmp    8010c8 <fd_lookup+0x39>
  8010d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010dd:	eb e9                	jmp    8010c8 <fd_lookup+0x39>

008010df <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 08             	sub    $0x8,%esp
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  8010e8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ed:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010f2:	39 08                	cmp    %ecx,(%eax)
  8010f4:	74 38                	je     80112e <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  8010f6:	83 c2 01             	add    $0x1,%edx
  8010f9:	8b 04 95 10 2a 80 00 	mov    0x802a10(,%edx,4),%eax
  801100:	85 c0                	test   %eax,%eax
  801102:	75 ee                	jne    8010f2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801104:	a1 08 40 80 00       	mov    0x804008,%eax
  801109:	8b 40 48             	mov    0x48(%eax),%eax
  80110c:	83 ec 04             	sub    $0x4,%esp
  80110f:	51                   	push   %ecx
  801110:	50                   	push   %eax
  801111:	68 94 29 80 00       	push   $0x802994
  801116:	e8 d5 f0 ff ff       	call   8001f0 <cprintf>
	*dev = 0;
  80111b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801124:	83 c4 10             	add    $0x10,%esp
  801127:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80112c:	c9                   	leave  
  80112d:	c3                   	ret    
			*dev = devtab[i];
  80112e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801131:	89 01                	mov    %eax,(%ecx)
			return 0;
  801133:	b8 00 00 00 00       	mov    $0x0,%eax
  801138:	eb f2                	jmp    80112c <dev_lookup+0x4d>

0080113a <fd_close>:
{
  80113a:	55                   	push   %ebp
  80113b:	89 e5                	mov    %esp,%ebp
  80113d:	57                   	push   %edi
  80113e:	56                   	push   %esi
  80113f:	53                   	push   %ebx
  801140:	83 ec 24             	sub    $0x24,%esp
  801143:	8b 75 08             	mov    0x8(%ebp),%esi
  801146:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801149:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80114c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80114d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801153:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801156:	50                   	push   %eax
  801157:	e8 33 ff ff ff       	call   80108f <fd_lookup>
  80115c:	89 c3                	mov    %eax,%ebx
  80115e:	83 c4 10             	add    $0x10,%esp
  801161:	85 c0                	test   %eax,%eax
  801163:	78 05                	js     80116a <fd_close+0x30>
	    || fd != fd2)
  801165:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801168:	74 16                	je     801180 <fd_close+0x46>
		return (must_exist ? r : 0);
  80116a:	89 f8                	mov    %edi,%eax
  80116c:	84 c0                	test   %al,%al
  80116e:	b8 00 00 00 00       	mov    $0x0,%eax
  801173:	0f 44 d8             	cmove  %eax,%ebx
}
  801176:	89 d8                	mov    %ebx,%eax
  801178:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80117b:	5b                   	pop    %ebx
  80117c:	5e                   	pop    %esi
  80117d:	5f                   	pop    %edi
  80117e:	5d                   	pop    %ebp
  80117f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801180:	83 ec 08             	sub    $0x8,%esp
  801183:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801186:	50                   	push   %eax
  801187:	ff 36                	pushl  (%esi)
  801189:	e8 51 ff ff ff       	call   8010df <dev_lookup>
  80118e:	89 c3                	mov    %eax,%ebx
  801190:	83 c4 10             	add    $0x10,%esp
  801193:	85 c0                	test   %eax,%eax
  801195:	78 1a                	js     8011b1 <fd_close+0x77>
		if (dev->dev_close)
  801197:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80119a:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  80119d:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011a2:	85 c0                	test   %eax,%eax
  8011a4:	74 0b                	je     8011b1 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011a6:	83 ec 0c             	sub    $0xc,%esp
  8011a9:	56                   	push   %esi
  8011aa:	ff d0                	call   *%eax
  8011ac:	89 c3                	mov    %eax,%ebx
  8011ae:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011b1:	83 ec 08             	sub    $0x8,%esp
  8011b4:	56                   	push   %esi
  8011b5:	6a 00                	push   $0x0
  8011b7:	e8 0a fc ff ff       	call   800dc6 <sys_page_unmap>
	return r;
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	eb b5                	jmp    801176 <fd_close+0x3c>

008011c1 <close>:

int
close(int fdnum)
{
  8011c1:	55                   	push   %ebp
  8011c2:	89 e5                	mov    %esp,%ebp
  8011c4:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011ca:	50                   	push   %eax
  8011cb:	ff 75 08             	pushl  0x8(%ebp)
  8011ce:	e8 bc fe ff ff       	call   80108f <fd_lookup>
  8011d3:	83 c4 10             	add    $0x10,%esp
  8011d6:	85 c0                	test   %eax,%eax
  8011d8:	79 02                	jns    8011dc <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  8011da:	c9                   	leave  
  8011db:	c3                   	ret    
		return fd_close(fd, 1);
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	6a 01                	push   $0x1
  8011e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8011e4:	e8 51 ff ff ff       	call   80113a <fd_close>
  8011e9:	83 c4 10             	add    $0x10,%esp
  8011ec:	eb ec                	jmp    8011da <close+0x19>

008011ee <close_all>:

void
close_all(void)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	53                   	push   %ebx
  8011f2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011f5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011fa:	83 ec 0c             	sub    $0xc,%esp
  8011fd:	53                   	push   %ebx
  8011fe:	e8 be ff ff ff       	call   8011c1 <close>
	for (i = 0; i < MAXFD; i++)
  801203:	83 c3 01             	add    $0x1,%ebx
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	83 fb 20             	cmp    $0x20,%ebx
  80120c:	75 ec                	jne    8011fa <close_all+0xc>
}
  80120e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801211:	c9                   	leave  
  801212:	c3                   	ret    

00801213 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	57                   	push   %edi
  801217:	56                   	push   %esi
  801218:	53                   	push   %ebx
  801219:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80121c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80121f:	50                   	push   %eax
  801220:	ff 75 08             	pushl  0x8(%ebp)
  801223:	e8 67 fe ff ff       	call   80108f <fd_lookup>
  801228:	89 c3                	mov    %eax,%ebx
  80122a:	83 c4 10             	add    $0x10,%esp
  80122d:	85 c0                	test   %eax,%eax
  80122f:	0f 88 81 00 00 00    	js     8012b6 <dup+0xa3>
		return r;
	close(newfdnum);
  801235:	83 ec 0c             	sub    $0xc,%esp
  801238:	ff 75 0c             	pushl  0xc(%ebp)
  80123b:	e8 81 ff ff ff       	call   8011c1 <close>

	newfd = INDEX2FD(newfdnum);
  801240:	8b 75 0c             	mov    0xc(%ebp),%esi
  801243:	c1 e6 0c             	shl    $0xc,%esi
  801246:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801252:	e8 cf fd ff ff       	call   801026 <fd2data>
  801257:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801259:	89 34 24             	mov    %esi,(%esp)
  80125c:	e8 c5 fd ff ff       	call   801026 <fd2data>
  801261:	83 c4 10             	add    $0x10,%esp
  801264:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801266:	89 d8                	mov    %ebx,%eax
  801268:	c1 e8 16             	shr    $0x16,%eax
  80126b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801272:	a8 01                	test   $0x1,%al
  801274:	74 11                	je     801287 <dup+0x74>
  801276:	89 d8                	mov    %ebx,%eax
  801278:	c1 e8 0c             	shr    $0xc,%eax
  80127b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801282:	f6 c2 01             	test   $0x1,%dl
  801285:	75 39                	jne    8012c0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801287:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80128a:	89 d0                	mov    %edx,%eax
  80128c:	c1 e8 0c             	shr    $0xc,%eax
  80128f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801296:	83 ec 0c             	sub    $0xc,%esp
  801299:	25 07 0e 00 00       	and    $0xe07,%eax
  80129e:	50                   	push   %eax
  80129f:	56                   	push   %esi
  8012a0:	6a 00                	push   $0x0
  8012a2:	52                   	push   %edx
  8012a3:	6a 00                	push   $0x0
  8012a5:	e8 da fa ff ff       	call   800d84 <sys_page_map>
  8012aa:	89 c3                	mov    %eax,%ebx
  8012ac:	83 c4 20             	add    $0x20,%esp
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	78 31                	js     8012e4 <dup+0xd1>
		goto err;

	return newfdnum;
  8012b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012b6:	89 d8                	mov    %ebx,%eax
  8012b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012bb:	5b                   	pop    %ebx
  8012bc:	5e                   	pop    %esi
  8012bd:	5f                   	pop    %edi
  8012be:	5d                   	pop    %ebp
  8012bf:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012c0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c7:	83 ec 0c             	sub    $0xc,%esp
  8012ca:	25 07 0e 00 00       	and    $0xe07,%eax
  8012cf:	50                   	push   %eax
  8012d0:	57                   	push   %edi
  8012d1:	6a 00                	push   $0x0
  8012d3:	53                   	push   %ebx
  8012d4:	6a 00                	push   $0x0
  8012d6:	e8 a9 fa ff ff       	call   800d84 <sys_page_map>
  8012db:	89 c3                	mov    %eax,%ebx
  8012dd:	83 c4 20             	add    $0x20,%esp
  8012e0:	85 c0                	test   %eax,%eax
  8012e2:	79 a3                	jns    801287 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	56                   	push   %esi
  8012e8:	6a 00                	push   $0x0
  8012ea:	e8 d7 fa ff ff       	call   800dc6 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012ef:	83 c4 08             	add    $0x8,%esp
  8012f2:	57                   	push   %edi
  8012f3:	6a 00                	push   $0x0
  8012f5:	e8 cc fa ff ff       	call   800dc6 <sys_page_unmap>
	return r;
  8012fa:	83 c4 10             	add    $0x10,%esp
  8012fd:	eb b7                	jmp    8012b6 <dup+0xa3>

008012ff <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	53                   	push   %ebx
  801303:	83 ec 1c             	sub    $0x1c,%esp
  801306:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801309:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80130c:	50                   	push   %eax
  80130d:	53                   	push   %ebx
  80130e:	e8 7c fd ff ff       	call   80108f <fd_lookup>
  801313:	83 c4 10             	add    $0x10,%esp
  801316:	85 c0                	test   %eax,%eax
  801318:	78 3f                	js     801359 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80131a:	83 ec 08             	sub    $0x8,%esp
  80131d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801320:	50                   	push   %eax
  801321:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801324:	ff 30                	pushl  (%eax)
  801326:	e8 b4 fd ff ff       	call   8010df <dev_lookup>
  80132b:	83 c4 10             	add    $0x10,%esp
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 27                	js     801359 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801332:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801335:	8b 42 08             	mov    0x8(%edx),%eax
  801338:	83 e0 03             	and    $0x3,%eax
  80133b:	83 f8 01             	cmp    $0x1,%eax
  80133e:	74 1e                	je     80135e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801343:	8b 40 08             	mov    0x8(%eax),%eax
  801346:	85 c0                	test   %eax,%eax
  801348:	74 35                	je     80137f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80134a:	83 ec 04             	sub    $0x4,%esp
  80134d:	ff 75 10             	pushl  0x10(%ebp)
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	52                   	push   %edx
  801354:	ff d0                	call   *%eax
  801356:	83 c4 10             	add    $0x10,%esp
}
  801359:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80135c:	c9                   	leave  
  80135d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80135e:	a1 08 40 80 00       	mov    0x804008,%eax
  801363:	8b 40 48             	mov    0x48(%eax),%eax
  801366:	83 ec 04             	sub    $0x4,%esp
  801369:	53                   	push   %ebx
  80136a:	50                   	push   %eax
  80136b:	68 d5 29 80 00       	push   $0x8029d5
  801370:	e8 7b ee ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  801375:	83 c4 10             	add    $0x10,%esp
  801378:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80137d:	eb da                	jmp    801359 <read+0x5a>
		return -E_NOT_SUPP;
  80137f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801384:	eb d3                	jmp    801359 <read+0x5a>

00801386 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	57                   	push   %edi
  80138a:	56                   	push   %esi
  80138b:	53                   	push   %ebx
  80138c:	83 ec 0c             	sub    $0xc,%esp
  80138f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801392:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801395:	bb 00 00 00 00       	mov    $0x0,%ebx
  80139a:	39 f3                	cmp    %esi,%ebx
  80139c:	73 23                	jae    8013c1 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139e:	83 ec 04             	sub    $0x4,%esp
  8013a1:	89 f0                	mov    %esi,%eax
  8013a3:	29 d8                	sub    %ebx,%eax
  8013a5:	50                   	push   %eax
  8013a6:	89 d8                	mov    %ebx,%eax
  8013a8:	03 45 0c             	add    0xc(%ebp),%eax
  8013ab:	50                   	push   %eax
  8013ac:	57                   	push   %edi
  8013ad:	e8 4d ff ff ff       	call   8012ff <read>
		if (m < 0)
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 06                	js     8013bf <readn+0x39>
			return m;
		if (m == 0)
  8013b9:	74 06                	je     8013c1 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013bb:	01 c3                	add    %eax,%ebx
  8013bd:	eb db                	jmp    80139a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013bf:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013c1:	89 d8                	mov    %ebx,%eax
  8013c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013c6:	5b                   	pop    %ebx
  8013c7:	5e                   	pop    %esi
  8013c8:	5f                   	pop    %edi
  8013c9:	5d                   	pop    %ebp
  8013ca:	c3                   	ret    

008013cb <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013cb:	55                   	push   %ebp
  8013cc:	89 e5                	mov    %esp,%ebp
  8013ce:	53                   	push   %ebx
  8013cf:	83 ec 1c             	sub    $0x1c,%esp
  8013d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013d5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	53                   	push   %ebx
  8013da:	e8 b0 fc ff ff       	call   80108f <fd_lookup>
  8013df:	83 c4 10             	add    $0x10,%esp
  8013e2:	85 c0                	test   %eax,%eax
  8013e4:	78 3a                	js     801420 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013e6:	83 ec 08             	sub    $0x8,%esp
  8013e9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ec:	50                   	push   %eax
  8013ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f0:	ff 30                	pushl  (%eax)
  8013f2:	e8 e8 fc ff ff       	call   8010df <dev_lookup>
  8013f7:	83 c4 10             	add    $0x10,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 22                	js     801420 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801401:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801405:	74 1e                	je     801425 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801407:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80140a:	8b 52 0c             	mov    0xc(%edx),%edx
  80140d:	85 d2                	test   %edx,%edx
  80140f:	74 35                	je     801446 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801411:	83 ec 04             	sub    $0x4,%esp
  801414:	ff 75 10             	pushl  0x10(%ebp)
  801417:	ff 75 0c             	pushl  0xc(%ebp)
  80141a:	50                   	push   %eax
  80141b:	ff d2                	call   *%edx
  80141d:	83 c4 10             	add    $0x10,%esp
}
  801420:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801423:	c9                   	leave  
  801424:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801425:	a1 08 40 80 00       	mov    0x804008,%eax
  80142a:	8b 40 48             	mov    0x48(%eax),%eax
  80142d:	83 ec 04             	sub    $0x4,%esp
  801430:	53                   	push   %ebx
  801431:	50                   	push   %eax
  801432:	68 f1 29 80 00       	push   $0x8029f1
  801437:	e8 b4 ed ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801444:	eb da                	jmp    801420 <write+0x55>
		return -E_NOT_SUPP;
  801446:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80144b:	eb d3                	jmp    801420 <write+0x55>

0080144d <seek>:

int
seek(int fdnum, off_t offset)
{
  80144d:	55                   	push   %ebp
  80144e:	89 e5                	mov    %esp,%ebp
  801450:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801453:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801456:	50                   	push   %eax
  801457:	ff 75 08             	pushl  0x8(%ebp)
  80145a:	e8 30 fc ff ff       	call   80108f <fd_lookup>
  80145f:	83 c4 10             	add    $0x10,%esp
  801462:	85 c0                	test   %eax,%eax
  801464:	78 0e                	js     801474 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801466:	8b 55 0c             	mov    0xc(%ebp),%edx
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80146f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801474:	c9                   	leave  
  801475:	c3                   	ret    

00801476 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	53                   	push   %ebx
  80147a:	83 ec 1c             	sub    $0x1c,%esp
  80147d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801480:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801483:	50                   	push   %eax
  801484:	53                   	push   %ebx
  801485:	e8 05 fc ff ff       	call   80108f <fd_lookup>
  80148a:	83 c4 10             	add    $0x10,%esp
  80148d:	85 c0                	test   %eax,%eax
  80148f:	78 37                	js     8014c8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801491:	83 ec 08             	sub    $0x8,%esp
  801494:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801497:	50                   	push   %eax
  801498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80149b:	ff 30                	pushl  (%eax)
  80149d:	e8 3d fc ff ff       	call   8010df <dev_lookup>
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	78 1f                	js     8014c8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ac:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014b0:	74 1b                	je     8014cd <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014b2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014b5:	8b 52 18             	mov    0x18(%edx),%edx
  8014b8:	85 d2                	test   %edx,%edx
  8014ba:	74 32                	je     8014ee <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014bc:	83 ec 08             	sub    $0x8,%esp
  8014bf:	ff 75 0c             	pushl  0xc(%ebp)
  8014c2:	50                   	push   %eax
  8014c3:	ff d2                	call   *%edx
  8014c5:	83 c4 10             	add    $0x10,%esp
}
  8014c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cb:	c9                   	leave  
  8014cc:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014cd:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014d2:	8b 40 48             	mov    0x48(%eax),%eax
  8014d5:	83 ec 04             	sub    $0x4,%esp
  8014d8:	53                   	push   %ebx
  8014d9:	50                   	push   %eax
  8014da:	68 b4 29 80 00       	push   $0x8029b4
  8014df:	e8 0c ed ff ff       	call   8001f0 <cprintf>
		return -E_INVAL;
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ec:	eb da                	jmp    8014c8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f3:	eb d3                	jmp    8014c8 <ftruncate+0x52>

008014f5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014f5:	55                   	push   %ebp
  8014f6:	89 e5                	mov    %esp,%ebp
  8014f8:	53                   	push   %ebx
  8014f9:	83 ec 1c             	sub    $0x1c,%esp
  8014fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801502:	50                   	push   %eax
  801503:	ff 75 08             	pushl  0x8(%ebp)
  801506:	e8 84 fb ff ff       	call   80108f <fd_lookup>
  80150b:	83 c4 10             	add    $0x10,%esp
  80150e:	85 c0                	test   %eax,%eax
  801510:	78 4b                	js     80155d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801512:	83 ec 08             	sub    $0x8,%esp
  801515:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801518:	50                   	push   %eax
  801519:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151c:	ff 30                	pushl  (%eax)
  80151e:	e8 bc fb ff ff       	call   8010df <dev_lookup>
  801523:	83 c4 10             	add    $0x10,%esp
  801526:	85 c0                	test   %eax,%eax
  801528:	78 33                	js     80155d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80152a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80152d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801531:	74 2f                	je     801562 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801533:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801536:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80153d:	00 00 00 
	stat->st_isdir = 0;
  801540:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801547:	00 00 00 
	stat->st_dev = dev;
  80154a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801550:	83 ec 08             	sub    $0x8,%esp
  801553:	53                   	push   %ebx
  801554:	ff 75 f0             	pushl  -0x10(%ebp)
  801557:	ff 50 14             	call   *0x14(%eax)
  80155a:	83 c4 10             	add    $0x10,%esp
}
  80155d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801560:	c9                   	leave  
  801561:	c3                   	ret    
		return -E_NOT_SUPP;
  801562:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801567:	eb f4                	jmp    80155d <fstat+0x68>

00801569 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801569:	55                   	push   %ebp
  80156a:	89 e5                	mov    %esp,%ebp
  80156c:	56                   	push   %esi
  80156d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80156e:	83 ec 08             	sub    $0x8,%esp
  801571:	6a 00                	push   $0x0
  801573:	ff 75 08             	pushl  0x8(%ebp)
  801576:	e8 22 02 00 00       	call   80179d <open>
  80157b:	89 c3                	mov    %eax,%ebx
  80157d:	83 c4 10             	add    $0x10,%esp
  801580:	85 c0                	test   %eax,%eax
  801582:	78 1b                	js     80159f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801584:	83 ec 08             	sub    $0x8,%esp
  801587:	ff 75 0c             	pushl  0xc(%ebp)
  80158a:	50                   	push   %eax
  80158b:	e8 65 ff ff ff       	call   8014f5 <fstat>
  801590:	89 c6                	mov    %eax,%esi
	close(fd);
  801592:	89 1c 24             	mov    %ebx,(%esp)
  801595:	e8 27 fc ff ff       	call   8011c1 <close>
	return r;
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	89 f3                	mov    %esi,%ebx
}
  80159f:	89 d8                	mov    %ebx,%eax
  8015a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a4:	5b                   	pop    %ebx
  8015a5:	5e                   	pop    %esi
  8015a6:	5d                   	pop    %ebp
  8015a7:	c3                   	ret    

008015a8 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015a8:	55                   	push   %ebp
  8015a9:	89 e5                	mov    %esp,%ebp
  8015ab:	56                   	push   %esi
  8015ac:	53                   	push   %ebx
  8015ad:	89 c6                	mov    %eax,%esi
  8015af:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015b1:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015b8:	74 27                	je     8015e1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015ba:	6a 07                	push   $0x7
  8015bc:	68 00 50 80 00       	push   $0x805000
  8015c1:	56                   	push   %esi
  8015c2:	ff 35 00 40 80 00    	pushl  0x804000
  8015c8:	e8 69 0c 00 00       	call   802236 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015cd:	83 c4 0c             	add    $0xc,%esp
  8015d0:	6a 00                	push   $0x0
  8015d2:	53                   	push   %ebx
  8015d3:	6a 00                	push   $0x0
  8015d5:	e8 f3 0b 00 00       	call   8021cd <ipc_recv>
}
  8015da:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015dd:	5b                   	pop    %ebx
  8015de:	5e                   	pop    %esi
  8015df:	5d                   	pop    %ebp
  8015e0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015e1:	83 ec 0c             	sub    $0xc,%esp
  8015e4:	6a 01                	push   $0x1
  8015e6:	e8 a3 0c 00 00       	call   80228e <ipc_find_env>
  8015eb:	a3 00 40 80 00       	mov    %eax,0x804000
  8015f0:	83 c4 10             	add    $0x10,%esp
  8015f3:	eb c5                	jmp    8015ba <fsipc+0x12>

008015f5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801601:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801606:	8b 45 0c             	mov    0xc(%ebp),%eax
  801609:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80160e:	ba 00 00 00 00       	mov    $0x0,%edx
  801613:	b8 02 00 00 00       	mov    $0x2,%eax
  801618:	e8 8b ff ff ff       	call   8015a8 <fsipc>
}
  80161d:	c9                   	leave  
  80161e:	c3                   	ret    

0080161f <devfile_flush>:
{
  80161f:	55                   	push   %ebp
  801620:	89 e5                	mov    %esp,%ebp
  801622:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
  801628:	8b 40 0c             	mov    0xc(%eax),%eax
  80162b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801630:	ba 00 00 00 00       	mov    $0x0,%edx
  801635:	b8 06 00 00 00       	mov    $0x6,%eax
  80163a:	e8 69 ff ff ff       	call   8015a8 <fsipc>
}
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <devfile_stat>:
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	53                   	push   %ebx
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8b 40 0c             	mov    0xc(%eax),%eax
  801651:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801656:	ba 00 00 00 00       	mov    $0x0,%edx
  80165b:	b8 05 00 00 00       	mov    $0x5,%eax
  801660:	e8 43 ff ff ff       	call   8015a8 <fsipc>
  801665:	85 c0                	test   %eax,%eax
  801667:	78 2c                	js     801695 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801669:	83 ec 08             	sub    $0x8,%esp
  80166c:	68 00 50 80 00       	push   $0x805000
  801671:	53                   	push   %ebx
  801672:	e8 d8 f2 ff ff       	call   80094f <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801677:	a1 80 50 80 00       	mov    0x805080,%eax
  80167c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801682:	a1 84 50 80 00       	mov    0x805084,%eax
  801687:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80168d:	83 c4 10             	add    $0x10,%esp
  801690:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801698:	c9                   	leave  
  801699:	c3                   	ret    

0080169a <devfile_write>:
{
  80169a:	55                   	push   %ebp
  80169b:	89 e5                	mov    %esp,%ebp
  80169d:	53                   	push   %ebx
  80169e:	83 ec 08             	sub    $0x8,%esp
  8016a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8016aa:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016af:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016b5:	53                   	push   %ebx
  8016b6:	ff 75 0c             	pushl  0xc(%ebp)
  8016b9:	68 08 50 80 00       	push   $0x805008
  8016be:	e8 7c f4 ff ff       	call   800b3f <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c8:	b8 04 00 00 00       	mov    $0x4,%eax
  8016cd:	e8 d6 fe ff ff       	call   8015a8 <fsipc>
  8016d2:	83 c4 10             	add    $0x10,%esp
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	78 0b                	js     8016e4 <devfile_write+0x4a>
	assert(r <= n);
  8016d9:	39 d8                	cmp    %ebx,%eax
  8016db:	77 0c                	ja     8016e9 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  8016dd:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e2:	7f 1e                	jg     801702 <devfile_write+0x68>
}
  8016e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    
	assert(r <= n);
  8016e9:	68 24 2a 80 00       	push   $0x802a24
  8016ee:	68 2b 2a 80 00       	push   $0x802a2b
  8016f3:	68 98 00 00 00       	push   $0x98
  8016f8:	68 40 2a 80 00       	push   $0x802a40
  8016fd:	e8 6a 0a 00 00       	call   80216c <_panic>
	assert(r <= PGSIZE);
  801702:	68 4b 2a 80 00       	push   $0x802a4b
  801707:	68 2b 2a 80 00       	push   $0x802a2b
  80170c:	68 99 00 00 00       	push   $0x99
  801711:	68 40 2a 80 00       	push   $0x802a40
  801716:	e8 51 0a 00 00       	call   80216c <_panic>

0080171b <devfile_read>:
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	56                   	push   %esi
  80171f:	53                   	push   %ebx
  801720:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801723:	8b 45 08             	mov    0x8(%ebp),%eax
  801726:	8b 40 0c             	mov    0xc(%eax),%eax
  801729:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80172e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801734:	ba 00 00 00 00       	mov    $0x0,%edx
  801739:	b8 03 00 00 00       	mov    $0x3,%eax
  80173e:	e8 65 fe ff ff       	call   8015a8 <fsipc>
  801743:	89 c3                	mov    %eax,%ebx
  801745:	85 c0                	test   %eax,%eax
  801747:	78 1f                	js     801768 <devfile_read+0x4d>
	assert(r <= n);
  801749:	39 f0                	cmp    %esi,%eax
  80174b:	77 24                	ja     801771 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80174d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801752:	7f 33                	jg     801787 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801754:	83 ec 04             	sub    $0x4,%esp
  801757:	50                   	push   %eax
  801758:	68 00 50 80 00       	push   $0x805000
  80175d:	ff 75 0c             	pushl  0xc(%ebp)
  801760:	e8 78 f3 ff ff       	call   800add <memmove>
	return r;
  801765:	83 c4 10             	add    $0x10,%esp
}
  801768:	89 d8                	mov    %ebx,%eax
  80176a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80176d:	5b                   	pop    %ebx
  80176e:	5e                   	pop    %esi
  80176f:	5d                   	pop    %ebp
  801770:	c3                   	ret    
	assert(r <= n);
  801771:	68 24 2a 80 00       	push   $0x802a24
  801776:	68 2b 2a 80 00       	push   $0x802a2b
  80177b:	6a 7c                	push   $0x7c
  80177d:	68 40 2a 80 00       	push   $0x802a40
  801782:	e8 e5 09 00 00       	call   80216c <_panic>
	assert(r <= PGSIZE);
  801787:	68 4b 2a 80 00       	push   $0x802a4b
  80178c:	68 2b 2a 80 00       	push   $0x802a2b
  801791:	6a 7d                	push   $0x7d
  801793:	68 40 2a 80 00       	push   $0x802a40
  801798:	e8 cf 09 00 00       	call   80216c <_panic>

0080179d <open>:
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
  8017a0:	56                   	push   %esi
  8017a1:	53                   	push   %ebx
  8017a2:	83 ec 1c             	sub    $0x1c,%esp
  8017a5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017a8:	56                   	push   %esi
  8017a9:	e8 68 f1 ff ff       	call   800916 <strlen>
  8017ae:	83 c4 10             	add    $0x10,%esp
  8017b1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017b6:	7f 6c                	jg     801824 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017b8:	83 ec 0c             	sub    $0xc,%esp
  8017bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017be:	50                   	push   %eax
  8017bf:	e8 79 f8 ff ff       	call   80103d <fd_alloc>
  8017c4:	89 c3                	mov    %eax,%ebx
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	85 c0                	test   %eax,%eax
  8017cb:	78 3c                	js     801809 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017cd:	83 ec 08             	sub    $0x8,%esp
  8017d0:	56                   	push   %esi
  8017d1:	68 00 50 80 00       	push   $0x805000
  8017d6:	e8 74 f1 ff ff       	call   80094f <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017de:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017e6:	b8 01 00 00 00       	mov    $0x1,%eax
  8017eb:	e8 b8 fd ff ff       	call   8015a8 <fsipc>
  8017f0:	89 c3                	mov    %eax,%ebx
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 19                	js     801812 <open+0x75>
	return fd2num(fd);
  8017f9:	83 ec 0c             	sub    $0xc,%esp
  8017fc:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ff:	e8 12 f8 ff ff       	call   801016 <fd2num>
  801804:	89 c3                	mov    %eax,%ebx
  801806:	83 c4 10             	add    $0x10,%esp
}
  801809:	89 d8                	mov    %ebx,%eax
  80180b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180e:	5b                   	pop    %ebx
  80180f:	5e                   	pop    %esi
  801810:	5d                   	pop    %ebp
  801811:	c3                   	ret    
		fd_close(fd, 0);
  801812:	83 ec 08             	sub    $0x8,%esp
  801815:	6a 00                	push   $0x0
  801817:	ff 75 f4             	pushl  -0xc(%ebp)
  80181a:	e8 1b f9 ff ff       	call   80113a <fd_close>
		return r;
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	eb e5                	jmp    801809 <open+0x6c>
		return -E_BAD_PATH;
  801824:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801829:	eb de                	jmp    801809 <open+0x6c>

0080182b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80182b:	55                   	push   %ebp
  80182c:	89 e5                	mov    %esp,%ebp
  80182e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801831:	ba 00 00 00 00       	mov    $0x0,%edx
  801836:	b8 08 00 00 00       	mov    $0x8,%eax
  80183b:	e8 68 fd ff ff       	call   8015a8 <fsipc>
}
  801840:	c9                   	leave  
  801841:	c3                   	ret    

00801842 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801848:	68 57 2a 80 00       	push   $0x802a57
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	e8 fa f0 ff ff       	call   80094f <strcpy>
	return 0;
}
  801855:	b8 00 00 00 00       	mov    $0x0,%eax
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    

0080185c <devsock_close>:
{
  80185c:	55                   	push   %ebp
  80185d:	89 e5                	mov    %esp,%ebp
  80185f:	53                   	push   %ebx
  801860:	83 ec 10             	sub    $0x10,%esp
  801863:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801866:	53                   	push   %ebx
  801867:	e8 5d 0a 00 00       	call   8022c9 <pageref>
  80186c:	83 c4 10             	add    $0x10,%esp
		return 0;
  80186f:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  801874:	83 f8 01             	cmp    $0x1,%eax
  801877:	74 07                	je     801880 <devsock_close+0x24>
}
  801879:	89 d0                	mov    %edx,%eax
  80187b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801880:	83 ec 0c             	sub    $0xc,%esp
  801883:	ff 73 0c             	pushl  0xc(%ebx)
  801886:	e8 b9 02 00 00       	call   801b44 <nsipc_close>
  80188b:	89 c2                	mov    %eax,%edx
  80188d:	83 c4 10             	add    $0x10,%esp
  801890:	eb e7                	jmp    801879 <devsock_close+0x1d>

00801892 <devsock_write>:
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
  801895:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801898:	6a 00                	push   $0x0
  80189a:	ff 75 10             	pushl  0x10(%ebp)
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	ff 70 0c             	pushl  0xc(%eax)
  8018a6:	e8 76 03 00 00       	call   801c21 <nsipc_send>
}
  8018ab:	c9                   	leave  
  8018ac:	c3                   	ret    

008018ad <devsock_read>:
{
  8018ad:	55                   	push   %ebp
  8018ae:	89 e5                	mov    %esp,%ebp
  8018b0:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 10             	pushl  0x10(%ebp)
  8018b8:	ff 75 0c             	pushl  0xc(%ebp)
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	ff 70 0c             	pushl  0xc(%eax)
  8018c1:	e8 ef 02 00 00       	call   801bb5 <nsipc_recv>
}
  8018c6:	c9                   	leave  
  8018c7:	c3                   	ret    

008018c8 <fd2sockid>:
{
  8018c8:	55                   	push   %ebp
  8018c9:	89 e5                	mov    %esp,%ebp
  8018cb:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018ce:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018d1:	52                   	push   %edx
  8018d2:	50                   	push   %eax
  8018d3:	e8 b7 f7 ff ff       	call   80108f <fd_lookup>
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	85 c0                	test   %eax,%eax
  8018dd:	78 10                	js     8018ef <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  8018df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e2:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  8018e8:	39 08                	cmp    %ecx,(%eax)
  8018ea:	75 05                	jne    8018f1 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  8018ec:	8b 40 0c             	mov    0xc(%eax),%eax
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8018f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f6:	eb f7                	jmp    8018ef <fd2sockid+0x27>

008018f8 <alloc_sockfd>:
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
  8018fd:	83 ec 1c             	sub    $0x1c,%esp
  801900:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801902:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801905:	50                   	push   %eax
  801906:	e8 32 f7 ff ff       	call   80103d <fd_alloc>
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	83 c4 10             	add    $0x10,%esp
  801910:	85 c0                	test   %eax,%eax
  801912:	78 43                	js     801957 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 07 04 00 00       	push   $0x407
  80191c:	ff 75 f4             	pushl  -0xc(%ebp)
  80191f:	6a 00                	push   $0x0
  801921:	e8 1b f4 ff ff       	call   800d41 <sys_page_alloc>
  801926:	89 c3                	mov    %eax,%ebx
  801928:	83 c4 10             	add    $0x10,%esp
  80192b:	85 c0                	test   %eax,%eax
  80192d:	78 28                	js     801957 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80192f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801932:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801938:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80193a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80193d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801944:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801947:	83 ec 0c             	sub    $0xc,%esp
  80194a:	50                   	push   %eax
  80194b:	e8 c6 f6 ff ff       	call   801016 <fd2num>
  801950:	89 c3                	mov    %eax,%ebx
  801952:	83 c4 10             	add    $0x10,%esp
  801955:	eb 0c                	jmp    801963 <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801957:	83 ec 0c             	sub    $0xc,%esp
  80195a:	56                   	push   %esi
  80195b:	e8 e4 01 00 00       	call   801b44 <nsipc_close>
		return r;
  801960:	83 c4 10             	add    $0x10,%esp
}
  801963:	89 d8                	mov    %ebx,%eax
  801965:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801968:	5b                   	pop    %ebx
  801969:	5e                   	pop    %esi
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <accept>:
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801972:	8b 45 08             	mov    0x8(%ebp),%eax
  801975:	e8 4e ff ff ff       	call   8018c8 <fd2sockid>
  80197a:	85 c0                	test   %eax,%eax
  80197c:	78 1b                	js     801999 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	ff 75 10             	pushl  0x10(%ebp)
  801984:	ff 75 0c             	pushl  0xc(%ebp)
  801987:	50                   	push   %eax
  801988:	e8 0e 01 00 00       	call   801a9b <nsipc_accept>
  80198d:	83 c4 10             	add    $0x10,%esp
  801990:	85 c0                	test   %eax,%eax
  801992:	78 05                	js     801999 <accept+0x2d>
	return alloc_sockfd(r);
  801994:	e8 5f ff ff ff       	call   8018f8 <alloc_sockfd>
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <bind>:
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	e8 1f ff ff ff       	call   8018c8 <fd2sockid>
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	78 12                	js     8019bf <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	ff 75 10             	pushl  0x10(%ebp)
  8019b3:	ff 75 0c             	pushl  0xc(%ebp)
  8019b6:	50                   	push   %eax
  8019b7:	e8 31 01 00 00       	call   801aed <nsipc_bind>
  8019bc:	83 c4 10             	add    $0x10,%esp
}
  8019bf:	c9                   	leave  
  8019c0:	c3                   	ret    

008019c1 <shutdown>:
{
  8019c1:	55                   	push   %ebp
  8019c2:	89 e5                	mov    %esp,%ebp
  8019c4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ca:	e8 f9 fe ff ff       	call   8018c8 <fd2sockid>
  8019cf:	85 c0                	test   %eax,%eax
  8019d1:	78 0f                	js     8019e2 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019d3:	83 ec 08             	sub    $0x8,%esp
  8019d6:	ff 75 0c             	pushl  0xc(%ebp)
  8019d9:	50                   	push   %eax
  8019da:	e8 43 01 00 00       	call   801b22 <nsipc_shutdown>
  8019df:	83 c4 10             	add    $0x10,%esp
}
  8019e2:	c9                   	leave  
  8019e3:	c3                   	ret    

008019e4 <connect>:
{
  8019e4:	55                   	push   %ebp
  8019e5:	89 e5                	mov    %esp,%ebp
  8019e7:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	e8 d6 fe ff ff       	call   8018c8 <fd2sockid>
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	78 12                	js     801a08 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  8019f6:	83 ec 04             	sub    $0x4,%esp
  8019f9:	ff 75 10             	pushl  0x10(%ebp)
  8019fc:	ff 75 0c             	pushl  0xc(%ebp)
  8019ff:	50                   	push   %eax
  801a00:	e8 59 01 00 00       	call   801b5e <nsipc_connect>
  801a05:	83 c4 10             	add    $0x10,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <listen>:
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	e8 b0 fe ff ff       	call   8018c8 <fd2sockid>
  801a18:	85 c0                	test   %eax,%eax
  801a1a:	78 0f                	js     801a2b <listen+0x21>
	return nsipc_listen(r, backlog);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	50                   	push   %eax
  801a23:	e8 6b 01 00 00       	call   801b93 <nsipc_listen>
  801a28:	83 c4 10             	add    $0x10,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <socket>:

int
socket(int domain, int type, int protocol)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
  801a30:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a33:	ff 75 10             	pushl  0x10(%ebp)
  801a36:	ff 75 0c             	pushl  0xc(%ebp)
  801a39:	ff 75 08             	pushl  0x8(%ebp)
  801a3c:	e8 3e 02 00 00       	call   801c7f <nsipc_socket>
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 05                	js     801a4d <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a48:	e8 ab fe ff ff       	call   8018f8 <alloc_sockfd>
}
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
  801a52:	53                   	push   %ebx
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a58:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a5f:	74 26                	je     801a87 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a61:	6a 07                	push   $0x7
  801a63:	68 00 60 80 00       	push   $0x806000
  801a68:	53                   	push   %ebx
  801a69:	ff 35 04 40 80 00    	pushl  0x804004
  801a6f:	e8 c2 07 00 00       	call   802236 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a74:	83 c4 0c             	add    $0xc,%esp
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	e8 4b 07 00 00       	call   8021cd <ipc_recv>
}
  801a82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a87:	83 ec 0c             	sub    $0xc,%esp
  801a8a:	6a 02                	push   $0x2
  801a8c:	e8 fd 07 00 00       	call   80228e <ipc_find_env>
  801a91:	a3 04 40 80 00       	mov    %eax,0x804004
  801a96:	83 c4 10             	add    $0x10,%esp
  801a99:	eb c6                	jmp    801a61 <nsipc+0x12>

00801a9b <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	56                   	push   %esi
  801a9f:	53                   	push   %ebx
  801aa0:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa6:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801aab:	8b 06                	mov    (%esi),%eax
  801aad:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ab2:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab7:	e8 93 ff ff ff       	call   801a4f <nsipc>
  801abc:	89 c3                	mov    %eax,%ebx
  801abe:	85 c0                	test   %eax,%eax
  801ac0:	79 09                	jns    801acb <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801ac2:	89 d8                	mov    %ebx,%eax
  801ac4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac7:	5b                   	pop    %ebx
  801ac8:	5e                   	pop    %esi
  801ac9:	5d                   	pop    %ebp
  801aca:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	ff 35 10 60 80 00    	pushl  0x806010
  801ad4:	68 00 60 80 00       	push   $0x806000
  801ad9:	ff 75 0c             	pushl  0xc(%ebp)
  801adc:	e8 fc ef ff ff       	call   800add <memmove>
		*addrlen = ret->ret_addrlen;
  801ae1:	a1 10 60 80 00       	mov    0x806010,%eax
  801ae6:	89 06                	mov    %eax,(%esi)
  801ae8:	83 c4 10             	add    $0x10,%esp
	return r;
  801aeb:	eb d5                	jmp    801ac2 <nsipc_accept+0x27>

00801aed <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	53                   	push   %ebx
  801af1:	83 ec 08             	sub    $0x8,%esp
  801af4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aff:	53                   	push   %ebx
  801b00:	ff 75 0c             	pushl  0xc(%ebp)
  801b03:	68 04 60 80 00       	push   $0x806004
  801b08:	e8 d0 ef ff ff       	call   800add <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b0d:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b13:	b8 02 00 00 00       	mov    $0x2,%eax
  801b18:	e8 32 ff ff ff       	call   801a4f <nsipc>
}
  801b1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b30:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b33:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b38:	b8 03 00 00 00       	mov    $0x3,%eax
  801b3d:	e8 0d ff ff ff       	call   801a4f <nsipc>
}
  801b42:	c9                   	leave  
  801b43:	c3                   	ret    

00801b44 <nsipc_close>:

int
nsipc_close(int s)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4d:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b52:	b8 04 00 00 00       	mov    $0x4,%eax
  801b57:	e8 f3 fe ff ff       	call   801a4f <nsipc>
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
  801b61:	53                   	push   %ebx
  801b62:	83 ec 08             	sub    $0x8,%esp
  801b65:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b70:	53                   	push   %ebx
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	68 04 60 80 00       	push   $0x806004
  801b79:	e8 5f ef ff ff       	call   800add <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b7e:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b84:	b8 05 00 00 00       	mov    $0x5,%eax
  801b89:	e8 c1 fe ff ff       	call   801a4f <nsipc>
}
  801b8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b91:	c9                   	leave  
  801b92:	c3                   	ret    

00801b93 <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b93:	55                   	push   %ebp
  801b94:	89 e5                	mov    %esp,%ebp
  801b96:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba4:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801ba9:	b8 06 00 00 00       	mov    $0x6,%eax
  801bae:	e8 9c fe ff ff       	call   801a4f <nsipc>
}
  801bb3:	c9                   	leave  
  801bb4:	c3                   	ret    

00801bb5 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	56                   	push   %esi
  801bb9:	53                   	push   %ebx
  801bba:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc0:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bc5:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bcb:	8b 45 14             	mov    0x14(%ebp),%eax
  801bce:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bd3:	b8 07 00 00 00       	mov    $0x7,%eax
  801bd8:	e8 72 fe ff ff       	call   801a4f <nsipc>
  801bdd:	89 c3                	mov    %eax,%ebx
  801bdf:	85 c0                	test   %eax,%eax
  801be1:	78 1f                	js     801c02 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801be3:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801be8:	7f 21                	jg     801c0b <nsipc_recv+0x56>
  801bea:	39 c6                	cmp    %eax,%esi
  801bec:	7c 1d                	jl     801c0b <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801bee:	83 ec 04             	sub    $0x4,%esp
  801bf1:	50                   	push   %eax
  801bf2:	68 00 60 80 00       	push   $0x806000
  801bf7:	ff 75 0c             	pushl  0xc(%ebp)
  801bfa:	e8 de ee ff ff       	call   800add <memmove>
  801bff:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c02:	89 d8                	mov    %ebx,%eax
  801c04:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5d                   	pop    %ebp
  801c0a:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c0b:	68 63 2a 80 00       	push   $0x802a63
  801c10:	68 2b 2a 80 00       	push   $0x802a2b
  801c15:	6a 62                	push   $0x62
  801c17:	68 78 2a 80 00       	push   $0x802a78
  801c1c:	e8 4b 05 00 00       	call   80216c <_panic>

00801c21 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	53                   	push   %ebx
  801c25:	83 ec 04             	sub    $0x4,%esp
  801c28:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c33:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c39:	7f 2e                	jg     801c69 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c3b:	83 ec 04             	sub    $0x4,%esp
  801c3e:	53                   	push   %ebx
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	68 0c 60 80 00       	push   $0x80600c
  801c47:	e8 91 ee ff ff       	call   800add <memmove>
	nsipcbuf.send.req_size = size;
  801c4c:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c52:	8b 45 14             	mov    0x14(%ebp),%eax
  801c55:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c5a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c5f:	e8 eb fd ff ff       	call   801a4f <nsipc>
}
  801c64:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    
	assert(size < 1600);
  801c69:	68 84 2a 80 00       	push   $0x802a84
  801c6e:	68 2b 2a 80 00       	push   $0x802a2b
  801c73:	6a 6d                	push   $0x6d
  801c75:	68 78 2a 80 00       	push   $0x802a78
  801c7a:	e8 ed 04 00 00       	call   80216c <_panic>

00801c7f <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c90:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c95:	8b 45 10             	mov    0x10(%ebp),%eax
  801c98:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c9d:	b8 09 00 00 00       	mov    $0x9,%eax
  801ca2:	e8 a8 fd ff ff       	call   801a4f <nsipc>
}
  801ca7:	c9                   	leave  
  801ca8:	c3                   	ret    

00801ca9 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ca9:	55                   	push   %ebp
  801caa:	89 e5                	mov    %esp,%ebp
  801cac:	56                   	push   %esi
  801cad:	53                   	push   %ebx
  801cae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cb1:	83 ec 0c             	sub    $0xc,%esp
  801cb4:	ff 75 08             	pushl  0x8(%ebp)
  801cb7:	e8 6a f3 ff ff       	call   801026 <fd2data>
  801cbc:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cbe:	83 c4 08             	add    $0x8,%esp
  801cc1:	68 90 2a 80 00       	push   $0x802a90
  801cc6:	53                   	push   %ebx
  801cc7:	e8 83 ec ff ff       	call   80094f <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801ccc:	8b 46 04             	mov    0x4(%esi),%eax
  801ccf:	2b 06                	sub    (%esi),%eax
  801cd1:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801cd7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801cde:	00 00 00 
	stat->st_dev = &devpipe;
  801ce1:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801ce8:	30 80 00 
	return 0;
}
  801ceb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cf3:	5b                   	pop    %ebx
  801cf4:	5e                   	pop    %esi
  801cf5:	5d                   	pop    %ebp
  801cf6:	c3                   	ret    

00801cf7 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
  801cfa:	53                   	push   %ebx
  801cfb:	83 ec 0c             	sub    $0xc,%esp
  801cfe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d01:	53                   	push   %ebx
  801d02:	6a 00                	push   $0x0
  801d04:	e8 bd f0 ff ff       	call   800dc6 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d09:	89 1c 24             	mov    %ebx,(%esp)
  801d0c:	e8 15 f3 ff ff       	call   801026 <fd2data>
  801d11:	83 c4 08             	add    $0x8,%esp
  801d14:	50                   	push   %eax
  801d15:	6a 00                	push   $0x0
  801d17:	e8 aa f0 ff ff       	call   800dc6 <sys_page_unmap>
}
  801d1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d1f:	c9                   	leave  
  801d20:	c3                   	ret    

00801d21 <_pipeisclosed>:
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
  801d24:	57                   	push   %edi
  801d25:	56                   	push   %esi
  801d26:	53                   	push   %ebx
  801d27:	83 ec 1c             	sub    $0x1c,%esp
  801d2a:	89 c7                	mov    %eax,%edi
  801d2c:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d2e:	a1 08 40 80 00       	mov    0x804008,%eax
  801d33:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d36:	83 ec 0c             	sub    $0xc,%esp
  801d39:	57                   	push   %edi
  801d3a:	e8 8a 05 00 00       	call   8022c9 <pageref>
  801d3f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d42:	89 34 24             	mov    %esi,(%esp)
  801d45:	e8 7f 05 00 00       	call   8022c9 <pageref>
		nn = thisenv->env_runs;
  801d4a:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d50:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d53:	83 c4 10             	add    $0x10,%esp
  801d56:	39 cb                	cmp    %ecx,%ebx
  801d58:	74 1b                	je     801d75 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d5a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d5d:	75 cf                	jne    801d2e <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d5f:	8b 42 58             	mov    0x58(%edx),%eax
  801d62:	6a 01                	push   $0x1
  801d64:	50                   	push   %eax
  801d65:	53                   	push   %ebx
  801d66:	68 97 2a 80 00       	push   $0x802a97
  801d6b:	e8 80 e4 ff ff       	call   8001f0 <cprintf>
  801d70:	83 c4 10             	add    $0x10,%esp
  801d73:	eb b9                	jmp    801d2e <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d75:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d78:	0f 94 c0             	sete   %al
  801d7b:	0f b6 c0             	movzbl %al,%eax
}
  801d7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d81:	5b                   	pop    %ebx
  801d82:	5e                   	pop    %esi
  801d83:	5f                   	pop    %edi
  801d84:	5d                   	pop    %ebp
  801d85:	c3                   	ret    

00801d86 <devpipe_write>:
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	57                   	push   %edi
  801d8a:	56                   	push   %esi
  801d8b:	53                   	push   %ebx
  801d8c:	83 ec 28             	sub    $0x28,%esp
  801d8f:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d92:	56                   	push   %esi
  801d93:	e8 8e f2 ff ff       	call   801026 <fd2data>
  801d98:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d9a:	83 c4 10             	add    $0x10,%esp
  801d9d:	bf 00 00 00 00       	mov    $0x0,%edi
  801da2:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801da5:	74 4f                	je     801df6 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801da7:	8b 43 04             	mov    0x4(%ebx),%eax
  801daa:	8b 0b                	mov    (%ebx),%ecx
  801dac:	8d 51 20             	lea    0x20(%ecx),%edx
  801daf:	39 d0                	cmp    %edx,%eax
  801db1:	72 14                	jb     801dc7 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801db3:	89 da                	mov    %ebx,%edx
  801db5:	89 f0                	mov    %esi,%eax
  801db7:	e8 65 ff ff ff       	call   801d21 <_pipeisclosed>
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	75 3b                	jne    801dfb <devpipe_write+0x75>
			sys_yield();
  801dc0:	e8 5d ef ff ff       	call   800d22 <sys_yield>
  801dc5:	eb e0                	jmp    801da7 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801dc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dca:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dce:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dd1:	89 c2                	mov    %eax,%edx
  801dd3:	c1 fa 1f             	sar    $0x1f,%edx
  801dd6:	89 d1                	mov    %edx,%ecx
  801dd8:	c1 e9 1b             	shr    $0x1b,%ecx
  801ddb:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801dde:	83 e2 1f             	and    $0x1f,%edx
  801de1:	29 ca                	sub    %ecx,%edx
  801de3:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801de7:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801deb:	83 c0 01             	add    $0x1,%eax
  801dee:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801df1:	83 c7 01             	add    $0x1,%edi
  801df4:	eb ac                	jmp    801da2 <devpipe_write+0x1c>
	return i;
  801df6:	8b 45 10             	mov    0x10(%ebp),%eax
  801df9:	eb 05                	jmp    801e00 <devpipe_write+0x7a>
				return 0;
  801dfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e03:	5b                   	pop    %ebx
  801e04:	5e                   	pop    %esi
  801e05:	5f                   	pop    %edi
  801e06:	5d                   	pop    %ebp
  801e07:	c3                   	ret    

00801e08 <devpipe_read>:
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	57                   	push   %edi
  801e0c:	56                   	push   %esi
  801e0d:	53                   	push   %ebx
  801e0e:	83 ec 18             	sub    $0x18,%esp
  801e11:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e14:	57                   	push   %edi
  801e15:	e8 0c f2 ff ff       	call   801026 <fd2data>
  801e1a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e1c:	83 c4 10             	add    $0x10,%esp
  801e1f:	be 00 00 00 00       	mov    $0x0,%esi
  801e24:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e27:	75 14                	jne    801e3d <devpipe_read+0x35>
	return i;
  801e29:	8b 45 10             	mov    0x10(%ebp),%eax
  801e2c:	eb 02                	jmp    801e30 <devpipe_read+0x28>
				return i;
  801e2e:	89 f0                	mov    %esi,%eax
}
  801e30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e33:	5b                   	pop    %ebx
  801e34:	5e                   	pop    %esi
  801e35:	5f                   	pop    %edi
  801e36:	5d                   	pop    %ebp
  801e37:	c3                   	ret    
			sys_yield();
  801e38:	e8 e5 ee ff ff       	call   800d22 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e3d:	8b 03                	mov    (%ebx),%eax
  801e3f:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e42:	75 18                	jne    801e5c <devpipe_read+0x54>
			if (i > 0)
  801e44:	85 f6                	test   %esi,%esi
  801e46:	75 e6                	jne    801e2e <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e48:	89 da                	mov    %ebx,%edx
  801e4a:	89 f8                	mov    %edi,%eax
  801e4c:	e8 d0 fe ff ff       	call   801d21 <_pipeisclosed>
  801e51:	85 c0                	test   %eax,%eax
  801e53:	74 e3                	je     801e38 <devpipe_read+0x30>
				return 0;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
  801e5a:	eb d4                	jmp    801e30 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e5c:	99                   	cltd   
  801e5d:	c1 ea 1b             	shr    $0x1b,%edx
  801e60:	01 d0                	add    %edx,%eax
  801e62:	83 e0 1f             	and    $0x1f,%eax
  801e65:	29 d0                	sub    %edx,%eax
  801e67:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e6f:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e72:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e75:	83 c6 01             	add    $0x1,%esi
  801e78:	eb aa                	jmp    801e24 <devpipe_read+0x1c>

00801e7a <pipe>:
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	56                   	push   %esi
  801e7e:	53                   	push   %ebx
  801e7f:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e85:	50                   	push   %eax
  801e86:	e8 b2 f1 ff ff       	call   80103d <fd_alloc>
  801e8b:	89 c3                	mov    %eax,%ebx
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	85 c0                	test   %eax,%eax
  801e92:	0f 88 23 01 00 00    	js     801fbb <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e98:	83 ec 04             	sub    $0x4,%esp
  801e9b:	68 07 04 00 00       	push   $0x407
  801ea0:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea3:	6a 00                	push   $0x0
  801ea5:	e8 97 ee ff ff       	call   800d41 <sys_page_alloc>
  801eaa:	89 c3                	mov    %eax,%ebx
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	0f 88 04 01 00 00    	js     801fbb <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801eb7:	83 ec 0c             	sub    $0xc,%esp
  801eba:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ebd:	50                   	push   %eax
  801ebe:	e8 7a f1 ff ff       	call   80103d <fd_alloc>
  801ec3:	89 c3                	mov    %eax,%ebx
  801ec5:	83 c4 10             	add    $0x10,%esp
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	0f 88 db 00 00 00    	js     801fab <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ed0:	83 ec 04             	sub    $0x4,%esp
  801ed3:	68 07 04 00 00       	push   $0x407
  801ed8:	ff 75 f0             	pushl  -0x10(%ebp)
  801edb:	6a 00                	push   $0x0
  801edd:	e8 5f ee ff ff       	call   800d41 <sys_page_alloc>
  801ee2:	89 c3                	mov    %eax,%ebx
  801ee4:	83 c4 10             	add    $0x10,%esp
  801ee7:	85 c0                	test   %eax,%eax
  801ee9:	0f 88 bc 00 00 00    	js     801fab <pipe+0x131>
	va = fd2data(fd0);
  801eef:	83 ec 0c             	sub    $0xc,%esp
  801ef2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ef5:	e8 2c f1 ff ff       	call   801026 <fd2data>
  801efa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efc:	83 c4 0c             	add    $0xc,%esp
  801eff:	68 07 04 00 00       	push   $0x407
  801f04:	50                   	push   %eax
  801f05:	6a 00                	push   $0x0
  801f07:	e8 35 ee ff ff       	call   800d41 <sys_page_alloc>
  801f0c:	89 c3                	mov    %eax,%ebx
  801f0e:	83 c4 10             	add    $0x10,%esp
  801f11:	85 c0                	test   %eax,%eax
  801f13:	0f 88 82 00 00 00    	js     801f9b <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f19:	83 ec 0c             	sub    $0xc,%esp
  801f1c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1f:	e8 02 f1 ff ff       	call   801026 <fd2data>
  801f24:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f2b:	50                   	push   %eax
  801f2c:	6a 00                	push   $0x0
  801f2e:	56                   	push   %esi
  801f2f:	6a 00                	push   $0x0
  801f31:	e8 4e ee ff ff       	call   800d84 <sys_page_map>
  801f36:	89 c3                	mov    %eax,%ebx
  801f38:	83 c4 20             	add    $0x20,%esp
  801f3b:	85 c0                	test   %eax,%eax
  801f3d:	78 4e                	js     801f8d <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f3f:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f44:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f47:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f49:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f4c:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f56:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f58:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f5b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f62:	83 ec 0c             	sub    $0xc,%esp
  801f65:	ff 75 f4             	pushl  -0xc(%ebp)
  801f68:	e8 a9 f0 ff ff       	call   801016 <fd2num>
  801f6d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f70:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f72:	83 c4 04             	add    $0x4,%esp
  801f75:	ff 75 f0             	pushl  -0x10(%ebp)
  801f78:	e8 99 f0 ff ff       	call   801016 <fd2num>
  801f7d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f80:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f8b:	eb 2e                	jmp    801fbb <pipe+0x141>
	sys_page_unmap(0, va);
  801f8d:	83 ec 08             	sub    $0x8,%esp
  801f90:	56                   	push   %esi
  801f91:	6a 00                	push   $0x0
  801f93:	e8 2e ee ff ff       	call   800dc6 <sys_page_unmap>
  801f98:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa1:	6a 00                	push   $0x0
  801fa3:	e8 1e ee ff ff       	call   800dc6 <sys_page_unmap>
  801fa8:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fab:	83 ec 08             	sub    $0x8,%esp
  801fae:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb1:	6a 00                	push   $0x0
  801fb3:	e8 0e ee ff ff       	call   800dc6 <sys_page_unmap>
  801fb8:	83 c4 10             	add    $0x10,%esp
}
  801fbb:	89 d8                	mov    %ebx,%eax
  801fbd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fc0:	5b                   	pop    %ebx
  801fc1:	5e                   	pop    %esi
  801fc2:	5d                   	pop    %ebp
  801fc3:	c3                   	ret    

00801fc4 <pipeisclosed>:
{
  801fc4:	55                   	push   %ebp
  801fc5:	89 e5                	mov    %esp,%ebp
  801fc7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801fca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fcd:	50                   	push   %eax
  801fce:	ff 75 08             	pushl  0x8(%ebp)
  801fd1:	e8 b9 f0 ff ff       	call   80108f <fd_lookup>
  801fd6:	83 c4 10             	add    $0x10,%esp
  801fd9:	85 c0                	test   %eax,%eax
  801fdb:	78 18                	js     801ff5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	ff 75 f4             	pushl  -0xc(%ebp)
  801fe3:	e8 3e f0 ff ff       	call   801026 <fd2data>
	return _pipeisclosed(fd, p);
  801fe8:	89 c2                	mov    %eax,%edx
  801fea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fed:	e8 2f fd ff ff       	call   801d21 <_pipeisclosed>
  801ff2:	83 c4 10             	add    $0x10,%esp
}
  801ff5:	c9                   	leave  
  801ff6:	c3                   	ret    

00801ff7 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801ff7:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffc:	c3                   	ret    

00801ffd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  802003:	68 af 2a 80 00       	push   $0x802aaf
  802008:	ff 75 0c             	pushl  0xc(%ebp)
  80200b:	e8 3f e9 ff ff       	call   80094f <strcpy>
	return 0;
}
  802010:	b8 00 00 00 00       	mov    $0x0,%eax
  802015:	c9                   	leave  
  802016:	c3                   	ret    

00802017 <devcons_write>:
{
  802017:	55                   	push   %ebp
  802018:	89 e5                	mov    %esp,%ebp
  80201a:	57                   	push   %edi
  80201b:	56                   	push   %esi
  80201c:	53                   	push   %ebx
  80201d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802023:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802028:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80202e:	3b 75 10             	cmp    0x10(%ebp),%esi
  802031:	73 31                	jae    802064 <devcons_write+0x4d>
		m = n - tot;
  802033:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802036:	29 f3                	sub    %esi,%ebx
  802038:	83 fb 7f             	cmp    $0x7f,%ebx
  80203b:	b8 7f 00 00 00       	mov    $0x7f,%eax
  802040:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  802043:	83 ec 04             	sub    $0x4,%esp
  802046:	53                   	push   %ebx
  802047:	89 f0                	mov    %esi,%eax
  802049:	03 45 0c             	add    0xc(%ebp),%eax
  80204c:	50                   	push   %eax
  80204d:	57                   	push   %edi
  80204e:	e8 8a ea ff ff       	call   800add <memmove>
		sys_cputs(buf, m);
  802053:	83 c4 08             	add    $0x8,%esp
  802056:	53                   	push   %ebx
  802057:	57                   	push   %edi
  802058:	e8 28 ec ff ff       	call   800c85 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80205d:	01 de                	add    %ebx,%esi
  80205f:	83 c4 10             	add    $0x10,%esp
  802062:	eb ca                	jmp    80202e <devcons_write+0x17>
}
  802064:	89 f0                	mov    %esi,%eax
  802066:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802069:	5b                   	pop    %ebx
  80206a:	5e                   	pop    %esi
  80206b:	5f                   	pop    %edi
  80206c:	5d                   	pop    %ebp
  80206d:	c3                   	ret    

0080206e <devcons_read>:
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
  802074:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802079:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80207d:	74 21                	je     8020a0 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  80207f:	e8 1f ec ff ff       	call   800ca3 <sys_cgetc>
  802084:	85 c0                	test   %eax,%eax
  802086:	75 07                	jne    80208f <devcons_read+0x21>
		sys_yield();
  802088:	e8 95 ec ff ff       	call   800d22 <sys_yield>
  80208d:	eb f0                	jmp    80207f <devcons_read+0x11>
	if (c < 0)
  80208f:	78 0f                	js     8020a0 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802091:	83 f8 04             	cmp    $0x4,%eax
  802094:	74 0c                	je     8020a2 <devcons_read+0x34>
	*(char*)vbuf = c;
  802096:	8b 55 0c             	mov    0xc(%ebp),%edx
  802099:	88 02                	mov    %al,(%edx)
	return 1;
  80209b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020a0:	c9                   	leave  
  8020a1:	c3                   	ret    
		return 0;
  8020a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a7:	eb f7                	jmp    8020a0 <devcons_read+0x32>

008020a9 <cputchar>:
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
  8020ac:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020b5:	6a 01                	push   $0x1
  8020b7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020ba:	50                   	push   %eax
  8020bb:	e8 c5 eb ff ff       	call   800c85 <sys_cputs>
}
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	c9                   	leave  
  8020c4:	c3                   	ret    

008020c5 <getchar>:
{
  8020c5:	55                   	push   %ebp
  8020c6:	89 e5                	mov    %esp,%ebp
  8020c8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020cb:	6a 01                	push   $0x1
  8020cd:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020d0:	50                   	push   %eax
  8020d1:	6a 00                	push   $0x0
  8020d3:	e8 27 f2 ff ff       	call   8012ff <read>
	if (r < 0)
  8020d8:	83 c4 10             	add    $0x10,%esp
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	78 06                	js     8020e5 <getchar+0x20>
	if (r < 1)
  8020df:	74 06                	je     8020e7 <getchar+0x22>
	return c;
  8020e1:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8020e5:	c9                   	leave  
  8020e6:	c3                   	ret    
		return -E_EOF;
  8020e7:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8020ec:	eb f7                	jmp    8020e5 <getchar+0x20>

008020ee <iscons>:
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020f7:	50                   	push   %eax
  8020f8:	ff 75 08             	pushl  0x8(%ebp)
  8020fb:	e8 8f ef ff ff       	call   80108f <fd_lookup>
  802100:	83 c4 10             	add    $0x10,%esp
  802103:	85 c0                	test   %eax,%eax
  802105:	78 11                	js     802118 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802110:	39 10                	cmp    %edx,(%eax)
  802112:	0f 94 c0             	sete   %al
  802115:	0f b6 c0             	movzbl %al,%eax
}
  802118:	c9                   	leave  
  802119:	c3                   	ret    

0080211a <opencons>:
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802120:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802123:	50                   	push   %eax
  802124:	e8 14 ef ff ff       	call   80103d <fd_alloc>
  802129:	83 c4 10             	add    $0x10,%esp
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 3a                	js     80216a <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802130:	83 ec 04             	sub    $0x4,%esp
  802133:	68 07 04 00 00       	push   $0x407
  802138:	ff 75 f4             	pushl  -0xc(%ebp)
  80213b:	6a 00                	push   $0x0
  80213d:	e8 ff eb ff ff       	call   800d41 <sys_page_alloc>
  802142:	83 c4 10             	add    $0x10,%esp
  802145:	85 c0                	test   %eax,%eax
  802147:	78 21                	js     80216a <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802149:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214c:	8b 15 58 30 80 00    	mov    0x803058,%edx
  802152:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802154:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802157:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80215e:	83 ec 0c             	sub    $0xc,%esp
  802161:	50                   	push   %eax
  802162:	e8 af ee ff ff       	call   801016 <fd2num>
  802167:	83 c4 10             	add    $0x10,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
  80216f:	56                   	push   %esi
  802170:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802171:	a1 08 40 80 00       	mov    0x804008,%eax
  802176:	8b 40 48             	mov    0x48(%eax),%eax
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	68 e0 2a 80 00       	push   $0x802ae0
  802181:	50                   	push   %eax
  802182:	68 d6 25 80 00       	push   $0x8025d6
  802187:	e8 64 e0 ff ff       	call   8001f0 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80218c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80218f:	8b 35 00 30 80 00    	mov    0x803000,%esi
  802195:	e8 69 eb ff ff       	call   800d03 <sys_getenvid>
  80219a:	83 c4 04             	add    $0x4,%esp
  80219d:	ff 75 0c             	pushl  0xc(%ebp)
  8021a0:	ff 75 08             	pushl  0x8(%ebp)
  8021a3:	56                   	push   %esi
  8021a4:	50                   	push   %eax
  8021a5:	68 bc 2a 80 00       	push   $0x802abc
  8021aa:	e8 41 e0 ff ff       	call   8001f0 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021af:	83 c4 18             	add    $0x18,%esp
  8021b2:	53                   	push   %ebx
  8021b3:	ff 75 10             	pushl  0x10(%ebp)
  8021b6:	e8 e4 df ff ff       	call   80019f <vcprintf>
	cprintf("\n");
  8021bb:	c7 04 24 7c 25 80 00 	movl   $0x80257c,(%esp)
  8021c2:	e8 29 e0 ff ff       	call   8001f0 <cprintf>
  8021c7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021ca:	cc                   	int3   
  8021cb:	eb fd                	jmp    8021ca <_panic+0x5e>

008021cd <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	56                   	push   %esi
  8021d1:	53                   	push   %ebx
  8021d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8021d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  8021db:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  8021dd:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  8021e2:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8021e5:	83 ec 0c             	sub    $0xc,%esp
  8021e8:	50                   	push   %eax
  8021e9:	e8 03 ed ff ff       	call   800ef1 <sys_ipc_recv>
	if(ret < 0){
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	78 2b                	js     802220 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8021f5:	85 f6                	test   %esi,%esi
  8021f7:	74 0a                	je     802203 <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021f9:	a1 08 40 80 00       	mov    0x804008,%eax
  8021fe:	8b 40 74             	mov    0x74(%eax),%eax
  802201:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  802203:	85 db                	test   %ebx,%ebx
  802205:	74 0a                	je     802211 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802207:	a1 08 40 80 00       	mov    0x804008,%eax
  80220c:	8b 40 78             	mov    0x78(%eax),%eax
  80220f:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  802211:	a1 08 40 80 00       	mov    0x804008,%eax
  802216:	8b 40 70             	mov    0x70(%eax),%eax
}
  802219:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80221c:	5b                   	pop    %ebx
  80221d:	5e                   	pop    %esi
  80221e:	5d                   	pop    %ebp
  80221f:	c3                   	ret    
		if(from_env_store)
  802220:	85 f6                	test   %esi,%esi
  802222:	74 06                	je     80222a <ipc_recv+0x5d>
			*from_env_store = 0;
  802224:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  80222a:	85 db                	test   %ebx,%ebx
  80222c:	74 eb                	je     802219 <ipc_recv+0x4c>
			*perm_store = 0;
  80222e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  802234:	eb e3                	jmp    802219 <ipc_recv+0x4c>

00802236 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	57                   	push   %edi
  80223a:	56                   	push   %esi
  80223b:	53                   	push   %ebx
  80223c:	83 ec 0c             	sub    $0xc,%esp
  80223f:	8b 7d 08             	mov    0x8(%ebp),%edi
  802242:	8b 75 0c             	mov    0xc(%ebp),%esi
  802245:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802248:	85 db                	test   %ebx,%ebx
  80224a:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80224f:	0f 44 d8             	cmove  %eax,%ebx
  802252:	eb 05                	jmp    802259 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  802254:	e8 c9 ea ff ff       	call   800d22 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802259:	ff 75 14             	pushl  0x14(%ebp)
  80225c:	53                   	push   %ebx
  80225d:	56                   	push   %esi
  80225e:	57                   	push   %edi
  80225f:	e8 6a ec ff ff       	call   800ece <sys_ipc_try_send>
  802264:	83 c4 10             	add    $0x10,%esp
  802267:	85 c0                	test   %eax,%eax
  802269:	74 1b                	je     802286 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  80226b:	79 e7                	jns    802254 <ipc_send+0x1e>
  80226d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802270:	74 e2                	je     802254 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802272:	83 ec 04             	sub    $0x4,%esp
  802275:	68 e7 2a 80 00       	push   $0x802ae7
  80227a:	6a 46                	push   $0x46
  80227c:	68 fc 2a 80 00       	push   $0x802afc
  802281:	e8 e6 fe ff ff       	call   80216c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802289:	5b                   	pop    %ebx
  80228a:	5e                   	pop    %esi
  80228b:	5f                   	pop    %edi
  80228c:	5d                   	pop    %ebp
  80228d:	c3                   	ret    

0080228e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802294:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802299:	89 c2                	mov    %eax,%edx
  80229b:	c1 e2 07             	shl    $0x7,%edx
  80229e:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  8022a4:	8b 52 50             	mov    0x50(%edx),%edx
  8022a7:	39 ca                	cmp    %ecx,%edx
  8022a9:	74 11                	je     8022bc <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  8022ab:	83 c0 01             	add    $0x1,%eax
  8022ae:	3d 00 04 00 00       	cmp    $0x400,%eax
  8022b3:	75 e4                	jne    802299 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8022b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8022ba:	eb 0b                	jmp    8022c7 <ipc_find_env+0x39>
			return envs[i].env_id;
  8022bc:	c1 e0 07             	shl    $0x7,%eax
  8022bf:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8022c4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8022c7:	5d                   	pop    %ebp
  8022c8:	c3                   	ret    

008022c9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
  8022cc:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8022cf:	89 d0                	mov    %edx,%eax
  8022d1:	c1 e8 16             	shr    $0x16,%eax
  8022d4:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  8022db:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  8022e0:	f6 c1 01             	test   $0x1,%cl
  8022e3:	74 1d                	je     802302 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8022e5:	c1 ea 0c             	shr    $0xc,%edx
  8022e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8022ef:	f6 c2 01             	test   $0x1,%dl
  8022f2:	74 0e                	je     802302 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022f4:	c1 ea 0c             	shr    $0xc,%edx
  8022f7:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022fe:	ef 
  8022ff:	0f b7 c0             	movzwl %ax,%eax
}
  802302:	5d                   	pop    %ebp
  802303:	c3                   	ret    
  802304:	66 90                	xchg   %ax,%ax
  802306:	66 90                	xchg   %ax,%ax
  802308:	66 90                	xchg   %ax,%ax
  80230a:	66 90                	xchg   %ax,%ax
  80230c:	66 90                	xchg   %ax,%ax
  80230e:	66 90                	xchg   %ax,%ax

00802310 <__udivdi3>:
  802310:	55                   	push   %ebp
  802311:	57                   	push   %edi
  802312:	56                   	push   %esi
  802313:	53                   	push   %ebx
  802314:	83 ec 1c             	sub    $0x1c,%esp
  802317:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  80231b:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  80231f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802323:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  802327:	85 d2                	test   %edx,%edx
  802329:	75 4d                	jne    802378 <__udivdi3+0x68>
  80232b:	39 f3                	cmp    %esi,%ebx
  80232d:	76 19                	jbe    802348 <__udivdi3+0x38>
  80232f:	31 ff                	xor    %edi,%edi
  802331:	89 e8                	mov    %ebp,%eax
  802333:	89 f2                	mov    %esi,%edx
  802335:	f7 f3                	div    %ebx
  802337:	89 fa                	mov    %edi,%edx
  802339:	83 c4 1c             	add    $0x1c,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5f                   	pop    %edi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
  802341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802348:	89 d9                	mov    %ebx,%ecx
  80234a:	85 db                	test   %ebx,%ebx
  80234c:	75 0b                	jne    802359 <__udivdi3+0x49>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f3                	div    %ebx
  802357:	89 c1                	mov    %eax,%ecx
  802359:	31 d2                	xor    %edx,%edx
  80235b:	89 f0                	mov    %esi,%eax
  80235d:	f7 f1                	div    %ecx
  80235f:	89 c6                	mov    %eax,%esi
  802361:	89 e8                	mov    %ebp,%eax
  802363:	89 f7                	mov    %esi,%edi
  802365:	f7 f1                	div    %ecx
  802367:	89 fa                	mov    %edi,%edx
  802369:	83 c4 1c             	add    $0x1c,%esp
  80236c:	5b                   	pop    %ebx
  80236d:	5e                   	pop    %esi
  80236e:	5f                   	pop    %edi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    
  802371:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802378:	39 f2                	cmp    %esi,%edx
  80237a:	77 1c                	ja     802398 <__udivdi3+0x88>
  80237c:	0f bd fa             	bsr    %edx,%edi
  80237f:	83 f7 1f             	xor    $0x1f,%edi
  802382:	75 2c                	jne    8023b0 <__udivdi3+0xa0>
  802384:	39 f2                	cmp    %esi,%edx
  802386:	72 06                	jb     80238e <__udivdi3+0x7e>
  802388:	31 c0                	xor    %eax,%eax
  80238a:	39 eb                	cmp    %ebp,%ebx
  80238c:	77 a9                	ja     802337 <__udivdi3+0x27>
  80238e:	b8 01 00 00 00       	mov    $0x1,%eax
  802393:	eb a2                	jmp    802337 <__udivdi3+0x27>
  802395:	8d 76 00             	lea    0x0(%esi),%esi
  802398:	31 ff                	xor    %edi,%edi
  80239a:	31 c0                	xor    %eax,%eax
  80239c:	89 fa                	mov    %edi,%edx
  80239e:	83 c4 1c             	add    $0x1c,%esp
  8023a1:	5b                   	pop    %ebx
  8023a2:	5e                   	pop    %esi
  8023a3:	5f                   	pop    %edi
  8023a4:	5d                   	pop    %ebp
  8023a5:	c3                   	ret    
  8023a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023ad:	8d 76 00             	lea    0x0(%esi),%esi
  8023b0:	89 f9                	mov    %edi,%ecx
  8023b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8023b7:	29 f8                	sub    %edi,%eax
  8023b9:	d3 e2                	shl    %cl,%edx
  8023bb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8023bf:	89 c1                	mov    %eax,%ecx
  8023c1:	89 da                	mov    %ebx,%edx
  8023c3:	d3 ea                	shr    %cl,%edx
  8023c5:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8023c9:	09 d1                	or     %edx,%ecx
  8023cb:	89 f2                	mov    %esi,%edx
  8023cd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023d1:	89 f9                	mov    %edi,%ecx
  8023d3:	d3 e3                	shl    %cl,%ebx
  8023d5:	89 c1                	mov    %eax,%ecx
  8023d7:	d3 ea                	shr    %cl,%edx
  8023d9:	89 f9                	mov    %edi,%ecx
  8023db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8023df:	89 eb                	mov    %ebp,%ebx
  8023e1:	d3 e6                	shl    %cl,%esi
  8023e3:	89 c1                	mov    %eax,%ecx
  8023e5:	d3 eb                	shr    %cl,%ebx
  8023e7:	09 de                	or     %ebx,%esi
  8023e9:	89 f0                	mov    %esi,%eax
  8023eb:	f7 74 24 08          	divl   0x8(%esp)
  8023ef:	89 d6                	mov    %edx,%esi
  8023f1:	89 c3                	mov    %eax,%ebx
  8023f3:	f7 64 24 0c          	mull   0xc(%esp)
  8023f7:	39 d6                	cmp    %edx,%esi
  8023f9:	72 15                	jb     802410 <__udivdi3+0x100>
  8023fb:	89 f9                	mov    %edi,%ecx
  8023fd:	d3 e5                	shl    %cl,%ebp
  8023ff:	39 c5                	cmp    %eax,%ebp
  802401:	73 04                	jae    802407 <__udivdi3+0xf7>
  802403:	39 d6                	cmp    %edx,%esi
  802405:	74 09                	je     802410 <__udivdi3+0x100>
  802407:	89 d8                	mov    %ebx,%eax
  802409:	31 ff                	xor    %edi,%edi
  80240b:	e9 27 ff ff ff       	jmp    802337 <__udivdi3+0x27>
  802410:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802413:	31 ff                	xor    %edi,%edi
  802415:	e9 1d ff ff ff       	jmp    802337 <__udivdi3+0x27>
  80241a:	66 90                	xchg   %ax,%ax
  80241c:	66 90                	xchg   %ax,%ax
  80241e:	66 90                	xchg   %ax,%ax

00802420 <__umoddi3>:
  802420:	55                   	push   %ebp
  802421:	57                   	push   %edi
  802422:	56                   	push   %esi
  802423:	53                   	push   %ebx
  802424:	83 ec 1c             	sub    $0x1c,%esp
  802427:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  80242b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80242f:	8b 74 24 30          	mov    0x30(%esp),%esi
  802433:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802437:	89 da                	mov    %ebx,%edx
  802439:	85 c0                	test   %eax,%eax
  80243b:	75 43                	jne    802480 <__umoddi3+0x60>
  80243d:	39 df                	cmp    %ebx,%edi
  80243f:	76 17                	jbe    802458 <__umoddi3+0x38>
  802441:	89 f0                	mov    %esi,%eax
  802443:	f7 f7                	div    %edi
  802445:	89 d0                	mov    %edx,%eax
  802447:	31 d2                	xor    %edx,%edx
  802449:	83 c4 1c             	add    $0x1c,%esp
  80244c:	5b                   	pop    %ebx
  80244d:	5e                   	pop    %esi
  80244e:	5f                   	pop    %edi
  80244f:	5d                   	pop    %ebp
  802450:	c3                   	ret    
  802451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802458:	89 fd                	mov    %edi,%ebp
  80245a:	85 ff                	test   %edi,%edi
  80245c:	75 0b                	jne    802469 <__umoddi3+0x49>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f7                	div    %edi
  802467:	89 c5                	mov    %eax,%ebp
  802469:	89 d8                	mov    %ebx,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f5                	div    %ebp
  80246f:	89 f0                	mov    %esi,%eax
  802471:	f7 f5                	div    %ebp
  802473:	89 d0                	mov    %edx,%eax
  802475:	eb d0                	jmp    802447 <__umoddi3+0x27>
  802477:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80247e:	66 90                	xchg   %ax,%ax
  802480:	89 f1                	mov    %esi,%ecx
  802482:	39 d8                	cmp    %ebx,%eax
  802484:	76 0a                	jbe    802490 <__umoddi3+0x70>
  802486:	89 f0                	mov    %esi,%eax
  802488:	83 c4 1c             	add    $0x1c,%esp
  80248b:	5b                   	pop    %ebx
  80248c:	5e                   	pop    %esi
  80248d:	5f                   	pop    %edi
  80248e:	5d                   	pop    %ebp
  80248f:	c3                   	ret    
  802490:	0f bd e8             	bsr    %eax,%ebp
  802493:	83 f5 1f             	xor    $0x1f,%ebp
  802496:	75 20                	jne    8024b8 <__umoddi3+0x98>
  802498:	39 d8                	cmp    %ebx,%eax
  80249a:	0f 82 b0 00 00 00    	jb     802550 <__umoddi3+0x130>
  8024a0:	39 f7                	cmp    %esi,%edi
  8024a2:	0f 86 a8 00 00 00    	jbe    802550 <__umoddi3+0x130>
  8024a8:	89 c8                	mov    %ecx,%eax
  8024aa:	83 c4 1c             	add    $0x1c,%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5e                   	pop    %esi
  8024af:	5f                   	pop    %edi
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    
  8024b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8024b8:	89 e9                	mov    %ebp,%ecx
  8024ba:	ba 20 00 00 00       	mov    $0x20,%edx
  8024bf:	29 ea                	sub    %ebp,%edx
  8024c1:	d3 e0                	shl    %cl,%eax
  8024c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024c7:	89 d1                	mov    %edx,%ecx
  8024c9:	89 f8                	mov    %edi,%eax
  8024cb:	d3 e8                	shr    %cl,%eax
  8024cd:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8024d1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024d5:	8b 54 24 04          	mov    0x4(%esp),%edx
  8024d9:	09 c1                	or     %eax,%ecx
  8024db:	89 d8                	mov    %ebx,%eax
  8024dd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e7                	shl    %cl,%edi
  8024e5:	89 d1                	mov    %edx,%ecx
  8024e7:	d3 e8                	shr    %cl,%eax
  8024e9:	89 e9                	mov    %ebp,%ecx
  8024eb:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8024ef:	d3 e3                	shl    %cl,%ebx
  8024f1:	89 c7                	mov    %eax,%edi
  8024f3:	89 d1                	mov    %edx,%ecx
  8024f5:	89 f0                	mov    %esi,%eax
  8024f7:	d3 e8                	shr    %cl,%eax
  8024f9:	89 e9                	mov    %ebp,%ecx
  8024fb:	89 fa                	mov    %edi,%edx
  8024fd:	d3 e6                	shl    %cl,%esi
  8024ff:	09 d8                	or     %ebx,%eax
  802501:	f7 74 24 08          	divl   0x8(%esp)
  802505:	89 d1                	mov    %edx,%ecx
  802507:	89 f3                	mov    %esi,%ebx
  802509:	f7 64 24 0c          	mull   0xc(%esp)
  80250d:	89 c6                	mov    %eax,%esi
  80250f:	89 d7                	mov    %edx,%edi
  802511:	39 d1                	cmp    %edx,%ecx
  802513:	72 06                	jb     80251b <__umoddi3+0xfb>
  802515:	75 10                	jne    802527 <__umoddi3+0x107>
  802517:	39 c3                	cmp    %eax,%ebx
  802519:	73 0c                	jae    802527 <__umoddi3+0x107>
  80251b:	2b 44 24 0c          	sub    0xc(%esp),%eax
  80251f:	1b 54 24 08          	sbb    0x8(%esp),%edx
  802523:	89 d7                	mov    %edx,%edi
  802525:	89 c6                	mov    %eax,%esi
  802527:	89 ca                	mov    %ecx,%edx
  802529:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  80252e:	29 f3                	sub    %esi,%ebx
  802530:	19 fa                	sbb    %edi,%edx
  802532:	89 d0                	mov    %edx,%eax
  802534:	d3 e0                	shl    %cl,%eax
  802536:	89 e9                	mov    %ebp,%ecx
  802538:	d3 eb                	shr    %cl,%ebx
  80253a:	d3 ea                	shr    %cl,%edx
  80253c:	09 d8                	or     %ebx,%eax
  80253e:	83 c4 1c             	add    $0x1c,%esp
  802541:	5b                   	pop    %ebx
  802542:	5e                   	pop    %esi
  802543:	5f                   	pop    %edi
  802544:	5d                   	pop    %ebp
  802545:	c3                   	ret    
  802546:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80254d:	8d 76 00             	lea    0x0(%esi),%esi
  802550:	89 da                	mov    %ebx,%edx
  802552:	29 fe                	sub    %edi,%esi
  802554:	19 c2                	sbb    %eax,%edx
  802556:	89 f1                	mov    %esi,%ecx
  802558:	89 c8                	mov    %ecx,%eax
  80255a:	e9 4b ff ff ff       	jmp    8024aa <__umoddi3+0x8a>
