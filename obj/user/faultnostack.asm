
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
  800039:	68 1c 10 80 00       	push   $0x80101c
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
  8000d7:	68 00 26 80 00       	push   $0x802600
  8000dc:	e8 15 01 00 00       	call   8001f6 <cprintf>
	cprintf("before umain\n");
  8000e1:	c7 04 24 1e 26 80 00 	movl   $0x80261e,(%esp)
  8000e8:	e8 09 01 00 00       	call   8001f6 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ed:	83 c4 08             	add    $0x8,%esp
  8000f0:	ff 75 0c             	pushl  0xc(%ebp)
  8000f3:	ff 75 08             	pushl  0x8(%ebp)
  8000f6:	e8 38 ff ff ff       	call   800033 <umain>
	cprintf("after umain\n");
  8000fb:	c7 04 24 2c 26 80 00 	movl   $0x80262c,(%esp)
  800102:	e8 ef 00 00 00       	call   8001f6 <cprintf>
	cprintf("%d: limain.c exit()\n", thisenv->env_id);
  800107:	a1 08 40 80 00       	mov    0x804008,%eax
  80010c:	8b 40 48             	mov    0x48(%eax),%eax
  80010f:	83 c4 08             	add    $0x8,%esp
  800112:	50                   	push   %eax
  800113:	68 39 26 80 00       	push   $0x802639
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
  80013b:	68 64 26 80 00       	push   $0x802664
  800140:	50                   	push   %eax
  800141:	68 58 26 80 00       	push   $0x802658
  800146:	e8 ab 00 00 00       	call   8001f6 <cprintf>
	close_all();
  80014b:	e8 ca 10 00 00       	call   80121a <close_all>
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
  8002a3:	e8 f8 20 00 00       	call   8023a0 <__udivdi3>
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
  8002cc:	e8 df 21 00 00       	call   8024b0 <__umoddi3>
  8002d1:	83 c4 14             	add    $0x14,%esp
  8002d4:	0f be 80 69 26 80 00 	movsbl 0x802669(%eax),%eax
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
  80037d:	ff 24 85 40 28 80 00 	jmp    *0x802840(,%eax,4)
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
  800448:	8b 14 85 a0 29 80 00 	mov    0x8029a0(,%eax,4),%edx
  80044f:	85 d2                	test   %edx,%edx
  800451:	74 18                	je     80046b <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  800453:	52                   	push   %edx
  800454:	68 bd 2a 80 00       	push   $0x802abd
  800459:	53                   	push   %ebx
  80045a:	56                   	push   %esi
  80045b:	e8 a6 fe ff ff       	call   800306 <printfmt>
  800460:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800463:	89 7d 14             	mov    %edi,0x14(%ebp)
  800466:	e9 fe 02 00 00       	jmp    800769 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80046b:	50                   	push   %eax
  80046c:	68 81 26 80 00       	push   $0x802681
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
  800493:	b8 7a 26 80 00       	mov    $0x80267a,%eax
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
  80082b:	bf 9d 27 80 00       	mov    $0x80279d,%edi
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
  800857:	bf d5 27 80 00       	mov    $0x8027d5,%edi
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
  800cf8:	68 e8 29 80 00       	push   $0x8029e8
  800cfd:	6a 43                	push   $0x43
  800cff:	68 05 2a 80 00       	push   $0x802a05
  800d04:	e8 8f 14 00 00       	call   802198 <_panic>

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
  800d79:	68 e8 29 80 00       	push   $0x8029e8
  800d7e:	6a 43                	push   $0x43
  800d80:	68 05 2a 80 00       	push   $0x802a05
  800d85:	e8 0e 14 00 00       	call   802198 <_panic>

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
  800dbb:	68 e8 29 80 00       	push   $0x8029e8
  800dc0:	6a 43                	push   $0x43
  800dc2:	68 05 2a 80 00       	push   $0x802a05
  800dc7:	e8 cc 13 00 00       	call   802198 <_panic>

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
  800dfd:	68 e8 29 80 00       	push   $0x8029e8
  800e02:	6a 43                	push   $0x43
  800e04:	68 05 2a 80 00       	push   $0x802a05
  800e09:	e8 8a 13 00 00       	call   802198 <_panic>

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
  800e3f:	68 e8 29 80 00       	push   $0x8029e8
  800e44:	6a 43                	push   $0x43
  800e46:	68 05 2a 80 00       	push   $0x802a05
  800e4b:	e8 48 13 00 00       	call   802198 <_panic>

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
  800e81:	68 e8 29 80 00       	push   $0x8029e8
  800e86:	6a 43                	push   $0x43
  800e88:	68 05 2a 80 00       	push   $0x802a05
  800e8d:	e8 06 13 00 00       	call   802198 <_panic>

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
  800ec3:	68 e8 29 80 00       	push   $0x8029e8
  800ec8:	6a 43                	push   $0x43
  800eca:	68 05 2a 80 00       	push   $0x802a05
  800ecf:	e8 c4 12 00 00       	call   802198 <_panic>

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
  800f27:	68 e8 29 80 00       	push   $0x8029e8
  800f2c:	6a 43                	push   $0x43
  800f2e:	68 05 2a 80 00       	push   $0x802a05
  800f33:	e8 60 12 00 00       	call   802198 <_panic>

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
  80100b:	68 e8 29 80 00       	push   $0x8029e8
  801010:	6a 43                	push   $0x43
  801012:	68 05 2a 80 00       	push   $0x802a05
  801017:	e8 7c 11 00 00       	call   802198 <_panic>

0080101c <_pgfault_upcall>:
_pgfault_upcall:
	//movl testxixi, %eax 
	//call *%eax 

	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80101c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80101d:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  801022:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801024:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 0x28(%esp), %ebx 
  801027:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	movl 0x30(%esp), %eax 
  80102b:	8b 44 24 30          	mov    0x30(%esp),%eax
	subl $0x4, %eax 
  80102f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801032:	89 18                	mov    %ebx,(%eax)
	movl %eax, 0x30(%esp)
  801034:	89 44 24 30          	mov    %eax,0x30(%esp)

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	addl $0x8, %esp 
  801038:	83 c4 08             	add    $0x8,%esp
	popal
  80103b:	61                   	popa   
	
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	addl $0x4, %esp
  80103c:	83 c4 04             	add    $0x4,%esp
	popfl
  80103f:	9d                   	popf   
	
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801040:	5c                   	pop    %esp
	
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801041:	c3                   	ret    

00801042 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801045:	8b 45 08             	mov    0x8(%ebp),%eax
  801048:	05 00 00 00 30       	add    $0x30000000,%eax
  80104d:	c1 e8 0c             	shr    $0xc,%eax
}
  801050:	5d                   	pop    %ebp
  801051:	c3                   	ret    

00801052 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801052:	55                   	push   %ebp
  801053:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80105d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801062:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801071:	89 c2                	mov    %eax,%edx
  801073:	c1 ea 16             	shr    $0x16,%edx
  801076:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80107d:	f6 c2 01             	test   $0x1,%dl
  801080:	74 2d                	je     8010af <fd_alloc+0x46>
  801082:	89 c2                	mov    %eax,%edx
  801084:	c1 ea 0c             	shr    $0xc,%edx
  801087:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80108e:	f6 c2 01             	test   $0x1,%dl
  801091:	74 1c                	je     8010af <fd_alloc+0x46>
  801093:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801098:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80109d:	75 d2                	jne    801071 <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  8010a8:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8010ad:	eb 0a                	jmp    8010b9 <fd_alloc+0x50>
			*fd_store = fd;
  8010af:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b2:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8010c1:	83 f8 1f             	cmp    $0x1f,%eax
  8010c4:	77 30                	ja     8010f6 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8010c6:	c1 e0 0c             	shl    $0xc,%eax
  8010c9:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8010ce:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  8010d4:	f6 c2 01             	test   $0x1,%dl
  8010d7:	74 24                	je     8010fd <fd_lookup+0x42>
  8010d9:	89 c2                	mov    %eax,%edx
  8010db:	c1 ea 0c             	shr    $0xc,%edx
  8010de:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010e5:	f6 c2 01             	test   $0x1,%dl
  8010e8:	74 1a                	je     801104 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010ed:	89 02                	mov    %eax,(%edx)
	return 0;
  8010ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    
		return -E_INVAL;
  8010f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010fb:	eb f7                	jmp    8010f4 <fd_lookup+0x39>
		return -E_INVAL;
  8010fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801102:	eb f0                	jmp    8010f4 <fd_lookup+0x39>
  801104:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801109:	eb e9                	jmp    8010f4 <fd_lookup+0x39>

0080110b <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  80110b:	55                   	push   %ebp
  80110c:	89 e5                	mov    %esp,%ebp
  80110e:	83 ec 08             	sub    $0x8,%esp
  801111:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801114:	ba 00 00 00 00       	mov    $0x0,%edx
  801119:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80111e:	39 08                	cmp    %ecx,(%eax)
  801120:	74 38                	je     80115a <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  801122:	83 c2 01             	add    $0x1,%edx
  801125:	8b 04 95 90 2a 80 00 	mov    0x802a90(,%edx,4),%eax
  80112c:	85 c0                	test   %eax,%eax
  80112e:	75 ee                	jne    80111e <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801130:	a1 08 40 80 00       	mov    0x804008,%eax
  801135:	8b 40 48             	mov    0x48(%eax),%eax
  801138:	83 ec 04             	sub    $0x4,%esp
  80113b:	51                   	push   %ecx
  80113c:	50                   	push   %eax
  80113d:	68 14 2a 80 00       	push   $0x802a14
  801142:	e8 af f0 ff ff       	call   8001f6 <cprintf>
	*dev = 0;
  801147:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801150:	83 c4 10             	add    $0x10,%esp
  801153:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801158:	c9                   	leave  
  801159:	c3                   	ret    
			*dev = devtab[i];
  80115a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80115f:	b8 00 00 00 00       	mov    $0x0,%eax
  801164:	eb f2                	jmp    801158 <dev_lookup+0x4d>

00801166 <fd_close>:
{
  801166:	55                   	push   %ebp
  801167:	89 e5                	mov    %esp,%ebp
  801169:	57                   	push   %edi
  80116a:	56                   	push   %esi
  80116b:	53                   	push   %ebx
  80116c:	83 ec 24             	sub    $0x24,%esp
  80116f:	8b 75 08             	mov    0x8(%ebp),%esi
  801172:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801175:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801178:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801179:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80117f:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801182:	50                   	push   %eax
  801183:	e8 33 ff ff ff       	call   8010bb <fd_lookup>
  801188:	89 c3                	mov    %eax,%ebx
  80118a:	83 c4 10             	add    $0x10,%esp
  80118d:	85 c0                	test   %eax,%eax
  80118f:	78 05                	js     801196 <fd_close+0x30>
	    || fd != fd2)
  801191:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801194:	74 16                	je     8011ac <fd_close+0x46>
		return (must_exist ? r : 0);
  801196:	89 f8                	mov    %edi,%eax
  801198:	84 c0                	test   %al,%al
  80119a:	b8 00 00 00 00       	mov    $0x0,%eax
  80119f:	0f 44 d8             	cmove  %eax,%ebx
}
  8011a2:	89 d8                	mov    %ebx,%eax
  8011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8011ac:	83 ec 08             	sub    $0x8,%esp
  8011af:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8011b2:	50                   	push   %eax
  8011b3:	ff 36                	pushl  (%esi)
  8011b5:	e8 51 ff ff ff       	call   80110b <dev_lookup>
  8011ba:	89 c3                	mov    %eax,%ebx
  8011bc:	83 c4 10             	add    $0x10,%esp
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	78 1a                	js     8011dd <fd_close+0x77>
		if (dev->dev_close)
  8011c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011c6:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  8011c9:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  8011ce:	85 c0                	test   %eax,%eax
  8011d0:	74 0b                	je     8011dd <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  8011d2:	83 ec 0c             	sub    $0xc,%esp
  8011d5:	56                   	push   %esi
  8011d6:	ff d0                	call   *%eax
  8011d8:	89 c3                	mov    %eax,%ebx
  8011da:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8011dd:	83 ec 08             	sub    $0x8,%esp
  8011e0:	56                   	push   %esi
  8011e1:	6a 00                	push   $0x0
  8011e3:	e8 e4 fb ff ff       	call   800dcc <sys_page_unmap>
	return r;
  8011e8:	83 c4 10             	add    $0x10,%esp
  8011eb:	eb b5                	jmp    8011a2 <fd_close+0x3c>

008011ed <close>:

int
close(int fdnum)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011f3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	e8 bc fe ff ff       	call   8010bb <fd_lookup>
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	79 02                	jns    801208 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801206:	c9                   	leave  
  801207:	c3                   	ret    
		return fd_close(fd, 1);
  801208:	83 ec 08             	sub    $0x8,%esp
  80120b:	6a 01                	push   $0x1
  80120d:	ff 75 f4             	pushl  -0xc(%ebp)
  801210:	e8 51 ff ff ff       	call   801166 <fd_close>
  801215:	83 c4 10             	add    $0x10,%esp
  801218:	eb ec                	jmp    801206 <close+0x19>

0080121a <close_all>:

void
close_all(void)
{
  80121a:	55                   	push   %ebp
  80121b:	89 e5                	mov    %esp,%ebp
  80121d:	53                   	push   %ebx
  80121e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801221:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801226:	83 ec 0c             	sub    $0xc,%esp
  801229:	53                   	push   %ebx
  80122a:	e8 be ff ff ff       	call   8011ed <close>
	for (i = 0; i < MAXFD; i++)
  80122f:	83 c3 01             	add    $0x1,%ebx
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	83 fb 20             	cmp    $0x20,%ebx
  801238:	75 ec                	jne    801226 <close_all+0xc>
}
  80123a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80123d:	c9                   	leave  
  80123e:	c3                   	ret    

0080123f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	57                   	push   %edi
  801243:	56                   	push   %esi
  801244:	53                   	push   %ebx
  801245:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801248:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80124b:	50                   	push   %eax
  80124c:	ff 75 08             	pushl  0x8(%ebp)
  80124f:	e8 67 fe ff ff       	call   8010bb <fd_lookup>
  801254:	89 c3                	mov    %eax,%ebx
  801256:	83 c4 10             	add    $0x10,%esp
  801259:	85 c0                	test   %eax,%eax
  80125b:	0f 88 81 00 00 00    	js     8012e2 <dup+0xa3>
		return r;
	close(newfdnum);
  801261:	83 ec 0c             	sub    $0xc,%esp
  801264:	ff 75 0c             	pushl  0xc(%ebp)
  801267:	e8 81 ff ff ff       	call   8011ed <close>

	newfd = INDEX2FD(newfdnum);
  80126c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80126f:	c1 e6 0c             	shl    $0xc,%esi
  801272:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801278:	83 c4 04             	add    $0x4,%esp
  80127b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80127e:	e8 cf fd ff ff       	call   801052 <fd2data>
  801283:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801285:	89 34 24             	mov    %esi,(%esp)
  801288:	e8 c5 fd ff ff       	call   801052 <fd2data>
  80128d:	83 c4 10             	add    $0x10,%esp
  801290:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801292:	89 d8                	mov    %ebx,%eax
  801294:	c1 e8 16             	shr    $0x16,%eax
  801297:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80129e:	a8 01                	test   $0x1,%al
  8012a0:	74 11                	je     8012b3 <dup+0x74>
  8012a2:	89 d8                	mov    %ebx,%eax
  8012a4:	c1 e8 0c             	shr    $0xc,%eax
  8012a7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8012ae:	f6 c2 01             	test   $0x1,%dl
  8012b1:	75 39                	jne    8012ec <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8012b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012b6:	89 d0                	mov    %edx,%eax
  8012b8:	c1 e8 0c             	shr    $0xc,%eax
  8012bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012c2:	83 ec 0c             	sub    $0xc,%esp
  8012c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8012ca:	50                   	push   %eax
  8012cb:	56                   	push   %esi
  8012cc:	6a 00                	push   $0x0
  8012ce:	52                   	push   %edx
  8012cf:	6a 00                	push   $0x0
  8012d1:	e8 b4 fa ff ff       	call   800d8a <sys_page_map>
  8012d6:	89 c3                	mov    %eax,%ebx
  8012d8:	83 c4 20             	add    $0x20,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	78 31                	js     801310 <dup+0xd1>
		goto err;

	return newfdnum;
  8012df:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8012e2:	89 d8                	mov    %ebx,%eax
  8012e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5f                   	pop    %edi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8012ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012f3:	83 ec 0c             	sub    $0xc,%esp
  8012f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8012fb:	50                   	push   %eax
  8012fc:	57                   	push   %edi
  8012fd:	6a 00                	push   $0x0
  8012ff:	53                   	push   %ebx
  801300:	6a 00                	push   $0x0
  801302:	e8 83 fa ff ff       	call   800d8a <sys_page_map>
  801307:	89 c3                	mov    %eax,%ebx
  801309:	83 c4 20             	add    $0x20,%esp
  80130c:	85 c0                	test   %eax,%eax
  80130e:	79 a3                	jns    8012b3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801310:	83 ec 08             	sub    $0x8,%esp
  801313:	56                   	push   %esi
  801314:	6a 00                	push   $0x0
  801316:	e8 b1 fa ff ff       	call   800dcc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80131b:	83 c4 08             	add    $0x8,%esp
  80131e:	57                   	push   %edi
  80131f:	6a 00                	push   $0x0
  801321:	e8 a6 fa ff ff       	call   800dcc <sys_page_unmap>
	return r;
  801326:	83 c4 10             	add    $0x10,%esp
  801329:	eb b7                	jmp    8012e2 <dup+0xa3>

0080132b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	53                   	push   %ebx
  80132f:	83 ec 1c             	sub    $0x1c,%esp
  801332:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801335:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	53                   	push   %ebx
  80133a:	e8 7c fd ff ff       	call   8010bb <fd_lookup>
  80133f:	83 c4 10             	add    $0x10,%esp
  801342:	85 c0                	test   %eax,%eax
  801344:	78 3f                	js     801385 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801346:	83 ec 08             	sub    $0x8,%esp
  801349:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134c:	50                   	push   %eax
  80134d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801350:	ff 30                	pushl  (%eax)
  801352:	e8 b4 fd ff ff       	call   80110b <dev_lookup>
  801357:	83 c4 10             	add    $0x10,%esp
  80135a:	85 c0                	test   %eax,%eax
  80135c:	78 27                	js     801385 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80135e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801361:	8b 42 08             	mov    0x8(%edx),%eax
  801364:	83 e0 03             	and    $0x3,%eax
  801367:	83 f8 01             	cmp    $0x1,%eax
  80136a:	74 1e                	je     80138a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80136c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136f:	8b 40 08             	mov    0x8(%eax),%eax
  801372:	85 c0                	test   %eax,%eax
  801374:	74 35                	je     8013ab <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801376:	83 ec 04             	sub    $0x4,%esp
  801379:	ff 75 10             	pushl  0x10(%ebp)
  80137c:	ff 75 0c             	pushl  0xc(%ebp)
  80137f:	52                   	push   %edx
  801380:	ff d0                	call   *%eax
  801382:	83 c4 10             	add    $0x10,%esp
}
  801385:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801388:	c9                   	leave  
  801389:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80138a:	a1 08 40 80 00       	mov    0x804008,%eax
  80138f:	8b 40 48             	mov    0x48(%eax),%eax
  801392:	83 ec 04             	sub    $0x4,%esp
  801395:	53                   	push   %ebx
  801396:	50                   	push   %eax
  801397:	68 55 2a 80 00       	push   $0x802a55
  80139c:	e8 55 ee ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  8013a1:	83 c4 10             	add    $0x10,%esp
  8013a4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013a9:	eb da                	jmp    801385 <read+0x5a>
		return -E_NOT_SUPP;
  8013ab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013b0:	eb d3                	jmp    801385 <read+0x5a>

008013b2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8013b2:	55                   	push   %ebp
  8013b3:	89 e5                	mov    %esp,%ebp
  8013b5:	57                   	push   %edi
  8013b6:	56                   	push   %esi
  8013b7:	53                   	push   %ebx
  8013b8:	83 ec 0c             	sub    $0xc,%esp
  8013bb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013be:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8013c1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013c6:	39 f3                	cmp    %esi,%ebx
  8013c8:	73 23                	jae    8013ed <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013ca:	83 ec 04             	sub    $0x4,%esp
  8013cd:	89 f0                	mov    %esi,%eax
  8013cf:	29 d8                	sub    %ebx,%eax
  8013d1:	50                   	push   %eax
  8013d2:	89 d8                	mov    %ebx,%eax
  8013d4:	03 45 0c             	add    0xc(%ebp),%eax
  8013d7:	50                   	push   %eax
  8013d8:	57                   	push   %edi
  8013d9:	e8 4d ff ff ff       	call   80132b <read>
		if (m < 0)
  8013de:	83 c4 10             	add    $0x10,%esp
  8013e1:	85 c0                	test   %eax,%eax
  8013e3:	78 06                	js     8013eb <readn+0x39>
			return m;
		if (m == 0)
  8013e5:	74 06                	je     8013ed <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  8013e7:	01 c3                	add    %eax,%ebx
  8013e9:	eb db                	jmp    8013c6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8013eb:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8013ed:	89 d8                	mov    %ebx,%eax
  8013ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013f2:	5b                   	pop    %ebx
  8013f3:	5e                   	pop    %esi
  8013f4:	5f                   	pop    %edi
  8013f5:	5d                   	pop    %ebp
  8013f6:	c3                   	ret    

008013f7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013f7:	55                   	push   %ebp
  8013f8:	89 e5                	mov    %esp,%ebp
  8013fa:	53                   	push   %ebx
  8013fb:	83 ec 1c             	sub    $0x1c,%esp
  8013fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801401:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801404:	50                   	push   %eax
  801405:	53                   	push   %ebx
  801406:	e8 b0 fc ff ff       	call   8010bb <fd_lookup>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 3a                	js     80144c <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801412:	83 ec 08             	sub    $0x8,%esp
  801415:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801418:	50                   	push   %eax
  801419:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141c:	ff 30                	pushl  (%eax)
  80141e:	e8 e8 fc ff ff       	call   80110b <dev_lookup>
  801423:	83 c4 10             	add    $0x10,%esp
  801426:	85 c0                	test   %eax,%eax
  801428:	78 22                	js     80144c <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80142a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801431:	74 1e                	je     801451 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801433:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801436:	8b 52 0c             	mov    0xc(%edx),%edx
  801439:	85 d2                	test   %edx,%edx
  80143b:	74 35                	je     801472 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80143d:	83 ec 04             	sub    $0x4,%esp
  801440:	ff 75 10             	pushl  0x10(%ebp)
  801443:	ff 75 0c             	pushl  0xc(%ebp)
  801446:	50                   	push   %eax
  801447:	ff d2                	call   *%edx
  801449:	83 c4 10             	add    $0x10,%esp
}
  80144c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144f:	c9                   	leave  
  801450:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801451:	a1 08 40 80 00       	mov    0x804008,%eax
  801456:	8b 40 48             	mov    0x48(%eax),%eax
  801459:	83 ec 04             	sub    $0x4,%esp
  80145c:	53                   	push   %ebx
  80145d:	50                   	push   %eax
  80145e:	68 71 2a 80 00       	push   $0x802a71
  801463:	e8 8e ed ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  801468:	83 c4 10             	add    $0x10,%esp
  80146b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801470:	eb da                	jmp    80144c <write+0x55>
		return -E_NOT_SUPP;
  801472:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801477:	eb d3                	jmp    80144c <write+0x55>

00801479 <seek>:

int
seek(int fdnum, off_t offset)
{
  801479:	55                   	push   %ebp
  80147a:	89 e5                	mov    %esp,%ebp
  80147c:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80147f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801482:	50                   	push   %eax
  801483:	ff 75 08             	pushl  0x8(%ebp)
  801486:	e8 30 fc ff ff       	call   8010bb <fd_lookup>
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	85 c0                	test   %eax,%eax
  801490:	78 0e                	js     8014a0 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801492:	8b 55 0c             	mov    0xc(%ebp),%edx
  801495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801498:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80149b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014a0:	c9                   	leave  
  8014a1:	c3                   	ret    

008014a2 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8014a2:	55                   	push   %ebp
  8014a3:	89 e5                	mov    %esp,%ebp
  8014a5:	53                   	push   %ebx
  8014a6:	83 ec 1c             	sub    $0x1c,%esp
  8014a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014af:	50                   	push   %eax
  8014b0:	53                   	push   %ebx
  8014b1:	e8 05 fc ff ff       	call   8010bb <fd_lookup>
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	85 c0                	test   %eax,%eax
  8014bb:	78 37                	js     8014f4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014bd:	83 ec 08             	sub    $0x8,%esp
  8014c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c3:	50                   	push   %eax
  8014c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c7:	ff 30                	pushl  (%eax)
  8014c9:	e8 3d fc ff ff       	call   80110b <dev_lookup>
  8014ce:	83 c4 10             	add    $0x10,%esp
  8014d1:	85 c0                	test   %eax,%eax
  8014d3:	78 1f                	js     8014f4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014dc:	74 1b                	je     8014f9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8014de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014e1:	8b 52 18             	mov    0x18(%edx),%edx
  8014e4:	85 d2                	test   %edx,%edx
  8014e6:	74 32                	je     80151a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014e8:	83 ec 08             	sub    $0x8,%esp
  8014eb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ee:	50                   	push   %eax
  8014ef:	ff d2                	call   *%edx
  8014f1:	83 c4 10             	add    $0x10,%esp
}
  8014f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014f9:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014fe:	8b 40 48             	mov    0x48(%eax),%eax
  801501:	83 ec 04             	sub    $0x4,%esp
  801504:	53                   	push   %ebx
  801505:	50                   	push   %eax
  801506:	68 34 2a 80 00       	push   $0x802a34
  80150b:	e8 e6 ec ff ff       	call   8001f6 <cprintf>
		return -E_INVAL;
  801510:	83 c4 10             	add    $0x10,%esp
  801513:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801518:	eb da                	jmp    8014f4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80151a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80151f:	eb d3                	jmp    8014f4 <ftruncate+0x52>

00801521 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	53                   	push   %ebx
  801525:	83 ec 1c             	sub    $0x1c,%esp
  801528:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80152b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152e:	50                   	push   %eax
  80152f:	ff 75 08             	pushl  0x8(%ebp)
  801532:	e8 84 fb ff ff       	call   8010bb <fd_lookup>
  801537:	83 c4 10             	add    $0x10,%esp
  80153a:	85 c0                	test   %eax,%eax
  80153c:	78 4b                	js     801589 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153e:	83 ec 08             	sub    $0x8,%esp
  801541:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801544:	50                   	push   %eax
  801545:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801548:	ff 30                	pushl  (%eax)
  80154a:	e8 bc fb ff ff       	call   80110b <dev_lookup>
  80154f:	83 c4 10             	add    $0x10,%esp
  801552:	85 c0                	test   %eax,%eax
  801554:	78 33                	js     801589 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801556:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801559:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80155d:	74 2f                	je     80158e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80155f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801562:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801569:	00 00 00 
	stat->st_isdir = 0;
  80156c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801573:	00 00 00 
	stat->st_dev = dev;
  801576:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80157c:	83 ec 08             	sub    $0x8,%esp
  80157f:	53                   	push   %ebx
  801580:	ff 75 f0             	pushl  -0x10(%ebp)
  801583:	ff 50 14             	call   *0x14(%eax)
  801586:	83 c4 10             	add    $0x10,%esp
}
  801589:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80158c:	c9                   	leave  
  80158d:	c3                   	ret    
		return -E_NOT_SUPP;
  80158e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801593:	eb f4                	jmp    801589 <fstat+0x68>

00801595 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801595:	55                   	push   %ebp
  801596:	89 e5                	mov    %esp,%ebp
  801598:	56                   	push   %esi
  801599:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80159a:	83 ec 08             	sub    $0x8,%esp
  80159d:	6a 00                	push   $0x0
  80159f:	ff 75 08             	pushl  0x8(%ebp)
  8015a2:	e8 22 02 00 00       	call   8017c9 <open>
  8015a7:	89 c3                	mov    %eax,%ebx
  8015a9:	83 c4 10             	add    $0x10,%esp
  8015ac:	85 c0                	test   %eax,%eax
  8015ae:	78 1b                	js     8015cb <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8015b0:	83 ec 08             	sub    $0x8,%esp
  8015b3:	ff 75 0c             	pushl  0xc(%ebp)
  8015b6:	50                   	push   %eax
  8015b7:	e8 65 ff ff ff       	call   801521 <fstat>
  8015bc:	89 c6                	mov    %eax,%esi
	close(fd);
  8015be:	89 1c 24             	mov    %ebx,(%esp)
  8015c1:	e8 27 fc ff ff       	call   8011ed <close>
	return r;
  8015c6:	83 c4 10             	add    $0x10,%esp
  8015c9:	89 f3                	mov    %esi,%ebx
}
  8015cb:	89 d8                	mov    %ebx,%eax
  8015cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d0:	5b                   	pop    %ebx
  8015d1:	5e                   	pop    %esi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    

008015d4 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
  8015d9:	89 c6                	mov    %eax,%esi
  8015db:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8015dd:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8015e4:	74 27                	je     80160d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8015e6:	6a 07                	push   $0x7
  8015e8:	68 00 50 80 00       	push   $0x805000
  8015ed:	56                   	push   %esi
  8015ee:	ff 35 00 40 80 00    	pushl  0x804000
  8015f4:	e8 d8 0c 00 00       	call   8022d1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015f9:	83 c4 0c             	add    $0xc,%esp
  8015fc:	6a 00                	push   $0x0
  8015fe:	53                   	push   %ebx
  8015ff:	6a 00                	push   $0x0
  801601:	e8 62 0c 00 00       	call   802268 <ipc_recv>
}
  801606:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801609:	5b                   	pop    %ebx
  80160a:	5e                   	pop    %esi
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80160d:	83 ec 0c             	sub    $0xc,%esp
  801610:	6a 01                	push   $0x1
  801612:	e8 12 0d 00 00       	call   802329 <ipc_find_env>
  801617:	a3 00 40 80 00       	mov    %eax,0x804000
  80161c:	83 c4 10             	add    $0x10,%esp
  80161f:	eb c5                	jmp    8015e6 <fsipc+0x12>

00801621 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8b 40 0c             	mov    0xc(%eax),%eax
  80162d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801632:	8b 45 0c             	mov    0xc(%ebp),%eax
  801635:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80163a:	ba 00 00 00 00       	mov    $0x0,%edx
  80163f:	b8 02 00 00 00       	mov    $0x2,%eax
  801644:	e8 8b ff ff ff       	call   8015d4 <fsipc>
}
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <devfile_flush>:
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
  80164e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801651:	8b 45 08             	mov    0x8(%ebp),%eax
  801654:	8b 40 0c             	mov    0xc(%eax),%eax
  801657:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80165c:	ba 00 00 00 00       	mov    $0x0,%edx
  801661:	b8 06 00 00 00       	mov    $0x6,%eax
  801666:	e8 69 ff ff ff       	call   8015d4 <fsipc>
}
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <devfile_stat>:
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
  801670:	53                   	push   %ebx
  801671:	83 ec 04             	sub    $0x4,%esp
  801674:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	8b 40 0c             	mov    0xc(%eax),%eax
  80167d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801682:	ba 00 00 00 00       	mov    $0x0,%edx
  801687:	b8 05 00 00 00       	mov    $0x5,%eax
  80168c:	e8 43 ff ff ff       	call   8015d4 <fsipc>
  801691:	85 c0                	test   %eax,%eax
  801693:	78 2c                	js     8016c1 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	68 00 50 80 00       	push   $0x805000
  80169d:	53                   	push   %ebx
  80169e:	e8 b2 f2 ff ff       	call   800955 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8016a3:	a1 80 50 80 00       	mov    0x805080,%eax
  8016a8:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8016ae:	a1 84 50 80 00       	mov    0x805084,%eax
  8016b3:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8016b9:	83 c4 10             	add    $0x10,%esp
  8016bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016c4:	c9                   	leave  
  8016c5:	c3                   	ret    

008016c6 <devfile_write>:
{
  8016c6:	55                   	push   %ebp
  8016c7:	89 e5                	mov    %esp,%ebp
  8016c9:	53                   	push   %ebx
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d6:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  8016db:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  8016e1:	53                   	push   %ebx
  8016e2:	ff 75 0c             	pushl  0xc(%ebp)
  8016e5:	68 08 50 80 00       	push   $0x805008
  8016ea:	e8 56 f4 ff ff       	call   800b45 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  8016ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8016f4:	b8 04 00 00 00       	mov    $0x4,%eax
  8016f9:	e8 d6 fe ff ff       	call   8015d4 <fsipc>
  8016fe:	83 c4 10             	add    $0x10,%esp
  801701:	85 c0                	test   %eax,%eax
  801703:	78 0b                	js     801710 <devfile_write+0x4a>
	assert(r <= n);
  801705:	39 d8                	cmp    %ebx,%eax
  801707:	77 0c                	ja     801715 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801709:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80170e:	7f 1e                	jg     80172e <devfile_write+0x68>
}
  801710:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801713:	c9                   	leave  
  801714:	c3                   	ret    
	assert(r <= n);
  801715:	68 a4 2a 80 00       	push   $0x802aa4
  80171a:	68 ab 2a 80 00       	push   $0x802aab
  80171f:	68 98 00 00 00       	push   $0x98
  801724:	68 c0 2a 80 00       	push   $0x802ac0
  801729:	e8 6a 0a 00 00       	call   802198 <_panic>
	assert(r <= PGSIZE);
  80172e:	68 cb 2a 80 00       	push   $0x802acb
  801733:	68 ab 2a 80 00       	push   $0x802aab
  801738:	68 99 00 00 00       	push   $0x99
  80173d:	68 c0 2a 80 00       	push   $0x802ac0
  801742:	e8 51 0a 00 00       	call   802198 <_panic>

00801747 <devfile_read>:
{
  801747:	55                   	push   %ebp
  801748:	89 e5                	mov    %esp,%ebp
  80174a:	56                   	push   %esi
  80174b:	53                   	push   %ebx
  80174c:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80174f:	8b 45 08             	mov    0x8(%ebp),%eax
  801752:	8b 40 0c             	mov    0xc(%eax),%eax
  801755:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80175a:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801760:	ba 00 00 00 00       	mov    $0x0,%edx
  801765:	b8 03 00 00 00       	mov    $0x3,%eax
  80176a:	e8 65 fe ff ff       	call   8015d4 <fsipc>
  80176f:	89 c3                	mov    %eax,%ebx
  801771:	85 c0                	test   %eax,%eax
  801773:	78 1f                	js     801794 <devfile_read+0x4d>
	assert(r <= n);
  801775:	39 f0                	cmp    %esi,%eax
  801777:	77 24                	ja     80179d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801779:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80177e:	7f 33                	jg     8017b3 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801780:	83 ec 04             	sub    $0x4,%esp
  801783:	50                   	push   %eax
  801784:	68 00 50 80 00       	push   $0x805000
  801789:	ff 75 0c             	pushl  0xc(%ebp)
  80178c:	e8 52 f3 ff ff       	call   800ae3 <memmove>
	return r;
  801791:	83 c4 10             	add    $0x10,%esp
}
  801794:	89 d8                	mov    %ebx,%eax
  801796:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5d                   	pop    %ebp
  80179c:	c3                   	ret    
	assert(r <= n);
  80179d:	68 a4 2a 80 00       	push   $0x802aa4
  8017a2:	68 ab 2a 80 00       	push   $0x802aab
  8017a7:	6a 7c                	push   $0x7c
  8017a9:	68 c0 2a 80 00       	push   $0x802ac0
  8017ae:	e8 e5 09 00 00       	call   802198 <_panic>
	assert(r <= PGSIZE);
  8017b3:	68 cb 2a 80 00       	push   $0x802acb
  8017b8:	68 ab 2a 80 00       	push   $0x802aab
  8017bd:	6a 7d                	push   $0x7d
  8017bf:	68 c0 2a 80 00       	push   $0x802ac0
  8017c4:	e8 cf 09 00 00       	call   802198 <_panic>

008017c9 <open>:
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	56                   	push   %esi
  8017cd:	53                   	push   %ebx
  8017ce:	83 ec 1c             	sub    $0x1c,%esp
  8017d1:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8017d4:	56                   	push   %esi
  8017d5:	e8 42 f1 ff ff       	call   80091c <strlen>
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017e2:	7f 6c                	jg     801850 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017e4:	83 ec 0c             	sub    $0xc,%esp
  8017e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ea:	50                   	push   %eax
  8017eb:	e8 79 f8 ff ff       	call   801069 <fd_alloc>
  8017f0:	89 c3                	mov    %eax,%ebx
  8017f2:	83 c4 10             	add    $0x10,%esp
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 3c                	js     801835 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017f9:	83 ec 08             	sub    $0x8,%esp
  8017fc:	56                   	push   %esi
  8017fd:	68 00 50 80 00       	push   $0x805000
  801802:	e8 4e f1 ff ff       	call   800955 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801807:	8b 45 0c             	mov    0xc(%ebp),%eax
  80180a:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80180f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801812:	b8 01 00 00 00       	mov    $0x1,%eax
  801817:	e8 b8 fd ff ff       	call   8015d4 <fsipc>
  80181c:	89 c3                	mov    %eax,%ebx
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	85 c0                	test   %eax,%eax
  801823:	78 19                	js     80183e <open+0x75>
	return fd2num(fd);
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	ff 75 f4             	pushl  -0xc(%ebp)
  80182b:	e8 12 f8 ff ff       	call   801042 <fd2num>
  801830:	89 c3                	mov    %eax,%ebx
  801832:	83 c4 10             	add    $0x10,%esp
}
  801835:	89 d8                	mov    %ebx,%eax
  801837:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183a:	5b                   	pop    %ebx
  80183b:	5e                   	pop    %esi
  80183c:	5d                   	pop    %ebp
  80183d:	c3                   	ret    
		fd_close(fd, 0);
  80183e:	83 ec 08             	sub    $0x8,%esp
  801841:	6a 00                	push   $0x0
  801843:	ff 75 f4             	pushl  -0xc(%ebp)
  801846:	e8 1b f9 ff ff       	call   801166 <fd_close>
		return r;
  80184b:	83 c4 10             	add    $0x10,%esp
  80184e:	eb e5                	jmp    801835 <open+0x6c>
		return -E_BAD_PATH;
  801850:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801855:	eb de                	jmp    801835 <open+0x6c>

00801857 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801857:	55                   	push   %ebp
  801858:	89 e5                	mov    %esp,%ebp
  80185a:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80185d:	ba 00 00 00 00       	mov    $0x0,%edx
  801862:	b8 08 00 00 00       	mov    $0x8,%eax
  801867:	e8 68 fd ff ff       	call   8015d4 <fsipc>
}
  80186c:	c9                   	leave  
  80186d:	c3                   	ret    

0080186e <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  80186e:	55                   	push   %ebp
  80186f:	89 e5                	mov    %esp,%ebp
  801871:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  801874:	68 d7 2a 80 00       	push   $0x802ad7
  801879:	ff 75 0c             	pushl  0xc(%ebp)
  80187c:	e8 d4 f0 ff ff       	call   800955 <strcpy>
	return 0;
}
  801881:	b8 00 00 00 00       	mov    $0x0,%eax
  801886:	c9                   	leave  
  801887:	c3                   	ret    

00801888 <devsock_close>:
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	53                   	push   %ebx
  80188c:	83 ec 10             	sub    $0x10,%esp
  80188f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  801892:	53                   	push   %ebx
  801893:	e8 cc 0a 00 00       	call   802364 <pageref>
  801898:	83 c4 10             	add    $0x10,%esp
		return 0;
  80189b:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  8018a0:	83 f8 01             	cmp    $0x1,%eax
  8018a3:	74 07                	je     8018ac <devsock_close+0x24>
}
  8018a5:	89 d0                	mov    %edx,%eax
  8018a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  8018ac:	83 ec 0c             	sub    $0xc,%esp
  8018af:	ff 73 0c             	pushl  0xc(%ebx)
  8018b2:	e8 b9 02 00 00       	call   801b70 <nsipc_close>
  8018b7:	89 c2                	mov    %eax,%edx
  8018b9:	83 c4 10             	add    $0x10,%esp
  8018bc:	eb e7                	jmp    8018a5 <devsock_close+0x1d>

008018be <devsock_write>:
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
  8018c1:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8018c4:	6a 00                	push   $0x0
  8018c6:	ff 75 10             	pushl  0x10(%ebp)
  8018c9:	ff 75 0c             	pushl  0xc(%ebp)
  8018cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018cf:	ff 70 0c             	pushl  0xc(%eax)
  8018d2:	e8 76 03 00 00       	call   801c4d <nsipc_send>
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <devsock_read>:
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8018df:	6a 00                	push   $0x0
  8018e1:	ff 75 10             	pushl  0x10(%ebp)
  8018e4:	ff 75 0c             	pushl  0xc(%ebp)
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	ff 70 0c             	pushl  0xc(%eax)
  8018ed:	e8 ef 02 00 00       	call   801be1 <nsipc_recv>
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <fd2sockid>:
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
  8018f7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  8018fa:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8018fd:	52                   	push   %edx
  8018fe:	50                   	push   %eax
  8018ff:	e8 b7 f7 ff ff       	call   8010bb <fd_lookup>
  801904:	83 c4 10             	add    $0x10,%esp
  801907:	85 c0                	test   %eax,%eax
  801909:	78 10                	js     80191b <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  80190b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80190e:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801914:	39 08                	cmp    %ecx,(%eax)
  801916:	75 05                	jne    80191d <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801918:	8b 40 0c             	mov    0xc(%eax),%eax
}
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    
		return -E_NOT_SUPP;
  80191d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801922:	eb f7                	jmp    80191b <fd2sockid+0x27>

00801924 <alloc_sockfd>:
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
  801927:	56                   	push   %esi
  801928:	53                   	push   %ebx
  801929:	83 ec 1c             	sub    $0x1c,%esp
  80192c:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  80192e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801931:	50                   	push   %eax
  801932:	e8 32 f7 ff ff       	call   801069 <fd_alloc>
  801937:	89 c3                	mov    %eax,%ebx
  801939:	83 c4 10             	add    $0x10,%esp
  80193c:	85 c0                	test   %eax,%eax
  80193e:	78 43                	js     801983 <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  801940:	83 ec 04             	sub    $0x4,%esp
  801943:	68 07 04 00 00       	push   $0x407
  801948:	ff 75 f4             	pushl  -0xc(%ebp)
  80194b:	6a 00                	push   $0x0
  80194d:	e8 f5 f3 ff ff       	call   800d47 <sys_page_alloc>
  801952:	89 c3                	mov    %eax,%ebx
  801954:	83 c4 10             	add    $0x10,%esp
  801957:	85 c0                	test   %eax,%eax
  801959:	78 28                	js     801983 <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  80195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80195e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801964:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801966:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801969:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801970:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801973:	83 ec 0c             	sub    $0xc,%esp
  801976:	50                   	push   %eax
  801977:	e8 c6 f6 ff ff       	call   801042 <fd2num>
  80197c:	89 c3                	mov    %eax,%ebx
  80197e:	83 c4 10             	add    $0x10,%esp
  801981:	eb 0c                	jmp    80198f <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  801983:	83 ec 0c             	sub    $0xc,%esp
  801986:	56                   	push   %esi
  801987:	e8 e4 01 00 00       	call   801b70 <nsipc_close>
		return r;
  80198c:	83 c4 10             	add    $0x10,%esp
}
  80198f:	89 d8                	mov    %ebx,%eax
  801991:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801994:	5b                   	pop    %ebx
  801995:	5e                   	pop    %esi
  801996:	5d                   	pop    %ebp
  801997:	c3                   	ret    

00801998 <accept>:
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
  80199b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	e8 4e ff ff ff       	call   8018f4 <fd2sockid>
  8019a6:	85 c0                	test   %eax,%eax
  8019a8:	78 1b                	js     8019c5 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8019aa:	83 ec 04             	sub    $0x4,%esp
  8019ad:	ff 75 10             	pushl  0x10(%ebp)
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	50                   	push   %eax
  8019b4:	e8 0e 01 00 00       	call   801ac7 <nsipc_accept>
  8019b9:	83 c4 10             	add    $0x10,%esp
  8019bc:	85 c0                	test   %eax,%eax
  8019be:	78 05                	js     8019c5 <accept+0x2d>
	return alloc_sockfd(r);
  8019c0:	e8 5f ff ff ff       	call   801924 <alloc_sockfd>
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <bind>:
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
  8019ca:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	e8 1f ff ff ff       	call   8018f4 <fd2sockid>
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	78 12                	js     8019eb <bind+0x24>
	return nsipc_bind(r, name, namelen);
  8019d9:	83 ec 04             	sub    $0x4,%esp
  8019dc:	ff 75 10             	pushl  0x10(%ebp)
  8019df:	ff 75 0c             	pushl  0xc(%ebp)
  8019e2:	50                   	push   %eax
  8019e3:	e8 31 01 00 00       	call   801b19 <nsipc_bind>
  8019e8:	83 c4 10             	add    $0x10,%esp
}
  8019eb:	c9                   	leave  
  8019ec:	c3                   	ret    

008019ed <shutdown>:
{
  8019ed:	55                   	push   %ebp
  8019ee:	89 e5                	mov    %esp,%ebp
  8019f0:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f6:	e8 f9 fe ff ff       	call   8018f4 <fd2sockid>
  8019fb:	85 c0                	test   %eax,%eax
  8019fd:	78 0f                	js     801a0e <shutdown+0x21>
	return nsipc_shutdown(r, how);
  8019ff:	83 ec 08             	sub    $0x8,%esp
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	50                   	push   %eax
  801a06:	e8 43 01 00 00       	call   801b4e <nsipc_shutdown>
  801a0b:	83 c4 10             	add    $0x10,%esp
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <connect>:
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	e8 d6 fe ff ff       	call   8018f4 <fd2sockid>
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 12                	js     801a34 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  801a22:	83 ec 04             	sub    $0x4,%esp
  801a25:	ff 75 10             	pushl  0x10(%ebp)
  801a28:	ff 75 0c             	pushl  0xc(%ebp)
  801a2b:	50                   	push   %eax
  801a2c:	e8 59 01 00 00       	call   801b8a <nsipc_connect>
  801a31:	83 c4 10             	add    $0x10,%esp
}
  801a34:	c9                   	leave  
  801a35:	c3                   	ret    

00801a36 <listen>:
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	e8 b0 fe ff ff       	call   8018f4 <fd2sockid>
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 0f                	js     801a57 <listen+0x21>
	return nsipc_listen(r, backlog);
  801a48:	83 ec 08             	sub    $0x8,%esp
  801a4b:	ff 75 0c             	pushl  0xc(%ebp)
  801a4e:	50                   	push   %eax
  801a4f:	e8 6b 01 00 00       	call   801bbf <nsipc_listen>
  801a54:	83 c4 10             	add    $0x10,%esp
}
  801a57:	c9                   	leave  
  801a58:	c3                   	ret    

00801a59 <socket>:

int
socket(int domain, int type, int protocol)
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801a5f:	ff 75 10             	pushl  0x10(%ebp)
  801a62:	ff 75 0c             	pushl  0xc(%ebp)
  801a65:	ff 75 08             	pushl  0x8(%ebp)
  801a68:	e8 3e 02 00 00       	call   801cab <nsipc_socket>
  801a6d:	83 c4 10             	add    $0x10,%esp
  801a70:	85 c0                	test   %eax,%eax
  801a72:	78 05                	js     801a79 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  801a74:	e8 ab fe ff ff       	call   801924 <alloc_sockfd>
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
  801a7e:	53                   	push   %ebx
  801a7f:	83 ec 04             	sub    $0x4,%esp
  801a82:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a84:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a8b:	74 26                	je     801ab3 <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a8d:	6a 07                	push   $0x7
  801a8f:	68 00 60 80 00       	push   $0x806000
  801a94:	53                   	push   %ebx
  801a95:	ff 35 04 40 80 00    	pushl  0x804004
  801a9b:	e8 31 08 00 00       	call   8022d1 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801aa0:	83 c4 0c             	add    $0xc,%esp
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	e8 ba 07 00 00       	call   802268 <ipc_recv>
}
  801aae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801ab3:	83 ec 0c             	sub    $0xc,%esp
  801ab6:	6a 02                	push   $0x2
  801ab8:	e8 6c 08 00 00       	call   802329 <ipc_find_env>
  801abd:	a3 04 40 80 00       	mov    %eax,0x804004
  801ac2:	83 c4 10             	add    $0x10,%esp
  801ac5:	eb c6                	jmp    801a8d <nsipc+0x12>

00801ac7 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
  801aca:	56                   	push   %esi
  801acb:	53                   	push   %ebx
  801acc:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801ad7:	8b 06                	mov    (%esi),%eax
  801ad9:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801ade:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae3:	e8 93 ff ff ff       	call   801a7b <nsipc>
  801ae8:	89 c3                	mov    %eax,%ebx
  801aea:	85 c0                	test   %eax,%eax
  801aec:	79 09                	jns    801af7 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801aee:	89 d8                	mov    %ebx,%eax
  801af0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801af3:	5b                   	pop    %ebx
  801af4:	5e                   	pop    %esi
  801af5:	5d                   	pop    %ebp
  801af6:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801af7:	83 ec 04             	sub    $0x4,%esp
  801afa:	ff 35 10 60 80 00    	pushl  0x806010
  801b00:	68 00 60 80 00       	push   $0x806000
  801b05:	ff 75 0c             	pushl  0xc(%ebp)
  801b08:	e8 d6 ef ff ff       	call   800ae3 <memmove>
		*addrlen = ret->ret_addrlen;
  801b0d:	a1 10 60 80 00       	mov    0x806010,%eax
  801b12:	89 06                	mov    %eax,(%esi)
  801b14:	83 c4 10             	add    $0x10,%esp
	return r;
  801b17:	eb d5                	jmp    801aee <nsipc_accept+0x27>

00801b19 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801b19:	55                   	push   %ebp
  801b1a:	89 e5                	mov    %esp,%ebp
  801b1c:	53                   	push   %ebx
  801b1d:	83 ec 08             	sub    $0x8,%esp
  801b20:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801b2b:	53                   	push   %ebx
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	68 04 60 80 00       	push   $0x806004
  801b34:	e8 aa ef ff ff       	call   800ae3 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801b39:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801b3f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b44:	e8 32 ff ff ff       	call   801a7b <nsipc>
}
  801b49:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b4c:	c9                   	leave  
  801b4d:	c3                   	ret    

00801b4e <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b5f:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801b64:	b8 03 00 00 00       	mov    $0x3,%eax
  801b69:	e8 0d ff ff ff       	call   801a7b <nsipc>
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <nsipc_close>:

int
nsipc_close(int s)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801b7e:	b8 04 00 00 00       	mov    $0x4,%eax
  801b83:	e8 f3 fe ff ff       	call   801a7b <nsipc>
}
  801b88:	c9                   	leave  
  801b89:	c3                   	ret    

00801b8a <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
  801b8d:	53                   	push   %ebx
  801b8e:	83 ec 08             	sub    $0x8,%esp
  801b91:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b94:	8b 45 08             	mov    0x8(%ebp),%eax
  801b97:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b9c:	53                   	push   %ebx
  801b9d:	ff 75 0c             	pushl  0xc(%ebp)
  801ba0:	68 04 60 80 00       	push   $0x806004
  801ba5:	e8 39 ef ff ff       	call   800ae3 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801baa:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801bb0:	b8 05 00 00 00       	mov    $0x5,%eax
  801bb5:	e8 c1 fe ff ff       	call   801a7b <nsipc>
}
  801bba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
  801bc2:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd0:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801bd5:	b8 06 00 00 00       	mov    $0x6,%eax
  801bda:	e8 9c fe ff ff       	call   801a7b <nsipc>
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	56                   	push   %esi
  801be5:	53                   	push   %ebx
  801be6:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801bf1:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801bf7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfa:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801bff:	b8 07 00 00 00       	mov    $0x7,%eax
  801c04:	e8 72 fe ff ff       	call   801a7b <nsipc>
  801c09:	89 c3                	mov    %eax,%ebx
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	78 1f                	js     801c2e <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801c0f:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801c14:	7f 21                	jg     801c37 <nsipc_recv+0x56>
  801c16:	39 c6                	cmp    %eax,%esi
  801c18:	7c 1d                	jl     801c37 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801c1a:	83 ec 04             	sub    $0x4,%esp
  801c1d:	50                   	push   %eax
  801c1e:	68 00 60 80 00       	push   $0x806000
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	e8 b8 ee ff ff       	call   800ae3 <memmove>
  801c2b:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801c2e:	89 d8                	mov    %ebx,%eax
  801c30:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c33:	5b                   	pop    %ebx
  801c34:	5e                   	pop    %esi
  801c35:	5d                   	pop    %ebp
  801c36:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801c37:	68 e3 2a 80 00       	push   $0x802ae3
  801c3c:	68 ab 2a 80 00       	push   $0x802aab
  801c41:	6a 62                	push   $0x62
  801c43:	68 f8 2a 80 00       	push   $0x802af8
  801c48:	e8 4b 05 00 00       	call   802198 <_panic>

00801c4d <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801c4d:	55                   	push   %ebp
  801c4e:	89 e5                	mov    %esp,%ebp
  801c50:	53                   	push   %ebx
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801c57:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5a:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801c5f:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801c65:	7f 2e                	jg     801c95 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	53                   	push   %ebx
  801c6b:	ff 75 0c             	pushl  0xc(%ebp)
  801c6e:	68 0c 60 80 00       	push   $0x80600c
  801c73:	e8 6b ee ff ff       	call   800ae3 <memmove>
	nsipcbuf.send.req_size = size;
  801c78:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801c7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801c81:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c86:	b8 08 00 00 00       	mov    $0x8,%eax
  801c8b:	e8 eb fd ff ff       	call   801a7b <nsipc>
}
  801c90:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    
	assert(size < 1600);
  801c95:	68 04 2b 80 00       	push   $0x802b04
  801c9a:	68 ab 2a 80 00       	push   $0x802aab
  801c9f:	6a 6d                	push   $0x6d
  801ca1:	68 f8 2a 80 00       	push   $0x802af8
  801ca6:	e8 ed 04 00 00       	call   802198 <_panic>

00801cab <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
  801cae:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  801cc4:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801cc9:	b8 09 00 00 00       	mov    $0x9,%eax
  801cce:	e8 a8 fd ff ff       	call   801a7b <nsipc>
}
  801cd3:	c9                   	leave  
  801cd4:	c3                   	ret    

00801cd5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
  801cd8:	56                   	push   %esi
  801cd9:	53                   	push   %ebx
  801cda:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	e8 6a f3 ff ff       	call   801052 <fd2data>
  801ce8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801cea:	83 c4 08             	add    $0x8,%esp
  801ced:	68 10 2b 80 00       	push   $0x802b10
  801cf2:	53                   	push   %ebx
  801cf3:	e8 5d ec ff ff       	call   800955 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801cf8:	8b 46 04             	mov    0x4(%esi),%eax
  801cfb:	2b 06                	sub    (%esi),%eax
  801cfd:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801d03:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801d0a:	00 00 00 
	stat->st_dev = &devpipe;
  801d0d:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801d14:	30 80 00 
	return 0;
}
  801d17:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d1f:	5b                   	pop    %ebx
  801d20:	5e                   	pop    %esi
  801d21:	5d                   	pop    %ebp
  801d22:	c3                   	ret    

00801d23 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	53                   	push   %ebx
  801d27:	83 ec 0c             	sub    $0xc,%esp
  801d2a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d2d:	53                   	push   %ebx
  801d2e:	6a 00                	push   $0x0
  801d30:	e8 97 f0 ff ff       	call   800dcc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d35:	89 1c 24             	mov    %ebx,(%esp)
  801d38:	e8 15 f3 ff ff       	call   801052 <fd2data>
  801d3d:	83 c4 08             	add    $0x8,%esp
  801d40:	50                   	push   %eax
  801d41:	6a 00                	push   $0x0
  801d43:	e8 84 f0 ff ff       	call   800dcc <sys_page_unmap>
}
  801d48:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <_pipeisclosed>:
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	57                   	push   %edi
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	83 ec 1c             	sub    $0x1c,%esp
  801d56:	89 c7                	mov    %eax,%edi
  801d58:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801d5a:	a1 08 40 80 00       	mov    0x804008,%eax
  801d5f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801d62:	83 ec 0c             	sub    $0xc,%esp
  801d65:	57                   	push   %edi
  801d66:	e8 f9 05 00 00       	call   802364 <pageref>
  801d6b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801d6e:	89 34 24             	mov    %esi,(%esp)
  801d71:	e8 ee 05 00 00       	call   802364 <pageref>
		nn = thisenv->env_runs;
  801d76:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801d7c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801d7f:	83 c4 10             	add    $0x10,%esp
  801d82:	39 cb                	cmp    %ecx,%ebx
  801d84:	74 1b                	je     801da1 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d89:	75 cf                	jne    801d5a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d8b:	8b 42 58             	mov    0x58(%edx),%eax
  801d8e:	6a 01                	push   $0x1
  801d90:	50                   	push   %eax
  801d91:	53                   	push   %ebx
  801d92:	68 17 2b 80 00       	push   $0x802b17
  801d97:	e8 5a e4 ff ff       	call   8001f6 <cprintf>
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	eb b9                	jmp    801d5a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801da1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801da4:	0f 94 c0             	sete   %al
  801da7:	0f b6 c0             	movzbl %al,%eax
}
  801daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dad:	5b                   	pop    %ebx
  801dae:	5e                   	pop    %esi
  801daf:	5f                   	pop    %edi
  801db0:	5d                   	pop    %ebp
  801db1:	c3                   	ret    

00801db2 <devpipe_write>:
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 28             	sub    $0x28,%esp
  801dbb:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801dbe:	56                   	push   %esi
  801dbf:	e8 8e f2 ff ff       	call   801052 <fd2data>
  801dc4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc6:	83 c4 10             	add    $0x10,%esp
  801dc9:	bf 00 00 00 00       	mov    $0x0,%edi
  801dce:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801dd1:	74 4f                	je     801e22 <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801dd3:	8b 43 04             	mov    0x4(%ebx),%eax
  801dd6:	8b 0b                	mov    (%ebx),%ecx
  801dd8:	8d 51 20             	lea    0x20(%ecx),%edx
  801ddb:	39 d0                	cmp    %edx,%eax
  801ddd:	72 14                	jb     801df3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ddf:	89 da                	mov    %ebx,%edx
  801de1:	89 f0                	mov    %esi,%eax
  801de3:	e8 65 ff ff ff       	call   801d4d <_pipeisclosed>
  801de8:	85 c0                	test   %eax,%eax
  801dea:	75 3b                	jne    801e27 <devpipe_write+0x75>
			sys_yield();
  801dec:	e8 37 ef ff ff       	call   800d28 <sys_yield>
  801df1:	eb e0                	jmp    801dd3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801df3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801df6:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801dfa:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801dfd:	89 c2                	mov    %eax,%edx
  801dff:	c1 fa 1f             	sar    $0x1f,%edx
  801e02:	89 d1                	mov    %edx,%ecx
  801e04:	c1 e9 1b             	shr    $0x1b,%ecx
  801e07:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801e0a:	83 e2 1f             	and    $0x1f,%edx
  801e0d:	29 ca                	sub    %ecx,%edx
  801e0f:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801e13:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e17:	83 c0 01             	add    $0x1,%eax
  801e1a:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e1d:	83 c7 01             	add    $0x1,%edi
  801e20:	eb ac                	jmp    801dce <devpipe_write+0x1c>
	return i;
  801e22:	8b 45 10             	mov    0x10(%ebp),%eax
  801e25:	eb 05                	jmp    801e2c <devpipe_write+0x7a>
				return 0;
  801e27:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e2f:	5b                   	pop    %ebx
  801e30:	5e                   	pop    %esi
  801e31:	5f                   	pop    %edi
  801e32:	5d                   	pop    %ebp
  801e33:	c3                   	ret    

00801e34 <devpipe_read>:
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	57                   	push   %edi
  801e38:	56                   	push   %esi
  801e39:	53                   	push   %ebx
  801e3a:	83 ec 18             	sub    $0x18,%esp
  801e3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e40:	57                   	push   %edi
  801e41:	e8 0c f2 ff ff       	call   801052 <fd2data>
  801e46:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e48:	83 c4 10             	add    $0x10,%esp
  801e4b:	be 00 00 00 00       	mov    $0x0,%esi
  801e50:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e53:	75 14                	jne    801e69 <devpipe_read+0x35>
	return i;
  801e55:	8b 45 10             	mov    0x10(%ebp),%eax
  801e58:	eb 02                	jmp    801e5c <devpipe_read+0x28>
				return i;
  801e5a:	89 f0                	mov    %esi,%eax
}
  801e5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e5f:	5b                   	pop    %ebx
  801e60:	5e                   	pop    %esi
  801e61:	5f                   	pop    %edi
  801e62:	5d                   	pop    %ebp
  801e63:	c3                   	ret    
			sys_yield();
  801e64:	e8 bf ee ff ff       	call   800d28 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801e69:	8b 03                	mov    (%ebx),%eax
  801e6b:	3b 43 04             	cmp    0x4(%ebx),%eax
  801e6e:	75 18                	jne    801e88 <devpipe_read+0x54>
			if (i > 0)
  801e70:	85 f6                	test   %esi,%esi
  801e72:	75 e6                	jne    801e5a <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801e74:	89 da                	mov    %ebx,%edx
  801e76:	89 f8                	mov    %edi,%eax
  801e78:	e8 d0 fe ff ff       	call   801d4d <_pipeisclosed>
  801e7d:	85 c0                	test   %eax,%eax
  801e7f:	74 e3                	je     801e64 <devpipe_read+0x30>
				return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
  801e86:	eb d4                	jmp    801e5c <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e88:	99                   	cltd   
  801e89:	c1 ea 1b             	shr    $0x1b,%edx
  801e8c:	01 d0                	add    %edx,%eax
  801e8e:	83 e0 1f             	and    $0x1f,%eax
  801e91:	29 d0                	sub    %edx,%eax
  801e93:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e9b:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e9e:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801ea1:	83 c6 01             	add    $0x1,%esi
  801ea4:	eb aa                	jmp    801e50 <devpipe_read+0x1c>

00801ea6 <pipe>:
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	56                   	push   %esi
  801eaa:	53                   	push   %ebx
  801eab:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801eae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801eb1:	50                   	push   %eax
  801eb2:	e8 b2 f1 ff ff       	call   801069 <fd_alloc>
  801eb7:	89 c3                	mov    %eax,%ebx
  801eb9:	83 c4 10             	add    $0x10,%esp
  801ebc:	85 c0                	test   %eax,%eax
  801ebe:	0f 88 23 01 00 00    	js     801fe7 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec4:	83 ec 04             	sub    $0x4,%esp
  801ec7:	68 07 04 00 00       	push   $0x407
  801ecc:	ff 75 f4             	pushl  -0xc(%ebp)
  801ecf:	6a 00                	push   $0x0
  801ed1:	e8 71 ee ff ff       	call   800d47 <sys_page_alloc>
  801ed6:	89 c3                	mov    %eax,%ebx
  801ed8:	83 c4 10             	add    $0x10,%esp
  801edb:	85 c0                	test   %eax,%eax
  801edd:	0f 88 04 01 00 00    	js     801fe7 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801ee3:	83 ec 0c             	sub    $0xc,%esp
  801ee6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ee9:	50                   	push   %eax
  801eea:	e8 7a f1 ff ff       	call   801069 <fd_alloc>
  801eef:	89 c3                	mov    %eax,%ebx
  801ef1:	83 c4 10             	add    $0x10,%esp
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	0f 88 db 00 00 00    	js     801fd7 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801efc:	83 ec 04             	sub    $0x4,%esp
  801eff:	68 07 04 00 00       	push   $0x407
  801f04:	ff 75 f0             	pushl  -0x10(%ebp)
  801f07:	6a 00                	push   $0x0
  801f09:	e8 39 ee ff ff       	call   800d47 <sys_page_alloc>
  801f0e:	89 c3                	mov    %eax,%ebx
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	85 c0                	test   %eax,%eax
  801f15:	0f 88 bc 00 00 00    	js     801fd7 <pipe+0x131>
	va = fd2data(fd0);
  801f1b:	83 ec 0c             	sub    $0xc,%esp
  801f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f21:	e8 2c f1 ff ff       	call   801052 <fd2data>
  801f26:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f28:	83 c4 0c             	add    $0xc,%esp
  801f2b:	68 07 04 00 00       	push   $0x407
  801f30:	50                   	push   %eax
  801f31:	6a 00                	push   $0x0
  801f33:	e8 0f ee ff ff       	call   800d47 <sys_page_alloc>
  801f38:	89 c3                	mov    %eax,%ebx
  801f3a:	83 c4 10             	add    $0x10,%esp
  801f3d:	85 c0                	test   %eax,%eax
  801f3f:	0f 88 82 00 00 00    	js     801fc7 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f45:	83 ec 0c             	sub    $0xc,%esp
  801f48:	ff 75 f0             	pushl  -0x10(%ebp)
  801f4b:	e8 02 f1 ff ff       	call   801052 <fd2data>
  801f50:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801f57:	50                   	push   %eax
  801f58:	6a 00                	push   $0x0
  801f5a:	56                   	push   %esi
  801f5b:	6a 00                	push   $0x0
  801f5d:	e8 28 ee ff ff       	call   800d8a <sys_page_map>
  801f62:	89 c3                	mov    %eax,%ebx
  801f64:	83 c4 20             	add    $0x20,%esp
  801f67:	85 c0                	test   %eax,%eax
  801f69:	78 4e                	js     801fb9 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801f6b:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801f70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f73:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801f75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f78:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801f7f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f82:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f87:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f8e:	83 ec 0c             	sub    $0xc,%esp
  801f91:	ff 75 f4             	pushl  -0xc(%ebp)
  801f94:	e8 a9 f0 ff ff       	call   801042 <fd2num>
  801f99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f9c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f9e:	83 c4 04             	add    $0x4,%esp
  801fa1:	ff 75 f0             	pushl  -0x10(%ebp)
  801fa4:	e8 99 f0 ff ff       	call   801042 <fd2num>
  801fa9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fac:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801faf:	83 c4 10             	add    $0x10,%esp
  801fb2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801fb7:	eb 2e                	jmp    801fe7 <pipe+0x141>
	sys_page_unmap(0, va);
  801fb9:	83 ec 08             	sub    $0x8,%esp
  801fbc:	56                   	push   %esi
  801fbd:	6a 00                	push   $0x0
  801fbf:	e8 08 ee ff ff       	call   800dcc <sys_page_unmap>
  801fc4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801fc7:	83 ec 08             	sub    $0x8,%esp
  801fca:	ff 75 f0             	pushl  -0x10(%ebp)
  801fcd:	6a 00                	push   $0x0
  801fcf:	e8 f8 ed ff ff       	call   800dcc <sys_page_unmap>
  801fd4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801fd7:	83 ec 08             	sub    $0x8,%esp
  801fda:	ff 75 f4             	pushl  -0xc(%ebp)
  801fdd:	6a 00                	push   $0x0
  801fdf:	e8 e8 ed ff ff       	call   800dcc <sys_page_unmap>
  801fe4:	83 c4 10             	add    $0x10,%esp
}
  801fe7:	89 d8                	mov    %ebx,%eax
  801fe9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fec:	5b                   	pop    %ebx
  801fed:	5e                   	pop    %esi
  801fee:	5d                   	pop    %ebp
  801fef:	c3                   	ret    

00801ff0 <pipeisclosed>:
{
  801ff0:	55                   	push   %ebp
  801ff1:	89 e5                	mov    %esp,%ebp
  801ff3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ff6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ff9:	50                   	push   %eax
  801ffa:	ff 75 08             	pushl  0x8(%ebp)
  801ffd:	e8 b9 f0 ff ff       	call   8010bb <fd_lookup>
  802002:	83 c4 10             	add    $0x10,%esp
  802005:	85 c0                	test   %eax,%eax
  802007:	78 18                	js     802021 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	ff 75 f4             	pushl  -0xc(%ebp)
  80200f:	e8 3e f0 ff ff       	call   801052 <fd2data>
	return _pipeisclosed(fd, p);
  802014:	89 c2                	mov    %eax,%edx
  802016:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802019:	e8 2f fd ff ff       	call   801d4d <_pipeisclosed>
  80201e:	83 c4 10             	add    $0x10,%esp
}
  802021:	c9                   	leave  
  802022:	c3                   	ret    

00802023 <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  802023:	b8 00 00 00 00       	mov    $0x0,%eax
  802028:	c3                   	ret    

00802029 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802029:	55                   	push   %ebp
  80202a:	89 e5                	mov    %esp,%ebp
  80202c:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  80202f:	68 2f 2b 80 00       	push   $0x802b2f
  802034:	ff 75 0c             	pushl  0xc(%ebp)
  802037:	e8 19 e9 ff ff       	call   800955 <strcpy>
	return 0;
}
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	c9                   	leave  
  802042:	c3                   	ret    

00802043 <devcons_write>:
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	57                   	push   %edi
  802047:	56                   	push   %esi
  802048:	53                   	push   %ebx
  802049:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80204f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  802054:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80205a:	3b 75 10             	cmp    0x10(%ebp),%esi
  80205d:	73 31                	jae    802090 <devcons_write+0x4d>
		m = n - tot;
  80205f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802062:	29 f3                	sub    %esi,%ebx
  802064:	83 fb 7f             	cmp    $0x7f,%ebx
  802067:	b8 7f 00 00 00       	mov    $0x7f,%eax
  80206c:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  80206f:	83 ec 04             	sub    $0x4,%esp
  802072:	53                   	push   %ebx
  802073:	89 f0                	mov    %esi,%eax
  802075:	03 45 0c             	add    0xc(%ebp),%eax
  802078:	50                   	push   %eax
  802079:	57                   	push   %edi
  80207a:	e8 64 ea ff ff       	call   800ae3 <memmove>
		sys_cputs(buf, m);
  80207f:	83 c4 08             	add    $0x8,%esp
  802082:	53                   	push   %ebx
  802083:	57                   	push   %edi
  802084:	e8 02 ec ff ff       	call   800c8b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802089:	01 de                	add    %ebx,%esi
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	eb ca                	jmp    80205a <devcons_write+0x17>
}
  802090:	89 f0                	mov    %esi,%eax
  802092:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802095:	5b                   	pop    %ebx
  802096:	5e                   	pop    %esi
  802097:	5f                   	pop    %edi
  802098:	5d                   	pop    %ebp
  802099:	c3                   	ret    

0080209a <devcons_read>:
{
  80209a:	55                   	push   %ebp
  80209b:	89 e5                	mov    %esp,%ebp
  80209d:	83 ec 08             	sub    $0x8,%esp
  8020a0:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  8020a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8020a9:	74 21                	je     8020cc <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  8020ab:	e8 f9 eb ff ff       	call   800ca9 <sys_cgetc>
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	75 07                	jne    8020bb <devcons_read+0x21>
		sys_yield();
  8020b4:	e8 6f ec ff ff       	call   800d28 <sys_yield>
  8020b9:	eb f0                	jmp    8020ab <devcons_read+0x11>
	if (c < 0)
  8020bb:	78 0f                	js     8020cc <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  8020bd:	83 f8 04             	cmp    $0x4,%eax
  8020c0:	74 0c                	je     8020ce <devcons_read+0x34>
	*(char*)vbuf = c;
  8020c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c5:	88 02                	mov    %al,(%edx)
	return 1;
  8020c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8020cc:	c9                   	leave  
  8020cd:	c3                   	ret    
		return 0;
  8020ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d3:	eb f7                	jmp    8020cc <devcons_read+0x32>

008020d5 <cputchar>:
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
  8020d8:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8020db:	8b 45 08             	mov    0x8(%ebp),%eax
  8020de:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8020e1:	6a 01                	push   $0x1
  8020e3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020e6:	50                   	push   %eax
  8020e7:	e8 9f eb ff ff       	call   800c8b <sys_cputs>
}
  8020ec:	83 c4 10             	add    $0x10,%esp
  8020ef:	c9                   	leave  
  8020f0:	c3                   	ret    

008020f1 <getchar>:
{
  8020f1:	55                   	push   %ebp
  8020f2:	89 e5                	mov    %esp,%ebp
  8020f4:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8020f7:	6a 01                	push   $0x1
  8020f9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8020fc:	50                   	push   %eax
  8020fd:	6a 00                	push   $0x0
  8020ff:	e8 27 f2 ff ff       	call   80132b <read>
	if (r < 0)
  802104:	83 c4 10             	add    $0x10,%esp
  802107:	85 c0                	test   %eax,%eax
  802109:	78 06                	js     802111 <getchar+0x20>
	if (r < 1)
  80210b:	74 06                	je     802113 <getchar+0x22>
	return c;
  80210d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    
		return -E_EOF;
  802113:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802118:	eb f7                	jmp    802111 <getchar+0x20>

0080211a <iscons>:
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802120:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802123:	50                   	push   %eax
  802124:	ff 75 08             	pushl  0x8(%ebp)
  802127:	e8 8f ef ff ff       	call   8010bb <fd_lookup>
  80212c:	83 c4 10             	add    $0x10,%esp
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 11                	js     802144 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802136:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80213c:	39 10                	cmp    %edx,(%eax)
  80213e:	0f 94 c0             	sete   %al
  802141:	0f b6 c0             	movzbl %al,%eax
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <opencons>:
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80214c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80214f:	50                   	push   %eax
  802150:	e8 14 ef ff ff       	call   801069 <fd_alloc>
  802155:	83 c4 10             	add    $0x10,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 3a                	js     802196 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	68 07 04 00 00       	push   $0x407
  802164:	ff 75 f4             	pushl  -0xc(%ebp)
  802167:	6a 00                	push   $0x0
  802169:	e8 d9 eb ff ff       	call   800d47 <sys_page_alloc>
  80216e:	83 c4 10             	add    $0x10,%esp
  802171:	85 c0                	test   %eax,%eax
  802173:	78 21                	js     802196 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802175:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802178:	8b 15 58 30 80 00    	mov    0x803058,%edx
  80217e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802183:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80218a:	83 ec 0c             	sub    $0xc,%esp
  80218d:	50                   	push   %eax
  80218e:	e8 af ee ff ff       	call   801042 <fd2num>
  802193:	83 c4 10             	add    $0x10,%esp
}
  802196:	c9                   	leave  
  802197:	c3                   	ret    

00802198 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802198:	55                   	push   %ebp
  802199:	89 e5                	mov    %esp,%ebp
  80219b:	56                   	push   %esi
  80219c:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  80219d:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a2:	8b 40 48             	mov    0x48(%eax),%eax
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	68 60 2b 80 00       	push   $0x802b60
  8021ad:	50                   	push   %eax
  8021ae:	68 58 26 80 00       	push   $0x802658
  8021b3:	e8 3e e0 ff ff       	call   8001f6 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  8021b8:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  8021bb:	8b 35 00 30 80 00    	mov    0x803000,%esi
  8021c1:	e8 43 eb ff ff       	call   800d09 <sys_getenvid>
  8021c6:	83 c4 04             	add    $0x4,%esp
  8021c9:	ff 75 0c             	pushl  0xc(%ebp)
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	56                   	push   %esi
  8021d0:	50                   	push   %eax
  8021d1:	68 3c 2b 80 00       	push   $0x802b3c
  8021d6:	e8 1b e0 ff ff       	call   8001f6 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  8021db:	83 c4 18             	add    $0x18,%esp
  8021de:	53                   	push   %ebx
  8021df:	ff 75 10             	pushl  0x10(%ebp)
  8021e2:	e8 be df ff ff       	call   8001a5 <vcprintf>
	cprintf("\n");
  8021e7:	c7 04 24 1c 26 80 00 	movl   $0x80261c,(%esp)
  8021ee:	e8 03 e0 ff ff       	call   8001f6 <cprintf>
  8021f3:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8021f6:	cc                   	int3   
  8021f7:	eb fd                	jmp    8021f6 <_panic+0x5e>

008021f9 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8021f9:	55                   	push   %ebp
  8021fa:	89 e5                	mov    %esp,%ebp
  8021fc:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8021ff:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802206:	74 0a                	je     802212 <set_pgfault_handler+0x19>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
		// panic("set_pgfault_handler not implemented");
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    
		r = sys_page_alloc((envid_t)0, (void*)(UXSTACKTOP-PGSIZE), PTE_U|PTE_W|PTE_P);
  802212:	83 ec 04             	sub    $0x4,%esp
  802215:	6a 07                	push   $0x7
  802217:	68 00 f0 bf ee       	push   $0xeebff000
  80221c:	6a 00                	push   $0x0
  80221e:	e8 24 eb ff ff       	call   800d47 <sys_page_alloc>
		if(r < 0)
  802223:	83 c4 10             	add    $0x10,%esp
  802226:	85 c0                	test   %eax,%eax
  802228:	78 2a                	js     802254 <set_pgfault_handler+0x5b>
		r = sys_env_set_pgfault_upcall((envid_t)0, _pgfault_upcall);
  80222a:	83 ec 08             	sub    $0x8,%esp
  80222d:	68 1c 10 80 00       	push   $0x80101c
  802232:	6a 00                	push   $0x0
  802234:	e8 59 ec ff ff       	call   800e92 <sys_env_set_pgfault_upcall>
		if(r < 0)
  802239:	83 c4 10             	add    $0x10,%esp
  80223c:	85 c0                	test   %eax,%eax
  80223e:	79 c8                	jns    802208 <set_pgfault_handler+0xf>
			panic("the sys_env_set_pgfault_upcall() return value is wrong!\n");
  802240:	83 ec 04             	sub    $0x4,%esp
  802243:	68 98 2b 80 00       	push   $0x802b98
  802248:	6a 25                	push   $0x25
  80224a:	68 d4 2b 80 00       	push   $0x802bd4
  80224f:	e8 44 ff ff ff       	call   802198 <_panic>
			panic("the sys_page_alloc() return value is wrong!\n");
  802254:	83 ec 04             	sub    $0x4,%esp
  802257:	68 68 2b 80 00       	push   $0x802b68
  80225c:	6a 22                	push   $0x22
  80225e:	68 d4 2b 80 00       	push   $0x802bd4
  802263:	e8 30 ff ff ff       	call   802198 <_panic>

00802268 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802268:	55                   	push   %ebp
  802269:	89 e5                	mov    %esp,%ebp
  80226b:	56                   	push   %esi
  80226c:	53                   	push   %ebx
  80226d:	8b 75 08             	mov    0x8(%ebp),%esi
  802270:	8b 45 0c             	mov    0xc(%ebp),%eax
  802273:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802276:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802278:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80227d:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  802280:	83 ec 0c             	sub    $0xc,%esp
  802283:	50                   	push   %eax
  802284:	e8 6e ec ff ff       	call   800ef7 <sys_ipc_recv>
	if(ret < 0){
  802289:	83 c4 10             	add    $0x10,%esp
  80228c:	85 c0                	test   %eax,%eax
  80228e:	78 2b                	js     8022bb <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  802290:	85 f6                	test   %esi,%esi
  802292:	74 0a                	je     80229e <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  802294:	a1 08 40 80 00       	mov    0x804008,%eax
  802299:	8b 40 74             	mov    0x74(%eax),%eax
  80229c:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80229e:	85 db                	test   %ebx,%ebx
  8022a0:	74 0a                	je     8022ac <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8022a2:	a1 08 40 80 00       	mov    0x804008,%eax
  8022a7:	8b 40 78             	mov    0x78(%eax),%eax
  8022aa:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8022ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8022b1:	8b 40 70             	mov    0x70(%eax),%eax
}
  8022b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022b7:	5b                   	pop    %ebx
  8022b8:	5e                   	pop    %esi
  8022b9:	5d                   	pop    %ebp
  8022ba:	c3                   	ret    
		if(from_env_store)
  8022bb:	85 f6                	test   %esi,%esi
  8022bd:	74 06                	je     8022c5 <ipc_recv+0x5d>
			*from_env_store = 0;
  8022bf:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8022c5:	85 db                	test   %ebx,%ebx
  8022c7:	74 eb                	je     8022b4 <ipc_recv+0x4c>
			*perm_store = 0;
  8022c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8022cf:	eb e3                	jmp    8022b4 <ipc_recv+0x4c>

008022d1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8022d1:	55                   	push   %ebp
  8022d2:	89 e5                	mov    %esp,%ebp
  8022d4:	57                   	push   %edi
  8022d5:	56                   	push   %esi
  8022d6:	53                   	push   %ebx
  8022d7:	83 ec 0c             	sub    $0xc,%esp
  8022da:	8b 7d 08             	mov    0x8(%ebp),%edi
  8022dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8022e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8022e3:	85 db                	test   %ebx,%ebx
  8022e5:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8022ea:	0f 44 d8             	cmove  %eax,%ebx
  8022ed:	eb 05                	jmp    8022f4 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8022ef:	e8 34 ea ff ff       	call   800d28 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8022f4:	ff 75 14             	pushl  0x14(%ebp)
  8022f7:	53                   	push   %ebx
  8022f8:	56                   	push   %esi
  8022f9:	57                   	push   %edi
  8022fa:	e8 d5 eb ff ff       	call   800ed4 <sys_ipc_try_send>
  8022ff:	83 c4 10             	add    $0x10,%esp
  802302:	85 c0                	test   %eax,%eax
  802304:	74 1b                	je     802321 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802306:	79 e7                	jns    8022ef <ipc_send+0x1e>
  802308:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80230b:	74 e2                	je     8022ef <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	68 e2 2b 80 00       	push   $0x802be2
  802315:	6a 46                	push   $0x46
  802317:	68 f7 2b 80 00       	push   $0x802bf7
  80231c:	e8 77 fe ff ff       	call   802198 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  802321:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802324:	5b                   	pop    %ebx
  802325:	5e                   	pop    %esi
  802326:	5f                   	pop    %edi
  802327:	5d                   	pop    %ebp
  802328:	c3                   	ret    

00802329 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802329:	55                   	push   %ebp
  80232a:	89 e5                	mov    %esp,%ebp
  80232c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80232f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802334:	89 c2                	mov    %eax,%edx
  802336:	c1 e2 07             	shl    $0x7,%edx
  802339:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80233f:	8b 52 50             	mov    0x50(%edx),%edx
  802342:	39 ca                	cmp    %ecx,%edx
  802344:	74 11                	je     802357 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802346:	83 c0 01             	add    $0x1,%eax
  802349:	3d 00 04 00 00       	cmp    $0x400,%eax
  80234e:	75 e4                	jne    802334 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802350:	b8 00 00 00 00       	mov    $0x0,%eax
  802355:	eb 0b                	jmp    802362 <ipc_find_env+0x39>
			return envs[i].env_id;
  802357:	c1 e0 07             	shl    $0x7,%eax
  80235a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80235f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    

00802364 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
  802367:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80236a:	89 d0                	mov    %edx,%eax
  80236c:	c1 e8 16             	shr    $0x16,%eax
  80236f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802376:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80237b:	f6 c1 01             	test   $0x1,%cl
  80237e:	74 1d                	je     80239d <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802380:	c1 ea 0c             	shr    $0xc,%edx
  802383:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80238a:	f6 c2 01             	test   $0x1,%dl
  80238d:	74 0e                	je     80239d <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80238f:	c1 ea 0c             	shr    $0xc,%edx
  802392:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802399:	ef 
  80239a:	0f b7 c0             	movzwl %ax,%eax
}
  80239d:	5d                   	pop    %ebp
  80239e:	c3                   	ret    
  80239f:	90                   	nop

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
