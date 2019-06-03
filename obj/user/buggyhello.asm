
obj/user/buggyhello.debug:     file format elf32-i386


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
  80002c:	e8 16 00 00 00       	call   800047 <libmain>
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
	sys_cputs((char*)1, 1);
  800039:	6a 01                	push   $0x1
  80003b:	6a 01                	push   $0x1
  80003d:	e8 eb 0b 00 00       	call   800c2d <sys_cputs>
}
  800042:	83 c4 10             	add    $0x10,%esp
  800045:	c9                   	leave  
  800046:	c3                   	ret    

00800047 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800047:	55                   	push   %ebp
  800048:	89 e5                	mov    %esp,%ebp
  80004a:	57                   	push   %edi
  80004b:	56                   	push   %esi
  80004c:	53                   	push   %ebx
  80004d:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  800050:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800057:	00 00 00 
	envid_t find = sys_getenvid();
  80005a:	e8 4c 0c 00 00       	call   800cab <sys_getenvid>
  80005f:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800065:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  80006a:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80006f:	bf 01 00 00 00       	mov    $0x1,%edi
  800074:	eb 0b                	jmp    800081 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800076:	83 c2 01             	add    $0x1,%edx
  800079:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80007f:	74 21                	je     8000a2 <libmain+0x5b>
		if(envs[i].env_id == find)
  800081:	89 d1                	mov    %edx,%ecx
  800083:	c1 e1 07             	shl    $0x7,%ecx
  800086:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80008c:	8b 49 48             	mov    0x48(%ecx),%ecx
  80008f:	39 c1                	cmp    %eax,%ecx
  800091:	75 e3                	jne    800076 <libmain+0x2f>
  800093:	89 d3                	mov    %edx,%ebx
  800095:	c1 e3 07             	shl    $0x7,%ebx
  800098:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80009e:	89 fe                	mov    %edi,%esi
  8000a0:	eb d4                	jmp    800076 <libmain+0x2f>
  8000a2:	89 f0                	mov    %esi,%eax
  8000a4:	84 c0                	test   %al,%al
  8000a6:	74 06                	je     8000ae <libmain+0x67>
  8000a8:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000b2:	7e 0a                	jle    8000be <libmain+0x77>
		binaryname = argv[0];
  8000b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000b7:	8b 00                	mov    (%eax),%eax
  8000b9:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("call umain!\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 00 25 80 00       	push   $0x802500
  8000c6:	e8 cd 00 00 00       	call   800198 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000cb:	83 c4 08             	add    $0x8,%esp
  8000ce:	ff 75 0c             	pushl  0xc(%ebp)
  8000d1:	ff 75 08             	pushl  0x8(%ebp)
  8000d4:	e8 5a ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000d9:	e8 0b 00 00 00       	call   8000e9 <exit>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ef:	e8 a2 10 00 00       	call   801196 <close_all>
	sys_env_destroy(0);
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	6a 00                	push   $0x0
  8000f9:	e8 6c 0b 00 00       	call   800c6a <sys_env_destroy>
}
  8000fe:	83 c4 10             	add    $0x10,%esp
  800101:	c9                   	leave  
  800102:	c3                   	ret    

00800103 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800103:	55                   	push   %ebp
  800104:	89 e5                	mov    %esp,%ebp
  800106:	53                   	push   %ebx
  800107:	83 ec 04             	sub    $0x4,%esp
  80010a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80010d:	8b 13                	mov    (%ebx),%edx
  80010f:	8d 42 01             	lea    0x1(%edx),%eax
  800112:	89 03                	mov    %eax,(%ebx)
  800114:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800117:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80011b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800120:	74 09                	je     80012b <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800122:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800126:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800129:	c9                   	leave  
  80012a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80012b:	83 ec 08             	sub    $0x8,%esp
  80012e:	68 ff 00 00 00       	push   $0xff
  800133:	8d 43 08             	lea    0x8(%ebx),%eax
  800136:	50                   	push   %eax
  800137:	e8 f1 0a 00 00       	call   800c2d <sys_cputs>
		b->idx = 0;
  80013c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	eb db                	jmp    800122 <putch+0x1f>

00800147 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800150:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800157:	00 00 00 
	b.cnt = 0;
  80015a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800161:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800164:	ff 75 0c             	pushl  0xc(%ebp)
  800167:	ff 75 08             	pushl  0x8(%ebp)
  80016a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800170:	50                   	push   %eax
  800171:	68 03 01 80 00       	push   $0x800103
  800176:	e8 4a 01 00 00       	call   8002c5 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80017b:	83 c4 08             	add    $0x8,%esp
  80017e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800184:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80018a:	50                   	push   %eax
  80018b:	e8 9d 0a 00 00       	call   800c2d <sys_cputs>

	return b.cnt;
}
  800190:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800196:	c9                   	leave  
  800197:	c3                   	ret    

00800198 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80019e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001a1:	50                   	push   %eax
  8001a2:	ff 75 08             	pushl  0x8(%ebp)
  8001a5:	e8 9d ff ff ff       	call   800147 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001aa:	c9                   	leave  
  8001ab:	c3                   	ret    

008001ac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	57                   	push   %edi
  8001b0:	56                   	push   %esi
  8001b1:	53                   	push   %ebx
  8001b2:	83 ec 1c             	sub    $0x1c,%esp
  8001b5:	89 c6                	mov    %eax,%esi
  8001b7:	89 d7                	mov    %edx,%edi
  8001b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001c2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8001c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001cb:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001cf:	74 2c                	je     8001fd <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001db:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001de:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001e1:	39 c2                	cmp    %eax,%edx
  8001e3:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001e6:	73 43                	jae    80022b <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001e8:	83 eb 01             	sub    $0x1,%ebx
  8001eb:	85 db                	test   %ebx,%ebx
  8001ed:	7e 6c                	jle    80025b <printnum+0xaf>
				putch(padc, putdat);
  8001ef:	83 ec 08             	sub    $0x8,%esp
  8001f2:	57                   	push   %edi
  8001f3:	ff 75 18             	pushl  0x18(%ebp)
  8001f6:	ff d6                	call   *%esi
  8001f8:	83 c4 10             	add    $0x10,%esp
  8001fb:	eb eb                	jmp    8001e8 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	6a 20                	push   $0x20
  800202:	6a 00                	push   $0x0
  800204:	50                   	push   %eax
  800205:	ff 75 e4             	pushl  -0x1c(%ebp)
  800208:	ff 75 e0             	pushl  -0x20(%ebp)
  80020b:	89 fa                	mov    %edi,%edx
  80020d:	89 f0                	mov    %esi,%eax
  80020f:	e8 98 ff ff ff       	call   8001ac <printnum>
		while (--width > 0)
  800214:	83 c4 20             	add    $0x20,%esp
  800217:	83 eb 01             	sub    $0x1,%ebx
  80021a:	85 db                	test   %ebx,%ebx
  80021c:	7e 65                	jle    800283 <printnum+0xd7>
			putch(padc, putdat);
  80021e:	83 ec 08             	sub    $0x8,%esp
  800221:	57                   	push   %edi
  800222:	6a 20                	push   $0x20
  800224:	ff d6                	call   *%esi
  800226:	83 c4 10             	add    $0x10,%esp
  800229:	eb ec                	jmp    800217 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	ff 75 18             	pushl  0x18(%ebp)
  800231:	83 eb 01             	sub    $0x1,%ebx
  800234:	53                   	push   %ebx
  800235:	50                   	push   %eax
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	ff 75 dc             	pushl  -0x24(%ebp)
  80023c:	ff 75 d8             	pushl  -0x28(%ebp)
  80023f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800242:	ff 75 e0             	pushl  -0x20(%ebp)
  800245:	e8 66 20 00 00       	call   8022b0 <__udivdi3>
  80024a:	83 c4 18             	add    $0x18,%esp
  80024d:	52                   	push   %edx
  80024e:	50                   	push   %eax
  80024f:	89 fa                	mov    %edi,%edx
  800251:	89 f0                	mov    %esi,%eax
  800253:	e8 54 ff ff ff       	call   8001ac <printnum>
  800258:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80025b:	83 ec 08             	sub    $0x8,%esp
  80025e:	57                   	push   %edi
  80025f:	83 ec 04             	sub    $0x4,%esp
  800262:	ff 75 dc             	pushl  -0x24(%ebp)
  800265:	ff 75 d8             	pushl  -0x28(%ebp)
  800268:	ff 75 e4             	pushl  -0x1c(%ebp)
  80026b:	ff 75 e0             	pushl  -0x20(%ebp)
  80026e:	e8 4d 21 00 00       	call   8023c0 <__umoddi3>
  800273:	83 c4 14             	add    $0x14,%esp
  800276:	0f be 80 17 25 80 00 	movsbl 0x802517(%eax),%eax
  80027d:	50                   	push   %eax
  80027e:	ff d6                	call   *%esi
  800280:	83 c4 10             	add    $0x10,%esp
	}
}
  800283:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800286:	5b                   	pop    %ebx
  800287:	5e                   	pop    %esi
  800288:	5f                   	pop    %edi
  800289:	5d                   	pop    %ebp
  80028a:	c3                   	ret    

0080028b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800291:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800295:	8b 10                	mov    (%eax),%edx
  800297:	3b 50 04             	cmp    0x4(%eax),%edx
  80029a:	73 0a                	jae    8002a6 <sprintputch+0x1b>
		*b->buf++ = ch;
  80029c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80029f:	89 08                	mov    %ecx,(%eax)
  8002a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002a4:	88 02                	mov    %al,(%edx)
}
  8002a6:	5d                   	pop    %ebp
  8002a7:	c3                   	ret    

008002a8 <printfmt>:
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002ae:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002b1:	50                   	push   %eax
  8002b2:	ff 75 10             	pushl  0x10(%ebp)
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	e8 05 00 00 00       	call   8002c5 <vprintfmt>
}
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <vprintfmt>:
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	57                   	push   %edi
  8002c9:	56                   	push   %esi
  8002ca:	53                   	push   %ebx
  8002cb:	83 ec 3c             	sub    $0x3c,%esp
  8002ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8002d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002d4:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002d7:	e9 32 04 00 00       	jmp    80070e <vprintfmt+0x449>
		padc = ' ';
  8002dc:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002e0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002e7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002ee:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002f5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002fc:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800303:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800308:	8d 47 01             	lea    0x1(%edi),%eax
  80030b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80030e:	0f b6 17             	movzbl (%edi),%edx
  800311:	8d 42 dd             	lea    -0x23(%edx),%eax
  800314:	3c 55                	cmp    $0x55,%al
  800316:	0f 87 12 05 00 00    	ja     80082e <vprintfmt+0x569>
  80031c:	0f b6 c0             	movzbl %al,%eax
  80031f:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800326:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800329:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80032d:	eb d9                	jmp    800308 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80032f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800332:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800336:	eb d0                	jmp    800308 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800338:	0f b6 d2             	movzbl %dl,%edx
  80033b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80033e:	b8 00 00 00 00       	mov    $0x0,%eax
  800343:	89 75 08             	mov    %esi,0x8(%ebp)
  800346:	eb 03                	jmp    80034b <vprintfmt+0x86>
  800348:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80034b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800352:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800355:	8d 72 d0             	lea    -0x30(%edx),%esi
  800358:	83 fe 09             	cmp    $0x9,%esi
  80035b:	76 eb                	jbe    800348 <vprintfmt+0x83>
  80035d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800360:	8b 75 08             	mov    0x8(%ebp),%esi
  800363:	eb 14                	jmp    800379 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800365:	8b 45 14             	mov    0x14(%ebp),%eax
  800368:	8b 00                	mov    (%eax),%eax
  80036a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036d:	8b 45 14             	mov    0x14(%ebp),%eax
  800370:	8d 40 04             	lea    0x4(%eax),%eax
  800373:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800376:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800379:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80037d:	79 89                	jns    800308 <vprintfmt+0x43>
				width = precision, precision = -1;
  80037f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800382:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800385:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80038c:	e9 77 ff ff ff       	jmp    800308 <vprintfmt+0x43>
  800391:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800394:	85 c0                	test   %eax,%eax
  800396:	0f 48 c1             	cmovs  %ecx,%eax
  800399:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80039c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80039f:	e9 64 ff ff ff       	jmp    800308 <vprintfmt+0x43>
  8003a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a7:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003ae:	e9 55 ff ff ff       	jmp    800308 <vprintfmt+0x43>
			lflag++;
  8003b3:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ba:	e9 49 ff ff ff       	jmp    800308 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c2:	8d 78 04             	lea    0x4(%eax),%edi
  8003c5:	83 ec 08             	sub    $0x8,%esp
  8003c8:	53                   	push   %ebx
  8003c9:	ff 30                	pushl  (%eax)
  8003cb:	ff d6                	call   *%esi
			break;
  8003cd:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d0:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d3:	e9 33 03 00 00       	jmp    80070b <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003db:	8d 78 04             	lea    0x4(%eax),%edi
  8003de:	8b 00                	mov    (%eax),%eax
  8003e0:	99                   	cltd   
  8003e1:	31 d0                	xor    %edx,%eax
  8003e3:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e5:	83 f8 10             	cmp    $0x10,%eax
  8003e8:	7f 23                	jg     80040d <vprintfmt+0x148>
  8003ea:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003f1:	85 d2                	test   %edx,%edx
  8003f3:	74 18                	je     80040d <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003f5:	52                   	push   %edx
  8003f6:	68 79 29 80 00       	push   $0x802979
  8003fb:	53                   	push   %ebx
  8003fc:	56                   	push   %esi
  8003fd:	e8 a6 fe ff ff       	call   8002a8 <printfmt>
  800402:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800405:	89 7d 14             	mov    %edi,0x14(%ebp)
  800408:	e9 fe 02 00 00       	jmp    80070b <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  80040d:	50                   	push   %eax
  80040e:	68 2f 25 80 00       	push   $0x80252f
  800413:	53                   	push   %ebx
  800414:	56                   	push   %esi
  800415:	e8 8e fe ff ff       	call   8002a8 <printfmt>
  80041a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80041d:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800420:	e9 e6 02 00 00       	jmp    80070b <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800425:	8b 45 14             	mov    0x14(%ebp),%eax
  800428:	83 c0 04             	add    $0x4,%eax
  80042b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80042e:	8b 45 14             	mov    0x14(%ebp),%eax
  800431:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800433:	85 c9                	test   %ecx,%ecx
  800435:	b8 28 25 80 00       	mov    $0x802528,%eax
  80043a:	0f 45 c1             	cmovne %ecx,%eax
  80043d:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800440:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800444:	7e 06                	jle    80044c <vprintfmt+0x187>
  800446:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80044a:	75 0d                	jne    800459 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80044c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80044f:	89 c7                	mov    %eax,%edi
  800451:	03 45 e0             	add    -0x20(%ebp),%eax
  800454:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800457:	eb 53                	jmp    8004ac <vprintfmt+0x1e7>
  800459:	83 ec 08             	sub    $0x8,%esp
  80045c:	ff 75 d8             	pushl  -0x28(%ebp)
  80045f:	50                   	push   %eax
  800460:	e8 71 04 00 00       	call   8008d6 <strnlen>
  800465:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800468:	29 c1                	sub    %eax,%ecx
  80046a:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800472:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800476:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800479:	eb 0f                	jmp    80048a <vprintfmt+0x1c5>
					putch(padc, putdat);
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	53                   	push   %ebx
  80047f:	ff 75 e0             	pushl  -0x20(%ebp)
  800482:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800484:	83 ef 01             	sub    $0x1,%edi
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	85 ff                	test   %edi,%edi
  80048c:	7f ed                	jg     80047b <vprintfmt+0x1b6>
  80048e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800491:	85 c9                	test   %ecx,%ecx
  800493:	b8 00 00 00 00       	mov    $0x0,%eax
  800498:	0f 49 c1             	cmovns %ecx,%eax
  80049b:	29 c1                	sub    %eax,%ecx
  80049d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a0:	eb aa                	jmp    80044c <vprintfmt+0x187>
					putch(ch, putdat);
  8004a2:	83 ec 08             	sub    $0x8,%esp
  8004a5:	53                   	push   %ebx
  8004a6:	52                   	push   %edx
  8004a7:	ff d6                	call   *%esi
  8004a9:	83 c4 10             	add    $0x10,%esp
  8004ac:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004af:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004b1:	83 c7 01             	add    $0x1,%edi
  8004b4:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004b8:	0f be d0             	movsbl %al,%edx
  8004bb:	85 d2                	test   %edx,%edx
  8004bd:	74 4b                	je     80050a <vprintfmt+0x245>
  8004bf:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004c3:	78 06                	js     8004cb <vprintfmt+0x206>
  8004c5:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004c9:	78 1e                	js     8004e9 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004cb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004cf:	74 d1                	je     8004a2 <vprintfmt+0x1dd>
  8004d1:	0f be c0             	movsbl %al,%eax
  8004d4:	83 e8 20             	sub    $0x20,%eax
  8004d7:	83 f8 5e             	cmp    $0x5e,%eax
  8004da:	76 c6                	jbe    8004a2 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	53                   	push   %ebx
  8004e0:	6a 3f                	push   $0x3f
  8004e2:	ff d6                	call   *%esi
  8004e4:	83 c4 10             	add    $0x10,%esp
  8004e7:	eb c3                	jmp    8004ac <vprintfmt+0x1e7>
  8004e9:	89 cf                	mov    %ecx,%edi
  8004eb:	eb 0e                	jmp    8004fb <vprintfmt+0x236>
				putch(' ', putdat);
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	53                   	push   %ebx
  8004f1:	6a 20                	push   $0x20
  8004f3:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004f5:	83 ef 01             	sub    $0x1,%edi
  8004f8:	83 c4 10             	add    $0x10,%esp
  8004fb:	85 ff                	test   %edi,%edi
  8004fd:	7f ee                	jg     8004ed <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ff:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800502:	89 45 14             	mov    %eax,0x14(%ebp)
  800505:	e9 01 02 00 00       	jmp    80070b <vprintfmt+0x446>
  80050a:	89 cf                	mov    %ecx,%edi
  80050c:	eb ed                	jmp    8004fb <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  80050e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800511:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800518:	e9 eb fd ff ff       	jmp    800308 <vprintfmt+0x43>
	if (lflag >= 2)
  80051d:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800521:	7f 21                	jg     800544 <vprintfmt+0x27f>
	else if (lflag)
  800523:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800527:	74 68                	je     800591 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8b 00                	mov    (%eax),%eax
  80052e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800531:	89 c1                	mov    %eax,%ecx
  800533:	c1 f9 1f             	sar    $0x1f,%ecx
  800536:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800539:	8b 45 14             	mov    0x14(%ebp),%eax
  80053c:	8d 40 04             	lea    0x4(%eax),%eax
  80053f:	89 45 14             	mov    %eax,0x14(%ebp)
  800542:	eb 17                	jmp    80055b <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8b 50 04             	mov    0x4(%eax),%edx
  80054a:	8b 00                	mov    (%eax),%eax
  80054c:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800552:	8b 45 14             	mov    0x14(%ebp),%eax
  800555:	8d 40 08             	lea    0x8(%eax),%eax
  800558:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80055b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80055e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800561:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800564:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800567:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80056b:	78 3f                	js     8005ac <vprintfmt+0x2e7>
			base = 10;
  80056d:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800572:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800576:	0f 84 71 01 00 00    	je     8006ed <vprintfmt+0x428>
				putch('+', putdat);
  80057c:	83 ec 08             	sub    $0x8,%esp
  80057f:	53                   	push   %ebx
  800580:	6a 2b                	push   $0x2b
  800582:	ff d6                	call   *%esi
  800584:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058c:	e9 5c 01 00 00       	jmp    8006ed <vprintfmt+0x428>
		return va_arg(*ap, int);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 00                	mov    (%eax),%eax
  800596:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800599:	89 c1                	mov    %eax,%ecx
  80059b:	c1 f9 1f             	sar    $0x1f,%ecx
  80059e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a4:	8d 40 04             	lea    0x4(%eax),%eax
  8005a7:	89 45 14             	mov    %eax,0x14(%ebp)
  8005aa:	eb af                	jmp    80055b <vprintfmt+0x296>
				putch('-', putdat);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	53                   	push   %ebx
  8005b0:	6a 2d                	push   $0x2d
  8005b2:	ff d6                	call   *%esi
				num = -(long long) num;
  8005b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005b7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ba:	f7 d8                	neg    %eax
  8005bc:	83 d2 00             	adc    $0x0,%edx
  8005bf:	f7 da                	neg    %edx
  8005c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005c4:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005c7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005ca:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005cf:	e9 19 01 00 00       	jmp    8006ed <vprintfmt+0x428>
	if (lflag >= 2)
  8005d4:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005d8:	7f 29                	jg     800603 <vprintfmt+0x33e>
	else if (lflag)
  8005da:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005de:	74 44                	je     800624 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e3:	8b 00                	mov    (%eax),%eax
  8005e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 40 04             	lea    0x4(%eax),%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fe:	e9 ea 00 00 00       	jmp    8006ed <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 50 04             	mov    0x4(%eax),%edx
  800609:	8b 00                	mov    (%eax),%eax
  80060b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80060e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800611:	8b 45 14             	mov    0x14(%ebp),%eax
  800614:	8d 40 08             	lea    0x8(%eax),%eax
  800617:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80061f:	e9 c9 00 00 00       	jmp    8006ed <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800624:	8b 45 14             	mov    0x14(%ebp),%eax
  800627:	8b 00                	mov    (%eax),%eax
  800629:	ba 00 00 00 00       	mov    $0x0,%edx
  80062e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800631:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8d 40 04             	lea    0x4(%eax),%eax
  80063a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800642:	e9 a6 00 00 00       	jmp    8006ed <vprintfmt+0x428>
			putch('0', putdat);
  800647:	83 ec 08             	sub    $0x8,%esp
  80064a:	53                   	push   %ebx
  80064b:	6a 30                	push   $0x30
  80064d:	ff d6                	call   *%esi
	if (lflag >= 2)
  80064f:	83 c4 10             	add    $0x10,%esp
  800652:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800656:	7f 26                	jg     80067e <vprintfmt+0x3b9>
	else if (lflag)
  800658:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80065c:	74 3e                	je     80069c <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 00                	mov    (%eax),%eax
  800663:	ba 00 00 00 00       	mov    $0x0,%edx
  800668:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80066b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8d 40 04             	lea    0x4(%eax),%eax
  800674:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800677:	b8 08 00 00 00       	mov    $0x8,%eax
  80067c:	eb 6f                	jmp    8006ed <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80067e:	8b 45 14             	mov    0x14(%ebp),%eax
  800681:	8b 50 04             	mov    0x4(%eax),%edx
  800684:	8b 00                	mov    (%eax),%eax
  800686:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800689:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068c:	8b 45 14             	mov    0x14(%ebp),%eax
  80068f:	8d 40 08             	lea    0x8(%eax),%eax
  800692:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800695:	b8 08 00 00 00       	mov    $0x8,%eax
  80069a:	eb 51                	jmp    8006ed <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8d 40 04             	lea    0x4(%eax),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006b5:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ba:	eb 31                	jmp    8006ed <vprintfmt+0x428>
			putch('0', putdat);
  8006bc:	83 ec 08             	sub    $0x8,%esp
  8006bf:	53                   	push   %ebx
  8006c0:	6a 30                	push   $0x30
  8006c2:	ff d6                	call   *%esi
			putch('x', putdat);
  8006c4:	83 c4 08             	add    $0x8,%esp
  8006c7:	53                   	push   %ebx
  8006c8:	6a 78                	push   $0x78
  8006ca:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006dc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8d 40 04             	lea    0x4(%eax),%eax
  8006e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006e8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006ed:	83 ec 0c             	sub    $0xc,%esp
  8006f0:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006f4:	52                   	push   %edx
  8006f5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006f8:	50                   	push   %eax
  8006f9:	ff 75 dc             	pushl  -0x24(%ebp)
  8006fc:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ff:	89 da                	mov    %ebx,%edx
  800701:	89 f0                	mov    %esi,%eax
  800703:	e8 a4 fa ff ff       	call   8001ac <printnum>
			break;
  800708:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  80070b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070e:	83 c7 01             	add    $0x1,%edi
  800711:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800715:	83 f8 25             	cmp    $0x25,%eax
  800718:	0f 84 be fb ff ff    	je     8002dc <vprintfmt+0x17>
			if (ch == '\0')
  80071e:	85 c0                	test   %eax,%eax
  800720:	0f 84 28 01 00 00    	je     80084e <vprintfmt+0x589>
			putch(ch, putdat);
  800726:	83 ec 08             	sub    $0x8,%esp
  800729:	53                   	push   %ebx
  80072a:	50                   	push   %eax
  80072b:	ff d6                	call   *%esi
  80072d:	83 c4 10             	add    $0x10,%esp
  800730:	eb dc                	jmp    80070e <vprintfmt+0x449>
	if (lflag >= 2)
  800732:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800736:	7f 26                	jg     80075e <vprintfmt+0x499>
	else if (lflag)
  800738:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80073c:	74 41                	je     80077f <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	ba 00 00 00 00       	mov    $0x0,%edx
  800748:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80074b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074e:	8b 45 14             	mov    0x14(%ebp),%eax
  800751:	8d 40 04             	lea    0x4(%eax),%eax
  800754:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800757:	b8 10 00 00 00       	mov    $0x10,%eax
  80075c:	eb 8f                	jmp    8006ed <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 50 04             	mov    0x4(%eax),%edx
  800764:	8b 00                	mov    (%eax),%eax
  800766:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800769:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076c:	8b 45 14             	mov    0x14(%ebp),%eax
  80076f:	8d 40 08             	lea    0x8(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
  80077a:	e9 6e ff ff ff       	jmp    8006ed <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	ba 00 00 00 00       	mov    $0x0,%edx
  800789:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80078f:	8b 45 14             	mov    0x14(%ebp),%eax
  800792:	8d 40 04             	lea    0x4(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800798:	b8 10 00 00 00       	mov    $0x10,%eax
  80079d:	e9 4b ff ff ff       	jmp    8006ed <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	83 c0 04             	add    $0x4,%eax
  8007a8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8b 00                	mov    (%eax),%eax
  8007b0:	85 c0                	test   %eax,%eax
  8007b2:	74 14                	je     8007c8 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007b4:	8b 13                	mov    (%ebx),%edx
  8007b6:	83 fa 7f             	cmp    $0x7f,%edx
  8007b9:	7f 37                	jg     8007f2 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007bb:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	e9 43 ff ff ff       	jmp    80070b <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007c8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007cd:	bf 4d 26 80 00       	mov    $0x80264d,%edi
							putch(ch, putdat);
  8007d2:	83 ec 08             	sub    $0x8,%esp
  8007d5:	53                   	push   %ebx
  8007d6:	50                   	push   %eax
  8007d7:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007d9:	83 c7 01             	add    $0x1,%edi
  8007dc:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007e0:	83 c4 10             	add    $0x10,%esp
  8007e3:	85 c0                	test   %eax,%eax
  8007e5:	75 eb                	jne    8007d2 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007ea:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ed:	e9 19 ff ff ff       	jmp    80070b <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007f2:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007f4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007f9:	bf 85 26 80 00       	mov    $0x802685,%edi
							putch(ch, putdat);
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	53                   	push   %ebx
  800802:	50                   	push   %eax
  800803:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  800805:	83 c7 01             	add    $0x1,%edi
  800808:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	85 c0                	test   %eax,%eax
  800811:	75 eb                	jne    8007fe <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800813:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800816:	89 45 14             	mov    %eax,0x14(%ebp)
  800819:	e9 ed fe ff ff       	jmp    80070b <vprintfmt+0x446>
			putch(ch, putdat);
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	53                   	push   %ebx
  800822:	6a 25                	push   $0x25
  800824:	ff d6                	call   *%esi
			break;
  800826:	83 c4 10             	add    $0x10,%esp
  800829:	e9 dd fe ff ff       	jmp    80070b <vprintfmt+0x446>
			putch('%', putdat);
  80082e:	83 ec 08             	sub    $0x8,%esp
  800831:	53                   	push   %ebx
  800832:	6a 25                	push   $0x25
  800834:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	89 f8                	mov    %edi,%eax
  80083b:	eb 03                	jmp    800840 <vprintfmt+0x57b>
  80083d:	83 e8 01             	sub    $0x1,%eax
  800840:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800844:	75 f7                	jne    80083d <vprintfmt+0x578>
  800846:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800849:	e9 bd fe ff ff       	jmp    80070b <vprintfmt+0x446>
}
  80084e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800851:	5b                   	pop    %ebx
  800852:	5e                   	pop    %esi
  800853:	5f                   	pop    %edi
  800854:	5d                   	pop    %ebp
  800855:	c3                   	ret    

00800856 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	83 ec 18             	sub    $0x18,%esp
  80085c:	8b 45 08             	mov    0x8(%ebp),%eax
  80085f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800862:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800865:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800869:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80086c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800873:	85 c0                	test   %eax,%eax
  800875:	74 26                	je     80089d <vsnprintf+0x47>
  800877:	85 d2                	test   %edx,%edx
  800879:	7e 22                	jle    80089d <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80087b:	ff 75 14             	pushl  0x14(%ebp)
  80087e:	ff 75 10             	pushl  0x10(%ebp)
  800881:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800884:	50                   	push   %eax
  800885:	68 8b 02 80 00       	push   $0x80028b
  80088a:	e8 36 fa ff ff       	call   8002c5 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80088f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800892:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800898:	83 c4 10             	add    $0x10,%esp
}
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    
		return -E_INVAL;
  80089d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008a2:	eb f7                	jmp    80089b <vsnprintf+0x45>

008008a4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008aa:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008ad:	50                   	push   %eax
  8008ae:	ff 75 10             	pushl  0x10(%ebp)
  8008b1:	ff 75 0c             	pushl  0xc(%ebp)
  8008b4:	ff 75 08             	pushl  0x8(%ebp)
  8008b7:	e8 9a ff ff ff       	call   800856 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008bc:	c9                   	leave  
  8008bd:	c3                   	ret    

008008be <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008cd:	74 05                	je     8008d4 <strlen+0x16>
		n++;
  8008cf:	83 c0 01             	add    $0x1,%eax
  8008d2:	eb f5                	jmp    8008c9 <strlen+0xb>
	return n;
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008df:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e4:	39 c2                	cmp    %eax,%edx
  8008e6:	74 0d                	je     8008f5 <strnlen+0x1f>
  8008e8:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008ec:	74 05                	je     8008f3 <strnlen+0x1d>
		n++;
  8008ee:	83 c2 01             	add    $0x1,%edx
  8008f1:	eb f1                	jmp    8008e4 <strnlen+0xe>
  8008f3:	89 d0                	mov    %edx,%eax
	return n;
}
  8008f5:	5d                   	pop    %ebp
  8008f6:	c3                   	ret    

008008f7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	53                   	push   %ebx
  8008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800901:	ba 00 00 00 00       	mov    $0x0,%edx
  800906:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80090a:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  80090d:	83 c2 01             	add    $0x1,%edx
  800910:	84 c9                	test   %cl,%cl
  800912:	75 f2                	jne    800906 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800914:	5b                   	pop    %ebx
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	53                   	push   %ebx
  80091b:	83 ec 10             	sub    $0x10,%esp
  80091e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800921:	53                   	push   %ebx
  800922:	e8 97 ff ff ff       	call   8008be <strlen>
  800927:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	01 d8                	add    %ebx,%eax
  80092f:	50                   	push   %eax
  800930:	e8 c2 ff ff ff       	call   8008f7 <strcpy>
	return dst;
}
  800935:	89 d8                	mov    %ebx,%eax
  800937:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	56                   	push   %esi
  800940:	53                   	push   %ebx
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800947:	89 c6                	mov    %eax,%esi
  800949:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80094c:	89 c2                	mov    %eax,%edx
  80094e:	39 f2                	cmp    %esi,%edx
  800950:	74 11                	je     800963 <strncpy+0x27>
		*dst++ = *src;
  800952:	83 c2 01             	add    $0x1,%edx
  800955:	0f b6 19             	movzbl (%ecx),%ebx
  800958:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80095b:	80 fb 01             	cmp    $0x1,%bl
  80095e:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800961:	eb eb                	jmp    80094e <strncpy+0x12>
	}
	return ret;
}
  800963:	5b                   	pop    %ebx
  800964:	5e                   	pop    %esi
  800965:	5d                   	pop    %ebp
  800966:	c3                   	ret    

00800967 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	56                   	push   %esi
  80096b:	53                   	push   %ebx
  80096c:	8b 75 08             	mov    0x8(%ebp),%esi
  80096f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800972:	8b 55 10             	mov    0x10(%ebp),%edx
  800975:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800977:	85 d2                	test   %edx,%edx
  800979:	74 21                	je     80099c <strlcpy+0x35>
  80097b:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80097f:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800981:	39 c2                	cmp    %eax,%edx
  800983:	74 14                	je     800999 <strlcpy+0x32>
  800985:	0f b6 19             	movzbl (%ecx),%ebx
  800988:	84 db                	test   %bl,%bl
  80098a:	74 0b                	je     800997 <strlcpy+0x30>
			*dst++ = *src++;
  80098c:	83 c1 01             	add    $0x1,%ecx
  80098f:	83 c2 01             	add    $0x1,%edx
  800992:	88 5a ff             	mov    %bl,-0x1(%edx)
  800995:	eb ea                	jmp    800981 <strlcpy+0x1a>
  800997:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800999:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80099c:	29 f0                	sub    %esi,%eax
}
  80099e:	5b                   	pop    %ebx
  80099f:	5e                   	pop    %esi
  8009a0:	5d                   	pop    %ebp
  8009a1:	c3                   	ret    

008009a2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009a8:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ab:	0f b6 01             	movzbl (%ecx),%eax
  8009ae:	84 c0                	test   %al,%al
  8009b0:	74 0c                	je     8009be <strcmp+0x1c>
  8009b2:	3a 02                	cmp    (%edx),%al
  8009b4:	75 08                	jne    8009be <strcmp+0x1c>
		p++, q++;
  8009b6:	83 c1 01             	add    $0x1,%ecx
  8009b9:	83 c2 01             	add    $0x1,%edx
  8009bc:	eb ed                	jmp    8009ab <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009be:	0f b6 c0             	movzbl %al,%eax
  8009c1:	0f b6 12             	movzbl (%edx),%edx
  8009c4:	29 d0                	sub    %edx,%eax
}
  8009c6:	5d                   	pop    %ebp
  8009c7:	c3                   	ret    

008009c8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009c8:	55                   	push   %ebp
  8009c9:	89 e5                	mov    %esp,%ebp
  8009cb:	53                   	push   %ebx
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d2:	89 c3                	mov    %eax,%ebx
  8009d4:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009d7:	eb 06                	jmp    8009df <strncmp+0x17>
		n--, p++, q++;
  8009d9:	83 c0 01             	add    $0x1,%eax
  8009dc:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009df:	39 d8                	cmp    %ebx,%eax
  8009e1:	74 16                	je     8009f9 <strncmp+0x31>
  8009e3:	0f b6 08             	movzbl (%eax),%ecx
  8009e6:	84 c9                	test   %cl,%cl
  8009e8:	74 04                	je     8009ee <strncmp+0x26>
  8009ea:	3a 0a                	cmp    (%edx),%cl
  8009ec:	74 eb                	je     8009d9 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ee:	0f b6 00             	movzbl (%eax),%eax
  8009f1:	0f b6 12             	movzbl (%edx),%edx
  8009f4:	29 d0                	sub    %edx,%eax
}
  8009f6:	5b                   	pop    %ebx
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    
		return 0;
  8009f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8009fe:	eb f6                	jmp    8009f6 <strncmp+0x2e>

00800a00 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0a:	0f b6 10             	movzbl (%eax),%edx
  800a0d:	84 d2                	test   %dl,%dl
  800a0f:	74 09                	je     800a1a <strchr+0x1a>
		if (*s == c)
  800a11:	38 ca                	cmp    %cl,%dl
  800a13:	74 0a                	je     800a1f <strchr+0x1f>
	for (; *s; s++)
  800a15:	83 c0 01             	add    $0x1,%eax
  800a18:	eb f0                	jmp    800a0a <strchr+0xa>
			return (char *) s;
	return 0;
  800a1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a1f:	5d                   	pop    %ebp
  800a20:	c3                   	ret    

00800a21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a2b:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a2e:	38 ca                	cmp    %cl,%dl
  800a30:	74 09                	je     800a3b <strfind+0x1a>
  800a32:	84 d2                	test   %dl,%dl
  800a34:	74 05                	je     800a3b <strfind+0x1a>
	for (; *s; s++)
  800a36:	83 c0 01             	add    $0x1,%eax
  800a39:	eb f0                	jmp    800a2b <strfind+0xa>
			break;
	return (char *) s;
}
  800a3b:	5d                   	pop    %ebp
  800a3c:	c3                   	ret    

00800a3d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a3d:	55                   	push   %ebp
  800a3e:	89 e5                	mov    %esp,%ebp
  800a40:	57                   	push   %edi
  800a41:	56                   	push   %esi
  800a42:	53                   	push   %ebx
  800a43:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a46:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a49:	85 c9                	test   %ecx,%ecx
  800a4b:	74 31                	je     800a7e <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4d:	89 f8                	mov    %edi,%eax
  800a4f:	09 c8                	or     %ecx,%eax
  800a51:	a8 03                	test   $0x3,%al
  800a53:	75 23                	jne    800a78 <memset+0x3b>
		c &= 0xFF;
  800a55:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a59:	89 d3                	mov    %edx,%ebx
  800a5b:	c1 e3 08             	shl    $0x8,%ebx
  800a5e:	89 d0                	mov    %edx,%eax
  800a60:	c1 e0 18             	shl    $0x18,%eax
  800a63:	89 d6                	mov    %edx,%esi
  800a65:	c1 e6 10             	shl    $0x10,%esi
  800a68:	09 f0                	or     %esi,%eax
  800a6a:	09 c2                	or     %eax,%edx
  800a6c:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a6e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a71:	89 d0                	mov    %edx,%eax
  800a73:	fc                   	cld    
  800a74:	f3 ab                	rep stos %eax,%es:(%edi)
  800a76:	eb 06                	jmp    800a7e <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a7b:	fc                   	cld    
  800a7c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a7e:	89 f8                	mov    %edi,%eax
  800a80:	5b                   	pop    %ebx
  800a81:	5e                   	pop    %esi
  800a82:	5f                   	pop    %edi
  800a83:	5d                   	pop    %ebp
  800a84:	c3                   	ret    

00800a85 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a85:	55                   	push   %ebp
  800a86:	89 e5                	mov    %esp,%ebp
  800a88:	57                   	push   %edi
  800a89:	56                   	push   %esi
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a90:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a93:	39 c6                	cmp    %eax,%esi
  800a95:	73 32                	jae    800ac9 <memmove+0x44>
  800a97:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a9a:	39 c2                	cmp    %eax,%edx
  800a9c:	76 2b                	jbe    800ac9 <memmove+0x44>
		s += n;
		d += n;
  800a9e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa1:	89 fe                	mov    %edi,%esi
  800aa3:	09 ce                	or     %ecx,%esi
  800aa5:	09 d6                	or     %edx,%esi
  800aa7:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800aad:	75 0e                	jne    800abd <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aaf:	83 ef 04             	sub    $0x4,%edi
  800ab2:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ab5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ab8:	fd                   	std    
  800ab9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abb:	eb 09                	jmp    800ac6 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800abd:	83 ef 01             	sub    $0x1,%edi
  800ac0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ac3:	fd                   	std    
  800ac4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ac6:	fc                   	cld    
  800ac7:	eb 1a                	jmp    800ae3 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ac9:	89 c2                	mov    %eax,%edx
  800acb:	09 ca                	or     %ecx,%edx
  800acd:	09 f2                	or     %esi,%edx
  800acf:	f6 c2 03             	test   $0x3,%dl
  800ad2:	75 0a                	jne    800ade <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ad4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ad7:	89 c7                	mov    %eax,%edi
  800ad9:	fc                   	cld    
  800ada:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800adc:	eb 05                	jmp    800ae3 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800ade:	89 c7                	mov    %eax,%edi
  800ae0:	fc                   	cld    
  800ae1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ae3:	5e                   	pop    %esi
  800ae4:	5f                   	pop    %edi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800aed:	ff 75 10             	pushl  0x10(%ebp)
  800af0:	ff 75 0c             	pushl  0xc(%ebp)
  800af3:	ff 75 08             	pushl  0x8(%ebp)
  800af6:	e8 8a ff ff ff       	call   800a85 <memmove>
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	56                   	push   %esi
  800b01:	53                   	push   %ebx
  800b02:	8b 45 08             	mov    0x8(%ebp),%eax
  800b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b08:	89 c6                	mov    %eax,%esi
  800b0a:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b0d:	39 f0                	cmp    %esi,%eax
  800b0f:	74 1c                	je     800b2d <memcmp+0x30>
		if (*s1 != *s2)
  800b11:	0f b6 08             	movzbl (%eax),%ecx
  800b14:	0f b6 1a             	movzbl (%edx),%ebx
  800b17:	38 d9                	cmp    %bl,%cl
  800b19:	75 08                	jne    800b23 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b1b:	83 c0 01             	add    $0x1,%eax
  800b1e:	83 c2 01             	add    $0x1,%edx
  800b21:	eb ea                	jmp    800b0d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b23:	0f b6 c1             	movzbl %cl,%eax
  800b26:	0f b6 db             	movzbl %bl,%ebx
  800b29:	29 d8                	sub    %ebx,%eax
  800b2b:	eb 05                	jmp    800b32 <memcmp+0x35>
	}

	return 0;
  800b2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b3f:	89 c2                	mov    %eax,%edx
  800b41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b44:	39 d0                	cmp    %edx,%eax
  800b46:	73 09                	jae    800b51 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b48:	38 08                	cmp    %cl,(%eax)
  800b4a:	74 05                	je     800b51 <memfind+0x1b>
	for (; s < ends; s++)
  800b4c:	83 c0 01             	add    $0x1,%eax
  800b4f:	eb f3                	jmp    800b44 <memfind+0xe>
			break;
	return (void *) s;
}
  800b51:	5d                   	pop    %ebp
  800b52:	c3                   	ret    

00800b53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b53:	55                   	push   %ebp
  800b54:	89 e5                	mov    %esp,%ebp
  800b56:	57                   	push   %edi
  800b57:	56                   	push   %esi
  800b58:	53                   	push   %ebx
  800b59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b5f:	eb 03                	jmp    800b64 <strtol+0x11>
		s++;
  800b61:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b64:	0f b6 01             	movzbl (%ecx),%eax
  800b67:	3c 20                	cmp    $0x20,%al
  800b69:	74 f6                	je     800b61 <strtol+0xe>
  800b6b:	3c 09                	cmp    $0x9,%al
  800b6d:	74 f2                	je     800b61 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b6f:	3c 2b                	cmp    $0x2b,%al
  800b71:	74 2a                	je     800b9d <strtol+0x4a>
	int neg = 0;
  800b73:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b78:	3c 2d                	cmp    $0x2d,%al
  800b7a:	74 2b                	je     800ba7 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7c:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b82:	75 0f                	jne    800b93 <strtol+0x40>
  800b84:	80 39 30             	cmpb   $0x30,(%ecx)
  800b87:	74 28                	je     800bb1 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b89:	85 db                	test   %ebx,%ebx
  800b8b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b90:	0f 44 d8             	cmove  %eax,%ebx
  800b93:	b8 00 00 00 00       	mov    $0x0,%eax
  800b98:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b9b:	eb 50                	jmp    800bed <strtol+0x9a>
		s++;
  800b9d:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800ba0:	bf 00 00 00 00       	mov    $0x0,%edi
  800ba5:	eb d5                	jmp    800b7c <strtol+0x29>
		s++, neg = 1;
  800ba7:	83 c1 01             	add    $0x1,%ecx
  800baa:	bf 01 00 00 00       	mov    $0x1,%edi
  800baf:	eb cb                	jmp    800b7c <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bb1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bb5:	74 0e                	je     800bc5 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bb7:	85 db                	test   %ebx,%ebx
  800bb9:	75 d8                	jne    800b93 <strtol+0x40>
		s++, base = 8;
  800bbb:	83 c1 01             	add    $0x1,%ecx
  800bbe:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bc3:	eb ce                	jmp    800b93 <strtol+0x40>
		s += 2, base = 16;
  800bc5:	83 c1 02             	add    $0x2,%ecx
  800bc8:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bcd:	eb c4                	jmp    800b93 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bcf:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bd2:	89 f3                	mov    %esi,%ebx
  800bd4:	80 fb 19             	cmp    $0x19,%bl
  800bd7:	77 29                	ja     800c02 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bd9:	0f be d2             	movsbl %dl,%edx
  800bdc:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bdf:	3b 55 10             	cmp    0x10(%ebp),%edx
  800be2:	7d 30                	jge    800c14 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800be4:	83 c1 01             	add    $0x1,%ecx
  800be7:	0f af 45 10          	imul   0x10(%ebp),%eax
  800beb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bed:	0f b6 11             	movzbl (%ecx),%edx
  800bf0:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bf3:	89 f3                	mov    %esi,%ebx
  800bf5:	80 fb 09             	cmp    $0x9,%bl
  800bf8:	77 d5                	ja     800bcf <strtol+0x7c>
			dig = *s - '0';
  800bfa:	0f be d2             	movsbl %dl,%edx
  800bfd:	83 ea 30             	sub    $0x30,%edx
  800c00:	eb dd                	jmp    800bdf <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c02:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c05:	89 f3                	mov    %esi,%ebx
  800c07:	80 fb 19             	cmp    $0x19,%bl
  800c0a:	77 08                	ja     800c14 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c0c:	0f be d2             	movsbl %dl,%edx
  800c0f:	83 ea 37             	sub    $0x37,%edx
  800c12:	eb cb                	jmp    800bdf <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c14:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c18:	74 05                	je     800c1f <strtol+0xcc>
		*endptr = (char *) s;
  800c1a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c1d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c1f:	89 c2                	mov    %eax,%edx
  800c21:	f7 da                	neg    %edx
  800c23:	85 ff                	test   %edi,%edi
  800c25:	0f 45 c2             	cmovne %edx,%eax
}
  800c28:	5b                   	pop    %ebx
  800c29:	5e                   	pop    %esi
  800c2a:	5f                   	pop    %edi
  800c2b:	5d                   	pop    %ebp
  800c2c:	c3                   	ret    

00800c2d <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c33:	b8 00 00 00 00       	mov    $0x0,%eax
  800c38:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3e:	89 c3                	mov    %eax,%ebx
  800c40:	89 c7                	mov    %eax,%edi
  800c42:	89 c6                	mov    %eax,%esi
  800c44:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    

00800c4b <sys_cgetc>:

int
sys_cgetc(void)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c51:	ba 00 00 00 00       	mov    $0x0,%edx
  800c56:	b8 01 00 00 00       	mov    $0x1,%eax
  800c5b:	89 d1                	mov    %edx,%ecx
  800c5d:	89 d3                	mov    %edx,%ebx
  800c5f:	89 d7                	mov    %edx,%edi
  800c61:	89 d6                	mov    %edx,%esi
  800c63:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c65:	5b                   	pop    %ebx
  800c66:	5e                   	pop    %esi
  800c67:	5f                   	pop    %edi
  800c68:	5d                   	pop    %ebp
  800c69:	c3                   	ret    

00800c6a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c6a:	55                   	push   %ebp
  800c6b:	89 e5                	mov    %esp,%ebp
  800c6d:	57                   	push   %edi
  800c6e:	56                   	push   %esi
  800c6f:	53                   	push   %ebx
  800c70:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c73:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c78:	8b 55 08             	mov    0x8(%ebp),%edx
  800c7b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c80:	89 cb                	mov    %ecx,%ebx
  800c82:	89 cf                	mov    %ecx,%edi
  800c84:	89 ce                	mov    %ecx,%esi
  800c86:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	7f 08                	jg     800c94 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c8f:	5b                   	pop    %ebx
  800c90:	5e                   	pop    %esi
  800c91:	5f                   	pop    %edi
  800c92:	5d                   	pop    %ebp
  800c93:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c94:	83 ec 0c             	sub    $0xc,%esp
  800c97:	50                   	push   %eax
  800c98:	6a 03                	push   $0x3
  800c9a:	68 a4 28 80 00       	push   $0x8028a4
  800c9f:	6a 43                	push   $0x43
  800ca1:	68 c1 28 80 00       	push   $0x8028c1
  800ca6:	e8 69 14 00 00       	call   802114 <_panic>

00800cab <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb1:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb6:	b8 02 00 00 00       	mov    $0x2,%eax
  800cbb:	89 d1                	mov    %edx,%ecx
  800cbd:	89 d3                	mov    %edx,%ebx
  800cbf:	89 d7                	mov    %edx,%edi
  800cc1:	89 d6                	mov    %edx,%esi
  800cc3:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cc5:	5b                   	pop    %ebx
  800cc6:	5e                   	pop    %esi
  800cc7:	5f                   	pop    %edi
  800cc8:	5d                   	pop    %ebp
  800cc9:	c3                   	ret    

00800cca <sys_yield>:

void
sys_yield(void)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	57                   	push   %edi
  800cce:	56                   	push   %esi
  800ccf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd0:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd5:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cda:	89 d1                	mov    %edx,%ecx
  800cdc:	89 d3                	mov    %edx,%ebx
  800cde:	89 d7                	mov    %edx,%edi
  800ce0:	89 d6                	mov    %edx,%esi
  800ce2:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ce4:	5b                   	pop    %ebx
  800ce5:	5e                   	pop    %esi
  800ce6:	5f                   	pop    %edi
  800ce7:	5d                   	pop    %ebp
  800ce8:	c3                   	ret    

00800ce9 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	57                   	push   %edi
  800ced:	56                   	push   %esi
  800cee:	53                   	push   %ebx
  800cef:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf2:	be 00 00 00 00       	mov    $0x0,%esi
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cfd:	b8 04 00 00 00       	mov    $0x4,%eax
  800d02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d05:	89 f7                	mov    %esi,%edi
  800d07:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d09:	85 c0                	test   %eax,%eax
  800d0b:	7f 08                	jg     800d15 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d0d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d15:	83 ec 0c             	sub    $0xc,%esp
  800d18:	50                   	push   %eax
  800d19:	6a 04                	push   $0x4
  800d1b:	68 a4 28 80 00       	push   $0x8028a4
  800d20:	6a 43                	push   $0x43
  800d22:	68 c1 28 80 00       	push   $0x8028c1
  800d27:	e8 e8 13 00 00       	call   802114 <_panic>

00800d2c <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	57                   	push   %edi
  800d30:	56                   	push   %esi
  800d31:	53                   	push   %ebx
  800d32:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d35:	8b 55 08             	mov    0x8(%ebp),%edx
  800d38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3b:	b8 05 00 00 00       	mov    $0x5,%eax
  800d40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d46:	8b 75 18             	mov    0x18(%ebp),%esi
  800d49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4b:	85 c0                	test   %eax,%eax
  800d4d:	7f 08                	jg     800d57 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d52:	5b                   	pop    %ebx
  800d53:	5e                   	pop    %esi
  800d54:	5f                   	pop    %edi
  800d55:	5d                   	pop    %ebp
  800d56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d57:	83 ec 0c             	sub    $0xc,%esp
  800d5a:	50                   	push   %eax
  800d5b:	6a 05                	push   $0x5
  800d5d:	68 a4 28 80 00       	push   $0x8028a4
  800d62:	6a 43                	push   $0x43
  800d64:	68 c1 28 80 00       	push   $0x8028c1
  800d69:	e8 a6 13 00 00       	call   802114 <_panic>

00800d6e <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	57                   	push   %edi
  800d72:	56                   	push   %esi
  800d73:	53                   	push   %ebx
  800d74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d82:	b8 06 00 00 00       	mov    $0x6,%eax
  800d87:	89 df                	mov    %ebx,%edi
  800d89:	89 de                	mov    %ebx,%esi
  800d8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d8d:	85 c0                	test   %eax,%eax
  800d8f:	7f 08                	jg     800d99 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d99:	83 ec 0c             	sub    $0xc,%esp
  800d9c:	50                   	push   %eax
  800d9d:	6a 06                	push   $0x6
  800d9f:	68 a4 28 80 00       	push   $0x8028a4
  800da4:	6a 43                	push   $0x43
  800da6:	68 c1 28 80 00       	push   $0x8028c1
  800dab:	e8 64 13 00 00       	call   802114 <_panic>

00800db0 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800db0:	55                   	push   %ebp
  800db1:	89 e5                	mov    %esp,%ebp
  800db3:	57                   	push   %edi
  800db4:	56                   	push   %esi
  800db5:	53                   	push   %ebx
  800db6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc4:	b8 08 00 00 00       	mov    $0x8,%eax
  800dc9:	89 df                	mov    %ebx,%edi
  800dcb:	89 de                	mov    %ebx,%esi
  800dcd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dcf:	85 c0                	test   %eax,%eax
  800dd1:	7f 08                	jg     800ddb <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd6:	5b                   	pop    %ebx
  800dd7:	5e                   	pop    %esi
  800dd8:	5f                   	pop    %edi
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ddb:	83 ec 0c             	sub    $0xc,%esp
  800dde:	50                   	push   %eax
  800ddf:	6a 08                	push   $0x8
  800de1:	68 a4 28 80 00       	push   $0x8028a4
  800de6:	6a 43                	push   $0x43
  800de8:	68 c1 28 80 00       	push   $0x8028c1
  800ded:	e8 22 13 00 00       	call   802114 <_panic>

00800df2 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	57                   	push   %edi
  800df6:	56                   	push   %esi
  800df7:	53                   	push   %ebx
  800df8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e00:	8b 55 08             	mov    0x8(%ebp),%edx
  800e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e06:	b8 09 00 00 00       	mov    $0x9,%eax
  800e0b:	89 df                	mov    %ebx,%edi
  800e0d:	89 de                	mov    %ebx,%esi
  800e0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e11:	85 c0                	test   %eax,%eax
  800e13:	7f 08                	jg     800e1d <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e18:	5b                   	pop    %ebx
  800e19:	5e                   	pop    %esi
  800e1a:	5f                   	pop    %edi
  800e1b:	5d                   	pop    %ebp
  800e1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e1d:	83 ec 0c             	sub    $0xc,%esp
  800e20:	50                   	push   %eax
  800e21:	6a 09                	push   $0x9
  800e23:	68 a4 28 80 00       	push   $0x8028a4
  800e28:	6a 43                	push   $0x43
  800e2a:	68 c1 28 80 00       	push   $0x8028c1
  800e2f:	e8 e0 12 00 00       	call   802114 <_panic>

00800e34 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e34:	55                   	push   %ebp
  800e35:	89 e5                	mov    %esp,%ebp
  800e37:	57                   	push   %edi
  800e38:	56                   	push   %esi
  800e39:	53                   	push   %ebx
  800e3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e3d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e42:	8b 55 08             	mov    0x8(%ebp),%edx
  800e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e48:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e4d:	89 df                	mov    %ebx,%edi
  800e4f:	89 de                	mov    %ebx,%esi
  800e51:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e53:	85 c0                	test   %eax,%eax
  800e55:	7f 08                	jg     800e5f <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e57:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5a:	5b                   	pop    %ebx
  800e5b:	5e                   	pop    %esi
  800e5c:	5f                   	pop    %edi
  800e5d:	5d                   	pop    %ebp
  800e5e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e5f:	83 ec 0c             	sub    $0xc,%esp
  800e62:	50                   	push   %eax
  800e63:	6a 0a                	push   $0xa
  800e65:	68 a4 28 80 00       	push   $0x8028a4
  800e6a:	6a 43                	push   $0x43
  800e6c:	68 c1 28 80 00       	push   $0x8028c1
  800e71:	e8 9e 12 00 00       	call   802114 <_panic>

00800e76 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e76:	55                   	push   %ebp
  800e77:	89 e5                	mov    %esp,%ebp
  800e79:	57                   	push   %edi
  800e7a:	56                   	push   %esi
  800e7b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e82:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e87:	be 00 00 00 00       	mov    $0x0,%esi
  800e8c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e8f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e92:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    

00800e99 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	57                   	push   %edi
  800e9d:	56                   	push   %esi
  800e9e:	53                   	push   %ebx
  800e9f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ea2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ea7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaa:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eaf:	89 cb                	mov    %ecx,%ebx
  800eb1:	89 cf                	mov    %ecx,%edi
  800eb3:	89 ce                	mov    %ecx,%esi
  800eb5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	7f 08                	jg     800ec3 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ebb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ebe:	5b                   	pop    %ebx
  800ebf:	5e                   	pop    %esi
  800ec0:	5f                   	pop    %edi
  800ec1:	5d                   	pop    %ebp
  800ec2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	83 ec 0c             	sub    $0xc,%esp
  800ec6:	50                   	push   %eax
  800ec7:	6a 0d                	push   $0xd
  800ec9:	68 a4 28 80 00       	push   $0x8028a4
  800ece:	6a 43                	push   $0x43
  800ed0:	68 c1 28 80 00       	push   $0x8028c1
  800ed5:	e8 3a 12 00 00       	call   802114 <_panic>

00800eda <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eeb:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ef0:	89 df                	mov    %ebx,%edi
  800ef2:	89 de                	mov    %ebx,%esi
  800ef4:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ef6:	5b                   	pop    %ebx
  800ef7:	5e                   	pop    %esi
  800ef8:	5f                   	pop    %edi
  800ef9:	5d                   	pop    %ebp
  800efa:	c3                   	ret    

00800efb <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f06:	8b 55 08             	mov    0x8(%ebp),%edx
  800f09:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f0e:	89 cb                	mov    %ecx,%ebx
  800f10:	89 cf                	mov    %ecx,%edi
  800f12:	89 ce                	mov    %ecx,%esi
  800f14:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f16:	5b                   	pop    %ebx
  800f17:	5e                   	pop    %esi
  800f18:	5f                   	pop    %edi
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	57                   	push   %edi
  800f1f:	56                   	push   %esi
  800f20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f21:	ba 00 00 00 00       	mov    $0x0,%edx
  800f26:	b8 10 00 00 00       	mov    $0x10,%eax
  800f2b:	89 d1                	mov    %edx,%ecx
  800f2d:	89 d3                	mov    %edx,%ebx
  800f2f:	89 d7                	mov    %edx,%edi
  800f31:	89 d6                	mov    %edx,%esi
  800f33:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f3a:	55                   	push   %ebp
  800f3b:	89 e5                	mov    %esp,%ebp
  800f3d:	57                   	push   %edi
  800f3e:	56                   	push   %esi
  800f3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f45:	8b 55 08             	mov    0x8(%ebp),%edx
  800f48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4b:	b8 11 00 00 00       	mov    $0x11,%eax
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f61:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6c:	b8 12 00 00 00       	mov    $0x12,%eax
  800f71:	89 df                	mov    %ebx,%edi
  800f73:	89 de                	mov    %ebx,%esi
  800f75:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f77:	5b                   	pop    %ebx
  800f78:	5e                   	pop    %esi
  800f79:	5f                   	pop    %edi
  800f7a:	5d                   	pop    %ebp
  800f7b:	c3                   	ret    

00800f7c <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f7c:	55                   	push   %ebp
  800f7d:	89 e5                	mov    %esp,%ebp
  800f7f:	57                   	push   %edi
  800f80:	56                   	push   %esi
  800f81:	53                   	push   %ebx
  800f82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f90:	b8 13 00 00 00       	mov    $0x13,%eax
  800f95:	89 df                	mov    %ebx,%edi
  800f97:	89 de                	mov    %ebx,%esi
  800f99:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f9b:	85 c0                	test   %eax,%eax
  800f9d:	7f 08                	jg     800fa7 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fa2:	5b                   	pop    %ebx
  800fa3:	5e                   	pop    %esi
  800fa4:	5f                   	pop    %edi
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa7:	83 ec 0c             	sub    $0xc,%esp
  800faa:	50                   	push   %eax
  800fab:	6a 13                	push   $0x13
  800fad:	68 a4 28 80 00       	push   $0x8028a4
  800fb2:	6a 43                	push   $0x43
  800fb4:	68 c1 28 80 00       	push   $0x8028c1
  800fb9:	e8 56 11 00 00       	call   802114 <_panic>

00800fbe <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc9:	c1 e8 0c             	shr    $0xc,%eax
}
  800fcc:	5d                   	pop    %ebp
  800fcd:	c3                   	ret    

00800fce <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fce:	55                   	push   %ebp
  800fcf:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fde:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fe3:	5d                   	pop    %ebp
  800fe4:	c3                   	ret    

00800fe5 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	c1 ea 16             	shr    $0x16,%edx
  800ff2:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff9:	f6 c2 01             	test   $0x1,%dl
  800ffc:	74 2d                	je     80102b <fd_alloc+0x46>
  800ffe:	89 c2                	mov    %eax,%edx
  801000:	c1 ea 0c             	shr    $0xc,%edx
  801003:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80100a:	f6 c2 01             	test   $0x1,%dl
  80100d:	74 1c                	je     80102b <fd_alloc+0x46>
  80100f:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801014:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801019:	75 d2                	jne    800fed <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80101b:	8b 45 08             	mov    0x8(%ebp),%eax
  80101e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801024:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801029:	eb 0a                	jmp    801035 <fd_alloc+0x50>
			*fd_store = fd;
  80102b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102e:	89 01                	mov    %eax,(%ecx)
			return 0;
  801030:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801035:	5d                   	pop    %ebp
  801036:	c3                   	ret    

00801037 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80103d:	83 f8 1f             	cmp    $0x1f,%eax
  801040:	77 30                	ja     801072 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801042:	c1 e0 0c             	shl    $0xc,%eax
  801045:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80104a:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  801050:	f6 c2 01             	test   $0x1,%dl
  801053:	74 24                	je     801079 <fd_lookup+0x42>
  801055:	89 c2                	mov    %eax,%edx
  801057:	c1 ea 0c             	shr    $0xc,%edx
  80105a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801061:	f6 c2 01             	test   $0x1,%dl
  801064:	74 1a                	je     801080 <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801066:	8b 55 0c             	mov    0xc(%ebp),%edx
  801069:	89 02                	mov    %eax,(%edx)
	return 0;
  80106b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801070:	5d                   	pop    %ebp
  801071:	c3                   	ret    
		return -E_INVAL;
  801072:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801077:	eb f7                	jmp    801070 <fd_lookup+0x39>
		return -E_INVAL;
  801079:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107e:	eb f0                	jmp    801070 <fd_lookup+0x39>
  801080:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801085:	eb e9                	jmp    801070 <fd_lookup+0x39>

00801087 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 08             	sub    $0x8,%esp
  80108d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  801090:	ba 00 00 00 00       	mov    $0x0,%edx
  801095:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80109a:	39 08                	cmp    %ecx,(%eax)
  80109c:	74 38                	je     8010d6 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80109e:	83 c2 01             	add    $0x1,%edx
  8010a1:	8b 04 95 4c 29 80 00 	mov    0x80294c(,%edx,4),%eax
  8010a8:	85 c0                	test   %eax,%eax
  8010aa:	75 ee                	jne    80109a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ac:	a1 08 40 80 00       	mov    0x804008,%eax
  8010b1:	8b 40 48             	mov    0x48(%eax),%eax
  8010b4:	83 ec 04             	sub    $0x4,%esp
  8010b7:	51                   	push   %ecx
  8010b8:	50                   	push   %eax
  8010b9:	68 d0 28 80 00       	push   $0x8028d0
  8010be:	e8 d5 f0 ff ff       	call   800198 <cprintf>
	*dev = 0;
  8010c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010cc:	83 c4 10             	add    $0x10,%esp
  8010cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    
			*dev = devtab[i];
  8010d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010db:	b8 00 00 00 00       	mov    $0x0,%eax
  8010e0:	eb f2                	jmp    8010d4 <dev_lookup+0x4d>

008010e2 <fd_close>:
{
  8010e2:	55                   	push   %ebp
  8010e3:	89 e5                	mov    %esp,%ebp
  8010e5:	57                   	push   %edi
  8010e6:	56                   	push   %esi
  8010e7:	53                   	push   %ebx
  8010e8:	83 ec 24             	sub    $0x24,%esp
  8010eb:	8b 75 08             	mov    0x8(%ebp),%esi
  8010ee:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010f4:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f5:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010fb:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010fe:	50                   	push   %eax
  8010ff:	e8 33 ff ff ff       	call   801037 <fd_lookup>
  801104:	89 c3                	mov    %eax,%ebx
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	85 c0                	test   %eax,%eax
  80110b:	78 05                	js     801112 <fd_close+0x30>
	    || fd != fd2)
  80110d:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  801110:	74 16                	je     801128 <fd_close+0x46>
		return (must_exist ? r : 0);
  801112:	89 f8                	mov    %edi,%eax
  801114:	84 c0                	test   %al,%al
  801116:	b8 00 00 00 00       	mov    $0x0,%eax
  80111b:	0f 44 d8             	cmove  %eax,%ebx
}
  80111e:	89 d8                	mov    %ebx,%eax
  801120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801128:	83 ec 08             	sub    $0x8,%esp
  80112b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80112e:	50                   	push   %eax
  80112f:	ff 36                	pushl  (%esi)
  801131:	e8 51 ff ff ff       	call   801087 <dev_lookup>
  801136:	89 c3                	mov    %eax,%ebx
  801138:	83 c4 10             	add    $0x10,%esp
  80113b:	85 c0                	test   %eax,%eax
  80113d:	78 1a                	js     801159 <fd_close+0x77>
		if (dev->dev_close)
  80113f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801142:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801145:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  80114a:	85 c0                	test   %eax,%eax
  80114c:	74 0b                	je     801159 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80114e:	83 ec 0c             	sub    $0xc,%esp
  801151:	56                   	push   %esi
  801152:	ff d0                	call   *%eax
  801154:	89 c3                	mov    %eax,%ebx
  801156:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801159:	83 ec 08             	sub    $0x8,%esp
  80115c:	56                   	push   %esi
  80115d:	6a 00                	push   $0x0
  80115f:	e8 0a fc ff ff       	call   800d6e <sys_page_unmap>
	return r;
  801164:	83 c4 10             	add    $0x10,%esp
  801167:	eb b5                	jmp    80111e <fd_close+0x3c>

00801169 <close>:

int
close(int fdnum)
{
  801169:	55                   	push   %ebp
  80116a:	89 e5                	mov    %esp,%ebp
  80116c:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80116f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801172:	50                   	push   %eax
  801173:	ff 75 08             	pushl  0x8(%ebp)
  801176:	e8 bc fe ff ff       	call   801037 <fd_lookup>
  80117b:	83 c4 10             	add    $0x10,%esp
  80117e:	85 c0                	test   %eax,%eax
  801180:	79 02                	jns    801184 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801182:	c9                   	leave  
  801183:	c3                   	ret    
		return fd_close(fd, 1);
  801184:	83 ec 08             	sub    $0x8,%esp
  801187:	6a 01                	push   $0x1
  801189:	ff 75 f4             	pushl  -0xc(%ebp)
  80118c:	e8 51 ff ff ff       	call   8010e2 <fd_close>
  801191:	83 c4 10             	add    $0x10,%esp
  801194:	eb ec                	jmp    801182 <close+0x19>

00801196 <close_all>:

void
close_all(void)
{
  801196:	55                   	push   %ebp
  801197:	89 e5                	mov    %esp,%ebp
  801199:	53                   	push   %ebx
  80119a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80119d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	53                   	push   %ebx
  8011a6:	e8 be ff ff ff       	call   801169 <close>
	for (i = 0; i < MAXFD; i++)
  8011ab:	83 c3 01             	add    $0x1,%ebx
  8011ae:	83 c4 10             	add    $0x10,%esp
  8011b1:	83 fb 20             	cmp    $0x20,%ebx
  8011b4:	75 ec                	jne    8011a2 <close_all+0xc>
}
  8011b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b9:	c9                   	leave  
  8011ba:	c3                   	ret    

008011bb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011bb:	55                   	push   %ebp
  8011bc:	89 e5                	mov    %esp,%ebp
  8011be:	57                   	push   %edi
  8011bf:	56                   	push   %esi
  8011c0:	53                   	push   %ebx
  8011c1:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c7:	50                   	push   %eax
  8011c8:	ff 75 08             	pushl  0x8(%ebp)
  8011cb:	e8 67 fe ff ff       	call   801037 <fd_lookup>
  8011d0:	89 c3                	mov    %eax,%ebx
  8011d2:	83 c4 10             	add    $0x10,%esp
  8011d5:	85 c0                	test   %eax,%eax
  8011d7:	0f 88 81 00 00 00    	js     80125e <dup+0xa3>
		return r;
	close(newfdnum);
  8011dd:	83 ec 0c             	sub    $0xc,%esp
  8011e0:	ff 75 0c             	pushl  0xc(%ebp)
  8011e3:	e8 81 ff ff ff       	call   801169 <close>

	newfd = INDEX2FD(newfdnum);
  8011e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011eb:	c1 e6 0c             	shl    $0xc,%esi
  8011ee:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011f4:	83 c4 04             	add    $0x4,%esp
  8011f7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011fa:	e8 cf fd ff ff       	call   800fce <fd2data>
  8011ff:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801201:	89 34 24             	mov    %esi,(%esp)
  801204:	e8 c5 fd ff ff       	call   800fce <fd2data>
  801209:	83 c4 10             	add    $0x10,%esp
  80120c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80120e:	89 d8                	mov    %ebx,%eax
  801210:	c1 e8 16             	shr    $0x16,%eax
  801213:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80121a:	a8 01                	test   $0x1,%al
  80121c:	74 11                	je     80122f <dup+0x74>
  80121e:	89 d8                	mov    %ebx,%eax
  801220:	c1 e8 0c             	shr    $0xc,%eax
  801223:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80122a:	f6 c2 01             	test   $0x1,%dl
  80122d:	75 39                	jne    801268 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80122f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801232:	89 d0                	mov    %edx,%eax
  801234:	c1 e8 0c             	shr    $0xc,%eax
  801237:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80123e:	83 ec 0c             	sub    $0xc,%esp
  801241:	25 07 0e 00 00       	and    $0xe07,%eax
  801246:	50                   	push   %eax
  801247:	56                   	push   %esi
  801248:	6a 00                	push   $0x0
  80124a:	52                   	push   %edx
  80124b:	6a 00                	push   $0x0
  80124d:	e8 da fa ff ff       	call   800d2c <sys_page_map>
  801252:	89 c3                	mov    %eax,%ebx
  801254:	83 c4 20             	add    $0x20,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 31                	js     80128c <dup+0xd1>
		goto err;

	return newfdnum;
  80125b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80125e:	89 d8                	mov    %ebx,%eax
  801260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801263:	5b                   	pop    %ebx
  801264:	5e                   	pop    %esi
  801265:	5f                   	pop    %edi
  801266:	5d                   	pop    %ebp
  801267:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801268:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80126f:	83 ec 0c             	sub    $0xc,%esp
  801272:	25 07 0e 00 00       	and    $0xe07,%eax
  801277:	50                   	push   %eax
  801278:	57                   	push   %edi
  801279:	6a 00                	push   $0x0
  80127b:	53                   	push   %ebx
  80127c:	6a 00                	push   $0x0
  80127e:	e8 a9 fa ff ff       	call   800d2c <sys_page_map>
  801283:	89 c3                	mov    %eax,%ebx
  801285:	83 c4 20             	add    $0x20,%esp
  801288:	85 c0                	test   %eax,%eax
  80128a:	79 a3                	jns    80122f <dup+0x74>
	sys_page_unmap(0, newfd);
  80128c:	83 ec 08             	sub    $0x8,%esp
  80128f:	56                   	push   %esi
  801290:	6a 00                	push   $0x0
  801292:	e8 d7 fa ff ff       	call   800d6e <sys_page_unmap>
	sys_page_unmap(0, nva);
  801297:	83 c4 08             	add    $0x8,%esp
  80129a:	57                   	push   %edi
  80129b:	6a 00                	push   $0x0
  80129d:	e8 cc fa ff ff       	call   800d6e <sys_page_unmap>
	return r;
  8012a2:	83 c4 10             	add    $0x10,%esp
  8012a5:	eb b7                	jmp    80125e <dup+0xa3>

008012a7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 1c             	sub    $0x1c,%esp
  8012ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b4:	50                   	push   %eax
  8012b5:	53                   	push   %ebx
  8012b6:	e8 7c fd ff ff       	call   801037 <fd_lookup>
  8012bb:	83 c4 10             	add    $0x10,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 3f                	js     801301 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c8:	50                   	push   %eax
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cc:	ff 30                	pushl  (%eax)
  8012ce:	e8 b4 fd ff ff       	call   801087 <dev_lookup>
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 27                	js     801301 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012dd:	8b 42 08             	mov    0x8(%edx),%eax
  8012e0:	83 e0 03             	and    $0x3,%eax
  8012e3:	83 f8 01             	cmp    $0x1,%eax
  8012e6:	74 1e                	je     801306 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012eb:	8b 40 08             	mov    0x8(%eax),%eax
  8012ee:	85 c0                	test   %eax,%eax
  8012f0:	74 35                	je     801327 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012f2:	83 ec 04             	sub    $0x4,%esp
  8012f5:	ff 75 10             	pushl  0x10(%ebp)
  8012f8:	ff 75 0c             	pushl  0xc(%ebp)
  8012fb:	52                   	push   %edx
  8012fc:	ff d0                	call   *%eax
  8012fe:	83 c4 10             	add    $0x10,%esp
}
  801301:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801304:	c9                   	leave  
  801305:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801306:	a1 08 40 80 00       	mov    0x804008,%eax
  80130b:	8b 40 48             	mov    0x48(%eax),%eax
  80130e:	83 ec 04             	sub    $0x4,%esp
  801311:	53                   	push   %ebx
  801312:	50                   	push   %eax
  801313:	68 11 29 80 00       	push   $0x802911
  801318:	e8 7b ee ff ff       	call   800198 <cprintf>
		return -E_INVAL;
  80131d:	83 c4 10             	add    $0x10,%esp
  801320:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801325:	eb da                	jmp    801301 <read+0x5a>
		return -E_NOT_SUPP;
  801327:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80132c:	eb d3                	jmp    801301 <read+0x5a>

0080132e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80132e:	55                   	push   %ebp
  80132f:	89 e5                	mov    %esp,%ebp
  801331:	57                   	push   %edi
  801332:	56                   	push   %esi
  801333:	53                   	push   %ebx
  801334:	83 ec 0c             	sub    $0xc,%esp
  801337:	8b 7d 08             	mov    0x8(%ebp),%edi
  80133a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80133d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801342:	39 f3                	cmp    %esi,%ebx
  801344:	73 23                	jae    801369 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801346:	83 ec 04             	sub    $0x4,%esp
  801349:	89 f0                	mov    %esi,%eax
  80134b:	29 d8                	sub    %ebx,%eax
  80134d:	50                   	push   %eax
  80134e:	89 d8                	mov    %ebx,%eax
  801350:	03 45 0c             	add    0xc(%ebp),%eax
  801353:	50                   	push   %eax
  801354:	57                   	push   %edi
  801355:	e8 4d ff ff ff       	call   8012a7 <read>
		if (m < 0)
  80135a:	83 c4 10             	add    $0x10,%esp
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 06                	js     801367 <readn+0x39>
			return m;
		if (m == 0)
  801361:	74 06                	je     801369 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801363:	01 c3                	add    %eax,%ebx
  801365:	eb db                	jmp    801342 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801367:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801369:	89 d8                	mov    %ebx,%eax
  80136b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136e:	5b                   	pop    %ebx
  80136f:	5e                   	pop    %esi
  801370:	5f                   	pop    %edi
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    

00801373 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	53                   	push   %ebx
  801377:	83 ec 1c             	sub    $0x1c,%esp
  80137a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801380:	50                   	push   %eax
  801381:	53                   	push   %ebx
  801382:	e8 b0 fc ff ff       	call   801037 <fd_lookup>
  801387:	83 c4 10             	add    $0x10,%esp
  80138a:	85 c0                	test   %eax,%eax
  80138c:	78 3a                	js     8013c8 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801394:	50                   	push   %eax
  801395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801398:	ff 30                	pushl  (%eax)
  80139a:	e8 e8 fc ff ff       	call   801087 <dev_lookup>
  80139f:	83 c4 10             	add    $0x10,%esp
  8013a2:	85 c0                	test   %eax,%eax
  8013a4:	78 22                	js     8013c8 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ad:	74 1e                	je     8013cd <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b2:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b5:	85 d2                	test   %edx,%edx
  8013b7:	74 35                	je     8013ee <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	ff 75 10             	pushl  0x10(%ebp)
  8013bf:	ff 75 0c             	pushl  0xc(%ebp)
  8013c2:	50                   	push   %eax
  8013c3:	ff d2                	call   *%edx
  8013c5:	83 c4 10             	add    $0x10,%esp
}
  8013c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013cb:	c9                   	leave  
  8013cc:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cd:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d2:	8b 40 48             	mov    0x48(%eax),%eax
  8013d5:	83 ec 04             	sub    $0x4,%esp
  8013d8:	53                   	push   %ebx
  8013d9:	50                   	push   %eax
  8013da:	68 2d 29 80 00       	push   $0x80292d
  8013df:	e8 b4 ed ff ff       	call   800198 <cprintf>
		return -E_INVAL;
  8013e4:	83 c4 10             	add    $0x10,%esp
  8013e7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013ec:	eb da                	jmp    8013c8 <write+0x55>
		return -E_NOT_SUPP;
  8013ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f3:	eb d3                	jmp    8013c8 <write+0x55>

008013f5 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f5:	55                   	push   %ebp
  8013f6:	89 e5                	mov    %esp,%ebp
  8013f8:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fe:	50                   	push   %eax
  8013ff:	ff 75 08             	pushl  0x8(%ebp)
  801402:	e8 30 fc ff ff       	call   801037 <fd_lookup>
  801407:	83 c4 10             	add    $0x10,%esp
  80140a:	85 c0                	test   %eax,%eax
  80140c:	78 0e                	js     80141c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80140e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801414:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801417:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141c:	c9                   	leave  
  80141d:	c3                   	ret    

0080141e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80141e:	55                   	push   %ebp
  80141f:	89 e5                	mov    %esp,%ebp
  801421:	53                   	push   %ebx
  801422:	83 ec 1c             	sub    $0x1c,%esp
  801425:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801428:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142b:	50                   	push   %eax
  80142c:	53                   	push   %ebx
  80142d:	e8 05 fc ff ff       	call   801037 <fd_lookup>
  801432:	83 c4 10             	add    $0x10,%esp
  801435:	85 c0                	test   %eax,%eax
  801437:	78 37                	js     801470 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801439:	83 ec 08             	sub    $0x8,%esp
  80143c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143f:	50                   	push   %eax
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	ff 30                	pushl  (%eax)
  801445:	e8 3d fc ff ff       	call   801087 <dev_lookup>
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	85 c0                	test   %eax,%eax
  80144f:	78 1f                	js     801470 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801454:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801458:	74 1b                	je     801475 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80145a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145d:	8b 52 18             	mov    0x18(%edx),%edx
  801460:	85 d2                	test   %edx,%edx
  801462:	74 32                	je     801496 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801464:	83 ec 08             	sub    $0x8,%esp
  801467:	ff 75 0c             	pushl  0xc(%ebp)
  80146a:	50                   	push   %eax
  80146b:	ff d2                	call   *%edx
  80146d:	83 c4 10             	add    $0x10,%esp
}
  801470:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801473:	c9                   	leave  
  801474:	c3                   	ret    
			thisenv->env_id, fdnum);
  801475:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80147a:	8b 40 48             	mov    0x48(%eax),%eax
  80147d:	83 ec 04             	sub    $0x4,%esp
  801480:	53                   	push   %ebx
  801481:	50                   	push   %eax
  801482:	68 f0 28 80 00       	push   $0x8028f0
  801487:	e8 0c ed ff ff       	call   800198 <cprintf>
		return -E_INVAL;
  80148c:	83 c4 10             	add    $0x10,%esp
  80148f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801494:	eb da                	jmp    801470 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801496:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149b:	eb d3                	jmp    801470 <ftruncate+0x52>

0080149d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80149d:	55                   	push   %ebp
  80149e:	89 e5                	mov    %esp,%ebp
  8014a0:	53                   	push   %ebx
  8014a1:	83 ec 1c             	sub    $0x1c,%esp
  8014a4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014aa:	50                   	push   %eax
  8014ab:	ff 75 08             	pushl  0x8(%ebp)
  8014ae:	e8 84 fb ff ff       	call   801037 <fd_lookup>
  8014b3:	83 c4 10             	add    $0x10,%esp
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 4b                	js     801505 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ba:	83 ec 08             	sub    $0x8,%esp
  8014bd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c0:	50                   	push   %eax
  8014c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c4:	ff 30                	pushl  (%eax)
  8014c6:	e8 bc fb ff ff       	call   801087 <dev_lookup>
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	78 33                	js     801505 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d5:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d9:	74 2f                	je     80150a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014db:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014de:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014e5:	00 00 00 
	stat->st_isdir = 0;
  8014e8:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014ef:	00 00 00 
	stat->st_dev = dev;
  8014f2:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014f8:	83 ec 08             	sub    $0x8,%esp
  8014fb:	53                   	push   %ebx
  8014fc:	ff 75 f0             	pushl  -0x10(%ebp)
  8014ff:	ff 50 14             	call   *0x14(%eax)
  801502:	83 c4 10             	add    $0x10,%esp
}
  801505:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801508:	c9                   	leave  
  801509:	c3                   	ret    
		return -E_NOT_SUPP;
  80150a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150f:	eb f4                	jmp    801505 <fstat+0x68>

00801511 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801511:	55                   	push   %ebp
  801512:	89 e5                	mov    %esp,%ebp
  801514:	56                   	push   %esi
  801515:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801516:	83 ec 08             	sub    $0x8,%esp
  801519:	6a 00                	push   $0x0
  80151b:	ff 75 08             	pushl  0x8(%ebp)
  80151e:	e8 22 02 00 00       	call   801745 <open>
  801523:	89 c3                	mov    %eax,%ebx
  801525:	83 c4 10             	add    $0x10,%esp
  801528:	85 c0                	test   %eax,%eax
  80152a:	78 1b                	js     801547 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80152c:	83 ec 08             	sub    $0x8,%esp
  80152f:	ff 75 0c             	pushl  0xc(%ebp)
  801532:	50                   	push   %eax
  801533:	e8 65 ff ff ff       	call   80149d <fstat>
  801538:	89 c6                	mov    %eax,%esi
	close(fd);
  80153a:	89 1c 24             	mov    %ebx,(%esp)
  80153d:	e8 27 fc ff ff       	call   801169 <close>
	return r;
  801542:	83 c4 10             	add    $0x10,%esp
  801545:	89 f3                	mov    %esi,%ebx
}
  801547:	89 d8                	mov    %ebx,%eax
  801549:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5d                   	pop    %ebp
  80154f:	c3                   	ret    

00801550 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801550:	55                   	push   %ebp
  801551:	89 e5                	mov    %esp,%ebp
  801553:	56                   	push   %esi
  801554:	53                   	push   %ebx
  801555:	89 c6                	mov    %eax,%esi
  801557:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801559:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801560:	74 27                	je     801589 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801562:	6a 07                	push   $0x7
  801564:	68 00 50 80 00       	push   $0x805000
  801569:	56                   	push   %esi
  80156a:	ff 35 00 40 80 00    	pushl  0x804000
  801570:	e8 69 0c 00 00       	call   8021de <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801575:	83 c4 0c             	add    $0xc,%esp
  801578:	6a 00                	push   $0x0
  80157a:	53                   	push   %ebx
  80157b:	6a 00                	push   $0x0
  80157d:	e8 f3 0b 00 00       	call   802175 <ipc_recv>
}
  801582:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801585:	5b                   	pop    %ebx
  801586:	5e                   	pop    %esi
  801587:	5d                   	pop    %ebp
  801588:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801589:	83 ec 0c             	sub    $0xc,%esp
  80158c:	6a 01                	push   $0x1
  80158e:	e8 a3 0c 00 00       	call   802236 <ipc_find_env>
  801593:	a3 00 40 80 00       	mov    %eax,0x804000
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	eb c5                	jmp    801562 <fsipc+0x12>

0080159d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80159d:	55                   	push   %ebp
  80159e:	89 e5                	mov    %esp,%ebp
  8015a0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bb:	b8 02 00 00 00       	mov    $0x2,%eax
  8015c0:	e8 8b ff ff ff       	call   801550 <fsipc>
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <devfile_flush>:
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d3:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8015dd:	b8 06 00 00 00       	mov    $0x6,%eax
  8015e2:	e8 69 ff ff ff       	call   801550 <fsipc>
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <devfile_stat>:
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	53                   	push   %ebx
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f6:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f9:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015fe:	ba 00 00 00 00       	mov    $0x0,%edx
  801603:	b8 05 00 00 00       	mov    $0x5,%eax
  801608:	e8 43 ff ff ff       	call   801550 <fsipc>
  80160d:	85 c0                	test   %eax,%eax
  80160f:	78 2c                	js     80163d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801611:	83 ec 08             	sub    $0x8,%esp
  801614:	68 00 50 80 00       	push   $0x805000
  801619:	53                   	push   %ebx
  80161a:	e8 d8 f2 ff ff       	call   8008f7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80161f:	a1 80 50 80 00       	mov    0x805080,%eax
  801624:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  80162a:	a1 84 50 80 00       	mov    0x805084,%eax
  80162f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801635:	83 c4 10             	add    $0x10,%esp
  801638:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801640:	c9                   	leave  
  801641:	c3                   	ret    

00801642 <devfile_write>:
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	53                   	push   %ebx
  801646:	83 ec 08             	sub    $0x8,%esp
  801649:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80164c:	8b 45 08             	mov    0x8(%ebp),%eax
  80164f:	8b 40 0c             	mov    0xc(%eax),%eax
  801652:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801657:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80165d:	53                   	push   %ebx
  80165e:	ff 75 0c             	pushl  0xc(%ebp)
  801661:	68 08 50 80 00       	push   $0x805008
  801666:	e8 7c f4 ff ff       	call   800ae7 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80166b:	ba 00 00 00 00       	mov    $0x0,%edx
  801670:	b8 04 00 00 00       	mov    $0x4,%eax
  801675:	e8 d6 fe ff ff       	call   801550 <fsipc>
  80167a:	83 c4 10             	add    $0x10,%esp
  80167d:	85 c0                	test   %eax,%eax
  80167f:	78 0b                	js     80168c <devfile_write+0x4a>
	assert(r <= n);
  801681:	39 d8                	cmp    %ebx,%eax
  801683:	77 0c                	ja     801691 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801685:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80168a:	7f 1e                	jg     8016aa <devfile_write+0x68>
}
  80168c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168f:	c9                   	leave  
  801690:	c3                   	ret    
	assert(r <= n);
  801691:	68 60 29 80 00       	push   $0x802960
  801696:	68 67 29 80 00       	push   $0x802967
  80169b:	68 98 00 00 00       	push   $0x98
  8016a0:	68 7c 29 80 00       	push   $0x80297c
  8016a5:	e8 6a 0a 00 00       	call   802114 <_panic>
	assert(r <= PGSIZE);
  8016aa:	68 87 29 80 00       	push   $0x802987
  8016af:	68 67 29 80 00       	push   $0x802967
  8016b4:	68 99 00 00 00       	push   $0x99
  8016b9:	68 7c 29 80 00       	push   $0x80297c
  8016be:	e8 51 0a 00 00       	call   802114 <_panic>

008016c3 <devfile_read>:
{
  8016c3:	55                   	push   %ebp
  8016c4:	89 e5                	mov    %esp,%ebp
  8016c6:	56                   	push   %esi
  8016c7:	53                   	push   %ebx
  8016c8:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016d6:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8016e6:	e8 65 fe ff ff       	call   801550 <fsipc>
  8016eb:	89 c3                	mov    %eax,%ebx
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	78 1f                	js     801710 <devfile_read+0x4d>
	assert(r <= n);
  8016f1:	39 f0                	cmp    %esi,%eax
  8016f3:	77 24                	ja     801719 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016fa:	7f 33                	jg     80172f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016fc:	83 ec 04             	sub    $0x4,%esp
  8016ff:	50                   	push   %eax
  801700:	68 00 50 80 00       	push   $0x805000
  801705:	ff 75 0c             	pushl  0xc(%ebp)
  801708:	e8 78 f3 ff ff       	call   800a85 <memmove>
	return r;
  80170d:	83 c4 10             	add    $0x10,%esp
}
  801710:	89 d8                	mov    %ebx,%eax
  801712:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801715:	5b                   	pop    %ebx
  801716:	5e                   	pop    %esi
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    
	assert(r <= n);
  801719:	68 60 29 80 00       	push   $0x802960
  80171e:	68 67 29 80 00       	push   $0x802967
  801723:	6a 7c                	push   $0x7c
  801725:	68 7c 29 80 00       	push   $0x80297c
  80172a:	e8 e5 09 00 00       	call   802114 <_panic>
	assert(r <= PGSIZE);
  80172f:	68 87 29 80 00       	push   $0x802987
  801734:	68 67 29 80 00       	push   $0x802967
  801739:	6a 7d                	push   $0x7d
  80173b:	68 7c 29 80 00       	push   $0x80297c
  801740:	e8 cf 09 00 00       	call   802114 <_panic>

00801745 <open>:
{
  801745:	55                   	push   %ebp
  801746:	89 e5                	mov    %esp,%ebp
  801748:	56                   	push   %esi
  801749:	53                   	push   %ebx
  80174a:	83 ec 1c             	sub    $0x1c,%esp
  80174d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801750:	56                   	push   %esi
  801751:	e8 68 f1 ff ff       	call   8008be <strlen>
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80175e:	7f 6c                	jg     8017cc <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801760:	83 ec 0c             	sub    $0xc,%esp
  801763:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801766:	50                   	push   %eax
  801767:	e8 79 f8 ff ff       	call   800fe5 <fd_alloc>
  80176c:	89 c3                	mov    %eax,%ebx
  80176e:	83 c4 10             	add    $0x10,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	78 3c                	js     8017b1 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	56                   	push   %esi
  801779:	68 00 50 80 00       	push   $0x805000
  80177e:	e8 74 f1 ff ff       	call   8008f7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801783:	8b 45 0c             	mov    0xc(%ebp),%eax
  801786:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80178b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178e:	b8 01 00 00 00       	mov    $0x1,%eax
  801793:	e8 b8 fd ff ff       	call   801550 <fsipc>
  801798:	89 c3                	mov    %eax,%ebx
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 19                	js     8017ba <open+0x75>
	return fd2num(fd);
  8017a1:	83 ec 0c             	sub    $0xc,%esp
  8017a4:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a7:	e8 12 f8 ff ff       	call   800fbe <fd2num>
  8017ac:	89 c3                	mov    %eax,%ebx
  8017ae:	83 c4 10             	add    $0x10,%esp
}
  8017b1:	89 d8                	mov    %ebx,%eax
  8017b3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    
		fd_close(fd, 0);
  8017ba:	83 ec 08             	sub    $0x8,%esp
  8017bd:	6a 00                	push   $0x0
  8017bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c2:	e8 1b f9 ff ff       	call   8010e2 <fd_close>
		return r;
  8017c7:	83 c4 10             	add    $0x10,%esp
  8017ca:	eb e5                	jmp    8017b1 <open+0x6c>
		return -E_BAD_PATH;
  8017cc:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017d1:	eb de                	jmp    8017b1 <open+0x6c>

008017d3 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017de:	b8 08 00 00 00       	mov    $0x8,%eax
  8017e3:	e8 68 fd ff ff       	call   801550 <fsipc>
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
  8017ed:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017f0:	68 93 29 80 00       	push   $0x802993
  8017f5:	ff 75 0c             	pushl  0xc(%ebp)
  8017f8:	e8 fa f0 ff ff       	call   8008f7 <strcpy>
	return 0;
}
  8017fd:	b8 00 00 00 00       	mov    $0x0,%eax
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <devsock_close>:
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
  801807:	53                   	push   %ebx
  801808:	83 ec 10             	sub    $0x10,%esp
  80180b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80180e:	53                   	push   %ebx
  80180f:	e8 5d 0a 00 00       	call   802271 <pageref>
  801814:	83 c4 10             	add    $0x10,%esp
		return 0;
  801817:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80181c:	83 f8 01             	cmp    $0x1,%eax
  80181f:	74 07                	je     801828 <devsock_close+0x24>
}
  801821:	89 d0                	mov    %edx,%eax
  801823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801826:	c9                   	leave  
  801827:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	ff 73 0c             	pushl  0xc(%ebx)
  80182e:	e8 b9 02 00 00       	call   801aec <nsipc_close>
  801833:	89 c2                	mov    %eax,%edx
  801835:	83 c4 10             	add    $0x10,%esp
  801838:	eb e7                	jmp    801821 <devsock_close+0x1d>

0080183a <devsock_write>:
{
  80183a:	55                   	push   %ebp
  80183b:	89 e5                	mov    %esp,%ebp
  80183d:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801840:	6a 00                	push   $0x0
  801842:	ff 75 10             	pushl  0x10(%ebp)
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	8b 45 08             	mov    0x8(%ebp),%eax
  80184b:	ff 70 0c             	pushl  0xc(%eax)
  80184e:	e8 76 03 00 00       	call   801bc9 <nsipc_send>
}
  801853:	c9                   	leave  
  801854:	c3                   	ret    

00801855 <devsock_read>:
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80185b:	6a 00                	push   $0x0
  80185d:	ff 75 10             	pushl  0x10(%ebp)
  801860:	ff 75 0c             	pushl  0xc(%ebp)
  801863:	8b 45 08             	mov    0x8(%ebp),%eax
  801866:	ff 70 0c             	pushl  0xc(%eax)
  801869:	e8 ef 02 00 00       	call   801b5d <nsipc_recv>
}
  80186e:	c9                   	leave  
  80186f:	c3                   	ret    

00801870 <fd2sockid>:
{
  801870:	55                   	push   %ebp
  801871:	89 e5                	mov    %esp,%ebp
  801873:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801876:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801879:	52                   	push   %edx
  80187a:	50                   	push   %eax
  80187b:	e8 b7 f7 ff ff       	call   801037 <fd_lookup>
  801880:	83 c4 10             	add    $0x10,%esp
  801883:	85 c0                	test   %eax,%eax
  801885:	78 10                	js     801897 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80188a:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  801890:	39 08                	cmp    %ecx,(%eax)
  801892:	75 05                	jne    801899 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801894:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801897:	c9                   	leave  
  801898:	c3                   	ret    
		return -E_NOT_SUPP;
  801899:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189e:	eb f7                	jmp    801897 <fd2sockid+0x27>

008018a0 <alloc_sockfd>:
{
  8018a0:	55                   	push   %ebp
  8018a1:	89 e5                	mov    %esp,%ebp
  8018a3:	56                   	push   %esi
  8018a4:	53                   	push   %ebx
  8018a5:	83 ec 1c             	sub    $0x1c,%esp
  8018a8:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ad:	50                   	push   %eax
  8018ae:	e8 32 f7 ff ff       	call   800fe5 <fd_alloc>
  8018b3:	89 c3                	mov    %eax,%ebx
  8018b5:	83 c4 10             	add    $0x10,%esp
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	78 43                	js     8018ff <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	68 07 04 00 00       	push   $0x407
  8018c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c7:	6a 00                	push   $0x0
  8018c9:	e8 1b f4 ff ff       	call   800ce9 <sys_page_alloc>
  8018ce:	89 c3                	mov    %eax,%ebx
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	78 28                	js     8018ff <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018da:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018e0:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e5:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018ec:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018ef:	83 ec 0c             	sub    $0xc,%esp
  8018f2:	50                   	push   %eax
  8018f3:	e8 c6 f6 ff ff       	call   800fbe <fd2num>
  8018f8:	89 c3                	mov    %eax,%ebx
  8018fa:	83 c4 10             	add    $0x10,%esp
  8018fd:	eb 0c                	jmp    80190b <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018ff:	83 ec 0c             	sub    $0xc,%esp
  801902:	56                   	push   %esi
  801903:	e8 e4 01 00 00       	call   801aec <nsipc_close>
		return r;
  801908:	83 c4 10             	add    $0x10,%esp
}
  80190b:	89 d8                	mov    %ebx,%eax
  80190d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <accept>:
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
  801917:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	e8 4e ff ff ff       	call   801870 <fd2sockid>
  801922:	85 c0                	test   %eax,%eax
  801924:	78 1b                	js     801941 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801926:	83 ec 04             	sub    $0x4,%esp
  801929:	ff 75 10             	pushl  0x10(%ebp)
  80192c:	ff 75 0c             	pushl  0xc(%ebp)
  80192f:	50                   	push   %eax
  801930:	e8 0e 01 00 00       	call   801a43 <nsipc_accept>
  801935:	83 c4 10             	add    $0x10,%esp
  801938:	85 c0                	test   %eax,%eax
  80193a:	78 05                	js     801941 <accept+0x2d>
	return alloc_sockfd(r);
  80193c:	e8 5f ff ff ff       	call   8018a0 <alloc_sockfd>
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <bind>:
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	e8 1f ff ff ff       	call   801870 <fd2sockid>
  801951:	85 c0                	test   %eax,%eax
  801953:	78 12                	js     801967 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801955:	83 ec 04             	sub    $0x4,%esp
  801958:	ff 75 10             	pushl  0x10(%ebp)
  80195b:	ff 75 0c             	pushl  0xc(%ebp)
  80195e:	50                   	push   %eax
  80195f:	e8 31 01 00 00       	call   801a95 <nsipc_bind>
  801964:	83 c4 10             	add    $0x10,%esp
}
  801967:	c9                   	leave  
  801968:	c3                   	ret    

00801969 <shutdown>:
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80196f:	8b 45 08             	mov    0x8(%ebp),%eax
  801972:	e8 f9 fe ff ff       	call   801870 <fd2sockid>
  801977:	85 c0                	test   %eax,%eax
  801979:	78 0f                	js     80198a <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80197b:	83 ec 08             	sub    $0x8,%esp
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	50                   	push   %eax
  801982:	e8 43 01 00 00       	call   801aca <nsipc_shutdown>
  801987:	83 c4 10             	add    $0x10,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <connect>:
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
  80198f:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801992:	8b 45 08             	mov    0x8(%ebp),%eax
  801995:	e8 d6 fe ff ff       	call   801870 <fd2sockid>
  80199a:	85 c0                	test   %eax,%eax
  80199c:	78 12                	js     8019b0 <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80199e:	83 ec 04             	sub    $0x4,%esp
  8019a1:	ff 75 10             	pushl  0x10(%ebp)
  8019a4:	ff 75 0c             	pushl  0xc(%ebp)
  8019a7:	50                   	push   %eax
  8019a8:	e8 59 01 00 00       	call   801b06 <nsipc_connect>
  8019ad:	83 c4 10             	add    $0x10,%esp
}
  8019b0:	c9                   	leave  
  8019b1:	c3                   	ret    

008019b2 <listen>:
{
  8019b2:	55                   	push   %ebp
  8019b3:	89 e5                	mov    %esp,%ebp
  8019b5:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bb:	e8 b0 fe ff ff       	call   801870 <fd2sockid>
  8019c0:	85 c0                	test   %eax,%eax
  8019c2:	78 0f                	js     8019d3 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019c4:	83 ec 08             	sub    $0x8,%esp
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	50                   	push   %eax
  8019cb:	e8 6b 01 00 00       	call   801b3b <nsipc_listen>
  8019d0:	83 c4 10             	add    $0x10,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019db:	ff 75 10             	pushl  0x10(%ebp)
  8019de:	ff 75 0c             	pushl  0xc(%ebp)
  8019e1:	ff 75 08             	pushl  0x8(%ebp)
  8019e4:	e8 3e 02 00 00       	call   801c27 <nsipc_socket>
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	78 05                	js     8019f5 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019f0:	e8 ab fe ff ff       	call   8018a0 <alloc_sockfd>
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	53                   	push   %ebx
  8019fb:	83 ec 04             	sub    $0x4,%esp
  8019fe:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  801a00:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a07:	74 26                	je     801a2f <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a09:	6a 07                	push   $0x7
  801a0b:	68 00 60 80 00       	push   $0x806000
  801a10:	53                   	push   %ebx
  801a11:	ff 35 04 40 80 00    	pushl  0x804004
  801a17:	e8 c2 07 00 00       	call   8021de <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a1c:	83 c4 0c             	add    $0xc,%esp
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	6a 00                	push   $0x0
  801a25:	e8 4b 07 00 00       	call   802175 <ipc_recv>
}
  801a2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a2f:	83 ec 0c             	sub    $0xc,%esp
  801a32:	6a 02                	push   $0x2
  801a34:	e8 fd 07 00 00       	call   802236 <ipc_find_env>
  801a39:	a3 04 40 80 00       	mov    %eax,0x804004
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	eb c6                	jmp    801a09 <nsipc+0x12>

00801a43 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	56                   	push   %esi
  801a47:	53                   	push   %ebx
  801a48:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a53:	8b 06                	mov    (%esi),%eax
  801a55:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a5a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5f:	e8 93 ff ff ff       	call   8019f7 <nsipc>
  801a64:	89 c3                	mov    %eax,%ebx
  801a66:	85 c0                	test   %eax,%eax
  801a68:	79 09                	jns    801a73 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a6a:	89 d8                	mov    %ebx,%eax
  801a6c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6f:	5b                   	pop    %ebx
  801a70:	5e                   	pop    %esi
  801a71:	5d                   	pop    %ebp
  801a72:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a73:	83 ec 04             	sub    $0x4,%esp
  801a76:	ff 35 10 60 80 00    	pushl  0x806010
  801a7c:	68 00 60 80 00       	push   $0x806000
  801a81:	ff 75 0c             	pushl  0xc(%ebp)
  801a84:	e8 fc ef ff ff       	call   800a85 <memmove>
		*addrlen = ret->ret_addrlen;
  801a89:	a1 10 60 80 00       	mov    0x806010,%eax
  801a8e:	89 06                	mov    %eax,(%esi)
  801a90:	83 c4 10             	add    $0x10,%esp
	return r;
  801a93:	eb d5                	jmp    801a6a <nsipc_accept+0x27>

00801a95 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa2:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aa7:	53                   	push   %ebx
  801aa8:	ff 75 0c             	pushl  0xc(%ebp)
  801aab:	68 04 60 80 00       	push   $0x806004
  801ab0:	e8 d0 ef ff ff       	call   800a85 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ab5:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801abb:	b8 02 00 00 00       	mov    $0x2,%eax
  801ac0:	e8 32 ff ff ff       	call   8019f7 <nsipc>
}
  801ac5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad3:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ad8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adb:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801ae0:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae5:	e8 0d ff ff ff       	call   8019f7 <nsipc>
}
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <nsipc_close>:

int
nsipc_close(int s)
{
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801af2:	8b 45 08             	mov    0x8(%ebp),%eax
  801af5:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801afa:	b8 04 00 00 00       	mov    $0x4,%eax
  801aff:	e8 f3 fe ff ff       	call   8019f7 <nsipc>
}
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
  801b09:	53                   	push   %ebx
  801b0a:	83 ec 08             	sub    $0x8,%esp
  801b0d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b18:	53                   	push   %ebx
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	68 04 60 80 00       	push   $0x806004
  801b21:	e8 5f ef ff ff       	call   800a85 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b26:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b2c:	b8 05 00 00 00       	mov    $0x5,%eax
  801b31:	e8 c1 fe ff ff       	call   8019f7 <nsipc>
}
  801b36:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b49:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4c:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b51:	b8 06 00 00 00       	mov    $0x6,%eax
  801b56:	e8 9c fe ff ff       	call   8019f7 <nsipc>
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
  801b60:	56                   	push   %esi
  801b61:	53                   	push   %ebx
  801b62:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b6d:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b73:	8b 45 14             	mov    0x14(%ebp),%eax
  801b76:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b7b:	b8 07 00 00 00       	mov    $0x7,%eax
  801b80:	e8 72 fe ff ff       	call   8019f7 <nsipc>
  801b85:	89 c3                	mov    %eax,%ebx
  801b87:	85 c0                	test   %eax,%eax
  801b89:	78 1f                	js     801baa <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b8b:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b90:	7f 21                	jg     801bb3 <nsipc_recv+0x56>
  801b92:	39 c6                	cmp    %eax,%esi
  801b94:	7c 1d                	jl     801bb3 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b96:	83 ec 04             	sub    $0x4,%esp
  801b99:	50                   	push   %eax
  801b9a:	68 00 60 80 00       	push   $0x806000
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	e8 de ee ff ff       	call   800a85 <memmove>
  801ba7:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801baa:	89 d8                	mov    %ebx,%eax
  801bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bb3:	68 9f 29 80 00       	push   $0x80299f
  801bb8:	68 67 29 80 00       	push   $0x802967
  801bbd:	6a 62                	push   $0x62
  801bbf:	68 b4 29 80 00       	push   $0x8029b4
  801bc4:	e8 4b 05 00 00       	call   802114 <_panic>

00801bc9 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	53                   	push   %ebx
  801bcd:	83 ec 04             	sub    $0x4,%esp
  801bd0:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd6:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bdb:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801be1:	7f 2e                	jg     801c11 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801be3:	83 ec 04             	sub    $0x4,%esp
  801be6:	53                   	push   %ebx
  801be7:	ff 75 0c             	pushl  0xc(%ebp)
  801bea:	68 0c 60 80 00       	push   $0x80600c
  801bef:	e8 91 ee ff ff       	call   800a85 <memmove>
	nsipcbuf.send.req_size = size;
  801bf4:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfd:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c02:	b8 08 00 00 00       	mov    $0x8,%eax
  801c07:	e8 eb fd ff ff       	call   8019f7 <nsipc>
}
  801c0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    
	assert(size < 1600);
  801c11:	68 c0 29 80 00       	push   $0x8029c0
  801c16:	68 67 29 80 00       	push   $0x802967
  801c1b:	6a 6d                	push   $0x6d
  801c1d:	68 b4 29 80 00       	push   $0x8029b4
  801c22:	e8 ed 04 00 00       	call   802114 <_panic>

00801c27 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c27:	55                   	push   %ebp
  801c28:	89 e5                	mov    %esp,%ebp
  801c2a:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c38:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c3d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c40:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c45:	b8 09 00 00 00       	mov    $0x9,%eax
  801c4a:	e8 a8 fd ff ff       	call   8019f7 <nsipc>
}
  801c4f:	c9                   	leave  
  801c50:	c3                   	ret    

00801c51 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	56                   	push   %esi
  801c55:	53                   	push   %ebx
  801c56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c59:	83 ec 0c             	sub    $0xc,%esp
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 6a f3 ff ff       	call   800fce <fd2data>
  801c64:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c66:	83 c4 08             	add    $0x8,%esp
  801c69:	68 cc 29 80 00       	push   $0x8029cc
  801c6e:	53                   	push   %ebx
  801c6f:	e8 83 ec ff ff       	call   8008f7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c74:	8b 46 04             	mov    0x4(%esi),%eax
  801c77:	2b 06                	sub    (%esi),%eax
  801c79:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c7f:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c86:	00 00 00 
	stat->st_dev = &devpipe;
  801c89:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c90:	30 80 00 
	return 0;
}
  801c93:	b8 00 00 00 00       	mov    $0x0,%eax
  801c98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9b:	5b                   	pop    %ebx
  801c9c:	5e                   	pop    %esi
  801c9d:	5d                   	pop    %ebp
  801c9e:	c3                   	ret    

00801c9f <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	53                   	push   %ebx
  801ca3:	83 ec 0c             	sub    $0xc,%esp
  801ca6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca9:	53                   	push   %ebx
  801caa:	6a 00                	push   $0x0
  801cac:	e8 bd f0 ff ff       	call   800d6e <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb1:	89 1c 24             	mov    %ebx,(%esp)
  801cb4:	e8 15 f3 ff ff       	call   800fce <fd2data>
  801cb9:	83 c4 08             	add    $0x8,%esp
  801cbc:	50                   	push   %eax
  801cbd:	6a 00                	push   $0x0
  801cbf:	e8 aa f0 ff ff       	call   800d6e <sys_page_unmap>
}
  801cc4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <_pipeisclosed>:
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	57                   	push   %edi
  801ccd:	56                   	push   %esi
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 1c             	sub    $0x1c,%esp
  801cd2:	89 c7                	mov    %eax,%edi
  801cd4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cd6:	a1 08 40 80 00       	mov    0x804008,%eax
  801cdb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cde:	83 ec 0c             	sub    $0xc,%esp
  801ce1:	57                   	push   %edi
  801ce2:	e8 8a 05 00 00       	call   802271 <pageref>
  801ce7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cea:	89 34 24             	mov    %esi,(%esp)
  801ced:	e8 7f 05 00 00       	call   802271 <pageref>
		nn = thisenv->env_runs;
  801cf2:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cf8:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cfb:	83 c4 10             	add    $0x10,%esp
  801cfe:	39 cb                	cmp    %ecx,%ebx
  801d00:	74 1b                	je     801d1d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d02:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d05:	75 cf                	jne    801cd6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d07:	8b 42 58             	mov    0x58(%edx),%eax
  801d0a:	6a 01                	push   $0x1
  801d0c:	50                   	push   %eax
  801d0d:	53                   	push   %ebx
  801d0e:	68 d3 29 80 00       	push   $0x8029d3
  801d13:	e8 80 e4 ff ff       	call   800198 <cprintf>
  801d18:	83 c4 10             	add    $0x10,%esp
  801d1b:	eb b9                	jmp    801cd6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d1d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d20:	0f 94 c0             	sete   %al
  801d23:	0f b6 c0             	movzbl %al,%eax
}
  801d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d29:	5b                   	pop    %ebx
  801d2a:	5e                   	pop    %esi
  801d2b:	5f                   	pop    %edi
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    

00801d2e <devpipe_write>:
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
  801d31:	57                   	push   %edi
  801d32:	56                   	push   %esi
  801d33:	53                   	push   %ebx
  801d34:	83 ec 28             	sub    $0x28,%esp
  801d37:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d3a:	56                   	push   %esi
  801d3b:	e8 8e f2 ff ff       	call   800fce <fd2data>
  801d40:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d42:	83 c4 10             	add    $0x10,%esp
  801d45:	bf 00 00 00 00       	mov    $0x0,%edi
  801d4a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d4d:	74 4f                	je     801d9e <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d4f:	8b 43 04             	mov    0x4(%ebx),%eax
  801d52:	8b 0b                	mov    (%ebx),%ecx
  801d54:	8d 51 20             	lea    0x20(%ecx),%edx
  801d57:	39 d0                	cmp    %edx,%eax
  801d59:	72 14                	jb     801d6f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d5b:	89 da                	mov    %ebx,%edx
  801d5d:	89 f0                	mov    %esi,%eax
  801d5f:	e8 65 ff ff ff       	call   801cc9 <_pipeisclosed>
  801d64:	85 c0                	test   %eax,%eax
  801d66:	75 3b                	jne    801da3 <devpipe_write+0x75>
			sys_yield();
  801d68:	e8 5d ef ff ff       	call   800cca <sys_yield>
  801d6d:	eb e0                	jmp    801d4f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d72:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d76:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d79:	89 c2                	mov    %eax,%edx
  801d7b:	c1 fa 1f             	sar    $0x1f,%edx
  801d7e:	89 d1                	mov    %edx,%ecx
  801d80:	c1 e9 1b             	shr    $0x1b,%ecx
  801d83:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d86:	83 e2 1f             	and    $0x1f,%edx
  801d89:	29 ca                	sub    %ecx,%edx
  801d8b:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d8f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d93:	83 c0 01             	add    $0x1,%eax
  801d96:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d99:	83 c7 01             	add    $0x1,%edi
  801d9c:	eb ac                	jmp    801d4a <devpipe_write+0x1c>
	return i;
  801d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801da1:	eb 05                	jmp    801da8 <devpipe_write+0x7a>
				return 0;
  801da3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dab:	5b                   	pop    %ebx
  801dac:	5e                   	pop    %esi
  801dad:	5f                   	pop    %edi
  801dae:	5d                   	pop    %ebp
  801daf:	c3                   	ret    

00801db0 <devpipe_read>:
{
  801db0:	55                   	push   %ebp
  801db1:	89 e5                	mov    %esp,%ebp
  801db3:	57                   	push   %edi
  801db4:	56                   	push   %esi
  801db5:	53                   	push   %ebx
  801db6:	83 ec 18             	sub    $0x18,%esp
  801db9:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dbc:	57                   	push   %edi
  801dbd:	e8 0c f2 ff ff       	call   800fce <fd2data>
  801dc2:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc4:	83 c4 10             	add    $0x10,%esp
  801dc7:	be 00 00 00 00       	mov    $0x0,%esi
  801dcc:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dcf:	75 14                	jne    801de5 <devpipe_read+0x35>
	return i;
  801dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd4:	eb 02                	jmp    801dd8 <devpipe_read+0x28>
				return i;
  801dd6:	89 f0                	mov    %esi,%eax
}
  801dd8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
			sys_yield();
  801de0:	e8 e5 ee ff ff       	call   800cca <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801de5:	8b 03                	mov    (%ebx),%eax
  801de7:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dea:	75 18                	jne    801e04 <devpipe_read+0x54>
			if (i > 0)
  801dec:	85 f6                	test   %esi,%esi
  801dee:	75 e6                	jne    801dd6 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801df0:	89 da                	mov    %ebx,%edx
  801df2:	89 f8                	mov    %edi,%eax
  801df4:	e8 d0 fe ff ff       	call   801cc9 <_pipeisclosed>
  801df9:	85 c0                	test   %eax,%eax
  801dfb:	74 e3                	je     801de0 <devpipe_read+0x30>
				return 0;
  801dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  801e02:	eb d4                	jmp    801dd8 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e04:	99                   	cltd   
  801e05:	c1 ea 1b             	shr    $0x1b,%edx
  801e08:	01 d0                	add    %edx,%eax
  801e0a:	83 e0 1f             	and    $0x1f,%eax
  801e0d:	29 d0                	sub    %edx,%eax
  801e0f:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e17:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e1a:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e1d:	83 c6 01             	add    $0x1,%esi
  801e20:	eb aa                	jmp    801dcc <devpipe_read+0x1c>

00801e22 <pipe>:
{
  801e22:	55                   	push   %ebp
  801e23:	89 e5                	mov    %esp,%ebp
  801e25:	56                   	push   %esi
  801e26:	53                   	push   %ebx
  801e27:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2d:	50                   	push   %eax
  801e2e:	e8 b2 f1 ff ff       	call   800fe5 <fd_alloc>
  801e33:	89 c3                	mov    %eax,%ebx
  801e35:	83 c4 10             	add    $0x10,%esp
  801e38:	85 c0                	test   %eax,%eax
  801e3a:	0f 88 23 01 00 00    	js     801f63 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e40:	83 ec 04             	sub    $0x4,%esp
  801e43:	68 07 04 00 00       	push   $0x407
  801e48:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4b:	6a 00                	push   $0x0
  801e4d:	e8 97 ee ff ff       	call   800ce9 <sys_page_alloc>
  801e52:	89 c3                	mov    %eax,%ebx
  801e54:	83 c4 10             	add    $0x10,%esp
  801e57:	85 c0                	test   %eax,%eax
  801e59:	0f 88 04 01 00 00    	js     801f63 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e5f:	83 ec 0c             	sub    $0xc,%esp
  801e62:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e65:	50                   	push   %eax
  801e66:	e8 7a f1 ff ff       	call   800fe5 <fd_alloc>
  801e6b:	89 c3                	mov    %eax,%ebx
  801e6d:	83 c4 10             	add    $0x10,%esp
  801e70:	85 c0                	test   %eax,%eax
  801e72:	0f 88 db 00 00 00    	js     801f53 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e78:	83 ec 04             	sub    $0x4,%esp
  801e7b:	68 07 04 00 00       	push   $0x407
  801e80:	ff 75 f0             	pushl  -0x10(%ebp)
  801e83:	6a 00                	push   $0x0
  801e85:	e8 5f ee ff ff       	call   800ce9 <sys_page_alloc>
  801e8a:	89 c3                	mov    %eax,%ebx
  801e8c:	83 c4 10             	add    $0x10,%esp
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	0f 88 bc 00 00 00    	js     801f53 <pipe+0x131>
	va = fd2data(fd0);
  801e97:	83 ec 0c             	sub    $0xc,%esp
  801e9a:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9d:	e8 2c f1 ff ff       	call   800fce <fd2data>
  801ea2:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea4:	83 c4 0c             	add    $0xc,%esp
  801ea7:	68 07 04 00 00       	push   $0x407
  801eac:	50                   	push   %eax
  801ead:	6a 00                	push   $0x0
  801eaf:	e8 35 ee ff ff       	call   800ce9 <sys_page_alloc>
  801eb4:	89 c3                	mov    %eax,%ebx
  801eb6:	83 c4 10             	add    $0x10,%esp
  801eb9:	85 c0                	test   %eax,%eax
  801ebb:	0f 88 82 00 00 00    	js     801f43 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec1:	83 ec 0c             	sub    $0xc,%esp
  801ec4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec7:	e8 02 f1 ff ff       	call   800fce <fd2data>
  801ecc:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ed3:	50                   	push   %eax
  801ed4:	6a 00                	push   $0x0
  801ed6:	56                   	push   %esi
  801ed7:	6a 00                	push   $0x0
  801ed9:	e8 4e ee ff ff       	call   800d2c <sys_page_map>
  801ede:	89 c3                	mov    %eax,%ebx
  801ee0:	83 c4 20             	add    $0x20,%esp
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 4e                	js     801f35 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee7:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801eec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eef:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ef1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef4:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801efb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801efe:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801f00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f03:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f0a:	83 ec 0c             	sub    $0xc,%esp
  801f0d:	ff 75 f4             	pushl  -0xc(%ebp)
  801f10:	e8 a9 f0 ff ff       	call   800fbe <fd2num>
  801f15:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f18:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f1a:	83 c4 04             	add    $0x4,%esp
  801f1d:	ff 75 f0             	pushl  -0x10(%ebp)
  801f20:	e8 99 f0 ff ff       	call   800fbe <fd2num>
  801f25:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f28:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f2b:	83 c4 10             	add    $0x10,%esp
  801f2e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f33:	eb 2e                	jmp    801f63 <pipe+0x141>
	sys_page_unmap(0, va);
  801f35:	83 ec 08             	sub    $0x8,%esp
  801f38:	56                   	push   %esi
  801f39:	6a 00                	push   $0x0
  801f3b:	e8 2e ee ff ff       	call   800d6e <sys_page_unmap>
  801f40:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f43:	83 ec 08             	sub    $0x8,%esp
  801f46:	ff 75 f0             	pushl  -0x10(%ebp)
  801f49:	6a 00                	push   $0x0
  801f4b:	e8 1e ee ff ff       	call   800d6e <sys_page_unmap>
  801f50:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f53:	83 ec 08             	sub    $0x8,%esp
  801f56:	ff 75 f4             	pushl  -0xc(%ebp)
  801f59:	6a 00                	push   $0x0
  801f5b:	e8 0e ee ff ff       	call   800d6e <sys_page_unmap>
  801f60:	83 c4 10             	add    $0x10,%esp
}
  801f63:	89 d8                	mov    %ebx,%eax
  801f65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f68:	5b                   	pop    %ebx
  801f69:	5e                   	pop    %esi
  801f6a:	5d                   	pop    %ebp
  801f6b:	c3                   	ret    

00801f6c <pipeisclosed>:
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	ff 75 08             	pushl  0x8(%ebp)
  801f79:	e8 b9 f0 ff ff       	call   801037 <fd_lookup>
  801f7e:	83 c4 10             	add    $0x10,%esp
  801f81:	85 c0                	test   %eax,%eax
  801f83:	78 18                	js     801f9d <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f85:	83 ec 0c             	sub    $0xc,%esp
  801f88:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8b:	e8 3e f0 ff ff       	call   800fce <fd2data>
	return _pipeisclosed(fd, p);
  801f90:	89 c2                	mov    %eax,%edx
  801f92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f95:	e8 2f fd ff ff       	call   801cc9 <_pipeisclosed>
  801f9a:	83 c4 10             	add    $0x10,%esp
}
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa4:	c3                   	ret    

00801fa5 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa5:	55                   	push   %ebp
  801fa6:	89 e5                	mov    %esp,%ebp
  801fa8:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801fab:	68 eb 29 80 00       	push   $0x8029eb
  801fb0:	ff 75 0c             	pushl  0xc(%ebp)
  801fb3:	e8 3f e9 ff ff       	call   8008f7 <strcpy>
	return 0;
}
  801fb8:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbd:	c9                   	leave  
  801fbe:	c3                   	ret    

00801fbf <devcons_write>:
{
  801fbf:	55                   	push   %ebp
  801fc0:	89 e5                	mov    %esp,%ebp
  801fc2:	57                   	push   %edi
  801fc3:	56                   	push   %esi
  801fc4:	53                   	push   %ebx
  801fc5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fcb:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fd0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd6:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd9:	73 31                	jae    80200c <devcons_write+0x4d>
		m = n - tot;
  801fdb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fde:	29 f3                	sub    %esi,%ebx
  801fe0:	83 fb 7f             	cmp    $0x7f,%ebx
  801fe3:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe8:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801feb:	83 ec 04             	sub    $0x4,%esp
  801fee:	53                   	push   %ebx
  801fef:	89 f0                	mov    %esi,%eax
  801ff1:	03 45 0c             	add    0xc(%ebp),%eax
  801ff4:	50                   	push   %eax
  801ff5:	57                   	push   %edi
  801ff6:	e8 8a ea ff ff       	call   800a85 <memmove>
		sys_cputs(buf, m);
  801ffb:	83 c4 08             	add    $0x8,%esp
  801ffe:	53                   	push   %ebx
  801fff:	57                   	push   %edi
  802000:	e8 28 ec ff ff       	call   800c2d <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802005:	01 de                	add    %ebx,%esi
  802007:	83 c4 10             	add    $0x10,%esp
  80200a:	eb ca                	jmp    801fd6 <devcons_write+0x17>
}
  80200c:	89 f0                	mov    %esi,%eax
  80200e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802011:	5b                   	pop    %ebx
  802012:	5e                   	pop    %esi
  802013:	5f                   	pop    %edi
  802014:	5d                   	pop    %ebp
  802015:	c3                   	ret    

00802016 <devcons_read>:
{
  802016:	55                   	push   %ebp
  802017:	89 e5                	mov    %esp,%ebp
  802019:	83 ec 08             	sub    $0x8,%esp
  80201c:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802021:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802025:	74 21                	je     802048 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802027:	e8 1f ec ff ff       	call   800c4b <sys_cgetc>
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 07                	jne    802037 <devcons_read+0x21>
		sys_yield();
  802030:	e8 95 ec ff ff       	call   800cca <sys_yield>
  802035:	eb f0                	jmp    802027 <devcons_read+0x11>
	if (c < 0)
  802037:	78 0f                	js     802048 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802039:	83 f8 04             	cmp    $0x4,%eax
  80203c:	74 0c                	je     80204a <devcons_read+0x34>
	*(char*)vbuf = c;
  80203e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802041:	88 02                	mov    %al,(%edx)
	return 1;
  802043:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802048:	c9                   	leave  
  802049:	c3                   	ret    
		return 0;
  80204a:	b8 00 00 00 00       	mov    $0x0,%eax
  80204f:	eb f7                	jmp    802048 <devcons_read+0x32>

00802051 <cputchar>:
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802057:	8b 45 08             	mov    0x8(%ebp),%eax
  80205a:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80205d:	6a 01                	push   $0x1
  80205f:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802062:	50                   	push   %eax
  802063:	e8 c5 eb ff ff       	call   800c2d <sys_cputs>
}
  802068:	83 c4 10             	add    $0x10,%esp
  80206b:	c9                   	leave  
  80206c:	c3                   	ret    

0080206d <getchar>:
{
  80206d:	55                   	push   %ebp
  80206e:	89 e5                	mov    %esp,%ebp
  802070:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802073:	6a 01                	push   $0x1
  802075:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802078:	50                   	push   %eax
  802079:	6a 00                	push   $0x0
  80207b:	e8 27 f2 ff ff       	call   8012a7 <read>
	if (r < 0)
  802080:	83 c4 10             	add    $0x10,%esp
  802083:	85 c0                	test   %eax,%eax
  802085:	78 06                	js     80208d <getchar+0x20>
	if (r < 1)
  802087:	74 06                	je     80208f <getchar+0x22>
	return c;
  802089:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80208d:	c9                   	leave  
  80208e:	c3                   	ret    
		return -E_EOF;
  80208f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802094:	eb f7                	jmp    80208d <getchar+0x20>

00802096 <iscons>:
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209f:	50                   	push   %eax
  8020a0:	ff 75 08             	pushl  0x8(%ebp)
  8020a3:	e8 8f ef ff ff       	call   801037 <fd_lookup>
  8020a8:	83 c4 10             	add    $0x10,%esp
  8020ab:	85 c0                	test   %eax,%eax
  8020ad:	78 11                	js     8020c0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b2:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020b8:	39 10                	cmp    %edx,(%eax)
  8020ba:	0f 94 c0             	sete   %al
  8020bd:	0f b6 c0             	movzbl %al,%eax
}
  8020c0:	c9                   	leave  
  8020c1:	c3                   	ret    

008020c2 <opencons>:
{
  8020c2:	55                   	push   %ebp
  8020c3:	89 e5                	mov    %esp,%ebp
  8020c5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020cb:	50                   	push   %eax
  8020cc:	e8 14 ef ff ff       	call   800fe5 <fd_alloc>
  8020d1:	83 c4 10             	add    $0x10,%esp
  8020d4:	85 c0                	test   %eax,%eax
  8020d6:	78 3a                	js     802112 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d8:	83 ec 04             	sub    $0x4,%esp
  8020db:	68 07 04 00 00       	push   $0x407
  8020e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e3:	6a 00                	push   $0x0
  8020e5:	e8 ff eb ff ff       	call   800ce9 <sys_page_alloc>
  8020ea:	83 c4 10             	add    $0x10,%esp
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	78 21                	js     802112 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020fa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802106:	83 ec 0c             	sub    $0xc,%esp
  802109:	50                   	push   %eax
  80210a:	e8 af ee ff ff       	call   800fbe <fd2num>
  80210f:	83 c4 10             	add    $0x10,%esp
}
  802112:	c9                   	leave  
  802113:	c3                   	ret    

00802114 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802114:	55                   	push   %ebp
  802115:	89 e5                	mov    %esp,%ebp
  802117:	56                   	push   %esi
  802118:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802119:	a1 08 40 80 00       	mov    0x804008,%eax
  80211e:	8b 40 48             	mov    0x48(%eax),%eax
  802121:	83 ec 04             	sub    $0x4,%esp
  802124:	68 28 2a 80 00       	push   $0x802a28
  802129:	50                   	push   %eax
  80212a:	68 f7 29 80 00       	push   $0x8029f7
  80212f:	e8 64 e0 ff ff       	call   800198 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802134:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802137:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80213d:	e8 69 eb ff ff       	call   800cab <sys_getenvid>
  802142:	83 c4 04             	add    $0x4,%esp
  802145:	ff 75 0c             	pushl  0xc(%ebp)
  802148:	ff 75 08             	pushl  0x8(%ebp)
  80214b:	56                   	push   %esi
  80214c:	50                   	push   %eax
  80214d:	68 04 2a 80 00       	push   $0x802a04
  802152:	e8 41 e0 ff ff       	call   800198 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802157:	83 c4 18             	add    $0x18,%esp
  80215a:	53                   	push   %ebx
  80215b:	ff 75 10             	pushl  0x10(%ebp)
  80215e:	e8 e4 df ff ff       	call   800147 <vcprintf>
	cprintf("\n");
  802163:	c7 04 24 0b 25 80 00 	movl   $0x80250b,(%esp)
  80216a:	e8 29 e0 ff ff       	call   800198 <cprintf>
  80216f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802172:	cc                   	int3   
  802173:	eb fd                	jmp    802172 <_panic+0x5e>

00802175 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	56                   	push   %esi
  802179:	53                   	push   %ebx
  80217a:	8b 75 08             	mov    0x8(%ebp),%esi
  80217d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802180:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802183:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802185:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  80218a:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80218d:	83 ec 0c             	sub    $0xc,%esp
  802190:	50                   	push   %eax
  802191:	e8 03 ed ff ff       	call   800e99 <sys_ipc_recv>
	if(ret < 0){
  802196:	83 c4 10             	add    $0x10,%esp
  802199:	85 c0                	test   %eax,%eax
  80219b:	78 2b                	js     8021c8 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80219d:	85 f6                	test   %esi,%esi
  80219f:	74 0a                	je     8021ab <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  8021a1:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a6:	8b 40 74             	mov    0x74(%eax),%eax
  8021a9:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021ab:	85 db                	test   %ebx,%ebx
  8021ad:	74 0a                	je     8021b9 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  8021af:	a1 08 40 80 00       	mov    0x804008,%eax
  8021b4:	8b 40 78             	mov    0x78(%eax),%eax
  8021b7:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021b9:	a1 08 40 80 00       	mov    0x804008,%eax
  8021be:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c4:	5b                   	pop    %ebx
  8021c5:	5e                   	pop    %esi
  8021c6:	5d                   	pop    %ebp
  8021c7:	c3                   	ret    
		if(from_env_store)
  8021c8:	85 f6                	test   %esi,%esi
  8021ca:	74 06                	je     8021d2 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021cc:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021d2:	85 db                	test   %ebx,%ebx
  8021d4:	74 eb                	je     8021c1 <ipc_recv+0x4c>
			*perm_store = 0;
  8021d6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021dc:	eb e3                	jmp    8021c1 <ipc_recv+0x4c>

008021de <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	57                   	push   %edi
  8021e2:	56                   	push   %esi
  8021e3:	53                   	push   %ebx
  8021e4:	83 ec 0c             	sub    $0xc,%esp
  8021e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021ea:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021ed:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021f0:	85 db                	test   %ebx,%ebx
  8021f2:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021f7:	0f 44 d8             	cmove  %eax,%ebx
  8021fa:	eb 05                	jmp    802201 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021fc:	e8 c9 ea ff ff       	call   800cca <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802201:	ff 75 14             	pushl  0x14(%ebp)
  802204:	53                   	push   %ebx
  802205:	56                   	push   %esi
  802206:	57                   	push   %edi
  802207:	e8 6a ec ff ff       	call   800e76 <sys_ipc_try_send>
  80220c:	83 c4 10             	add    $0x10,%esp
  80220f:	85 c0                	test   %eax,%eax
  802211:	74 1b                	je     80222e <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802213:	79 e7                	jns    8021fc <ipc_send+0x1e>
  802215:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802218:	74 e2                	je     8021fc <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	68 2f 2a 80 00       	push   $0x802a2f
  802222:	6a 48                	push   $0x48
  802224:	68 44 2a 80 00       	push   $0x802a44
  802229:	e8 e6 fe ff ff       	call   802114 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80222e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802231:	5b                   	pop    %ebx
  802232:	5e                   	pop    %esi
  802233:	5f                   	pop    %edi
  802234:	5d                   	pop    %ebp
  802235:	c3                   	ret    

00802236 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802236:	55                   	push   %ebp
  802237:	89 e5                	mov    %esp,%ebp
  802239:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80223c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802241:	89 c2                	mov    %eax,%edx
  802243:	c1 e2 07             	shl    $0x7,%edx
  802246:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80224c:	8b 52 50             	mov    0x50(%edx),%edx
  80224f:	39 ca                	cmp    %ecx,%edx
  802251:	74 11                	je     802264 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802253:	83 c0 01             	add    $0x1,%eax
  802256:	3d 00 04 00 00       	cmp    $0x400,%eax
  80225b:	75 e4                	jne    802241 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80225d:	b8 00 00 00 00       	mov    $0x0,%eax
  802262:	eb 0b                	jmp    80226f <ipc_find_env+0x39>
			return envs[i].env_id;
  802264:	c1 e0 07             	shl    $0x7,%eax
  802267:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80226c:	8b 40 48             	mov    0x48(%eax),%eax
}
  80226f:	5d                   	pop    %ebp
  802270:	c3                   	ret    

00802271 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802277:	89 d0                	mov    %edx,%eax
  802279:	c1 e8 16             	shr    $0x16,%eax
  80227c:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802283:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802288:	f6 c1 01             	test   $0x1,%cl
  80228b:	74 1d                	je     8022aa <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80228d:	c1 ea 0c             	shr    $0xc,%edx
  802290:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802297:	f6 c2 01             	test   $0x1,%dl
  80229a:	74 0e                	je     8022aa <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80229c:	c1 ea 0c             	shr    $0xc,%edx
  80229f:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022a6:	ef 
  8022a7:	0f b7 c0             	movzwl %ax,%eax
}
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    
  8022ac:	66 90                	xchg   %ax,%ax
  8022ae:	66 90                	xchg   %ax,%ax

008022b0 <__udivdi3>:
  8022b0:	55                   	push   %ebp
  8022b1:	57                   	push   %edi
  8022b2:	56                   	push   %esi
  8022b3:	53                   	push   %ebx
  8022b4:	83 ec 1c             	sub    $0x1c,%esp
  8022b7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022bb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022c3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022c7:	85 d2                	test   %edx,%edx
  8022c9:	75 4d                	jne    802318 <__udivdi3+0x68>
  8022cb:	39 f3                	cmp    %esi,%ebx
  8022cd:	76 19                	jbe    8022e8 <__udivdi3+0x38>
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	89 e8                	mov    %ebp,%eax
  8022d3:	89 f2                	mov    %esi,%edx
  8022d5:	f7 f3                	div    %ebx
  8022d7:	89 fa                	mov    %edi,%edx
  8022d9:	83 c4 1c             	add    $0x1c,%esp
  8022dc:	5b                   	pop    %ebx
  8022dd:	5e                   	pop    %esi
  8022de:	5f                   	pop    %edi
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    
  8022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022e8:	89 d9                	mov    %ebx,%ecx
  8022ea:	85 db                	test   %ebx,%ebx
  8022ec:	75 0b                	jne    8022f9 <__udivdi3+0x49>
  8022ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8022f3:	31 d2                	xor    %edx,%edx
  8022f5:	f7 f3                	div    %ebx
  8022f7:	89 c1                	mov    %eax,%ecx
  8022f9:	31 d2                	xor    %edx,%edx
  8022fb:	89 f0                	mov    %esi,%eax
  8022fd:	f7 f1                	div    %ecx
  8022ff:	89 c6                	mov    %eax,%esi
  802301:	89 e8                	mov    %ebp,%eax
  802303:	89 f7                	mov    %esi,%edi
  802305:	f7 f1                	div    %ecx
  802307:	89 fa                	mov    %edi,%edx
  802309:	83 c4 1c             	add    $0x1c,%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5e                   	pop    %esi
  80230e:	5f                   	pop    %edi
  80230f:	5d                   	pop    %ebp
  802310:	c3                   	ret    
  802311:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802318:	39 f2                	cmp    %esi,%edx
  80231a:	77 1c                	ja     802338 <__udivdi3+0x88>
  80231c:	0f bd fa             	bsr    %edx,%edi
  80231f:	83 f7 1f             	xor    $0x1f,%edi
  802322:	75 2c                	jne    802350 <__udivdi3+0xa0>
  802324:	39 f2                	cmp    %esi,%edx
  802326:	72 06                	jb     80232e <__udivdi3+0x7e>
  802328:	31 c0                	xor    %eax,%eax
  80232a:	39 eb                	cmp    %ebp,%ebx
  80232c:	77 a9                	ja     8022d7 <__udivdi3+0x27>
  80232e:	b8 01 00 00 00       	mov    $0x1,%eax
  802333:	eb a2                	jmp    8022d7 <__udivdi3+0x27>
  802335:	8d 76 00             	lea    0x0(%esi),%esi
  802338:	31 ff                	xor    %edi,%edi
  80233a:	31 c0                	xor    %eax,%eax
  80233c:	89 fa                	mov    %edi,%edx
  80233e:	83 c4 1c             	add    $0x1c,%esp
  802341:	5b                   	pop    %ebx
  802342:	5e                   	pop    %esi
  802343:	5f                   	pop    %edi
  802344:	5d                   	pop    %ebp
  802345:	c3                   	ret    
  802346:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	89 f9                	mov    %edi,%ecx
  802352:	b8 20 00 00 00       	mov    $0x20,%eax
  802357:	29 f8                	sub    %edi,%eax
  802359:	d3 e2                	shl    %cl,%edx
  80235b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80235f:	89 c1                	mov    %eax,%ecx
  802361:	89 da                	mov    %ebx,%edx
  802363:	d3 ea                	shr    %cl,%edx
  802365:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802369:	09 d1                	or     %edx,%ecx
  80236b:	89 f2                	mov    %esi,%edx
  80236d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802371:	89 f9                	mov    %edi,%ecx
  802373:	d3 e3                	shl    %cl,%ebx
  802375:	89 c1                	mov    %eax,%ecx
  802377:	d3 ea                	shr    %cl,%edx
  802379:	89 f9                	mov    %edi,%ecx
  80237b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80237f:	89 eb                	mov    %ebp,%ebx
  802381:	d3 e6                	shl    %cl,%esi
  802383:	89 c1                	mov    %eax,%ecx
  802385:	d3 eb                	shr    %cl,%ebx
  802387:	09 de                	or     %ebx,%esi
  802389:	89 f0                	mov    %esi,%eax
  80238b:	f7 74 24 08          	divl   0x8(%esp)
  80238f:	89 d6                	mov    %edx,%esi
  802391:	89 c3                	mov    %eax,%ebx
  802393:	f7 64 24 0c          	mull   0xc(%esp)
  802397:	39 d6                	cmp    %edx,%esi
  802399:	72 15                	jb     8023b0 <__udivdi3+0x100>
  80239b:	89 f9                	mov    %edi,%ecx
  80239d:	d3 e5                	shl    %cl,%ebp
  80239f:	39 c5                	cmp    %eax,%ebp
  8023a1:	73 04                	jae    8023a7 <__udivdi3+0xf7>
  8023a3:	39 d6                	cmp    %edx,%esi
  8023a5:	74 09                	je     8023b0 <__udivdi3+0x100>
  8023a7:	89 d8                	mov    %ebx,%eax
  8023a9:	31 ff                	xor    %edi,%edi
  8023ab:	e9 27 ff ff ff       	jmp    8022d7 <__udivdi3+0x27>
  8023b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023b3:	31 ff                	xor    %edi,%edi
  8023b5:	e9 1d ff ff ff       	jmp    8022d7 <__udivdi3+0x27>
  8023ba:	66 90                	xchg   %ax,%ax
  8023bc:	66 90                	xchg   %ax,%ax
  8023be:	66 90                	xchg   %ax,%ax

008023c0 <__umoddi3>:
  8023c0:	55                   	push   %ebp
  8023c1:	57                   	push   %edi
  8023c2:	56                   	push   %esi
  8023c3:	53                   	push   %ebx
  8023c4:	83 ec 1c             	sub    $0x1c,%esp
  8023c7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023cb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023cf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023d7:	89 da                	mov    %ebx,%edx
  8023d9:	85 c0                	test   %eax,%eax
  8023db:	75 43                	jne    802420 <__umoddi3+0x60>
  8023dd:	39 df                	cmp    %ebx,%edi
  8023df:	76 17                	jbe    8023f8 <__umoddi3+0x38>
  8023e1:	89 f0                	mov    %esi,%eax
  8023e3:	f7 f7                	div    %edi
  8023e5:	89 d0                	mov    %edx,%eax
  8023e7:	31 d2                	xor    %edx,%edx
  8023e9:	83 c4 1c             	add    $0x1c,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5e                   	pop    %esi
  8023ee:	5f                   	pop    %edi
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    
  8023f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023f8:	89 fd                	mov    %edi,%ebp
  8023fa:	85 ff                	test   %edi,%edi
  8023fc:	75 0b                	jne    802409 <__umoddi3+0x49>
  8023fe:	b8 01 00 00 00       	mov    $0x1,%eax
  802403:	31 d2                	xor    %edx,%edx
  802405:	f7 f7                	div    %edi
  802407:	89 c5                	mov    %eax,%ebp
  802409:	89 d8                	mov    %ebx,%eax
  80240b:	31 d2                	xor    %edx,%edx
  80240d:	f7 f5                	div    %ebp
  80240f:	89 f0                	mov    %esi,%eax
  802411:	f7 f5                	div    %ebp
  802413:	89 d0                	mov    %edx,%eax
  802415:	eb d0                	jmp    8023e7 <__umoddi3+0x27>
  802417:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80241e:	66 90                	xchg   %ax,%ax
  802420:	89 f1                	mov    %esi,%ecx
  802422:	39 d8                	cmp    %ebx,%eax
  802424:	76 0a                	jbe    802430 <__umoddi3+0x70>
  802426:	89 f0                	mov    %esi,%eax
  802428:	83 c4 1c             	add    $0x1c,%esp
  80242b:	5b                   	pop    %ebx
  80242c:	5e                   	pop    %esi
  80242d:	5f                   	pop    %edi
  80242e:	5d                   	pop    %ebp
  80242f:	c3                   	ret    
  802430:	0f bd e8             	bsr    %eax,%ebp
  802433:	83 f5 1f             	xor    $0x1f,%ebp
  802436:	75 20                	jne    802458 <__umoddi3+0x98>
  802438:	39 d8                	cmp    %ebx,%eax
  80243a:	0f 82 b0 00 00 00    	jb     8024f0 <__umoddi3+0x130>
  802440:	39 f7                	cmp    %esi,%edi
  802442:	0f 86 a8 00 00 00    	jbe    8024f0 <__umoddi3+0x130>
  802448:	89 c8                	mov    %ecx,%eax
  80244a:	83 c4 1c             	add    $0x1c,%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5f                   	pop    %edi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    
  802452:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802458:	89 e9                	mov    %ebp,%ecx
  80245a:	ba 20 00 00 00       	mov    $0x20,%edx
  80245f:	29 ea                	sub    %ebp,%edx
  802461:	d3 e0                	shl    %cl,%eax
  802463:	89 44 24 08          	mov    %eax,0x8(%esp)
  802467:	89 d1                	mov    %edx,%ecx
  802469:	89 f8                	mov    %edi,%eax
  80246b:	d3 e8                	shr    %cl,%eax
  80246d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802471:	89 54 24 04          	mov    %edx,0x4(%esp)
  802475:	8b 54 24 04          	mov    0x4(%esp),%edx
  802479:	09 c1                	or     %eax,%ecx
  80247b:	89 d8                	mov    %ebx,%eax
  80247d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802481:	89 e9                	mov    %ebp,%ecx
  802483:	d3 e7                	shl    %cl,%edi
  802485:	89 d1                	mov    %edx,%ecx
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80248f:	d3 e3                	shl    %cl,%ebx
  802491:	89 c7                	mov    %eax,%edi
  802493:	89 d1                	mov    %edx,%ecx
  802495:	89 f0                	mov    %esi,%eax
  802497:	d3 e8                	shr    %cl,%eax
  802499:	89 e9                	mov    %ebp,%ecx
  80249b:	89 fa                	mov    %edi,%edx
  80249d:	d3 e6                	shl    %cl,%esi
  80249f:	09 d8                	or     %ebx,%eax
  8024a1:	f7 74 24 08          	divl   0x8(%esp)
  8024a5:	89 d1                	mov    %edx,%ecx
  8024a7:	89 f3                	mov    %esi,%ebx
  8024a9:	f7 64 24 0c          	mull   0xc(%esp)
  8024ad:	89 c6                	mov    %eax,%esi
  8024af:	89 d7                	mov    %edx,%edi
  8024b1:	39 d1                	cmp    %edx,%ecx
  8024b3:	72 06                	jb     8024bb <__umoddi3+0xfb>
  8024b5:	75 10                	jne    8024c7 <__umoddi3+0x107>
  8024b7:	39 c3                	cmp    %eax,%ebx
  8024b9:	73 0c                	jae    8024c7 <__umoddi3+0x107>
  8024bb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024bf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024c3:	89 d7                	mov    %edx,%edi
  8024c5:	89 c6                	mov    %eax,%esi
  8024c7:	89 ca                	mov    %ecx,%edx
  8024c9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024ce:	29 f3                	sub    %esi,%ebx
  8024d0:	19 fa                	sbb    %edi,%edx
  8024d2:	89 d0                	mov    %edx,%eax
  8024d4:	d3 e0                	shl    %cl,%eax
  8024d6:	89 e9                	mov    %ebp,%ecx
  8024d8:	d3 eb                	shr    %cl,%ebx
  8024da:	d3 ea                	shr    %cl,%edx
  8024dc:	09 d8                	or     %ebx,%eax
  8024de:	83 c4 1c             	add    $0x1c,%esp
  8024e1:	5b                   	pop    %ebx
  8024e2:	5e                   	pop    %esi
  8024e3:	5f                   	pop    %edi
  8024e4:	5d                   	pop    %ebp
  8024e5:	c3                   	ret    
  8024e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024ed:	8d 76 00             	lea    0x0(%esi),%esi
  8024f0:	89 da                	mov    %ebx,%edx
  8024f2:	29 fe                	sub    %edi,%esi
  8024f4:	19 c2                	sbb    %eax,%edx
  8024f6:	89 f1                	mov    %esi,%ecx
  8024f8:	89 c8                	mov    %ecx,%eax
  8024fa:	e9 4b ff ff ff       	jmp    80244a <__umoddi3+0x8a>
