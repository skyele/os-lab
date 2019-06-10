
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 3c 10 80 00       	push   $0x80103c
  80003e:	6a 00                	push   $0x0
  800040:	e8 4d 0e 00 00       	call   800e92 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	57                   	push   %edi
  800058:	56                   	push   %esi
  800059:	53                   	push   %ebx
  80005a:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80005d:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800064:	00 00 00 
	envid_t find = sys_getenvid();
  800067:	e8 9d 0c 00 00       	call   800d09 <sys_getenvid>
  80006c:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800072:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800077:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80007c:	bf 01 00 00 00       	mov    $0x1,%edi
  800081:	eb 0b                	jmp    80008e <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800083:	83 c2 01             	add    $0x1,%edx
  800086:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80008c:	74 21                	je     8000af <libmain+0x5b>
		if(envs[i].env_id == find)
  80008e:	89 d1                	mov    %edx,%ecx
  800090:	c1 e1 07             	shl    $0x7,%ecx
  800093:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  800099:	8b 49 48             	mov    0x48(%ecx),%ecx
  80009c:	39 c1                	cmp    %eax,%ecx
  80009e:	75 e3                	jne    800083 <libmain+0x2f>
  8000a0:	89 d3                	mov    %edx,%ebx
  8000a2:	c1 e3 07             	shl    $0x7,%ebx
  8000a5:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000ab:	89 fe                	mov    %edi,%esi
  8000ad:	eb d4                	jmp    800083 <libmain+0x2f>
  8000af:	89 f0                	mov    %esi,%eax
  8000b1:	84 c0                	test   %al,%al
  8000b3:	74 06                	je     8000bb <libmain+0x67>
  8000b5:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000bf:	7e 0a                	jle    8000cb <libmain+0x77>
		binaryname = argv[0];
  8000c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000c4:	8b 00                	mov    (%eax),%eax
  8000c6:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("%d: in libmain.c call umain!\n", thisenv->env_id);
  8000cb:	a1 08 40 80 00       	mov    0x804008,%eax
  8000d0:	8b 40 48             	mov    0x48(%eax),%eax
  8000d3:	83 ec 08             	sub    $0x8,%esp
  8000d6:	50                   	push   %eax
  8000d7:	68 20 26 80 00       	push   $0x802620
  8000dc:	e8 15 01 00 00       	call   8001f6 <cprintf>
	cprintf("before umain\n");
  8000e1:	c7 04 24 3e 26 80 00 	movl   $0x80263e,(%esp)
  8000e8:	e8 09 01 00 00       	call   8001f6 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ed:	83 c4 08             	add    $0x8,%esp
  8000f0:	ff 75 0c             	pushl  0xc(%ebp)
  8000f3:	ff 75 08             	pushl  0x8(%ebp)
  8000f6:	e8 38 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000fb:	c7 04 24 4c 26 80 00 	movl   $0x80264c,(%esp)
  800102:	e8 ef 00 00 00       	call   8001f6 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800107:	a1 08 40 80 00       	mov    0x804008,%eax
  80010c:	8b 40 48             	mov    0x48(%eax),%eax
  80010f:	83 c4 08             	add    $0x8,%esp
  800112:	50                   	push   %eax
  800113:	68 59 26 80 00       	push   $0x802659
  800118:	e8 d9 00 00 00       	call   8001f6 <cprintf>
	// exit gracefully
	exit();
  80011d:	e8 0b 00 00 00       	call   80012d <exit>
}
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800128:	5b                   	pop    %ebx
  800129:	5e                   	pop    %esi
  80012a:	5f                   	pop    %edi
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
  80013b:	68 84 26 80 00       	push   $0x802684
  800140:	50                   	push   %eax
  800141:	68 78 26 80 00       	push   $0x802678
  800146:	e8 ab 00 00 00       	call   8001f6 <cprintf>
	close_all();
  80014b:	e8 ea 10 00 00       	call   80123a <close_all>
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
  8002a3:	e8 18 21 00 00       	call   8023c0 <__udivdi3>
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
  8002cc:	e8 ff 21 00 00       	call   8024d0 <__umoddi3>
  8002d1:	83 c4 14             	add    $0x14,%esp
  8002d4:	0f be 80 89 26 80 00 	movsbl 0x802689(%eax),%eax
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
  80037d:	ff 24 85 60 28 80 00 	jmp    *0x802860(,%eax,4)
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
  800448:	8b 14 85 c0 29 80 00 	mov    0x8029c0(,%eax,4),%edx
  80044f:	85 d2                	test   %edx,%edx
  800451:	74 18                	je     80046b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800453:	52                   	push   %edx
  800454:	68 dd 2a 80 00       	push   $0x802add
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 a6 fe ff ff       	call   800306 <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
  800466:	e9 fe 02 00 00       	jmp    800769 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80046b:	50                   	push   %eax
  80046c:	68 a1 26 80 00       	push   $0x8026a1
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
  800493:	b8 9a 26 80 00       	mov    $0x80269a,%eax
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
  80082b:	bf bd 27 80 00       	mov    $0x8027bd,%edi
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
  800857:	bf f5 27 80 00       	mov    $0x8027f5,%edi
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
  800cf8:	68 08 2a 80 00       	push   $0x802a08
  800cfd:	6a 43                	push   $0x43
  800cff:	68 25 2a 80 00       	push   $0x802a25
  800d04:	e8 af 14 00 00       	call   8021b8 <_panic>

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
  800d79:	68 08 2a 80 00       	push   $0x802a08
  800d7e:	6a 43                	push   $0x43
  800d80:	68 25 2a 80 00       	push   $0x802a25
  800d85:	e8 2e 14 00 00       	call   8021b8 <_panic>

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
  800dbb:	68 08 2a 80 00       	push   $0x802a08
  800dc0:	6a 43                	push   $0x43
  800dc2:	68 25 2a 80 00       	push   $0x802a25
  800dc7:	e8 ec 13 00 00       	call   8021b8 <_panic>

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
  800dfd:	68 08 2a 80 00       	push   $0x802a08
  800e02:	6a 43                	push   $0x43
  800e04:	68 25 2a 80 00       	push   $0x802a25
  800e09:	e8 aa 13 00 00       	call   8021b8 <_panic>

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
  800e3f:	68 08 2a 80 00       	push   $0x802a08
  800e44:	6a 43                	push   $0x43
  800e46:	68 25 2a 80 00       	push   $0x802a25
  800e4b:	e8 68 13 00 00       	call   8021b8 <_panic>

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
  800e81:	68 08 2a 80 00       	push   $0x802a08
  800e86:	6a 43                	push   $0x43
  800e88:	68 25 2a 80 00       	push   $0x802a25
  800e8d:	e8 26 13 00 00       	call   8021b8 <_panic>

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
  800ec3:	68 08 2a 80 00       	push   $0x802a08
  800ec8:	6a 43                	push   $0x43
  800eca:	68 25 2a 80 00       	push   $0x802a25
  800ecf:	e8 e4 12 00 00       	call   8021b8 <_panic>

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
  800f27:	68 08 2a 80 00       	push   $0x802a08
  800f2c:	6a 43                	push   $0x43
  800f2e:	68 25 2a 80 00       	push   $0x802a25
  800f33:	e8 80 12 00 00       	call   8021b8 <_panic>

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
  80100b:	68 08 2a 80 00       	push   $0x802a08
  801010:	6a 43                	push   $0x43
  801012:	68 25 2a 80 00       	push   $0x802a25
  801017:	e8 9c 11 00 00       	call   8021b8 <_panic>

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

0080103c <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80103c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80103d:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  801042:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801044:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801047:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80104b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80104f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801052:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801054:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801058:	83 c4 08             	add    $0x8,%esp
	popal
  80105b:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80105c:	83 c4 04             	add    $0x4,%esp
	popfl
  80105f:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801060:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801061:	c3                   	ret    

00801062 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801062:	55                   	push   %ebp
  801063:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	05 00 00 00 30       	add    $0x30000000,%eax
  80106d:	c1 e8 0c             	shr    $0xc,%eax
}
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    

00801072 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80107d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801082:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801087:	5d                   	pop    %ebp
  801088:	c3                   	ret    

00801089 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801089:	55                   	push   %ebp
  80108a:	89 e5                	mov    %esp,%ebp
  80108c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801091:	89 c2                	mov    %eax,%edx
  801093:	c1 ea 16             	shr    $0x16,%edx
  801096:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80109d:	f6 c2 01             	test   $0x1,%dl
  8010a0:	74 2d                	je     8010cf <fd_alloc+0x46>
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	c1 ea 0c             	shr    $0xc,%edx
  8010a7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010ae:	f6 c2 01             	test   $0x1,%dl
  8010b1:	74 1c                	je     8010cf <fd_alloc+0x46>
  8010b3:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010b8:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8010bd:	75 d2                	jne    801091 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010c8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010cd:	eb 0a                	jmp    8010d9 <fd_alloc+0x50>
			*fd_store = fd;
  8010cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010d4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010e1:	83 f8 1f             	cmp    $0x1f,%eax
  8010e4:	77 30                	ja     801116 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010e6:	c1 e0 0c             	shl    $0xc,%eax
  8010e9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ee:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010f4:	f6 c2 01             	test   $0x1,%dl
  8010f7:	74 24                	je     80111d <fd_lookup+0x42>
  8010f9:	89 c2                	mov    %eax,%edx
  8010fb:	c1 ea 0c             	shr    $0xc,%edx
  8010fe:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801105:	f6 c2 01             	test   $0x1,%dl
  801108:	74 1a                	je     801124 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80110a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80110d:	89 02                	mov    %eax,(%edx)
	return 0;
  80110f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801114:	5d                   	pop    %ebp
  801115:	c3                   	ret    
		return -E_INVAL;
  801116:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111b:	eb f7                	jmp    801114 <fd_lookup+0x39>
		return -E_INVAL;
  80111d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801122:	eb f0                	jmp    801114 <fd_lookup+0x39>
  801124:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801129:	eb e9                	jmp    801114 <fd_lookup+0x39>

0080112b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80112b:	55                   	push   %ebp
  80112c:	89 e5                	mov    %esp,%ebp
  80112e:	83 ec 08             	sub    $0x8,%esp
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801134:	ba 00 00 00 00       	mov    $0x0,%edx
  801139:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80113e:	39 08                	cmp    %ecx,(%eax)
  801140:	74 38                	je     80117a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801142:	83 c2 01             	add    $0x1,%edx
  801145:	8b 04 95 b0 2a 80 00 	mov    0x802ab0(,%edx,4),%eax
  80114c:	85 c0                	test   %eax,%eax
  80114e:	75 ee                	jne    80113e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801150:	a1 08 40 80 00       	mov    0x804008,%eax
  801155:	8b 40 48             	mov    0x48(%eax),%eax
  801158:	83 ec 04             	sub    $0x4,%esp
  80115b:	51                   	push   %ecx
  80115c:	50                   	push   %eax
  80115d:	68 34 2a 80 00       	push   $0x802a34
  801162:	e8 8f f0 ff ff       	call   8001f6 <cprintf>
	*dev = 0;
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801170:	83 c4 10             	add    $0x10,%esp
  801173:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801178:	c9                   	leave  
  801179:	c3                   	ret    
			*dev = devtab[i];
  80117a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80117f:	b8 00 00 00 00       	mov    $0x0,%eax
  801184:	eb f2                	jmp    801178 <dev_lookup+0x4d>

00801186 <fd_close>:
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	57                   	push   %edi
  80118a:	56                   	push   %esi
  80118b:	53                   	push   %ebx
  80118c:	83 ec 24             	sub    $0x24,%esp
  80118f:	8b 75 08             	mov    0x8(%ebp),%esi
  801192:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801195:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801198:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801199:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80119f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011a2:	50                   	push   %eax
  8011a3:	e8 33 ff ff ff       	call   8010db <fd_lookup>
  8011a8:	89 c3                	mov    %eax,%ebx
  8011aa:	83 c4 10             	add    $0x10,%esp
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	78 05                	js     8011b6 <fd_close+0x30>
	    || fd != fd2)
  8011b1:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8011b4:	74 16                	je     8011cc <fd_close+0x46>
		return (must_exist ? r : 0);
  8011b6:	89 f8                	mov    %edi,%eax
  8011b8:	84 c0                	test   %al,%al
  8011ba:	b8 00 00 00 00       	mov    $0x0,%eax
  8011bf:	0f 44 d8             	cmove  %eax,%ebx
}
  8011c2:	89 d8                	mov    %ebx,%eax
  8011c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c7:	5b                   	pop    %ebx
  8011c8:	5e                   	pop    %esi
  8011c9:	5f                   	pop    %edi
  8011ca:	5d                   	pop    %ebp
  8011cb:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011d2:	50                   	push   %eax
  8011d3:	ff 36                	pushl  (%esi)
  8011d5:	e8 51 ff ff ff       	call   80112b <dev_lookup>
  8011da:	89 c3                	mov    %eax,%ebx
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	85 c0                	test   %eax,%eax
  8011e1:	78 1a                	js     8011fd <fd_close+0x77>
		if (dev->dev_close)
  8011e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011e6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011e9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011ee:	85 c0                	test   %eax,%eax
  8011f0:	74 0b                	je     8011fd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011f2:	83 ec 0c             	sub    $0xc,%esp
  8011f5:	56                   	push   %esi
  8011f6:	ff d0                	call   *%eax
  8011f8:	89 c3                	mov    %eax,%ebx
  8011fa:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011fd:	83 ec 08             	sub    $0x8,%esp
  801200:	56                   	push   %esi
  801201:	6a 00                	push   $0x0
  801203:	e8 c4 fb ff ff       	call   800dcc <sys_page_unmap>
	return r;
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	eb b5                	jmp    8011c2 <fd_close+0x3c>

0080120d <close>:

int
close(int fdnum)
{
  80120d:	55                   	push   %ebp
  80120e:	89 e5                	mov    %esp,%ebp
  801210:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801213:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801216:	50                   	push   %eax
  801217:	ff 75 08             	pushl  0x8(%ebp)
  80121a:	e8 bc fe ff ff       	call   8010db <fd_lookup>
  80121f:	83 c4 10             	add    $0x10,%esp
  801222:	85 c0                	test   %eax,%eax
  801224:	79 02                	jns    801228 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    
		return fd_close(fd, 1);
  801228:	83 ec 08             	sub    $0x8,%esp
  80122b:	6a 01                	push   $0x1
  80122d:	ff 75 f4             	pushl  -0xc(%ebp)
  801230:	e8 51 ff ff ff       	call   801186 <fd_close>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	eb ec                	jmp    801226 <close+0x19>

0080123a <close_all>:

void
close_all(void)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	53                   	push   %ebx
  80123e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801241:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801246:	83 ec 0c             	sub    $0xc,%esp
  801249:	53                   	push   %ebx
  80124a:	e8 be ff ff ff       	call   80120d <close>
	for (i = 0; i < MAXFD; i++)
  80124f:	83 c3 01             	add    $0x1,%ebx
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	83 fb 20             	cmp    $0x20,%ebx
  801258:	75 ec                	jne    801246 <close_all+0xc>
}
  80125a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80125d:	c9                   	leave  
  80125e:	c3                   	ret    

0080125f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80125f:	55                   	push   %ebp
  801260:	89 e5                	mov    %esp,%ebp
  801262:	57                   	push   %edi
  801263:	56                   	push   %esi
  801264:	53                   	push   %ebx
  801265:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801268:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80126b:	50                   	push   %eax
  80126c:	ff 75 08             	pushl  0x8(%ebp)
  80126f:	e8 67 fe ff ff       	call   8010db <fd_lookup>
  801274:	89 c3                	mov    %eax,%ebx
  801276:	83 c4 10             	add    $0x10,%esp
  801279:	85 c0                	test   %eax,%eax
  80127b:	0f 88 81 00 00 00    	js     801302 <dup+0xa3>
		return r;
	close(newfdnum);
  801281:	83 ec 0c             	sub    $0xc,%esp
  801284:	ff 75 0c             	pushl  0xc(%ebp)
  801287:	e8 81 ff ff ff       	call   80120d <close>

	newfd = INDEX2FD(newfdnum);
  80128c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80128f:	c1 e6 0c             	shl    $0xc,%esi
  801292:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801298:	83 c4 04             	add    $0x4,%esp
  80129b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80129e:	e8 cf fd ff ff       	call   801072 <fd2data>
  8012a3:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012a5:	89 34 24             	mov    %esi,(%esp)
  8012a8:	e8 c5 fd ff ff       	call   801072 <fd2data>
  8012ad:	83 c4 10             	add    $0x10,%esp
  8012b0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012b2:	89 d8                	mov    %ebx,%eax
  8012b4:	c1 e8 16             	shr    $0x16,%eax
  8012b7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012be:	a8 01                	test   $0x1,%al
  8012c0:	74 11                	je     8012d3 <dup+0x74>
  8012c2:	89 d8                	mov    %ebx,%eax
  8012c4:	c1 e8 0c             	shr    $0xc,%eax
  8012c7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ce:	f6 c2 01             	test   $0x1,%dl
  8012d1:	75 39                	jne    80130c <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012d6:	89 d0                	mov    %edx,%eax
  8012d8:	c1 e8 0c             	shr    $0xc,%eax
  8012db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ea:	50                   	push   %eax
  8012eb:	56                   	push   %esi
  8012ec:	6a 00                	push   $0x0
  8012ee:	52                   	push   %edx
  8012ef:	6a 00                	push   $0x0
  8012f1:	e8 94 fa ff ff       	call   800d8a <sys_page_map>
  8012f6:	89 c3                	mov    %eax,%ebx
  8012f8:	83 c4 20             	add    $0x20,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 31                	js     801330 <dup+0xd1>
		goto err;

	return newfdnum;
  8012ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801302:	89 d8                	mov    %ebx,%eax
  801304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80130c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801313:	83 ec 0c             	sub    $0xc,%esp
  801316:	25 07 0e 00 00       	and    $0xe07,%eax
  80131b:	50                   	push   %eax
  80131c:	57                   	push   %edi
  80131d:	6a 00                	push   $0x0
  80131f:	53                   	push   %ebx
  801320:	6a 00                	push   $0x0
  801322:	e8 63 fa ff ff       	call   800d8a <sys_page_map>
  801327:	89 c3                	mov    %eax,%ebx
  801329:	83 c4 20             	add    $0x20,%esp
  80132c:	85 c0                	test   %eax,%eax
  80132e:	79 a3                	jns    8012d3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801330:	83 ec 08             	sub    $0x8,%esp
  801333:	56                   	push   %esi
  801334:	6a 00                	push   $0x0
  801336:	e8 91 fa ff ff       	call   800dcc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80133b:	83 c4 08             	add    $0x8,%esp
  80133e:	57                   	push   %edi
  80133f:	6a 00                	push   $0x0
  801341:	e8 86 fa ff ff       	call   800dcc <sys_page_unmap>
	return r;
  801346:	83 c4 10             	add    $0x10,%esp
  801349:	eb b7                	jmp    801302 <dup+0xa3>

0080134b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	53                   	push   %ebx
  80134f:	83 ec 1c             	sub    $0x1c,%esp
  801352:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801355:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801358:	50                   	push   %eax
  801359:	53                   	push   %ebx
  80135a:	e8 7c fd ff ff       	call   8010db <fd_lookup>
  80135f:	83 c4 10             	add    $0x10,%esp
  801362:	85 c0                	test   %eax,%eax
  801364:	78 3f                	js     8013a5 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801366:	83 ec 08             	sub    $0x8,%esp
  801369:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136c:	50                   	push   %eax
  80136d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801370:	ff 30                	pushl  (%eax)
  801372:	e8 b4 fd ff ff       	call   80112b <dev_lookup>
  801377:	83 c4 10             	add    $0x10,%esp
  80137a:	85 c0                	test   %eax,%eax
  80137c:	78 27                	js     8013a5 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80137e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801381:	8b 42 08             	mov    0x8(%edx),%eax
  801384:	83 e0 03             	and    $0x3,%eax
  801387:	83 f8 01             	cmp    $0x1,%eax
  80138a:	74 1e                	je     8013aa <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80138c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138f:	8b 40 08             	mov    0x8(%eax),%eax
  801392:	85 c0                	test   %eax,%eax
  801394:	74 35                	je     8013cb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801396:	83 ec 04             	sub    $0x4,%esp
  801399:	ff 75 10             	pushl  0x10(%ebp)
  80139c:	ff 75 0c             	pushl  0xc(%ebp)
  80139f:	52                   	push   %edx
  8013a0:	ff d0                	call   *%eax
  8013a2:	83 c4 10             	add    $0x10,%esp
}
  8013a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013aa:	a1 08 40 80 00       	mov    0x804008,%eax
  8013af:	8b 40 48             	mov    0x48(%eax),%eax
  8013b2:	83 ec 04             	sub    $0x4,%esp
  8013b5:	53                   	push   %ebx
  8013b6:	50                   	push   %eax
  8013b7:	68 75 2a 80 00       	push   $0x802a75
  8013bc:	e8 35 ee ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  8013c1:	83 c4 10             	add    $0x10,%esp
  8013c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013c9:	eb da                	jmp    8013a5 <read+0x5a>
		return -E_NOT_SUPP;
  8013cb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013d0:	eb d3                	jmp    8013a5 <read+0x5a>

008013d2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013d2:	55                   	push   %ebp
  8013d3:	89 e5                	mov    %esp,%ebp
  8013d5:	57                   	push   %edi
  8013d6:	56                   	push   %esi
  8013d7:	53                   	push   %ebx
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013de:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013e1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e6:	39 f3                	cmp    %esi,%ebx
  8013e8:	73 23                	jae    80140d <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ea:	83 ec 04             	sub    $0x4,%esp
  8013ed:	89 f0                	mov    %esi,%eax
  8013ef:	29 d8                	sub    %ebx,%eax
  8013f1:	50                   	push   %eax
  8013f2:	89 d8                	mov    %ebx,%eax
  8013f4:	03 45 0c             	add    0xc(%ebp),%eax
  8013f7:	50                   	push   %eax
  8013f8:	57                   	push   %edi
  8013f9:	e8 4d ff ff ff       	call   80134b <read>
		if (m < 0)
  8013fe:	83 c4 10             	add    $0x10,%esp
  801401:	85 c0                	test   %eax,%eax
  801403:	78 06                	js     80140b <readn+0x39>
			return m;
		if (m == 0)
  801405:	74 06                	je     80140d <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801407:	01 c3                	add    %eax,%ebx
  801409:	eb db                	jmp    8013e6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80140b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80140d:	89 d8                	mov    %ebx,%eax
  80140f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801412:	5b                   	pop    %ebx
  801413:	5e                   	pop    %esi
  801414:	5f                   	pop    %edi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    

00801417 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	53                   	push   %ebx
  80141b:	83 ec 1c             	sub    $0x1c,%esp
  80141e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801421:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801424:	50                   	push   %eax
  801425:	53                   	push   %ebx
  801426:	e8 b0 fc ff ff       	call   8010db <fd_lookup>
  80142b:	83 c4 10             	add    $0x10,%esp
  80142e:	85 c0                	test   %eax,%eax
  801430:	78 3a                	js     80146c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801432:	83 ec 08             	sub    $0x8,%esp
  801435:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801438:	50                   	push   %eax
  801439:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143c:	ff 30                	pushl  (%eax)
  80143e:	e8 e8 fc ff ff       	call   80112b <dev_lookup>
  801443:	83 c4 10             	add    $0x10,%esp
  801446:	85 c0                	test   %eax,%eax
  801448:	78 22                	js     80146c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80144a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801451:	74 1e                	je     801471 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801453:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801456:	8b 52 0c             	mov    0xc(%edx),%edx
  801459:	85 d2                	test   %edx,%edx
  80145b:	74 35                	je     801492 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80145d:	83 ec 04             	sub    $0x4,%esp
  801460:	ff 75 10             	pushl  0x10(%ebp)
  801463:	ff 75 0c             	pushl  0xc(%ebp)
  801466:	50                   	push   %eax
  801467:	ff d2                	call   *%edx
  801469:	83 c4 10             	add    $0x10,%esp
}
  80146c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80146f:	c9                   	leave  
  801470:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801471:	a1 08 40 80 00       	mov    0x804008,%eax
  801476:	8b 40 48             	mov    0x48(%eax),%eax
  801479:	83 ec 04             	sub    $0x4,%esp
  80147c:	53                   	push   %ebx
  80147d:	50                   	push   %eax
  80147e:	68 91 2a 80 00       	push   $0x802a91
  801483:	e8 6e ed ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  801488:	83 c4 10             	add    $0x10,%esp
  80148b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801490:	eb da                	jmp    80146c <write+0x55>
		return -E_NOT_SUPP;
  801492:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801497:	eb d3                	jmp    80146c <write+0x55>

00801499 <seek>:

int
seek(int fdnum, off_t offset)
{
  801499:	55                   	push   %ebp
  80149a:	89 e5                	mov    %esp,%ebp
  80149c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80149f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a2:	50                   	push   %eax
  8014a3:	ff 75 08             	pushl  0x8(%ebp)
  8014a6:	e8 30 fc ff ff       	call   8010db <fd_lookup>
  8014ab:	83 c4 10             	add    $0x10,%esp
  8014ae:	85 c0                	test   %eax,%eax
  8014b0:	78 0e                	js     8014c0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014c0:	c9                   	leave  
  8014c1:	c3                   	ret    

008014c2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014c2:	55                   	push   %ebp
  8014c3:	89 e5                	mov    %esp,%ebp
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 1c             	sub    $0x1c,%esp
  8014c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014cf:	50                   	push   %eax
  8014d0:	53                   	push   %ebx
  8014d1:	e8 05 fc ff ff       	call   8010db <fd_lookup>
  8014d6:	83 c4 10             	add    $0x10,%esp
  8014d9:	85 c0                	test   %eax,%eax
  8014db:	78 37                	js     801514 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014dd:	83 ec 08             	sub    $0x8,%esp
  8014e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014e3:	50                   	push   %eax
  8014e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e7:	ff 30                	pushl  (%eax)
  8014e9:	e8 3d fc ff ff       	call   80112b <dev_lookup>
  8014ee:	83 c4 10             	add    $0x10,%esp
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	78 1f                	js     801514 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014fc:	74 1b                	je     801519 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801501:	8b 52 18             	mov    0x18(%edx),%edx
  801504:	85 d2                	test   %edx,%edx
  801506:	74 32                	je     80153a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801508:	83 ec 08             	sub    $0x8,%esp
  80150b:	ff 75 0c             	pushl  0xc(%ebp)
  80150e:	50                   	push   %eax
  80150f:	ff d2                	call   *%edx
  801511:	83 c4 10             	add    $0x10,%esp
}
  801514:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801517:	c9                   	leave  
  801518:	c3                   	ret    
			thisenv->env_id, fdnum);
  801519:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80151e:	8b 40 48             	mov    0x48(%eax),%eax
  801521:	83 ec 04             	sub    $0x4,%esp
  801524:	53                   	push   %ebx
  801525:	50                   	push   %eax
  801526:	68 54 2a 80 00       	push   $0x802a54
  80152b:	e8 c6 ec ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  801530:	83 c4 10             	add    $0x10,%esp
  801533:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801538:	eb da                	jmp    801514 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80153a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80153f:	eb d3                	jmp    801514 <ftruncate+0x52>

00801541 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	53                   	push   %ebx
  801545:	83 ec 1c             	sub    $0x1c,%esp
  801548:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80154b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154e:	50                   	push   %eax
  80154f:	ff 75 08             	pushl  0x8(%ebp)
  801552:	e8 84 fb ff ff       	call   8010db <fd_lookup>
  801557:	83 c4 10             	add    $0x10,%esp
  80155a:	85 c0                	test   %eax,%eax
  80155c:	78 4b                	js     8015a9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80155e:	83 ec 08             	sub    $0x8,%esp
  801561:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801564:	50                   	push   %eax
  801565:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801568:	ff 30                	pushl  (%eax)
  80156a:	e8 bc fb ff ff       	call   80112b <dev_lookup>
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 c0                	test   %eax,%eax
  801574:	78 33                	js     8015a9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801576:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801579:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80157d:	74 2f                	je     8015ae <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80157f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801582:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801589:	00 00 00 
	stat->st_isdir = 0;
  80158c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801593:	00 00 00 
	stat->st_dev = dev;
  801596:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80159c:	83 ec 08             	sub    $0x8,%esp
  80159f:	53                   	push   %ebx
  8015a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a3:	ff 50 14             	call   *0x14(%eax)
  8015a6:	83 c4 10             	add    $0x10,%esp
}
  8015a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    
		return -E_NOT_SUPP;
  8015ae:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015b3:	eb f4                	jmp    8015a9 <fstat+0x68>

008015b5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	56                   	push   %esi
  8015b9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015ba:	83 ec 08             	sub    $0x8,%esp
  8015bd:	6a 00                	push   $0x0
  8015bf:	ff 75 08             	pushl  0x8(%ebp)
  8015c2:	e8 22 02 00 00       	call   8017e9 <open>
  8015c7:	89 c3                	mov    %eax,%ebx
  8015c9:	83 c4 10             	add    $0x10,%esp
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	78 1b                	js     8015eb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015d0:	83 ec 08             	sub    $0x8,%esp
  8015d3:	ff 75 0c             	pushl  0xc(%ebp)
  8015d6:	50                   	push   %eax
  8015d7:	e8 65 ff ff ff       	call   801541 <fstat>
  8015dc:	89 c6                	mov    %eax,%esi
	close(fd);
  8015de:	89 1c 24             	mov    %ebx,(%esp)
  8015e1:	e8 27 fc ff ff       	call   80120d <close>
	return r;
  8015e6:	83 c4 10             	add    $0x10,%esp
  8015e9:	89 f3                	mov    %esi,%ebx
}
  8015eb:	89 d8                	mov    %ebx,%eax
  8015ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015f0:	5b                   	pop    %ebx
  8015f1:	5e                   	pop    %esi
  8015f2:	5d                   	pop    %ebp
  8015f3:	c3                   	ret    

008015f4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	89 c6                	mov    %eax,%esi
  8015fb:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015fd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801604:	74 27                	je     80162d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801606:	6a 07                	push   $0x7
  801608:	68 00 50 80 00       	push   $0x805000
  80160d:	56                   	push   %esi
  80160e:	ff 35 00 40 80 00    	pushl  0x804000
  801614:	e8 d8 0c 00 00       	call   8022f1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801619:	83 c4 0c             	add    $0xc,%esp
  80161c:	6a 00                	push   $0x0
  80161e:	53                   	push   %ebx
  80161f:	6a 00                	push   $0x0
  801621:	e8 62 0c 00 00       	call   802288 <ipc_recv>
}
  801626:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801629:	5b                   	pop    %ebx
  80162a:	5e                   	pop    %esi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80162d:	83 ec 0c             	sub    $0xc,%esp
  801630:	6a 01                	push   $0x1
  801632:	e8 12 0d 00 00       	call   802349 <ipc_find_env>
  801637:	a3 00 40 80 00       	mov    %eax,0x804000
  80163c:	83 c4 10             	add    $0x10,%esp
  80163f:	eb c5                	jmp    801606 <fsipc+0x12>

00801641 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801647:	8b 45 08             	mov    0x8(%ebp),%eax
  80164a:	8b 40 0c             	mov    0xc(%eax),%eax
  80164d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801652:	8b 45 0c             	mov    0xc(%ebp),%eax
  801655:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80165a:	ba 00 00 00 00       	mov    $0x0,%edx
  80165f:	b8 02 00 00 00       	mov    $0x2,%eax
  801664:	e8 8b ff ff ff       	call   8015f4 <fsipc>
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <devfile_flush>:
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801671:	8b 45 08             	mov    0x8(%ebp),%eax
  801674:	8b 40 0c             	mov    0xc(%eax),%eax
  801677:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80167c:	ba 00 00 00 00       	mov    $0x0,%edx
  801681:	b8 06 00 00 00       	mov    $0x6,%eax
  801686:	e8 69 ff ff ff       	call   8015f4 <fsipc>
}
  80168b:	c9                   	leave  
  80168c:	c3                   	ret    

0080168d <devfile_stat>:
{
  80168d:	55                   	push   %ebp
  80168e:	89 e5                	mov    %esp,%ebp
  801690:	53                   	push   %ebx
  801691:	83 ec 04             	sub    $0x4,%esp
  801694:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801697:	8b 45 08             	mov    0x8(%ebp),%eax
  80169a:	8b 40 0c             	mov    0xc(%eax),%eax
  80169d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ac:	e8 43 ff ff ff       	call   8015f4 <fsipc>
  8016b1:	85 c0                	test   %eax,%eax
  8016b3:	78 2c                	js     8016e1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	68 00 50 80 00       	push   $0x805000
  8016bd:	53                   	push   %ebx
  8016be:	e8 92 f2 ff ff       	call   800955 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016c3:	a1 80 50 80 00       	mov    0x805080,%eax
  8016c8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ce:	a1 84 50 80 00       	mov    0x805084,%eax
  8016d3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016d9:	83 c4 10             	add    $0x10,%esp
  8016dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e4:	c9                   	leave  
  8016e5:	c3                   	ret    

008016e6 <devfile_write>:
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	53                   	push   %ebx
  8016ea:	83 ec 08             	sub    $0x8,%esp
  8016ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016f6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016fb:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  801701:	53                   	push   %ebx
  801702:	ff 75 0c             	pushl  0xc(%ebp)
  801705:	68 08 50 80 00       	push   $0x805008
  80170a:	e8 36 f4 ff ff       	call   800b45 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80170f:	ba 00 00 00 00       	mov    $0x0,%edx
  801714:	b8 04 00 00 00       	mov    $0x4,%eax
  801719:	e8 d6 fe ff ff       	call   8015f4 <fsipc>
  80171e:	83 c4 10             	add    $0x10,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	78 0b                	js     801730 <devfile_write+0x4a>
	assert(r <= n);
  801725:	39 d8                	cmp    %ebx,%eax
  801727:	77 0c                	ja     801735 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801729:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80172e:	7f 1e                	jg     80174e <devfile_write+0x68>
}
  801730:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801733:	c9                   	leave  
  801734:	c3                   	ret    
	assert(r <= n);
  801735:	68 c4 2a 80 00       	push   $0x802ac4
  80173a:	68 cb 2a 80 00       	push   $0x802acb
  80173f:	68 98 00 00 00       	push   $0x98
  801744:	68 e0 2a 80 00       	push   $0x802ae0
  801749:	e8 6a 0a 00 00       	call   8021b8 <_panic>
	assert(r <= PGSIZE);
  80174e:	68 eb 2a 80 00       	push   $0x802aeb
  801753:	68 cb 2a 80 00       	push   $0x802acb
  801758:	68 99 00 00 00       	push   $0x99
  80175d:	68 e0 2a 80 00       	push   $0x802ae0
  801762:	e8 51 0a 00 00       	call   8021b8 <_panic>

00801767 <devfile_read>:
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	8b 40 0c             	mov    0xc(%eax),%eax
  801775:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80177a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	b8 03 00 00 00       	mov    $0x3,%eax
  80178a:	e8 65 fe ff ff       	call   8015f4 <fsipc>
  80178f:	89 c3                	mov    %eax,%ebx
  801791:	85 c0                	test   %eax,%eax
  801793:	78 1f                	js     8017b4 <devfile_read+0x4d>
	assert(r <= n);
  801795:	39 f0                	cmp    %esi,%eax
  801797:	77 24                	ja     8017bd <devfile_read+0x56>
	assert(r <= PGSIZE);
  801799:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80179e:	7f 33                	jg     8017d3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	50                   	push   %eax
  8017a4:	68 00 50 80 00       	push   $0x805000
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	e8 32 f3 ff ff       	call   800ae3 <memmove>
	return r;
  8017b1:	83 c4 10             	add    $0x10,%esp
}
  8017b4:	89 d8                	mov    %ebx,%eax
  8017b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5e                   	pop    %esi
  8017bb:	5d                   	pop    %ebp
  8017bc:	c3                   	ret    
	assert(r <= n);
  8017bd:	68 c4 2a 80 00       	push   $0x802ac4
  8017c2:	68 cb 2a 80 00       	push   $0x802acb
  8017c7:	6a 7c                	push   $0x7c
  8017c9:	68 e0 2a 80 00       	push   $0x802ae0
  8017ce:	e8 e5 09 00 00       	call   8021b8 <_panic>
	assert(r <= PGSIZE);
  8017d3:	68 eb 2a 80 00       	push   $0x802aeb
  8017d8:	68 cb 2a 80 00       	push   $0x802acb
  8017dd:	6a 7d                	push   $0x7d
  8017df:	68 e0 2a 80 00       	push   $0x802ae0
  8017e4:	e8 cf 09 00 00       	call   8021b8 <_panic>

008017e9 <open>:
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	56                   	push   %esi
  8017ed:	53                   	push   %ebx
  8017ee:	83 ec 1c             	sub    $0x1c,%esp
  8017f1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017f4:	56                   	push   %esi
  8017f5:	e8 22 f1 ff ff       	call   80091c <strlen>
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801802:	7f 6c                	jg     801870 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801804:	83 ec 0c             	sub    $0xc,%esp
  801807:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80180a:	50                   	push   %eax
  80180b:	e8 79 f8 ff ff       	call   801089 <fd_alloc>
  801810:	89 c3                	mov    %eax,%ebx
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	85 c0                	test   %eax,%eax
  801817:	78 3c                	js     801855 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801819:	83 ec 08             	sub    $0x8,%esp
  80181c:	56                   	push   %esi
  80181d:	68 00 50 80 00       	push   $0x805000
  801822:	e8 2e f1 ff ff       	call   800955 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801827:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80182f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801832:	b8 01 00 00 00       	mov    $0x1,%eax
  801837:	e8 b8 fd ff ff       	call   8015f4 <fsipc>
  80183c:	89 c3                	mov    %eax,%ebx
  80183e:	83 c4 10             	add    $0x10,%esp
  801841:	85 c0                	test   %eax,%eax
  801843:	78 19                	js     80185e <open+0x75>
	return fd2num(fd);
  801845:	83 ec 0c             	sub    $0xc,%esp
  801848:	ff 75 f4             	pushl  -0xc(%ebp)
  80184b:	e8 12 f8 ff ff       	call   801062 <fd2num>
  801850:	89 c3                	mov    %eax,%ebx
  801852:	83 c4 10             	add    $0x10,%esp
}
  801855:	89 d8                	mov    %ebx,%eax
  801857:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185a:	5b                   	pop    %ebx
  80185b:	5e                   	pop    %esi
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    
		fd_close(fd, 0);
  80185e:	83 ec 08             	sub    $0x8,%esp
  801861:	6a 00                	push   $0x0
  801863:	ff 75 f4             	pushl  -0xc(%ebp)
  801866:	e8 1b f9 ff ff       	call   801186 <fd_close>
		return r;
  80186b:	83 c4 10             	add    $0x10,%esp
  80186e:	eb e5                	jmp    801855 <open+0x6c>
		return -E_BAD_PATH;
  801870:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801875:	eb de                	jmp    801855 <open+0x6c>

00801877 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801877:	55                   	push   %ebp
  801878:	89 e5                	mov    %esp,%ebp
  80187a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80187d:	ba 00 00 00 00       	mov    $0x0,%edx
  801882:	b8 08 00 00 00       	mov    $0x8,%eax
  801887:	e8 68 fd ff ff       	call   8015f4 <fsipc>
}
  80188c:	c9                   	leave  
  80188d:	c3                   	ret    

0080188e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801894:	68 f7 2a 80 00       	push   $0x802af7
  801899:	ff 75 0c             	pushl  0xc(%ebp)
  80189c:	e8 b4 f0 ff ff       	call   800955 <strcpy>
	return 0;
}
  8018a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018a6:	c9                   	leave  
  8018a7:	c3                   	ret    

008018a8 <devsock_close>:
{
  8018a8:	55                   	push   %ebp
  8018a9:	89 e5                	mov    %esp,%ebp
  8018ab:	53                   	push   %ebx
  8018ac:	83 ec 10             	sub    $0x10,%esp
  8018af:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8018b2:	53                   	push   %ebx
  8018b3:	e8 cc 0a 00 00       	call   802384 <pageref>
  8018b8:	83 c4 10             	add    $0x10,%esp
		return 0;
  8018bb:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018c0:	83 f8 01             	cmp    $0x1,%eax
  8018c3:	74 07                	je     8018cc <devsock_close+0x24>
}
  8018c5:	89 d0                	mov    %edx,%eax
  8018c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ca:	c9                   	leave  
  8018cb:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018cc:	83 ec 0c             	sub    $0xc,%esp
  8018cf:	ff 73 0c             	pushl  0xc(%ebx)
  8018d2:	e8 b9 02 00 00       	call   801b90 <nsipc_close>
  8018d7:	89 c2                	mov    %eax,%edx
  8018d9:	83 c4 10             	add    $0x10,%esp
  8018dc:	eb e7                	jmp    8018c5 <devsock_close+0x1d>

008018de <devsock_write>:
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018e4:	6a 00                	push   $0x0
  8018e6:	ff 75 10             	pushl  0x10(%ebp)
  8018e9:	ff 75 0c             	pushl  0xc(%ebp)
  8018ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ef:	ff 70 0c             	pushl  0xc(%eax)
  8018f2:	e8 76 03 00 00       	call   801c6d <nsipc_send>
}
  8018f7:	c9                   	leave  
  8018f8:	c3                   	ret    

008018f9 <devsock_read>:
{
  8018f9:	55                   	push   %ebp
  8018fa:	89 e5                	mov    %esp,%ebp
  8018fc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018ff:	6a 00                	push   $0x0
  801901:	ff 75 10             	pushl  0x10(%ebp)
  801904:	ff 75 0c             	pushl  0xc(%ebp)
  801907:	8b 45 08             	mov    0x8(%ebp),%eax
  80190a:	ff 70 0c             	pushl  0xc(%eax)
  80190d:	e8 ef 02 00 00       	call   801c01 <nsipc_recv>
}
  801912:	c9                   	leave  
  801913:	c3                   	ret    

00801914 <fd2sockid>:
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  80191a:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	e8 b7 f7 ff ff       	call   8010db <fd_lookup>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	85 c0                	test   %eax,%eax
  801929:	78 10                	js     80193b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80192b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80192e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801934:	39 08                	cmp    %ecx,(%eax)
  801936:	75 05                	jne    80193d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801938:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80193b:	c9                   	leave  
  80193c:	c3                   	ret    
		return -E_NOT_SUPP;
  80193d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801942:	eb f7                	jmp    80193b <fd2sockid+0x27>

00801944 <alloc_sockfd>:
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	56                   	push   %esi
  801948:	53                   	push   %ebx
  801949:	83 ec 1c             	sub    $0x1c,%esp
  80194c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80194e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801951:	50                   	push   %eax
  801952:	e8 32 f7 ff ff       	call   801089 <fd_alloc>
  801957:	89 c3                	mov    %eax,%ebx
  801959:	83 c4 10             	add    $0x10,%esp
  80195c:	85 c0                	test   %eax,%eax
  80195e:	78 43                	js     8019a3 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	68 07 04 00 00       	push   $0x407
  801968:	ff 75 f4             	pushl  -0xc(%ebp)
  80196b:	6a 00                	push   $0x0
  80196d:	e8 d5 f3 ff ff       	call   800d47 <sys_page_alloc>
  801972:	89 c3                	mov    %eax,%ebx
  801974:	83 c4 10             	add    $0x10,%esp
  801977:	85 c0                	test   %eax,%eax
  801979:	78 28                	js     8019a3 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80197b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80197e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801984:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801989:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801990:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801993:	83 ec 0c             	sub    $0xc,%esp
  801996:	50                   	push   %eax
  801997:	e8 c6 f6 ff ff       	call   801062 <fd2num>
  80199c:	89 c3                	mov    %eax,%ebx
  80199e:	83 c4 10             	add    $0x10,%esp
  8019a1:	eb 0c                	jmp    8019af <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8019a3:	83 ec 0c             	sub    $0xc,%esp
  8019a6:	56                   	push   %esi
  8019a7:	e8 e4 01 00 00       	call   801b90 <nsipc_close>
		return r;
  8019ac:	83 c4 10             	add    $0x10,%esp
}
  8019af:	89 d8                	mov    %ebx,%eax
  8019b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019b4:	5b                   	pop    %ebx
  8019b5:	5e                   	pop    %esi
  8019b6:	5d                   	pop    %ebp
  8019b7:	c3                   	ret    

008019b8 <accept>:
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	e8 4e ff ff ff       	call   801914 <fd2sockid>
  8019c6:	85 c0                	test   %eax,%eax
  8019c8:	78 1b                	js     8019e5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019ca:	83 ec 04             	sub    $0x4,%esp
  8019cd:	ff 75 10             	pushl  0x10(%ebp)
  8019d0:	ff 75 0c             	pushl  0xc(%ebp)
  8019d3:	50                   	push   %eax
  8019d4:	e8 0e 01 00 00       	call   801ae7 <nsipc_accept>
  8019d9:	83 c4 10             	add    $0x10,%esp
  8019dc:	85 c0                	test   %eax,%eax
  8019de:	78 05                	js     8019e5 <accept+0x2d>
	return alloc_sockfd(r);
  8019e0:	e8 5f ff ff ff       	call   801944 <alloc_sockfd>
}
  8019e5:	c9                   	leave  
  8019e6:	c3                   	ret    

008019e7 <bind>:
{
  8019e7:	55                   	push   %ebp
  8019e8:	89 e5                	mov    %esp,%ebp
  8019ea:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f0:	e8 1f ff ff ff       	call   801914 <fd2sockid>
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 12                	js     801a0b <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019f9:	83 ec 04             	sub    $0x4,%esp
  8019fc:	ff 75 10             	pushl  0x10(%ebp)
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	50                   	push   %eax
  801a03:	e8 31 01 00 00       	call   801b39 <nsipc_bind>
  801a08:	83 c4 10             	add    $0x10,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <shutdown>:
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
  801a10:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a13:	8b 45 08             	mov    0x8(%ebp),%eax
  801a16:	e8 f9 fe ff ff       	call   801914 <fd2sockid>
  801a1b:	85 c0                	test   %eax,%eax
  801a1d:	78 0f                	js     801a2e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  801a1f:	83 ec 08             	sub    $0x8,%esp
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	50                   	push   %eax
  801a26:	e8 43 01 00 00       	call   801b6e <nsipc_shutdown>
  801a2b:	83 c4 10             	add    $0x10,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <connect>:
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a36:	8b 45 08             	mov    0x8(%ebp),%eax
  801a39:	e8 d6 fe ff ff       	call   801914 <fd2sockid>
  801a3e:	85 c0                	test   %eax,%eax
  801a40:	78 12                	js     801a54 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a42:	83 ec 04             	sub    $0x4,%esp
  801a45:	ff 75 10             	pushl  0x10(%ebp)
  801a48:	ff 75 0c             	pushl  0xc(%ebp)
  801a4b:	50                   	push   %eax
  801a4c:	e8 59 01 00 00       	call   801baa <nsipc_connect>
  801a51:	83 c4 10             	add    $0x10,%esp
}
  801a54:	c9                   	leave  
  801a55:	c3                   	ret    

00801a56 <listen>:
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
  801a59:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	e8 b0 fe ff ff       	call   801914 <fd2sockid>
  801a64:	85 c0                	test   %eax,%eax
  801a66:	78 0f                	js     801a77 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a68:	83 ec 08             	sub    $0x8,%esp
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	50                   	push   %eax
  801a6f:	e8 6b 01 00 00       	call   801bdf <nsipc_listen>
  801a74:	83 c4 10             	add    $0x10,%esp
}
  801a77:	c9                   	leave  
  801a78:	c3                   	ret    

00801a79 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a79:	55                   	push   %ebp
  801a7a:	89 e5                	mov    %esp,%ebp
  801a7c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a7f:	ff 75 10             	pushl  0x10(%ebp)
  801a82:	ff 75 0c             	pushl  0xc(%ebp)
  801a85:	ff 75 08             	pushl  0x8(%ebp)
  801a88:	e8 3e 02 00 00       	call   801ccb <nsipc_socket>
  801a8d:	83 c4 10             	add    $0x10,%esp
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 05                	js     801a99 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a94:	e8 ab fe ff ff       	call   801944 <alloc_sockfd>
}
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
  801a9e:	53                   	push   %ebx
  801a9f:	83 ec 04             	sub    $0x4,%esp
  801aa2:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801aa4:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801aab:	74 26                	je     801ad3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801aad:	6a 07                	push   $0x7
  801aaf:	68 00 60 80 00       	push   $0x806000
  801ab4:	53                   	push   %ebx
  801ab5:	ff 35 04 40 80 00    	pushl  0x804004
  801abb:	e8 31 08 00 00       	call   8022f1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ac0:	83 c4 0c             	add    $0xc,%esp
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	e8 ba 07 00 00       	call   802288 <ipc_recv>
}
  801ace:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ad3:	83 ec 0c             	sub    $0xc,%esp
  801ad6:	6a 02                	push   $0x2
  801ad8:	e8 6c 08 00 00       	call   802349 <ipc_find_env>
  801add:	a3 04 40 80 00       	mov    %eax,0x804004
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	eb c6                	jmp    801aad <nsipc+0x12>

00801ae7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ae7:	55                   	push   %ebp
  801ae8:	89 e5                	mov    %esp,%ebp
  801aea:	56                   	push   %esi
  801aeb:	53                   	push   %ebx
  801aec:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801aef:	8b 45 08             	mov    0x8(%ebp),%eax
  801af2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801af7:	8b 06                	mov    (%esi),%eax
  801af9:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801afe:	b8 01 00 00 00       	mov    $0x1,%eax
  801b03:	e8 93 ff ff ff       	call   801a9b <nsipc>
  801b08:	89 c3                	mov    %eax,%ebx
  801b0a:	85 c0                	test   %eax,%eax
  801b0c:	79 09                	jns    801b17 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801b0e:	89 d8                	mov    %ebx,%eax
  801b10:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b13:	5b                   	pop    %ebx
  801b14:	5e                   	pop    %esi
  801b15:	5d                   	pop    %ebp
  801b16:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801b17:	83 ec 04             	sub    $0x4,%esp
  801b1a:	ff 35 10 60 80 00    	pushl  0x806010
  801b20:	68 00 60 80 00       	push   $0x806000
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	e8 b6 ef ff ff       	call   800ae3 <memmove>
		*addrlen = ret->ret_addrlen;
  801b2d:	a1 10 60 80 00       	mov    0x806010,%eax
  801b32:	89 06                	mov    %eax,(%esi)
  801b34:	83 c4 10             	add    $0x10,%esp
	return r;
  801b37:	eb d5                	jmp    801b0e <nsipc_accept+0x27>

00801b39 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
  801b3c:	53                   	push   %ebx
  801b3d:	83 ec 08             	sub    $0x8,%esp
  801b40:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b4b:	53                   	push   %ebx
  801b4c:	ff 75 0c             	pushl  0xc(%ebp)
  801b4f:	68 04 60 80 00       	push   $0x806004
  801b54:	e8 8a ef ff ff       	call   800ae3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b59:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b5f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b64:	e8 32 ff ff ff       	call   801a9b <nsipc>
}
  801b69:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b74:	8b 45 08             	mov    0x8(%ebp),%eax
  801b77:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b84:	b8 03 00 00 00       	mov    $0x3,%eax
  801b89:	e8 0d ff ff ff       	call   801a9b <nsipc>
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <nsipc_close>:

int
nsipc_close(int s)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b9e:	b8 04 00 00 00       	mov    $0x4,%eax
  801ba3:	e8 f3 fe ff ff       	call   801a9b <nsipc>
}
  801ba8:	c9                   	leave  
  801ba9:	c3                   	ret    

00801baa <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801baa:	55                   	push   %ebp
  801bab:	89 e5                	mov    %esp,%ebp
  801bad:	53                   	push   %ebx
  801bae:	83 ec 08             	sub    $0x8,%esp
  801bb1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801bbc:	53                   	push   %ebx
  801bbd:	ff 75 0c             	pushl  0xc(%ebp)
  801bc0:	68 04 60 80 00       	push   $0x806004
  801bc5:	e8 19 ef ff ff       	call   800ae3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801bca:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bd0:	b8 05 00 00 00       	mov    $0x5,%eax
  801bd5:	e8 c1 fe ff ff       	call   801a9b <nsipc>
}
  801bda:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bf5:	b8 06 00 00 00       	mov    $0x6,%eax
  801bfa:	e8 9c fe ff ff       	call   801a9b <nsipc>
}
  801bff:	c9                   	leave  
  801c00:	c3                   	ret    

00801c01 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801c01:	55                   	push   %ebp
  801c02:	89 e5                	mov    %esp,%ebp
  801c04:	56                   	push   %esi
  801c05:	53                   	push   %ebx
  801c06:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801c09:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0c:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801c11:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801c17:	8b 45 14             	mov    0x14(%ebp),%eax
  801c1a:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801c1f:	b8 07 00 00 00       	mov    $0x7,%eax
  801c24:	e8 72 fe ff ff       	call   801a9b <nsipc>
  801c29:	89 c3                	mov    %eax,%ebx
  801c2b:	85 c0                	test   %eax,%eax
  801c2d:	78 1f                	js     801c4e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c2f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c34:	7f 21                	jg     801c57 <nsipc_recv+0x56>
  801c36:	39 c6                	cmp    %eax,%esi
  801c38:	7c 1d                	jl     801c57 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c3a:	83 ec 04             	sub    $0x4,%esp
  801c3d:	50                   	push   %eax
  801c3e:	68 00 60 80 00       	push   $0x806000
  801c43:	ff 75 0c             	pushl  0xc(%ebp)
  801c46:	e8 98 ee ff ff       	call   800ae3 <memmove>
  801c4b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c4e:	89 d8                	mov    %ebx,%eax
  801c50:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5d                   	pop    %ebp
  801c56:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c57:	68 03 2b 80 00       	push   $0x802b03
  801c5c:	68 cb 2a 80 00       	push   $0x802acb
  801c61:	6a 62                	push   $0x62
  801c63:	68 18 2b 80 00       	push   $0x802b18
  801c68:	e8 4b 05 00 00       	call   8021b8 <_panic>

00801c6d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c6d:	55                   	push   %ebp
  801c6e:	89 e5                	mov    %esp,%ebp
  801c70:	53                   	push   %ebx
  801c71:	83 ec 04             	sub    $0x4,%esp
  801c74:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c7f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c85:	7f 2e                	jg     801cb5 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c87:	83 ec 04             	sub    $0x4,%esp
  801c8a:	53                   	push   %ebx
  801c8b:	ff 75 0c             	pushl  0xc(%ebp)
  801c8e:	68 0c 60 80 00       	push   $0x80600c
  801c93:	e8 4b ee ff ff       	call   800ae3 <memmove>
	nsipcbuf.send.req_size = size;
  801c98:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c9e:	8b 45 14             	mov    0x14(%ebp),%eax
  801ca1:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801ca6:	b8 08 00 00 00       	mov    $0x8,%eax
  801cab:	e8 eb fd ff ff       	call   801a9b <nsipc>
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    
	assert(size < 1600);
  801cb5:	68 24 2b 80 00       	push   $0x802b24
  801cba:	68 cb 2a 80 00       	push   $0x802acb
  801cbf:	6a 6d                	push   $0x6d
  801cc1:	68 18 2b 80 00       	push   $0x802b18
  801cc6:	e8 ed 04 00 00       	call   8021b8 <_panic>

00801ccb <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cdc:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801ce1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801ce9:	b8 09 00 00 00       	mov    $0x9,%eax
  801cee:	e8 a8 fd ff ff       	call   801a9b <nsipc>
}
  801cf3:	c9                   	leave  
  801cf4:	c3                   	ret    

00801cf5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
  801cf8:	56                   	push   %esi
  801cf9:	53                   	push   %ebx
  801cfa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cfd:	83 ec 0c             	sub    $0xc,%esp
  801d00:	ff 75 08             	pushl  0x8(%ebp)
  801d03:	e8 6a f3 ff ff       	call   801072 <fd2data>
  801d08:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d0a:	83 c4 08             	add    $0x8,%esp
  801d0d:	68 30 2b 80 00       	push   $0x802b30
  801d12:	53                   	push   %ebx
  801d13:	e8 3d ec ff ff       	call   800955 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d18:	8b 46 04             	mov    0x4(%esi),%eax
  801d1b:	2b 06                	sub    (%esi),%eax
  801d1d:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d23:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d2a:	00 00 00 
	stat->st_dev = &devpipe;
  801d2d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d34:	30 80 00 
	return 0;
}
  801d37:	b8 00 00 00 00       	mov    $0x0,%eax
  801d3c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d3f:	5b                   	pop    %ebx
  801d40:	5e                   	pop    %esi
  801d41:	5d                   	pop    %ebp
  801d42:	c3                   	ret    

00801d43 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	53                   	push   %ebx
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d4d:	53                   	push   %ebx
  801d4e:	6a 00                	push   $0x0
  801d50:	e8 77 f0 ff ff       	call   800dcc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d55:	89 1c 24             	mov    %ebx,(%esp)
  801d58:	e8 15 f3 ff ff       	call   801072 <fd2data>
  801d5d:	83 c4 08             	add    $0x8,%esp
  801d60:	50                   	push   %eax
  801d61:	6a 00                	push   $0x0
  801d63:	e8 64 f0 ff ff       	call   800dcc <sys_page_unmap>
}
  801d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <_pipeisclosed>:
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
  801d70:	57                   	push   %edi
  801d71:	56                   	push   %esi
  801d72:	53                   	push   %ebx
  801d73:	83 ec 1c             	sub    $0x1c,%esp
  801d76:	89 c7                	mov    %eax,%edi
  801d78:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d7a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d7f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d82:	83 ec 0c             	sub    $0xc,%esp
  801d85:	57                   	push   %edi
  801d86:	e8 f9 05 00 00       	call   802384 <pageref>
  801d8b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d8e:	89 34 24             	mov    %esi,(%esp)
  801d91:	e8 ee 05 00 00       	call   802384 <pageref>
		nn = thisenv->env_runs;
  801d96:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d9c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d9f:	83 c4 10             	add    $0x10,%esp
  801da2:	39 cb                	cmp    %ecx,%ebx
  801da4:	74 1b                	je     801dc1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801da6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da9:	75 cf                	jne    801d7a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dab:	8b 42 58             	mov    0x58(%edx),%eax
  801dae:	6a 01                	push   $0x1
  801db0:	50                   	push   %eax
  801db1:	53                   	push   %ebx
  801db2:	68 37 2b 80 00       	push   $0x802b37
  801db7:	e8 3a e4 ff ff       	call   8001f6 <cprintf>
  801dbc:	83 c4 10             	add    $0x10,%esp
  801dbf:	eb b9                	jmp    801d7a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801dc1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801dc4:	0f 94 c0             	sete   %al
  801dc7:	0f b6 c0             	movzbl %al,%eax
}
  801dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dcd:	5b                   	pop    %ebx
  801dce:	5e                   	pop    %esi
  801dcf:	5f                   	pop    %edi
  801dd0:	5d                   	pop    %ebp
  801dd1:	c3                   	ret    

00801dd2 <devpipe_write>:
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	57                   	push   %edi
  801dd6:	56                   	push   %esi
  801dd7:	53                   	push   %ebx
  801dd8:	83 ec 28             	sub    $0x28,%esp
  801ddb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dde:	56                   	push   %esi
  801ddf:	e8 8e f2 ff ff       	call   801072 <fd2data>
  801de4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801de6:	83 c4 10             	add    $0x10,%esp
  801de9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dee:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801df1:	74 4f                	je     801e42 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801df3:	8b 43 04             	mov    0x4(%ebx),%eax
  801df6:	8b 0b                	mov    (%ebx),%ecx
  801df8:	8d 51 20             	lea    0x20(%ecx),%edx
  801dfb:	39 d0                	cmp    %edx,%eax
  801dfd:	72 14                	jb     801e13 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801dff:	89 da                	mov    %ebx,%edx
  801e01:	89 f0                	mov    %esi,%eax
  801e03:	e8 65 ff ff ff       	call   801d6d <_pipeisclosed>
  801e08:	85 c0                	test   %eax,%eax
  801e0a:	75 3b                	jne    801e47 <devpipe_write+0x75>
			sys_yield();
  801e0c:	e8 17 ef ff ff       	call   800d28 <sys_yield>
  801e11:	eb e0                	jmp    801df3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e16:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801e1a:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801e1d:	89 c2                	mov    %eax,%edx
  801e1f:	c1 fa 1f             	sar    $0x1f,%edx
  801e22:	89 d1                	mov    %edx,%ecx
  801e24:	c1 e9 1b             	shr    $0x1b,%ecx
  801e27:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e2a:	83 e2 1f             	and    $0x1f,%edx
  801e2d:	29 ca                	sub    %ecx,%edx
  801e2f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e33:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e37:	83 c0 01             	add    $0x1,%eax
  801e3a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e3d:	83 c7 01             	add    $0x1,%edi
  801e40:	eb ac                	jmp    801dee <devpipe_write+0x1c>
	return i;
  801e42:	8b 45 10             	mov    0x10(%ebp),%eax
  801e45:	eb 05                	jmp    801e4c <devpipe_write+0x7a>
				return 0;
  801e47:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e4f:	5b                   	pop    %ebx
  801e50:	5e                   	pop    %esi
  801e51:	5f                   	pop    %edi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    

00801e54 <devpipe_read>:
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	57                   	push   %edi
  801e58:	56                   	push   %esi
  801e59:	53                   	push   %ebx
  801e5a:	83 ec 18             	sub    $0x18,%esp
  801e5d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e60:	57                   	push   %edi
  801e61:	e8 0c f2 ff ff       	call   801072 <fd2data>
  801e66:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e68:	83 c4 10             	add    $0x10,%esp
  801e6b:	be 00 00 00 00       	mov    $0x0,%esi
  801e70:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e73:	75 14                	jne    801e89 <devpipe_read+0x35>
	return i;
  801e75:	8b 45 10             	mov    0x10(%ebp),%eax
  801e78:	eb 02                	jmp    801e7c <devpipe_read+0x28>
				return i;
  801e7a:	89 f0                	mov    %esi,%eax
}
  801e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    
			sys_yield();
  801e84:	e8 9f ee ff ff       	call   800d28 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e89:	8b 03                	mov    (%ebx),%eax
  801e8b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e8e:	75 18                	jne    801ea8 <devpipe_read+0x54>
			if (i > 0)
  801e90:	85 f6                	test   %esi,%esi
  801e92:	75 e6                	jne    801e7a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e94:	89 da                	mov    %ebx,%edx
  801e96:	89 f8                	mov    %edi,%eax
  801e98:	e8 d0 fe ff ff       	call   801d6d <_pipeisclosed>
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	74 e3                	je     801e84 <devpipe_read+0x30>
				return 0;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea6:	eb d4                	jmp    801e7c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ea8:	99                   	cltd   
  801ea9:	c1 ea 1b             	shr    $0x1b,%edx
  801eac:	01 d0                	add    %edx,%eax
  801eae:	83 e0 1f             	and    $0x1f,%eax
  801eb1:	29 d0                	sub    %edx,%eax
  801eb3:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801eb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ebb:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801ebe:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ec1:	83 c6 01             	add    $0x1,%esi
  801ec4:	eb aa                	jmp    801e70 <devpipe_read+0x1c>

00801ec6 <pipe>:
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	56                   	push   %esi
  801eca:	53                   	push   %ebx
  801ecb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ece:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed1:	50                   	push   %eax
  801ed2:	e8 b2 f1 ff ff       	call   801089 <fd_alloc>
  801ed7:	89 c3                	mov    %eax,%ebx
  801ed9:	83 c4 10             	add    $0x10,%esp
  801edc:	85 c0                	test   %eax,%eax
  801ede:	0f 88 23 01 00 00    	js     802007 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ee4:	83 ec 04             	sub    $0x4,%esp
  801ee7:	68 07 04 00 00       	push   $0x407
  801eec:	ff 75 f4             	pushl  -0xc(%ebp)
  801eef:	6a 00                	push   $0x0
  801ef1:	e8 51 ee ff ff       	call   800d47 <sys_page_alloc>
  801ef6:	89 c3                	mov    %eax,%ebx
  801ef8:	83 c4 10             	add    $0x10,%esp
  801efb:	85 c0                	test   %eax,%eax
  801efd:	0f 88 04 01 00 00    	js     802007 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801f03:	83 ec 0c             	sub    $0xc,%esp
  801f06:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f09:	50                   	push   %eax
  801f0a:	e8 7a f1 ff ff       	call   801089 <fd_alloc>
  801f0f:	89 c3                	mov    %eax,%ebx
  801f11:	83 c4 10             	add    $0x10,%esp
  801f14:	85 c0                	test   %eax,%eax
  801f16:	0f 88 db 00 00 00    	js     801ff7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f1c:	83 ec 04             	sub    $0x4,%esp
  801f1f:	68 07 04 00 00       	push   $0x407
  801f24:	ff 75 f0             	pushl  -0x10(%ebp)
  801f27:	6a 00                	push   $0x0
  801f29:	e8 19 ee ff ff       	call   800d47 <sys_page_alloc>
  801f2e:	89 c3                	mov    %eax,%ebx
  801f30:	83 c4 10             	add    $0x10,%esp
  801f33:	85 c0                	test   %eax,%eax
  801f35:	0f 88 bc 00 00 00    	js     801ff7 <pipe+0x131>
	va = fd2data(fd0);
  801f3b:	83 ec 0c             	sub    $0xc,%esp
  801f3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f41:	e8 2c f1 ff ff       	call   801072 <fd2data>
  801f46:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f48:	83 c4 0c             	add    $0xc,%esp
  801f4b:	68 07 04 00 00       	push   $0x407
  801f50:	50                   	push   %eax
  801f51:	6a 00                	push   $0x0
  801f53:	e8 ef ed ff ff       	call   800d47 <sys_page_alloc>
  801f58:	89 c3                	mov    %eax,%ebx
  801f5a:	83 c4 10             	add    $0x10,%esp
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	0f 88 82 00 00 00    	js     801fe7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f65:	83 ec 0c             	sub    $0xc,%esp
  801f68:	ff 75 f0             	pushl  -0x10(%ebp)
  801f6b:	e8 02 f1 ff ff       	call   801072 <fd2data>
  801f70:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f77:	50                   	push   %eax
  801f78:	6a 00                	push   $0x0
  801f7a:	56                   	push   %esi
  801f7b:	6a 00                	push   $0x0
  801f7d:	e8 08 ee ff ff       	call   800d8a <sys_page_map>
  801f82:	89 c3                	mov    %eax,%ebx
  801f84:	83 c4 20             	add    $0x20,%esp
  801f87:	85 c0                	test   %eax,%eax
  801f89:	78 4e                	js     801fd9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f8b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f93:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f95:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f98:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f9f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801fa2:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fa7:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	ff 75 f4             	pushl  -0xc(%ebp)
  801fb4:	e8 a9 f0 ff ff       	call   801062 <fd2num>
  801fb9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fbc:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801fbe:	83 c4 04             	add    $0x4,%esp
  801fc1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fc4:	e8 99 f0 ff ff       	call   801062 <fd2num>
  801fc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fcc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801fcf:	83 c4 10             	add    $0x10,%esp
  801fd2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fd7:	eb 2e                	jmp    802007 <pipe+0x141>
	sys_page_unmap(0, va);
  801fd9:	83 ec 08             	sub    $0x8,%esp
  801fdc:	56                   	push   %esi
  801fdd:	6a 00                	push   $0x0
  801fdf:	e8 e8 ed ff ff       	call   800dcc <sys_page_unmap>
  801fe4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fe7:	83 ec 08             	sub    $0x8,%esp
  801fea:	ff 75 f0             	pushl  -0x10(%ebp)
  801fed:	6a 00                	push   $0x0
  801fef:	e8 d8 ed ff ff       	call   800dcc <sys_page_unmap>
  801ff4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ff7:	83 ec 08             	sub    $0x8,%esp
  801ffa:	ff 75 f4             	pushl  -0xc(%ebp)
  801ffd:	6a 00                	push   $0x0
  801fff:	e8 c8 ed ff ff       	call   800dcc <sys_page_unmap>
  802004:	83 c4 10             	add    $0x10,%esp
}
  802007:	89 d8                	mov    %ebx,%eax
  802009:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80200c:	5b                   	pop    %ebx
  80200d:	5e                   	pop    %esi
  80200e:	5d                   	pop    %ebp
  80200f:	c3                   	ret    

00802010 <pipeisclosed>:
{
  802010:	55                   	push   %ebp
  802011:	89 e5                	mov    %esp,%ebp
  802013:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802016:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802019:	50                   	push   %eax
  80201a:	ff 75 08             	pushl  0x8(%ebp)
  80201d:	e8 b9 f0 ff ff       	call   8010db <fd_lookup>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	85 c0                	test   %eax,%eax
  802027:	78 18                	js     802041 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802029:	83 ec 0c             	sub    $0xc,%esp
  80202c:	ff 75 f4             	pushl  -0xc(%ebp)
  80202f:	e8 3e f0 ff ff       	call   801072 <fd2data>
	return _pipeisclosed(fd, p);
  802034:	89 c2                	mov    %eax,%edx
  802036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802039:	e8 2f fd ff ff       	call   801d6d <_pipeisclosed>
  80203e:	83 c4 10             	add    $0x10,%esp
}
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802043:	b8 00 00 00 00       	mov    $0x0,%eax
  802048:	c3                   	ret    

00802049 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802049:	55                   	push   %ebp
  80204a:	89 e5                	mov    %esp,%ebp
  80204c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80204f:	68 4f 2b 80 00       	push   $0x802b4f
  802054:	ff 75 0c             	pushl  0xc(%ebp)
  802057:	e8 f9 e8 ff ff       	call   800955 <strcpy>
	return 0;
}
  80205c:	b8 00 00 00 00       	mov    $0x0,%eax
  802061:	c9                   	leave  
  802062:	c3                   	ret    

00802063 <devcons_write>:
{
  802063:	55                   	push   %ebp
  802064:	89 e5                	mov    %esp,%ebp
  802066:	57                   	push   %edi
  802067:	56                   	push   %esi
  802068:	53                   	push   %ebx
  802069:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80206f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802074:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80207a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80207d:	73 31                	jae    8020b0 <devcons_write+0x4d>
		m = n - tot;
  80207f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802082:	29 f3                	sub    %esi,%ebx
  802084:	83 fb 7f             	cmp    $0x7f,%ebx
  802087:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80208c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80208f:	83 ec 04             	sub    $0x4,%esp
  802092:	53                   	push   %ebx
  802093:	89 f0                	mov    %esi,%eax
  802095:	03 45 0c             	add    0xc(%ebp),%eax
  802098:	50                   	push   %eax
  802099:	57                   	push   %edi
  80209a:	e8 44 ea ff ff       	call   800ae3 <memmove>
		sys_cputs(buf, m);
  80209f:	83 c4 08             	add    $0x8,%esp
  8020a2:	53                   	push   %ebx
  8020a3:	57                   	push   %edi
  8020a4:	e8 e2 eb ff ff       	call   800c8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020a9:	01 de                	add    %ebx,%esi
  8020ab:	83 c4 10             	add    $0x10,%esp
  8020ae:	eb ca                	jmp    80207a <devcons_write+0x17>
}
  8020b0:	89 f0                	mov    %esi,%eax
  8020b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020b5:	5b                   	pop    %ebx
  8020b6:	5e                   	pop    %esi
  8020b7:	5f                   	pop    %edi
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    

008020ba <devcons_read>:
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	83 ec 08             	sub    $0x8,%esp
  8020c0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020c5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020c9:	74 21                	je     8020ec <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020cb:	e8 d9 eb ff ff       	call   800ca9 <sys_cgetc>
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	75 07                	jne    8020db <devcons_read+0x21>
		sys_yield();
  8020d4:	e8 4f ec ff ff       	call   800d28 <sys_yield>
  8020d9:	eb f0                	jmp    8020cb <devcons_read+0x11>
	if (c < 0)
  8020db:	78 0f                	js     8020ec <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020dd:	83 f8 04             	cmp    $0x4,%eax
  8020e0:	74 0c                	je     8020ee <devcons_read+0x34>
	*(char*)vbuf = c;
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	88 02                	mov    %al,(%edx)
	return 1;
  8020e7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    
		return 0;
  8020ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f3:	eb f7                	jmp    8020ec <devcons_read+0x32>

008020f5 <cputchar>:
{
  8020f5:	55                   	push   %ebp
  8020f6:	89 e5                	mov    %esp,%ebp
  8020f8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  802101:	6a 01                	push   $0x1
  802103:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802106:	50                   	push   %eax
  802107:	e8 7f eb ff ff       	call   800c8b <sys_cputs>
}
  80210c:	83 c4 10             	add    $0x10,%esp
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <getchar>:
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802117:	6a 01                	push   $0x1
  802119:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80211c:	50                   	push   %eax
  80211d:	6a 00                	push   $0x0
  80211f:	e8 27 f2 ff ff       	call   80134b <read>
	if (r < 0)
  802124:	83 c4 10             	add    $0x10,%esp
  802127:	85 c0                	test   %eax,%eax
  802129:	78 06                	js     802131 <getchar+0x20>
	if (r < 1)
  80212b:	74 06                	je     802133 <getchar+0x22>
	return c;
  80212d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802131:	c9                   	leave  
  802132:	c3                   	ret    
		return -E_EOF;
  802133:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802138:	eb f7                	jmp    802131 <getchar+0x20>

0080213a <iscons>:
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802140:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802143:	50                   	push   %eax
  802144:	ff 75 08             	pushl  0x8(%ebp)
  802147:	e8 8f ef ff ff       	call   8010db <fd_lookup>
  80214c:	83 c4 10             	add    $0x10,%esp
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 11                	js     802164 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802153:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802156:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80215c:	39 10                	cmp    %edx,(%eax)
  80215e:	0f 94 c0             	sete   %al
  802161:	0f b6 c0             	movzbl %al,%eax
}
  802164:	c9                   	leave  
  802165:	c3                   	ret    

00802166 <opencons>:
{
  802166:	55                   	push   %ebp
  802167:	89 e5                	mov    %esp,%ebp
  802169:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80216c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80216f:	50                   	push   %eax
  802170:	e8 14 ef ff ff       	call   801089 <fd_alloc>
  802175:	83 c4 10             	add    $0x10,%esp
  802178:	85 c0                	test   %eax,%eax
  80217a:	78 3a                	js     8021b6 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80217c:	83 ec 04             	sub    $0x4,%esp
  80217f:	68 07 04 00 00       	push   $0x407
  802184:	ff 75 f4             	pushl  -0xc(%ebp)
  802187:	6a 00                	push   $0x0
  802189:	e8 b9 eb ff ff       	call   800d47 <sys_page_alloc>
  80218e:	83 c4 10             	add    $0x10,%esp
  802191:	85 c0                	test   %eax,%eax
  802193:	78 21                	js     8021b6 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802198:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80219e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021aa:	83 ec 0c             	sub    $0xc,%esp
  8021ad:	50                   	push   %eax
  8021ae:	e8 af ee ff ff       	call   801062 <fd2num>
  8021b3:	83 c4 10             	add    $0x10,%esp
}
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	56                   	push   %esi
  8021bc:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8021bd:	a1 08 40 80 00       	mov    0x804008,%eax
  8021c2:	8b 40 48             	mov    0x48(%eax),%eax
  8021c5:	83 ec 04             	sub    $0x4,%esp
  8021c8:	68 80 2b 80 00       	push   $0x802b80
  8021cd:	50                   	push   %eax
  8021ce:	68 78 26 80 00       	push   $0x802678
  8021d3:	e8 1e e0 ff ff       	call   8001f6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021d8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021db:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021e1:	e8 23 eb ff ff       	call   800d09 <sys_getenvid>
  8021e6:	83 c4 04             	add    $0x4,%esp
  8021e9:	ff 75 0c             	pushl  0xc(%ebp)
  8021ec:	ff 75 08             	pushl  0x8(%ebp)
  8021ef:	56                   	push   %esi
  8021f0:	50                   	push   %eax
  8021f1:	68 5c 2b 80 00       	push   $0x802b5c
  8021f6:	e8 fb df ff ff       	call   8001f6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021fb:	83 c4 18             	add    $0x18,%esp
  8021fe:	53                   	push   %ebx
  8021ff:	ff 75 10             	pushl  0x10(%ebp)
  802202:	e8 9e df ff ff       	call   8001a5 <vcprintf>
	cprintf("\n");
  802207:	c7 04 24 3c 26 80 00 	movl   $0x80263c,(%esp)
  80220e:	e8 e3 df ff ff       	call   8001f6 <cprintf>
  802213:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802216:	cc                   	int3   
  802217:	eb fd                	jmp    802216 <_panic+0x5e>

00802219 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802219:	55                   	push   %ebp
  80221a:	89 e5                	mov    %esp,%ebp
  80221c:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  80221f:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802226:	74 0a                	je     802232 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802228:	8b 45 08             	mov    0x8(%ebp),%eax
  80222b:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802230:	c9                   	leave  
  802231:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802232:	83 ec 04             	sub    $0x4,%esp
  802235:	6a 07                	push   $0x7
  802237:	68 00 f0 bf ee       	push   $0xeebff000
  80223c:	6a 00                	push   $0x0
  80223e:	e8 04 eb ff ff       	call   800d47 <sys_page_alloc>
		if(r < 0)
  802243:	83 c4 10             	add    $0x10,%esp
  802246:	85 c0                	test   %eax,%eax
  802248:	78 2a                	js     802274 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80224a:	83 ec 08             	sub    $0x8,%esp
  80224d:	68 3c 10 80 00       	push   $0x80103c
  802252:	6a 00                	push   $0x0
  802254:	e8 39 ec ff ff       	call   800e92 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802259:	83 c4 10             	add    $0x10,%esp
  80225c:	85 c0                	test   %eax,%eax
  80225e:	79 c8                	jns    802228 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802260:	83 ec 04             	sub    $0x4,%esp
  802263:	68 b8 2b 80 00       	push   $0x802bb8
  802268:	6a 25                	push   $0x25
  80226a:	68 f4 2b 80 00       	push   $0x802bf4
  80226f:	e8 44 ff ff ff       	call   8021b8 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	68 88 2b 80 00       	push   $0x802b88
  80227c:	6a 22                	push   $0x22
  80227e:	68 f4 2b 80 00       	push   $0x802bf4
  802283:	e8 30 ff ff ff       	call   8021b8 <_panic>

00802288 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802288:	55                   	push   %ebp
  802289:	89 e5                	mov    %esp,%ebp
  80228b:	56                   	push   %esi
  80228c:	53                   	push   %ebx
  80228d:	8b 75 08             	mov    0x8(%ebp),%esi
  802290:	8b 45 0c             	mov    0xc(%ebp),%eax
  802293:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802296:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802298:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80229d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  8022a0:	83 ec 0c             	sub    $0xc,%esp
  8022a3:	50                   	push   %eax
  8022a4:	e8 4e ec ff ff       	call   800ef7 <sys_ipc_recv>
	if(ret < 0){
  8022a9:	83 c4 10             	add    $0x10,%esp
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	78 2b                	js     8022db <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  8022b0:	85 f6                	test   %esi,%esi
  8022b2:	74 0a                	je     8022be <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8022b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b9:	8b 40 74             	mov    0x74(%eax),%eax
  8022bc:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8022be:	85 db                	test   %ebx,%ebx
  8022c0:	74 0a                	je     8022cc <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022c2:	a1 08 40 80 00       	mov    0x804008,%eax
  8022c7:	8b 40 78             	mov    0x78(%eax),%eax
  8022ca:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022cc:	a1 08 40 80 00       	mov    0x804008,%eax
  8022d1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022d7:	5b                   	pop    %ebx
  8022d8:	5e                   	pop    %esi
  8022d9:	5d                   	pop    %ebp
  8022da:	c3                   	ret    
		if(from_env_store)
  8022db:	85 f6                	test   %esi,%esi
  8022dd:	74 06                	je     8022e5 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022df:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022e5:	85 db                	test   %ebx,%ebx
  8022e7:	74 eb                	je     8022d4 <ipc_recv+0x4c>
			*perm_store = 0;
  8022e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022ef:	eb e3                	jmp    8022d4 <ipc_recv+0x4c>

008022f1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	57                   	push   %edi
  8022f5:	56                   	push   %esi
  8022f6:	53                   	push   %ebx
  8022f7:	83 ec 0c             	sub    $0xc,%esp
  8022fa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  802300:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  802303:	85 db                	test   %ebx,%ebx
  802305:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  80230a:	0f 44 d8             	cmove  %eax,%ebx
  80230d:	eb 05                	jmp    802314 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  80230f:	e8 14 ea ff ff       	call   800d28 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802314:	ff 75 14             	pushl  0x14(%ebp)
  802317:	53                   	push   %ebx
  802318:	56                   	push   %esi
  802319:	57                   	push   %edi
  80231a:	e8 b5 eb ff ff       	call   800ed4 <sys_ipc_try_send>
  80231f:	83 c4 10             	add    $0x10,%esp
  802322:	85 c0                	test   %eax,%eax
  802324:	74 1b                	je     802341 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802326:	79 e7                	jns    80230f <ipc_send+0x1e>
  802328:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80232b:	74 e2                	je     80230f <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80232d:	83 ec 04             	sub    $0x4,%esp
  802330:	68 02 2c 80 00       	push   $0x802c02
  802335:	6a 46                	push   $0x46
  802337:	68 17 2c 80 00       	push   $0x802c17
  80233c:	e8 77 fe ff ff       	call   8021b8 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802341:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802344:	5b                   	pop    %ebx
  802345:	5e                   	pop    %esi
  802346:	5f                   	pop    %edi
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    

00802349 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80234f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802354:	89 c2                	mov    %eax,%edx
  802356:	c1 e2 07             	shl    $0x7,%edx
  802359:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80235f:	8b 52 50             	mov    0x50(%edx),%edx
  802362:	39 ca                	cmp    %ecx,%edx
  802364:	74 11                	je     802377 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802366:	83 c0 01             	add    $0x1,%eax
  802369:	3d 00 04 00 00       	cmp    $0x400,%eax
  80236e:	75 e4                	jne    802354 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802370:	b8 00 00 00 00       	mov    $0x0,%eax
  802375:	eb 0b                	jmp    802382 <ipc_find_env+0x39>
			return envs[i].env_id;
  802377:	c1 e0 07             	shl    $0x7,%eax
  80237a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80237f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    

00802384 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802384:	55                   	push   %ebp
  802385:	89 e5                	mov    %esp,%ebp
  802387:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80238a:	89 d0                	mov    %edx,%eax
  80238c:	c1 e8 16             	shr    $0x16,%eax
  80238f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802396:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80239b:	f6 c1 01             	test   $0x1,%cl
  80239e:	74 1d                	je     8023bd <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  8023a0:	c1 ea 0c             	shr    $0xc,%edx
  8023a3:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  8023aa:	f6 c2 01             	test   $0x1,%dl
  8023ad:	74 0e                	je     8023bd <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8023af:	c1 ea 0c             	shr    $0xc,%edx
  8023b2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8023b9:	ef 
  8023ba:	0f b7 c0             	movzwl %ax,%eax
}
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    
  8023bf:	90                   	nop

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
