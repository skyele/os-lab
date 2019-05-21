
obj/user/fairness.debug:     file format elf32-i386


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
  80002c:	e8 70 00 00 00       	call   8000a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 10             	sub    $0x10,%esp
	envid_t who, id;

	id = sys_getenvid();
  80003b:	e8 b0 0c 00 00       	call   800cf0 <sys_getenvid>
  800040:	89 c3                	mov    %eax,%ebx

	if (thisenv == &envs[1]) {
  800042:	81 3d 04 20 80 00 80 	cmpl   $0xeec00080,0x802004
  800049:	00 c0 ee 
  80004c:	74 2d                	je     80007b <umain+0x48>
		while (1) {
			ipc_recv(&who, 0, 0);
			cprintf("%x recv from %x\n", id, who);
		}
	} else {
		cprintf("%x loop sending to %x\n", id, envs[1].env_id);
  80004e:	a1 c8 00 c0 ee       	mov    0xeec000c8,%eax
  800053:	83 ec 04             	sub    $0x4,%esp
  800056:	50                   	push   %eax
  800057:	53                   	push   %ebx
  800058:	68 31 13 80 00       	push   $0x801331
  80005d:	e8 7b 01 00 00       	call   8001dd <cprintf>
  800062:	83 c4 10             	add    $0x10,%esp
		while (1)
			ipc_send(envs[1].env_id, 0, 0, 0);
  800065:	a1 c8 00 c0 ee       	mov    0xeec000c8,%eax
  80006a:	6a 00                	push   $0x0
  80006c:	6a 00                	push   $0x0
  80006e:	6a 00                	push   $0x0
  800070:	50                   	push   %eax
  800071:	e8 53 0f 00 00       	call   800fc9 <ipc_send>
  800076:	83 c4 10             	add    $0x10,%esp
  800079:	eb ea                	jmp    800065 <umain+0x32>
			ipc_recv(&who, 0, 0);
  80007b:	8d 75 f4             	lea    -0xc(%ebp),%esi
  80007e:	83 ec 04             	sub    $0x4,%esp
  800081:	6a 00                	push   $0x0
  800083:	6a 00                	push   $0x0
  800085:	56                   	push   %esi
  800086:	e8 d5 0e 00 00       	call   800f60 <ipc_recv>
			cprintf("%x recv from %x\n", id, who);
  80008b:	83 c4 0c             	add    $0xc,%esp
  80008e:	ff 75 f4             	pushl  -0xc(%ebp)
  800091:	53                   	push   %ebx
  800092:	68 20 13 80 00       	push   $0x801320
  800097:	e8 41 01 00 00       	call   8001dd <cprintf>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	eb dd                	jmp    80007e <umain+0x4b>

008000a1 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  8000a1:	55                   	push   %ebp
  8000a2:	89 e5                	mov    %esp,%ebp
  8000a4:	57                   	push   %edi
  8000a5:	56                   	push   %esi
  8000a6:	53                   	push   %ebx
  8000a7:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  8000aa:	c7 05 04 20 80 00 00 	movl   $0x0,0x802004
  8000b1:	00 00 00 
	envid_t find = sys_getenvid();
  8000b4:	e8 37 0c 00 00       	call   800cf0 <sys_getenvid>
  8000b9:	8b 1d 04 20 80 00    	mov    0x802004,%ebx
  8000bf:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  8000c4:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  8000c9:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ce:	eb 0b                	jmp    8000db <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  8000d0:	83 c2 01             	add    $0x1,%edx
  8000d3:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  8000d9:	74 21                	je     8000fc <libmain+0x5b>
		if(envs[i].env_id == find)
  8000db:	89 d1                	mov    %edx,%ecx
  8000dd:	c1 e1 07             	shl    $0x7,%ecx
  8000e0:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  8000e6:	8b 49 48             	mov    0x48(%ecx),%ecx
  8000e9:	39 c1                	cmp    %eax,%ecx
  8000eb:	75 e3                	jne    8000d0 <libmain+0x2f>
  8000ed:	89 d3                	mov    %edx,%ebx
  8000ef:	c1 e3 07             	shl    $0x7,%ebx
  8000f2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  8000f8:	89 fe                	mov    %edi,%esi
  8000fa:	eb d4                	jmp    8000d0 <libmain+0x2f>
  8000fc:	89 f0                	mov    %esi,%eax
  8000fe:	84 c0                	test   %al,%al
  800100:	74 06                	je     800108 <libmain+0x67>
  800102:	89 1d 04 20 80 00    	mov    %ebx,0x802004
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800108:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80010c:	7e 0a                	jle    800118 <libmain+0x77>
		binaryname = argv[0];
  80010e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800111:	8b 00                	mov    (%eax),%eax
  800113:	a3 00 20 80 00       	mov    %eax,0x802000

	// call user main routine
	umain(argc, argv);
  800118:	83 ec 08             	sub    $0x8,%esp
  80011b:	ff 75 0c             	pushl  0xc(%ebp)
  80011e:	ff 75 08             	pushl  0x8(%ebp)
  800121:	e8 0d ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800126:	e8 0b 00 00 00       	call   800136 <exit>
}
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800131:	5b                   	pop    %ebx
  800132:	5e                   	pop    %esi
  800133:	5f                   	pop    %edi
  800134:	5d                   	pop    %ebp
  800135:	c3                   	ret    

00800136 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	83 ec 14             	sub    $0x14,%esp
	// close_all();
	sys_env_destroy(0);
  80013c:	6a 00                	push   $0x0
  80013e:	e8 6c 0b 00 00       	call   800caf <sys_env_destroy>
}
  800143:	83 c4 10             	add    $0x10,%esp
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	53                   	push   %ebx
  80014c:	83 ec 04             	sub    $0x4,%esp
  80014f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800152:	8b 13                	mov    (%ebx),%edx
  800154:	8d 42 01             	lea    0x1(%edx),%eax
  800157:	89 03                	mov    %eax,(%ebx)
  800159:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800160:	3d ff 00 00 00       	cmp    $0xff,%eax
  800165:	74 09                	je     800170 <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800167:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80016b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	68 ff 00 00 00       	push   $0xff
  800178:	8d 43 08             	lea    0x8(%ebx),%eax
  80017b:	50                   	push   %eax
  80017c:	e8 f1 0a 00 00       	call   800c72 <sys_cputs>
		b->idx = 0;
  800181:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	eb db                	jmp    800167 <putch+0x1f>

0080018c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800195:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019c:	00 00 00 
	b.cnt = 0;
  80019f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b5:	50                   	push   %eax
  8001b6:	68 48 01 80 00       	push   $0x800148
  8001bb:	e8 4a 01 00 00       	call   80030a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c0:	83 c4 08             	add    $0x8,%esp
  8001c3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001cf:	50                   	push   %eax
  8001d0:	e8 9d 0a 00 00       	call   800c72 <sys_cputs>

	return b.cnt;
}
  8001d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e6:	50                   	push   %eax
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 9d ff ff ff       	call   80018c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	57                   	push   %edi
  8001f5:	56                   	push   %esi
  8001f6:	53                   	push   %ebx
  8001f7:	83 ec 1c             	sub    $0x1c,%esp
  8001fa:	89 c6                	mov    %eax,%esi
  8001fc:	89 d7                	mov    %edx,%edi
  8001fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800201:	8b 55 0c             	mov    0xc(%ebp),%edx
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800207:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80020a:	8b 45 10             	mov    0x10(%ebp),%eax
  80020d:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  800210:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  800214:	74 2c                	je     800242 <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  800216:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800219:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800220:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800223:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800226:	39 c2                	cmp    %eax,%edx
  800228:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  80022b:	73 43                	jae    800270 <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  80022d:	83 eb 01             	sub    $0x1,%ebx
  800230:	85 db                	test   %ebx,%ebx
  800232:	7e 6c                	jle    8002a0 <printnum+0xaf>
				putch(padc, putdat);
  800234:	83 ec 08             	sub    $0x8,%esp
  800237:	57                   	push   %edi
  800238:	ff 75 18             	pushl  0x18(%ebp)
  80023b:	ff d6                	call   *%esi
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	eb eb                	jmp    80022d <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	6a 20                	push   $0x20
  800247:	6a 00                	push   $0x0
  800249:	50                   	push   %eax
  80024a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024d:	ff 75 e0             	pushl  -0x20(%ebp)
  800250:	89 fa                	mov    %edi,%edx
  800252:	89 f0                	mov    %esi,%eax
  800254:	e8 98 ff ff ff       	call   8001f1 <printnum>
		while (--width > 0)
  800259:	83 c4 20             	add    $0x20,%esp
  80025c:	83 eb 01             	sub    $0x1,%ebx
  80025f:	85 db                	test   %ebx,%ebx
  800261:	7e 65                	jle    8002c8 <printnum+0xd7>
			putch(padc, putdat);
  800263:	83 ec 08             	sub    $0x8,%esp
  800266:	57                   	push   %edi
  800267:	6a 20                	push   $0x20
  800269:	ff d6                	call   *%esi
  80026b:	83 c4 10             	add    $0x10,%esp
  80026e:	eb ec                	jmp    80025c <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  800270:	83 ec 0c             	sub    $0xc,%esp
  800273:	ff 75 18             	pushl  0x18(%ebp)
  800276:	83 eb 01             	sub    $0x1,%ebx
  800279:	53                   	push   %ebx
  80027a:	50                   	push   %eax
  80027b:	83 ec 08             	sub    $0x8,%esp
  80027e:	ff 75 dc             	pushl  -0x24(%ebp)
  800281:	ff 75 d8             	pushl  -0x28(%ebp)
  800284:	ff 75 e4             	pushl  -0x1c(%ebp)
  800287:	ff 75 e0             	pushl  -0x20(%ebp)
  80028a:	e8 31 0e 00 00       	call   8010c0 <__udivdi3>
  80028f:	83 c4 18             	add    $0x18,%esp
  800292:	52                   	push   %edx
  800293:	50                   	push   %eax
  800294:	89 fa                	mov    %edi,%edx
  800296:	89 f0                	mov    %esi,%eax
  800298:	e8 54 ff ff ff       	call   8001f1 <printnum>
  80029d:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  8002a0:	83 ec 08             	sub    $0x8,%esp
  8002a3:	57                   	push   %edi
  8002a4:	83 ec 04             	sub    $0x4,%esp
  8002a7:	ff 75 dc             	pushl  -0x24(%ebp)
  8002aa:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8002b3:	e8 18 0f 00 00       	call   8011d0 <__umoddi3>
  8002b8:	83 c4 14             	add    $0x14,%esp
  8002bb:	0f be 80 52 13 80 00 	movsbl 0x801352(%eax),%eax
  8002c2:	50                   	push   %eax
  8002c3:	ff d6                	call   *%esi
  8002c5:	83 c4 10             	add    $0x10,%esp
	}
}
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    

008002d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002d6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002da:	8b 10                	mov    (%eax),%edx
  8002dc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002df:	73 0a                	jae    8002eb <sprintputch+0x1b>
		*b->buf++ = ch;
  8002e1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002e4:	89 08                	mov    %ecx,(%eax)
  8002e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e9:	88 02                	mov    %al,(%edx)
}
  8002eb:	5d                   	pop    %ebp
  8002ec:	c3                   	ret    

008002ed <printfmt>:
{
  8002ed:	55                   	push   %ebp
  8002ee:	89 e5                	mov    %esp,%ebp
  8002f0:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002f3:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002f6:	50                   	push   %eax
  8002f7:	ff 75 10             	pushl  0x10(%ebp)
  8002fa:	ff 75 0c             	pushl  0xc(%ebp)
  8002fd:	ff 75 08             	pushl  0x8(%ebp)
  800300:	e8 05 00 00 00       	call   80030a <vprintfmt>
}
  800305:	83 c4 10             	add    $0x10,%esp
  800308:	c9                   	leave  
  800309:	c3                   	ret    

0080030a <vprintfmt>:
{
  80030a:	55                   	push   %ebp
  80030b:	89 e5                	mov    %esp,%ebp
  80030d:	57                   	push   %edi
  80030e:	56                   	push   %esi
  80030f:	53                   	push   %ebx
  800310:	83 ec 3c             	sub    $0x3c,%esp
  800313:	8b 75 08             	mov    0x8(%ebp),%esi
  800316:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800319:	8b 7d 10             	mov    0x10(%ebp),%edi
  80031c:	e9 32 04 00 00       	jmp    800753 <vprintfmt+0x449>
		padc = ' ';
  800321:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  800325:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  80032c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  800333:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  80033a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800341:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  800348:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80034d:	8d 47 01             	lea    0x1(%edi),%eax
  800350:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800353:	0f b6 17             	movzbl (%edi),%edx
  800356:	8d 42 dd             	lea    -0x23(%edx),%eax
  800359:	3c 55                	cmp    $0x55,%al
  80035b:	0f 87 12 05 00 00    	ja     800873 <vprintfmt+0x569>
  800361:	0f b6 c0             	movzbl %al,%eax
  800364:	ff 24 85 40 15 80 00 	jmp    *0x801540(,%eax,4)
  80036b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80036e:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  800372:	eb d9                	jmp    80034d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800374:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800377:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  80037b:	eb d0                	jmp    80034d <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80037d:	0f b6 d2             	movzbl %dl,%edx
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  800383:	b8 00 00 00 00       	mov    $0x0,%eax
  800388:	89 75 08             	mov    %esi,0x8(%ebp)
  80038b:	eb 03                	jmp    800390 <vprintfmt+0x86>
  80038d:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  800390:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800393:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800397:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80039a:	8d 72 d0             	lea    -0x30(%edx),%esi
  80039d:	83 fe 09             	cmp    $0x9,%esi
  8003a0:	76 eb                	jbe    80038d <vprintfmt+0x83>
  8003a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003a5:	8b 75 08             	mov    0x8(%ebp),%esi
  8003a8:	eb 14                	jmp    8003be <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  8003aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ad:	8b 00                	mov    (%eax),%eax
  8003af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	8d 40 04             	lea    0x4(%eax),%eax
  8003b8:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003be:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c2:	79 89                	jns    80034d <vprintfmt+0x43>
				width = precision, precision = -1;
  8003c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ca:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  8003d1:	e9 77 ff ff ff       	jmp    80034d <vprintfmt+0x43>
  8003d6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003d9:	85 c0                	test   %eax,%eax
  8003db:	0f 48 c1             	cmovs  %ecx,%eax
  8003de:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e4:	e9 64 ff ff ff       	jmp    80034d <vprintfmt+0x43>
  8003e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003ec:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  8003f3:	e9 55 ff ff ff       	jmp    80034d <vprintfmt+0x43>
			lflag++;
  8003f8:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003ff:	e9 49 ff ff ff       	jmp    80034d <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  800404:	8b 45 14             	mov    0x14(%ebp),%eax
  800407:	8d 78 04             	lea    0x4(%eax),%edi
  80040a:	83 ec 08             	sub    $0x8,%esp
  80040d:	53                   	push   %ebx
  80040e:	ff 30                	pushl  (%eax)
  800410:	ff d6                	call   *%esi
			break;
  800412:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800415:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800418:	e9 33 03 00 00       	jmp    800750 <vprintfmt+0x446>
			err = va_arg(ap, int);
  80041d:	8b 45 14             	mov    0x14(%ebp),%eax
  800420:	8d 78 04             	lea    0x4(%eax),%edi
  800423:	8b 00                	mov    (%eax),%eax
  800425:	99                   	cltd   
  800426:	31 d0                	xor    %edx,%eax
  800428:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80042a:	83 f8 0f             	cmp    $0xf,%eax
  80042d:	7f 23                	jg     800452 <vprintfmt+0x148>
  80042f:	8b 14 85 a0 16 80 00 	mov    0x8016a0(,%eax,4),%edx
  800436:	85 d2                	test   %edx,%edx
  800438:	74 18                	je     800452 <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  80043a:	52                   	push   %edx
  80043b:	68 73 13 80 00       	push   $0x801373
  800440:	53                   	push   %ebx
  800441:	56                   	push   %esi
  800442:	e8 a6 fe ff ff       	call   8002ed <printfmt>
  800447:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80044a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80044d:	e9 fe 02 00 00       	jmp    800750 <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  800452:	50                   	push   %eax
  800453:	68 6a 13 80 00       	push   $0x80136a
  800458:	53                   	push   %ebx
  800459:	56                   	push   %esi
  80045a:	e8 8e fe ff ff       	call   8002ed <printfmt>
  80045f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800462:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800465:	e9 e6 02 00 00       	jmp    800750 <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  80046a:	8b 45 14             	mov    0x14(%ebp),%eax
  80046d:	83 c0 04             	add    $0x4,%eax
  800470:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800473:	8b 45 14             	mov    0x14(%ebp),%eax
  800476:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800478:	85 c9                	test   %ecx,%ecx
  80047a:	b8 63 13 80 00       	mov    $0x801363,%eax
  80047f:	0f 45 c1             	cmovne %ecx,%eax
  800482:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  800485:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800489:	7e 06                	jle    800491 <vprintfmt+0x187>
  80048b:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  80048f:	75 0d                	jne    80049e <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  800491:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800494:	89 c7                	mov    %eax,%edi
  800496:	03 45 e0             	add    -0x20(%ebp),%eax
  800499:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049c:	eb 53                	jmp    8004f1 <vprintfmt+0x1e7>
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	ff 75 d8             	pushl  -0x28(%ebp)
  8004a4:	50                   	push   %eax
  8004a5:	e8 71 04 00 00       	call   80091b <strnlen>
  8004aa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ad:	29 c1                	sub    %eax,%ecx
  8004af:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  8004b2:	83 c4 10             	add    $0x10,%esp
  8004b5:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  8004b7:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  8004bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  8004be:	eb 0f                	jmp    8004cf <vprintfmt+0x1c5>
					putch(padc, putdat);
  8004c0:	83 ec 08             	sub    $0x8,%esp
  8004c3:	53                   	push   %ebx
  8004c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8004c7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c9:	83 ef 01             	sub    $0x1,%edi
  8004cc:	83 c4 10             	add    $0x10,%esp
  8004cf:	85 ff                	test   %edi,%edi
  8004d1:	7f ed                	jg     8004c0 <vprintfmt+0x1b6>
  8004d3:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8004d6:	85 c9                	test   %ecx,%ecx
  8004d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004dd:	0f 49 c1             	cmovns %ecx,%eax
  8004e0:	29 c1                	sub    %eax,%ecx
  8004e2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004e5:	eb aa                	jmp    800491 <vprintfmt+0x187>
					putch(ch, putdat);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	53                   	push   %ebx
  8004eb:	52                   	push   %edx
  8004ec:	ff d6                	call   *%esi
  8004ee:	83 c4 10             	add    $0x10,%esp
  8004f1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f4:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004f6:	83 c7 01             	add    $0x1,%edi
  8004f9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004fd:	0f be d0             	movsbl %al,%edx
  800500:	85 d2                	test   %edx,%edx
  800502:	74 4b                	je     80054f <vprintfmt+0x245>
  800504:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800508:	78 06                	js     800510 <vprintfmt+0x206>
  80050a:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  80050e:	78 1e                	js     80052e <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  800510:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800514:	74 d1                	je     8004e7 <vprintfmt+0x1dd>
  800516:	0f be c0             	movsbl %al,%eax
  800519:	83 e8 20             	sub    $0x20,%eax
  80051c:	83 f8 5e             	cmp    $0x5e,%eax
  80051f:	76 c6                	jbe    8004e7 <vprintfmt+0x1dd>
					putch('?', putdat);
  800521:	83 ec 08             	sub    $0x8,%esp
  800524:	53                   	push   %ebx
  800525:	6a 3f                	push   $0x3f
  800527:	ff d6                	call   *%esi
  800529:	83 c4 10             	add    $0x10,%esp
  80052c:	eb c3                	jmp    8004f1 <vprintfmt+0x1e7>
  80052e:	89 cf                	mov    %ecx,%edi
  800530:	eb 0e                	jmp    800540 <vprintfmt+0x236>
				putch(' ', putdat);
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	53                   	push   %ebx
  800536:	6a 20                	push   $0x20
  800538:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80053a:	83 ef 01             	sub    $0x1,%edi
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	85 ff                	test   %edi,%edi
  800542:	7f ee                	jg     800532 <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  800544:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
  80054a:	e9 01 02 00 00       	jmp    800750 <vprintfmt+0x446>
  80054f:	89 cf                	mov    %ecx,%edi
  800551:	eb ed                	jmp    800540 <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  800553:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800556:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  80055d:	e9 eb fd ff ff       	jmp    80034d <vprintfmt+0x43>
	if (lflag >= 2)
  800562:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800566:	7f 21                	jg     800589 <vprintfmt+0x27f>
	else if (lflag)
  800568:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80056c:	74 68                	je     8005d6 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8b 00                	mov    (%eax),%eax
  800573:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800576:	89 c1                	mov    %eax,%ecx
  800578:	c1 f9 1f             	sar    $0x1f,%ecx
  80057b:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8d 40 04             	lea    0x4(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
  800587:	eb 17                	jmp    8005a0 <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800589:	8b 45 14             	mov    0x14(%ebp),%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800594:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8d 40 08             	lea    0x8(%eax),%eax
  80059d:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005a0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a9:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  8005ac:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8005b0:	78 3f                	js     8005f1 <vprintfmt+0x2e7>
			base = 10;
  8005b2:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  8005b7:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  8005bb:	0f 84 71 01 00 00    	je     800732 <vprintfmt+0x428>
				putch('+', putdat);
  8005c1:	83 ec 08             	sub    $0x8,%esp
  8005c4:	53                   	push   %ebx
  8005c5:	6a 2b                	push   $0x2b
  8005c7:	ff d6                	call   *%esi
  8005c9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d1:	e9 5c 01 00 00       	jmp    800732 <vprintfmt+0x428>
		return va_arg(*ap, int);
  8005d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d9:	8b 00                	mov    (%eax),%eax
  8005db:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005de:	89 c1                	mov    %eax,%ecx
  8005e0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005e3:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8d 40 04             	lea    0x4(%eax),%eax
  8005ec:	89 45 14             	mov    %eax,0x14(%ebp)
  8005ef:	eb af                	jmp    8005a0 <vprintfmt+0x296>
				putch('-', putdat);
  8005f1:	83 ec 08             	sub    $0x8,%esp
  8005f4:	53                   	push   %ebx
  8005f5:	6a 2d                	push   $0x2d
  8005f7:	ff d6                	call   *%esi
				num = -(long long) num;
  8005f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005fc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005ff:	f7 d8                	neg    %eax
  800601:	83 d2 00             	adc    $0x0,%edx
  800604:	f7 da                	neg    %edx
  800606:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800609:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80060c:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80060f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800614:	e9 19 01 00 00       	jmp    800732 <vprintfmt+0x428>
	if (lflag >= 2)
  800619:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80061d:	7f 29                	jg     800648 <vprintfmt+0x33e>
	else if (lflag)
  80061f:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800623:	74 44                	je     800669 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  800625:	8b 45 14             	mov    0x14(%ebp),%eax
  800628:	8b 00                	mov    (%eax),%eax
  80062a:	ba 00 00 00 00       	mov    $0x0,%edx
  80062f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800632:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 40 04             	lea    0x4(%eax),%eax
  80063b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80063e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800643:	e9 ea 00 00 00       	jmp    800732 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 14             	mov    0x14(%ebp),%eax
  80064b:	8b 50 04             	mov    0x4(%eax),%edx
  80064e:	8b 00                	mov    (%eax),%eax
  800650:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800653:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800656:	8b 45 14             	mov    0x14(%ebp),%eax
  800659:	8d 40 08             	lea    0x8(%eax),%eax
  80065c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800664:	e9 c9 00 00 00       	jmp    800732 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8b 00                	mov    (%eax),%eax
  80066e:	ba 00 00 00 00       	mov    $0x0,%edx
  800673:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800676:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8d 40 04             	lea    0x4(%eax),%eax
  80067f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800682:	b8 0a 00 00 00       	mov    $0xa,%eax
  800687:	e9 a6 00 00 00       	jmp    800732 <vprintfmt+0x428>
			putch('0', putdat);
  80068c:	83 ec 08             	sub    $0x8,%esp
  80068f:	53                   	push   %ebx
  800690:	6a 30                	push   $0x30
  800692:	ff d6                	call   *%esi
	if (lflag >= 2)
  800694:	83 c4 10             	add    $0x10,%esp
  800697:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80069b:	7f 26                	jg     8006c3 <vprintfmt+0x3b9>
	else if (lflag)
  80069d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8006a1:	74 3e                	je     8006e1 <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  8006a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006bc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c1:	eb 6f                	jmp    800732 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8006c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c6:	8b 50 04             	mov    0x4(%eax),%edx
  8006c9:	8b 00                	mov    (%eax),%eax
  8006cb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ce:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d4:	8d 40 08             	lea    0x8(%eax),%eax
  8006d7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006da:	b8 08 00 00 00       	mov    $0x8,%eax
  8006df:	eb 51                	jmp    800732 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8006eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f4:	8d 40 04             	lea    0x4(%eax),%eax
  8006f7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006fa:	b8 08 00 00 00       	mov    $0x8,%eax
  8006ff:	eb 31                	jmp    800732 <vprintfmt+0x428>
			putch('0', putdat);
  800701:	83 ec 08             	sub    $0x8,%esp
  800704:	53                   	push   %ebx
  800705:	6a 30                	push   $0x30
  800707:	ff d6                	call   *%esi
			putch('x', putdat);
  800709:	83 c4 08             	add    $0x8,%esp
  80070c:	53                   	push   %ebx
  80070d:	6a 78                	push   $0x78
  80070f:	ff d6                	call   *%esi
			num = (unsigned long long)
  800711:	8b 45 14             	mov    0x14(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	ba 00 00 00 00       	mov    $0x0,%edx
  80071b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80071e:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  800721:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800724:	8b 45 14             	mov    0x14(%ebp),%eax
  800727:	8d 40 04             	lea    0x4(%eax),%eax
  80072a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80072d:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800732:	83 ec 0c             	sub    $0xc,%esp
  800735:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  800739:	52                   	push   %edx
  80073a:	ff 75 e0             	pushl  -0x20(%ebp)
  80073d:	50                   	push   %eax
  80073e:	ff 75 dc             	pushl  -0x24(%ebp)
  800741:	ff 75 d8             	pushl  -0x28(%ebp)
  800744:	89 da                	mov    %ebx,%edx
  800746:	89 f0                	mov    %esi,%eax
  800748:	e8 a4 fa ff ff       	call   8001f1 <printnum>
			break;
  80074d:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  800750:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	83 c7 01             	add    $0x1,%edi
  800756:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80075a:	83 f8 25             	cmp    $0x25,%eax
  80075d:	0f 84 be fb ff ff    	je     800321 <vprintfmt+0x17>
			if (ch == '\0')
  800763:	85 c0                	test   %eax,%eax
  800765:	0f 84 28 01 00 00    	je     800893 <vprintfmt+0x589>
			putch(ch, putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	53                   	push   %ebx
  80076f:	50                   	push   %eax
  800770:	ff d6                	call   *%esi
  800772:	83 c4 10             	add    $0x10,%esp
  800775:	eb dc                	jmp    800753 <vprintfmt+0x449>
	if (lflag >= 2)
  800777:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  80077b:	7f 26                	jg     8007a3 <vprintfmt+0x499>
	else if (lflag)
  80077d:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800781:	74 41                	je     8007c4 <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 14             	mov    0x14(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800790:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8d 40 04             	lea    0x4(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80079c:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a1:	eb 8f                	jmp    800732 <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 50 04             	mov    0x4(%eax),%edx
  8007a9:	8b 00                	mov    (%eax),%eax
  8007ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007ae:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b4:	8d 40 08             	lea    0x8(%eax),%eax
  8007b7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007ba:	b8 10 00 00 00       	mov    $0x10,%eax
  8007bf:	e9 6e ff ff ff       	jmp    800732 <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ce:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007d1:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8007d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d7:	8d 40 04             	lea    0x4(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007dd:	b8 10 00 00 00       	mov    $0x10,%eax
  8007e2:	e9 4b ff ff ff       	jmp    800732 <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	83 c0 04             	add    $0x4,%eax
  8007ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8007f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	85 c0                	test   %eax,%eax
  8007f7:	74 14                	je     80080d <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007f9:	8b 13                	mov    (%ebx),%edx
  8007fb:	83 fa 7f             	cmp    $0x7f,%edx
  8007fe:	7f 37                	jg     800837 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  800800:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  800802:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
  800808:	e9 43 ff ff ff       	jmp    800750 <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  80080d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800812:	bf 89 14 80 00       	mov    $0x801489,%edi
							putch(ch, putdat);
  800817:	83 ec 08             	sub    $0x8,%esp
  80081a:	53                   	push   %ebx
  80081b:	50                   	push   %eax
  80081c:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80081e:	83 c7 01             	add    $0x1,%edi
  800821:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	85 c0                	test   %eax,%eax
  80082a:	75 eb                	jne    800817 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  80082c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80082f:	89 45 14             	mov    %eax,0x14(%ebp)
  800832:	e9 19 ff ff ff       	jmp    800750 <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  800837:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  800839:	b8 0a 00 00 00       	mov    $0xa,%eax
  80083e:	bf c1 14 80 00       	mov    $0x8014c1,%edi
							putch(ch, putdat);
  800843:	83 ec 08             	sub    $0x8,%esp
  800846:	53                   	push   %ebx
  800847:	50                   	push   %eax
  800848:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  80084a:	83 c7 01             	add    $0x1,%edi
  80084d:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  800851:	83 c4 10             	add    $0x10,%esp
  800854:	85 c0                	test   %eax,%eax
  800856:	75 eb                	jne    800843 <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800858:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80085b:	89 45 14             	mov    %eax,0x14(%ebp)
  80085e:	e9 ed fe ff ff       	jmp    800750 <vprintfmt+0x446>
			putch(ch, putdat);
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	53                   	push   %ebx
  800867:	6a 25                	push   $0x25
  800869:	ff d6                	call   *%esi
			break;
  80086b:	83 c4 10             	add    $0x10,%esp
  80086e:	e9 dd fe ff ff       	jmp    800750 <vprintfmt+0x446>
			putch('%', putdat);
  800873:	83 ec 08             	sub    $0x8,%esp
  800876:	53                   	push   %ebx
  800877:	6a 25                	push   $0x25
  800879:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80087b:	83 c4 10             	add    $0x10,%esp
  80087e:	89 f8                	mov    %edi,%eax
  800880:	eb 03                	jmp    800885 <vprintfmt+0x57b>
  800882:	83 e8 01             	sub    $0x1,%eax
  800885:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800889:	75 f7                	jne    800882 <vprintfmt+0x578>
  80088b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80088e:	e9 bd fe ff ff       	jmp    800750 <vprintfmt+0x446>
}
  800893:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800896:	5b                   	pop    %ebx
  800897:	5e                   	pop    %esi
  800898:	5f                   	pop    %edi
  800899:	5d                   	pop    %ebp
  80089a:	c3                   	ret    

0080089b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80089b:	55                   	push   %ebp
  80089c:	89 e5                	mov    %esp,%ebp
  80089e:	83 ec 18             	sub    $0x18,%esp
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008aa:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008ae:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008b8:	85 c0                	test   %eax,%eax
  8008ba:	74 26                	je     8008e2 <vsnprintf+0x47>
  8008bc:	85 d2                	test   %edx,%edx
  8008be:	7e 22                	jle    8008e2 <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008c0:	ff 75 14             	pushl  0x14(%ebp)
  8008c3:	ff 75 10             	pushl  0x10(%ebp)
  8008c6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008c9:	50                   	push   %eax
  8008ca:	68 d0 02 80 00       	push   $0x8002d0
  8008cf:	e8 36 fa ff ff       	call   80030a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008d7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008dd:	83 c4 10             	add    $0x10,%esp
}
  8008e0:	c9                   	leave  
  8008e1:	c3                   	ret    
		return -E_INVAL;
  8008e2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008e7:	eb f7                	jmp    8008e0 <vsnprintf+0x45>

008008e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8008ef:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8008f2:	50                   	push   %eax
  8008f3:	ff 75 10             	pushl  0x10(%ebp)
  8008f6:	ff 75 0c             	pushl  0xc(%ebp)
  8008f9:	ff 75 08             	pushl  0x8(%ebp)
  8008fc:	e8 9a ff ff ff       	call   80089b <vsnprintf>
	va_end(ap);

	return rc;
}
  800901:	c9                   	leave  
  800902:	c3                   	ret    

00800903 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800903:	55                   	push   %ebp
  800904:	89 e5                	mov    %esp,%ebp
  800906:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800909:	b8 00 00 00 00       	mov    $0x0,%eax
  80090e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800912:	74 05                	je     800919 <strlen+0x16>
		n++;
  800914:	83 c0 01             	add    $0x1,%eax
  800917:	eb f5                	jmp    80090e <strlen+0xb>
	return n;
}
  800919:	5d                   	pop    %ebp
  80091a:	c3                   	ret    

0080091b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800924:	ba 00 00 00 00       	mov    $0x0,%edx
  800929:	39 c2                	cmp    %eax,%edx
  80092b:	74 0d                	je     80093a <strnlen+0x1f>
  80092d:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  800931:	74 05                	je     800938 <strnlen+0x1d>
		n++;
  800933:	83 c2 01             	add    $0x1,%edx
  800936:	eb f1                	jmp    800929 <strnlen+0xe>
  800938:	89 d0                	mov    %edx,%eax
	return n;
}
  80093a:	5d                   	pop    %ebp
  80093b:	c3                   	ret    

0080093c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	53                   	push   %ebx
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800946:	ba 00 00 00 00       	mov    $0x0,%edx
  80094b:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80094f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800952:	83 c2 01             	add    $0x1,%edx
  800955:	84 c9                	test   %cl,%cl
  800957:	75 f2                	jne    80094b <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800959:	5b                   	pop    %ebx
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <strcat>:

char *
strcat(char *dst, const char *src)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	53                   	push   %ebx
  800960:	83 ec 10             	sub    $0x10,%esp
  800963:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800966:	53                   	push   %ebx
  800967:	e8 97 ff ff ff       	call   800903 <strlen>
  80096c:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	01 d8                	add    %ebx,%eax
  800974:	50                   	push   %eax
  800975:	e8 c2 ff ff ff       	call   80093c <strcpy>
	return dst;
}
  80097a:	89 d8                	mov    %ebx,%eax
  80097c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80097f:	c9                   	leave  
  800980:	c3                   	ret    

00800981 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	56                   	push   %esi
  800985:	53                   	push   %ebx
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80098c:	89 c6                	mov    %eax,%esi
  80098e:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800991:	89 c2                	mov    %eax,%edx
  800993:	39 f2                	cmp    %esi,%edx
  800995:	74 11                	je     8009a8 <strncpy+0x27>
		*dst++ = *src;
  800997:	83 c2 01             	add    $0x1,%edx
  80099a:	0f b6 19             	movzbl (%ecx),%ebx
  80099d:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a0:	80 fb 01             	cmp    $0x1,%bl
  8009a3:	83 d9 ff             	sbb    $0xffffffff,%ecx
  8009a6:	eb eb                	jmp    800993 <strncpy+0x12>
	}
	return ret;
}
  8009a8:	5b                   	pop    %ebx
  8009a9:	5e                   	pop    %esi
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	56                   	push   %esi
  8009b0:	53                   	push   %ebx
  8009b1:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009b7:	8b 55 10             	mov    0x10(%ebp),%edx
  8009ba:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bc:	85 d2                	test   %edx,%edx
  8009be:	74 21                	je     8009e1 <strlcpy+0x35>
  8009c0:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  8009c4:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  8009c6:	39 c2                	cmp    %eax,%edx
  8009c8:	74 14                	je     8009de <strlcpy+0x32>
  8009ca:	0f b6 19             	movzbl (%ecx),%ebx
  8009cd:	84 db                	test   %bl,%bl
  8009cf:	74 0b                	je     8009dc <strlcpy+0x30>
			*dst++ = *src++;
  8009d1:	83 c1 01             	add    $0x1,%ecx
  8009d4:	83 c2 01             	add    $0x1,%edx
  8009d7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009da:	eb ea                	jmp    8009c6 <strlcpy+0x1a>
  8009dc:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  8009de:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e1:	29 f0                	sub    %esi,%eax
}
  8009e3:	5b                   	pop    %ebx
  8009e4:	5e                   	pop    %esi
  8009e5:	5d                   	pop    %ebp
  8009e6:	c3                   	ret    

008009e7 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e7:	55                   	push   %ebp
  8009e8:	89 e5                	mov    %esp,%ebp
  8009ea:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ed:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f0:	0f b6 01             	movzbl (%ecx),%eax
  8009f3:	84 c0                	test   %al,%al
  8009f5:	74 0c                	je     800a03 <strcmp+0x1c>
  8009f7:	3a 02                	cmp    (%edx),%al
  8009f9:	75 08                	jne    800a03 <strcmp+0x1c>
		p++, q++;
  8009fb:	83 c1 01             	add    $0x1,%ecx
  8009fe:	83 c2 01             	add    $0x1,%edx
  800a01:	eb ed                	jmp    8009f0 <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a03:	0f b6 c0             	movzbl %al,%eax
  800a06:	0f b6 12             	movzbl (%edx),%edx
  800a09:	29 d0                	sub    %edx,%eax
}
  800a0b:	5d                   	pop    %ebp
  800a0c:	c3                   	ret    

00800a0d <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	53                   	push   %ebx
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a17:	89 c3                	mov    %eax,%ebx
  800a19:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a1c:	eb 06                	jmp    800a24 <strncmp+0x17>
		n--, p++, q++;
  800a1e:	83 c0 01             	add    $0x1,%eax
  800a21:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  800a24:	39 d8                	cmp    %ebx,%eax
  800a26:	74 16                	je     800a3e <strncmp+0x31>
  800a28:	0f b6 08             	movzbl (%eax),%ecx
  800a2b:	84 c9                	test   %cl,%cl
  800a2d:	74 04                	je     800a33 <strncmp+0x26>
  800a2f:	3a 0a                	cmp    (%edx),%cl
  800a31:	74 eb                	je     800a1e <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a33:	0f b6 00             	movzbl (%eax),%eax
  800a36:	0f b6 12             	movzbl (%edx),%edx
  800a39:	29 d0                	sub    %edx,%eax
}
  800a3b:	5b                   	pop    %ebx
  800a3c:	5d                   	pop    %ebp
  800a3d:	c3                   	ret    
		return 0;
  800a3e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a43:	eb f6                	jmp    800a3b <strncmp+0x2e>

00800a45 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a45:	55                   	push   %ebp
  800a46:	89 e5                	mov    %esp,%ebp
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a4f:	0f b6 10             	movzbl (%eax),%edx
  800a52:	84 d2                	test   %dl,%dl
  800a54:	74 09                	je     800a5f <strchr+0x1a>
		if (*s == c)
  800a56:	38 ca                	cmp    %cl,%dl
  800a58:	74 0a                	je     800a64 <strchr+0x1f>
	for (; *s; s++)
  800a5a:	83 c0 01             	add    $0x1,%eax
  800a5d:	eb f0                	jmp    800a4f <strchr+0xa>
			return (char *) s;
	return 0;
  800a5f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a64:	5d                   	pop    %ebp
  800a65:	c3                   	ret    

00800a66 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a66:	55                   	push   %ebp
  800a67:	89 e5                	mov    %esp,%ebp
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a70:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a73:	38 ca                	cmp    %cl,%dl
  800a75:	74 09                	je     800a80 <strfind+0x1a>
  800a77:	84 d2                	test   %dl,%dl
  800a79:	74 05                	je     800a80 <strfind+0x1a>
	for (; *s; s++)
  800a7b:	83 c0 01             	add    $0x1,%eax
  800a7e:	eb f0                	jmp    800a70 <strfind+0xa>
			break;
	return (char *) s;
}
  800a80:	5d                   	pop    %ebp
  800a81:	c3                   	ret    

00800a82 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	57                   	push   %edi
  800a86:	56                   	push   %esi
  800a87:	53                   	push   %ebx
  800a88:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a8e:	85 c9                	test   %ecx,%ecx
  800a90:	74 31                	je     800ac3 <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a92:	89 f8                	mov    %edi,%eax
  800a94:	09 c8                	or     %ecx,%eax
  800a96:	a8 03                	test   $0x3,%al
  800a98:	75 23                	jne    800abd <memset+0x3b>
		c &= 0xFF;
  800a9a:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9e:	89 d3                	mov    %edx,%ebx
  800aa0:	c1 e3 08             	shl    $0x8,%ebx
  800aa3:	89 d0                	mov    %edx,%eax
  800aa5:	c1 e0 18             	shl    $0x18,%eax
  800aa8:	89 d6                	mov    %edx,%esi
  800aaa:	c1 e6 10             	shl    $0x10,%esi
  800aad:	09 f0                	or     %esi,%eax
  800aaf:	09 c2                	or     %eax,%edx
  800ab1:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800ab3:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab6:	89 d0                	mov    %edx,%eax
  800ab8:	fc                   	cld    
  800ab9:	f3 ab                	rep stos %eax,%es:(%edi)
  800abb:	eb 06                	jmp    800ac3 <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac0:	fc                   	cld    
  800ac1:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ac3:	89 f8                	mov    %edi,%eax
  800ac5:	5b                   	pop    %ebx
  800ac6:	5e                   	pop    %esi
  800ac7:	5f                   	pop    %edi
  800ac8:	5d                   	pop    %ebp
  800ac9:	c3                   	ret    

00800aca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800aca:	55                   	push   %ebp
  800acb:	89 e5                	mov    %esp,%ebp
  800acd:	57                   	push   %edi
  800ace:	56                   	push   %esi
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ad5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ad8:	39 c6                	cmp    %eax,%esi
  800ada:	73 32                	jae    800b0e <memmove+0x44>
  800adc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800adf:	39 c2                	cmp    %eax,%edx
  800ae1:	76 2b                	jbe    800b0e <memmove+0x44>
		s += n;
		d += n;
  800ae3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ae6:	89 fe                	mov    %edi,%esi
  800ae8:	09 ce                	or     %ecx,%esi
  800aea:	09 d6                	or     %edx,%esi
  800aec:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800af2:	75 0e                	jne    800b02 <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800af4:	83 ef 04             	sub    $0x4,%edi
  800af7:	8d 72 fc             	lea    -0x4(%edx),%esi
  800afa:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800afd:	fd                   	std    
  800afe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b00:	eb 09                	jmp    800b0b <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b02:	83 ef 01             	sub    $0x1,%edi
  800b05:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b08:	fd                   	std    
  800b09:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b0b:	fc                   	cld    
  800b0c:	eb 1a                	jmp    800b28 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b0e:	89 c2                	mov    %eax,%edx
  800b10:	09 ca                	or     %ecx,%edx
  800b12:	09 f2                	or     %esi,%edx
  800b14:	f6 c2 03             	test   $0x3,%dl
  800b17:	75 0a                	jne    800b23 <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b19:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1c:	89 c7                	mov    %eax,%edi
  800b1e:	fc                   	cld    
  800b1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b21:	eb 05                	jmp    800b28 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800b23:	89 c7                	mov    %eax,%edi
  800b25:	fc                   	cld    
  800b26:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b28:	5e                   	pop    %esi
  800b29:	5f                   	pop    %edi
  800b2a:	5d                   	pop    %ebp
  800b2b:	c3                   	ret    

00800b2c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b2c:	55                   	push   %ebp
  800b2d:	89 e5                	mov    %esp,%ebp
  800b2f:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b32:	ff 75 10             	pushl  0x10(%ebp)
  800b35:	ff 75 0c             	pushl  0xc(%ebp)
  800b38:	ff 75 08             	pushl  0x8(%ebp)
  800b3b:	e8 8a ff ff ff       	call   800aca <memmove>
}
  800b40:	c9                   	leave  
  800b41:	c3                   	ret    

00800b42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	56                   	push   %esi
  800b46:	53                   	push   %ebx
  800b47:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b4d:	89 c6                	mov    %eax,%esi
  800b4f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b52:	39 f0                	cmp    %esi,%eax
  800b54:	74 1c                	je     800b72 <memcmp+0x30>
		if (*s1 != *s2)
  800b56:	0f b6 08             	movzbl (%eax),%ecx
  800b59:	0f b6 1a             	movzbl (%edx),%ebx
  800b5c:	38 d9                	cmp    %bl,%cl
  800b5e:	75 08                	jne    800b68 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b60:	83 c0 01             	add    $0x1,%eax
  800b63:	83 c2 01             	add    $0x1,%edx
  800b66:	eb ea                	jmp    800b52 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b68:	0f b6 c1             	movzbl %cl,%eax
  800b6b:	0f b6 db             	movzbl %bl,%ebx
  800b6e:	29 d8                	sub    %ebx,%eax
  800b70:	eb 05                	jmp    800b77 <memcmp+0x35>
	}

	return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b77:	5b                   	pop    %ebx
  800b78:	5e                   	pop    %esi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b84:	89 c2                	mov    %eax,%edx
  800b86:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b89:	39 d0                	cmp    %edx,%eax
  800b8b:	73 09                	jae    800b96 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b8d:	38 08                	cmp    %cl,(%eax)
  800b8f:	74 05                	je     800b96 <memfind+0x1b>
	for (; s < ends; s++)
  800b91:	83 c0 01             	add    $0x1,%eax
  800b94:	eb f3                	jmp    800b89 <memfind+0xe>
			break;
	return (void *) s;
}
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	57                   	push   %edi
  800b9c:	56                   	push   %esi
  800b9d:	53                   	push   %ebx
  800b9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ba1:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ba4:	eb 03                	jmp    800ba9 <strtol+0x11>
		s++;
  800ba6:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800ba9:	0f b6 01             	movzbl (%ecx),%eax
  800bac:	3c 20                	cmp    $0x20,%al
  800bae:	74 f6                	je     800ba6 <strtol+0xe>
  800bb0:	3c 09                	cmp    $0x9,%al
  800bb2:	74 f2                	je     800ba6 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800bb4:	3c 2b                	cmp    $0x2b,%al
  800bb6:	74 2a                	je     800be2 <strtol+0x4a>
	int neg = 0;
  800bb8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800bbd:	3c 2d                	cmp    $0x2d,%al
  800bbf:	74 2b                	je     800bec <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc1:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800bc7:	75 0f                	jne    800bd8 <strtol+0x40>
  800bc9:	80 39 30             	cmpb   $0x30,(%ecx)
  800bcc:	74 28                	je     800bf6 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bce:	85 db                	test   %ebx,%ebx
  800bd0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bd5:	0f 44 d8             	cmove  %eax,%ebx
  800bd8:	b8 00 00 00 00       	mov    $0x0,%eax
  800bdd:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800be0:	eb 50                	jmp    800c32 <strtol+0x9a>
		s++;
  800be2:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800be5:	bf 00 00 00 00       	mov    $0x0,%edi
  800bea:	eb d5                	jmp    800bc1 <strtol+0x29>
		s++, neg = 1;
  800bec:	83 c1 01             	add    $0x1,%ecx
  800bef:	bf 01 00 00 00       	mov    $0x1,%edi
  800bf4:	eb cb                	jmp    800bc1 <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bfa:	74 0e                	je     800c0a <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800bfc:	85 db                	test   %ebx,%ebx
  800bfe:	75 d8                	jne    800bd8 <strtol+0x40>
		s++, base = 8;
  800c00:	83 c1 01             	add    $0x1,%ecx
  800c03:	bb 08 00 00 00       	mov    $0x8,%ebx
  800c08:	eb ce                	jmp    800bd8 <strtol+0x40>
		s += 2, base = 16;
  800c0a:	83 c1 02             	add    $0x2,%ecx
  800c0d:	bb 10 00 00 00       	mov    $0x10,%ebx
  800c12:	eb c4                	jmp    800bd8 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c14:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c17:	89 f3                	mov    %esi,%ebx
  800c19:	80 fb 19             	cmp    $0x19,%bl
  800c1c:	77 29                	ja     800c47 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800c1e:	0f be d2             	movsbl %dl,%edx
  800c21:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c24:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c27:	7d 30                	jge    800c59 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800c29:	83 c1 01             	add    $0x1,%ecx
  800c2c:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c30:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c32:	0f b6 11             	movzbl (%ecx),%edx
  800c35:	8d 72 d0             	lea    -0x30(%edx),%esi
  800c38:	89 f3                	mov    %esi,%ebx
  800c3a:	80 fb 09             	cmp    $0x9,%bl
  800c3d:	77 d5                	ja     800c14 <strtol+0x7c>
			dig = *s - '0';
  800c3f:	0f be d2             	movsbl %dl,%edx
  800c42:	83 ea 30             	sub    $0x30,%edx
  800c45:	eb dd                	jmp    800c24 <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800c47:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c4a:	89 f3                	mov    %esi,%ebx
  800c4c:	80 fb 19             	cmp    $0x19,%bl
  800c4f:	77 08                	ja     800c59 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800c51:	0f be d2             	movsbl %dl,%edx
  800c54:	83 ea 37             	sub    $0x37,%edx
  800c57:	eb cb                	jmp    800c24 <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5d:	74 05                	je     800c64 <strtol+0xcc>
		*endptr = (char *) s;
  800c5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c62:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c64:	89 c2                	mov    %eax,%edx
  800c66:	f7 da                	neg    %edx
  800c68:	85 ff                	test   %edi,%edi
  800c6a:	0f 45 c2             	cmovne %edx,%eax
}
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    

00800c72 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c72:	55                   	push   %ebp
  800c73:	89 e5                	mov    %esp,%ebp
  800c75:	57                   	push   %edi
  800c76:	56                   	push   %esi
  800c77:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c78:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800c80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c83:	89 c3                	mov    %eax,%ebx
  800c85:	89 c7                	mov    %eax,%edi
  800c87:	89 c6                	mov    %eax,%esi
  800c89:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c8b:	5b                   	pop    %ebx
  800c8c:	5e                   	pop    %esi
  800c8d:	5f                   	pop    %edi
  800c8e:	5d                   	pop    %ebp
  800c8f:	c3                   	ret    

00800c90 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c90:	55                   	push   %ebp
  800c91:	89 e5                	mov    %esp,%ebp
  800c93:	57                   	push   %edi
  800c94:	56                   	push   %esi
  800c95:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c96:	ba 00 00 00 00       	mov    $0x0,%edx
  800c9b:	b8 01 00 00 00       	mov    $0x1,%eax
  800ca0:	89 d1                	mov    %edx,%ecx
  800ca2:	89 d3                	mov    %edx,%ebx
  800ca4:	89 d7                	mov    %edx,%edi
  800ca6:	89 d6                	mov    %edx,%esi
  800ca8:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800caa:	5b                   	pop    %ebx
  800cab:	5e                   	pop    %esi
  800cac:	5f                   	pop    %edi
  800cad:	5d                   	pop    %ebp
  800cae:	c3                   	ret    

00800caf <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
  800cb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cc5:	89 cb                	mov    %ecx,%ebx
  800cc7:	89 cf                	mov    %ecx,%edi
  800cc9:	89 ce                	mov    %ecx,%esi
  800ccb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccd:	85 c0                	test   %eax,%eax
  800ccf:	7f 08                	jg     800cd9 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cd1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd4:	5b                   	pop    %ebx
  800cd5:	5e                   	pop    %esi
  800cd6:	5f                   	pop    %edi
  800cd7:	5d                   	pop    %ebp
  800cd8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cd9:	83 ec 0c             	sub    $0xc,%esp
  800cdc:	50                   	push   %eax
  800cdd:	6a 03                	push   $0x3
  800cdf:	68 e0 16 80 00       	push   $0x8016e0
  800ce4:	6a 43                	push   $0x43
  800ce6:	68 fd 16 80 00       	push   $0x8016fd
  800ceb:	e8 6c 03 00 00       	call   80105c <_panic>

00800cf0 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	57                   	push   %edi
  800cf4:	56                   	push   %esi
  800cf5:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf6:	ba 00 00 00 00       	mov    $0x0,%edx
  800cfb:	b8 02 00 00 00       	mov    $0x2,%eax
  800d00:	89 d1                	mov    %edx,%ecx
  800d02:	89 d3                	mov    %edx,%ebx
  800d04:	89 d7                	mov    %edx,%edi
  800d06:	89 d6                	mov    %edx,%esi
  800d08:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d0a:	5b                   	pop    %ebx
  800d0b:	5e                   	pop    %esi
  800d0c:	5f                   	pop    %edi
  800d0d:	5d                   	pop    %ebp
  800d0e:	c3                   	ret    

00800d0f <sys_yield>:

void
sys_yield(void)
{
  800d0f:	55                   	push   %ebp
  800d10:	89 e5                	mov    %esp,%ebp
  800d12:	57                   	push   %edi
  800d13:	56                   	push   %esi
  800d14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d15:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d1f:	89 d1                	mov    %edx,%ecx
  800d21:	89 d3                	mov    %edx,%ebx
  800d23:	89 d7                	mov    %edx,%edi
  800d25:	89 d6                	mov    %edx,%esi
  800d27:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    

00800d2e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d2e:	55                   	push   %ebp
  800d2f:	89 e5                	mov    %esp,%ebp
  800d31:	57                   	push   %edi
  800d32:	56                   	push   %esi
  800d33:	53                   	push   %ebx
  800d34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d37:	be 00 00 00 00       	mov    $0x0,%esi
  800d3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d42:	b8 04 00 00 00       	mov    $0x4,%eax
  800d47:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d4a:	89 f7                	mov    %esi,%edi
  800d4c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d4e:	85 c0                	test   %eax,%eax
  800d50:	7f 08                	jg     800d5a <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d55:	5b                   	pop    %ebx
  800d56:	5e                   	pop    %esi
  800d57:	5f                   	pop    %edi
  800d58:	5d                   	pop    %ebp
  800d59:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5a:	83 ec 0c             	sub    $0xc,%esp
  800d5d:	50                   	push   %eax
  800d5e:	6a 04                	push   $0x4
  800d60:	68 e0 16 80 00       	push   $0x8016e0
  800d65:	6a 43                	push   $0x43
  800d67:	68 fd 16 80 00       	push   $0x8016fd
  800d6c:	e8 eb 02 00 00       	call   80105c <_panic>

00800d71 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	57                   	push   %edi
  800d75:	56                   	push   %esi
  800d76:	53                   	push   %ebx
  800d77:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d80:	b8 05 00 00 00       	mov    $0x5,%eax
  800d85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d88:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d8b:	8b 75 18             	mov    0x18(%ebp),%esi
  800d8e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d90:	85 c0                	test   %eax,%eax
  800d92:	7f 08                	jg     800d9c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d97:	5b                   	pop    %ebx
  800d98:	5e                   	pop    %esi
  800d99:	5f                   	pop    %edi
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d9c:	83 ec 0c             	sub    $0xc,%esp
  800d9f:	50                   	push   %eax
  800da0:	6a 05                	push   $0x5
  800da2:	68 e0 16 80 00       	push   $0x8016e0
  800da7:	6a 43                	push   $0x43
  800da9:	68 fd 16 80 00       	push   $0x8016fd
  800dae:	e8 a9 02 00 00       	call   80105c <_panic>

00800db3 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	57                   	push   %edi
  800db7:	56                   	push   %esi
  800db8:	53                   	push   %ebx
  800db9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dbc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dc7:	b8 06 00 00 00       	mov    $0x6,%eax
  800dcc:	89 df                	mov    %ebx,%edi
  800dce:	89 de                	mov    %ebx,%esi
  800dd0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd2:	85 c0                	test   %eax,%eax
  800dd4:	7f 08                	jg     800dde <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800dd6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5e                   	pop    %esi
  800ddb:	5f                   	pop    %edi
  800ddc:	5d                   	pop    %ebp
  800ddd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dde:	83 ec 0c             	sub    $0xc,%esp
  800de1:	50                   	push   %eax
  800de2:	6a 06                	push   $0x6
  800de4:	68 e0 16 80 00       	push   $0x8016e0
  800de9:	6a 43                	push   $0x43
  800deb:	68 fd 16 80 00       	push   $0x8016fd
  800df0:	e8 67 02 00 00       	call   80105c <_panic>

00800df5 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dfe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e03:	8b 55 08             	mov    0x8(%ebp),%edx
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	b8 08 00 00 00       	mov    $0x8,%eax
  800e0e:	89 df                	mov    %ebx,%edi
  800e10:	89 de                	mov    %ebx,%esi
  800e12:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e14:	85 c0                	test   %eax,%eax
  800e16:	7f 08                	jg     800e20 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1b:	5b                   	pop    %ebx
  800e1c:	5e                   	pop    %esi
  800e1d:	5f                   	pop    %edi
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e20:	83 ec 0c             	sub    $0xc,%esp
  800e23:	50                   	push   %eax
  800e24:	6a 08                	push   $0x8
  800e26:	68 e0 16 80 00       	push   $0x8016e0
  800e2b:	6a 43                	push   $0x43
  800e2d:	68 fd 16 80 00       	push   $0x8016fd
  800e32:	e8 25 02 00 00       	call   80105c <_panic>

00800e37 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e37:	55                   	push   %ebp
  800e38:	89 e5                	mov    %esp,%ebp
  800e3a:	57                   	push   %edi
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e40:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4b:	b8 09 00 00 00       	mov    $0x9,%eax
  800e50:	89 df                	mov    %ebx,%edi
  800e52:	89 de                	mov    %ebx,%esi
  800e54:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e56:	85 c0                	test   %eax,%eax
  800e58:	7f 08                	jg     800e62 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e5a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	50                   	push   %eax
  800e66:	6a 09                	push   $0x9
  800e68:	68 e0 16 80 00       	push   $0x8016e0
  800e6d:	6a 43                	push   $0x43
  800e6f:	68 fd 16 80 00       	push   $0x8016fd
  800e74:	e8 e3 01 00 00       	call   80105c <_panic>

00800e79 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	57                   	push   %edi
  800e7d:	56                   	push   %esi
  800e7e:	53                   	push   %ebx
  800e7f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e87:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e8d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e92:	89 df                	mov    %ebx,%edi
  800e94:	89 de                	mov    %ebx,%esi
  800e96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e98:	85 c0                	test   %eax,%eax
  800e9a:	7f 08                	jg     800ea4 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5f                   	pop    %edi
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea4:	83 ec 0c             	sub    $0xc,%esp
  800ea7:	50                   	push   %eax
  800ea8:	6a 0a                	push   $0xa
  800eaa:	68 e0 16 80 00       	push   $0x8016e0
  800eaf:	6a 43                	push   $0x43
  800eb1:	68 fd 16 80 00       	push   $0x8016fd
  800eb6:	e8 a1 01 00 00       	call   80105c <_panic>

00800ebb <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ec1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec7:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ecc:	be 00 00 00 00       	mov    $0x0,%esi
  800ed1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed9:	5b                   	pop    %ebx
  800eda:	5e                   	pop    %esi
  800edb:	5f                   	pop    %edi
  800edc:	5d                   	pop    %ebp
  800edd:	c3                   	ret    

00800ede <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800ede:	55                   	push   %ebp
  800edf:	89 e5                	mov    %esp,%ebp
  800ee1:	57                   	push   %edi
  800ee2:	56                   	push   %esi
  800ee3:	53                   	push   %ebx
  800ee4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eec:	8b 55 08             	mov    0x8(%ebp),%edx
  800eef:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ef4:	89 cb                	mov    %ecx,%ebx
  800ef6:	89 cf                	mov    %ecx,%edi
  800ef8:	89 ce                	mov    %ecx,%esi
  800efa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800efc:	85 c0                	test   %eax,%eax
  800efe:	7f 08                	jg     800f08 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f03:	5b                   	pop    %ebx
  800f04:	5e                   	pop    %esi
  800f05:	5f                   	pop    %edi
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f08:	83 ec 0c             	sub    $0xc,%esp
  800f0b:	50                   	push   %eax
  800f0c:	6a 0d                	push   $0xd
  800f0e:	68 e0 16 80 00       	push   $0x8016e0
  800f13:	6a 43                	push   $0x43
  800f15:	68 fd 16 80 00       	push   $0x8016fd
  800f1a:	e8 3d 01 00 00       	call   80105c <_panic>

00800f1f <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	57                   	push   %edi
  800f23:	56                   	push   %esi
  800f24:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f25:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f2a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f30:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f35:	89 df                	mov    %ebx,%edi
  800f37:	89 de                	mov    %ebx,%esi
  800f39:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800f3b:	5b                   	pop    %ebx
  800f3c:	5e                   	pop    %esi
  800f3d:	5f                   	pop    %edi
  800f3e:	5d                   	pop    %ebp
  800f3f:	c3                   	ret    

00800f40 <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800f40:	55                   	push   %ebp
  800f41:	89 e5                	mov    %esp,%ebp
  800f43:	57                   	push   %edi
  800f44:	56                   	push   %esi
  800f45:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f53:	89 cb                	mov    %ecx,%ebx
  800f55:	89 cf                	mov    %ecx,%edi
  800f57:	89 ce                	mov    %ecx,%esi
  800f59:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f5b:	5b                   	pop    %ebx
  800f5c:	5e                   	pop    %esi
  800f5d:	5f                   	pop    %edi
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	56                   	push   %esi
  800f64:	53                   	push   %ebx
  800f65:	8b 75 08             	mov    0x8(%ebp),%esi
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	// cprintf("in %s\n", __FUNCTION__);
	int ret;
	if(!pg)
  800f6e:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  800f70:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  800f75:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  800f78:	83 ec 0c             	sub    $0xc,%esp
  800f7b:	50                   	push   %eax
  800f7c:	e8 5d ff ff ff       	call   800ede <sys_ipc_recv>
	if(ret < 0){
  800f81:	83 c4 10             	add    $0x10,%esp
  800f84:	85 c0                	test   %eax,%eax
  800f86:	78 2b                	js     800fb3 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  800f88:	85 f6                	test   %esi,%esi
  800f8a:	74 0a                	je     800f96 <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  800f8c:	a1 04 20 80 00       	mov    0x802004,%eax
  800f91:	8b 40 74             	mov    0x74(%eax),%eax
  800f94:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  800f96:	85 db                	test   %ebx,%ebx
  800f98:	74 0a                	je     800fa4 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  800f9a:	a1 04 20 80 00       	mov    0x802004,%eax
  800f9f:	8b 40 78             	mov    0x78(%eax),%eax
  800fa2:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  800fa4:	a1 04 20 80 00       	mov    0x802004,%eax
  800fa9:	8b 40 70             	mov    0x70(%eax),%eax
}
  800fac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800faf:	5b                   	pop    %ebx
  800fb0:	5e                   	pop    %esi
  800fb1:	5d                   	pop    %ebp
  800fb2:	c3                   	ret    
		if(from_env_store)
  800fb3:	85 f6                	test   %esi,%esi
  800fb5:	74 06                	je     800fbd <ipc_recv+0x5d>
			*from_env_store = 0;
  800fb7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  800fbd:	85 db                	test   %ebx,%ebx
  800fbf:	74 eb                	je     800fac <ipc_recv+0x4c>
			*perm_store = 0;
  800fc1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800fc7:	eb e3                	jmp    800fac <ipc_recv+0x4c>

00800fc9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  800fc9:	55                   	push   %ebp
  800fca:	89 e5                	mov    %esp,%ebp
  800fcc:	57                   	push   %edi
  800fcd:	56                   	push   %esi
  800fce:	53                   	push   %ebx
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fd5:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  800fdb:	85 db                	test   %ebx,%ebx
  800fdd:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  800fe2:	0f 44 d8             	cmove  %eax,%ebx
  800fe5:	eb 05                	jmp    800fec <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  800fe7:	e8 23 fd ff ff       	call   800d0f <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  800fec:	ff 75 14             	pushl  0x14(%ebp)
  800fef:	53                   	push   %ebx
  800ff0:	56                   	push   %esi
  800ff1:	57                   	push   %edi
  800ff2:	e8 c4 fe ff ff       	call   800ebb <sys_ipc_try_send>
  800ff7:	83 c4 10             	add    $0x10,%esp
  800ffa:	85 c0                	test   %eax,%eax
  800ffc:	74 1b                	je     801019 <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  800ffe:	79 e7                	jns    800fe7 <ipc_send+0x1e>
  801000:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801003:	74 e2                	je     800fe7 <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  801005:	83 ec 04             	sub    $0x4,%esp
  801008:	68 0b 17 80 00       	push   $0x80170b
  80100d:	6a 49                	push   $0x49
  80100f:	68 20 17 80 00       	push   $0x801720
  801014:	e8 43 00 00 00       	call   80105c <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  801019:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80101c:	5b                   	pop    %ebx
  80101d:	5e                   	pop    %esi
  80101e:	5f                   	pop    %edi
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801027:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80102c:	89 c2                	mov    %eax,%edx
  80102e:	c1 e2 07             	shl    $0x7,%edx
  801031:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  801037:	8b 52 50             	mov    0x50(%edx),%edx
  80103a:	39 ca                	cmp    %ecx,%edx
  80103c:	74 11                	je     80104f <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  80103e:	83 c0 01             	add    $0x1,%eax
  801041:	3d 00 04 00 00       	cmp    $0x400,%eax
  801046:	75 e4                	jne    80102c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801048:	b8 00 00 00 00       	mov    $0x0,%eax
  80104d:	eb 0b                	jmp    80105a <ipc_find_env+0x39>
			return envs[i].env_id;
  80104f:	c1 e0 07             	shl    $0x7,%eax
  801052:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801057:	8b 40 48             	mov    0x48(%eax),%eax
}
  80105a:	5d                   	pop    %ebp
  80105b:	c3                   	ret    

0080105c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  801061:	a1 04 20 80 00       	mov    0x802004,%eax
  801066:	8b 40 48             	mov    0x48(%eax),%eax
  801069:	83 ec 04             	sub    $0x4,%esp
  80106c:	68 5c 17 80 00       	push   $0x80175c
  801071:	50                   	push   %eax
  801072:	68 2a 17 80 00       	push   $0x80172a
  801077:	e8 61 f1 ff ff       	call   8001dd <cprintf>
	va_list ap;

	va_start(ap, fmt);
  80107c:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  80107f:	8b 35 00 20 80 00    	mov    0x802000,%esi
  801085:	e8 66 fc ff ff       	call   800cf0 <sys_getenvid>
  80108a:	83 c4 04             	add    $0x4,%esp
  80108d:	ff 75 0c             	pushl  0xc(%ebp)
  801090:	ff 75 08             	pushl  0x8(%ebp)
  801093:	56                   	push   %esi
  801094:	50                   	push   %eax
  801095:	68 38 17 80 00       	push   $0x801738
  80109a:	e8 3e f1 ff ff       	call   8001dd <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  80109f:	83 c4 18             	add    $0x18,%esp
  8010a2:	53                   	push   %ebx
  8010a3:	ff 75 10             	pushl  0x10(%ebp)
  8010a6:	e8 e1 f0 ff ff       	call   80018c <vcprintf>
	cprintf("\n");
  8010ab:	c7 04 24 1e 17 80 00 	movl   $0x80171e,(%esp)
  8010b2:	e8 26 f1 ff ff       	call   8001dd <cprintf>
  8010b7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8010ba:	cc                   	int3   
  8010bb:	eb fd                	jmp    8010ba <_panic+0x5e>
  8010bd:	66 90                	xchg   %ax,%ax
  8010bf:	90                   	nop

008010c0 <__udivdi3>:
  8010c0:	55                   	push   %ebp
  8010c1:	57                   	push   %edi
  8010c2:	56                   	push   %esi
  8010c3:	53                   	push   %ebx
  8010c4:	83 ec 1c             	sub    $0x1c,%esp
  8010c7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8010cb:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8010cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8010d3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8010d7:	85 d2                	test   %edx,%edx
  8010d9:	75 4d                	jne    801128 <__udivdi3+0x68>
  8010db:	39 f3                	cmp    %esi,%ebx
  8010dd:	76 19                	jbe    8010f8 <__udivdi3+0x38>
  8010df:	31 ff                	xor    %edi,%edi
  8010e1:	89 e8                	mov    %ebp,%eax
  8010e3:	89 f2                	mov    %esi,%edx
  8010e5:	f7 f3                	div    %ebx
  8010e7:	89 fa                	mov    %edi,%edx
  8010e9:	83 c4 1c             	add    $0x1c,%esp
  8010ec:	5b                   	pop    %ebx
  8010ed:	5e                   	pop    %esi
  8010ee:	5f                   	pop    %edi
  8010ef:	5d                   	pop    %ebp
  8010f0:	c3                   	ret    
  8010f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8010f8:	89 d9                	mov    %ebx,%ecx
  8010fa:	85 db                	test   %ebx,%ebx
  8010fc:	75 0b                	jne    801109 <__udivdi3+0x49>
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
  801103:	31 d2                	xor    %edx,%edx
  801105:	f7 f3                	div    %ebx
  801107:	89 c1                	mov    %eax,%ecx
  801109:	31 d2                	xor    %edx,%edx
  80110b:	89 f0                	mov    %esi,%eax
  80110d:	f7 f1                	div    %ecx
  80110f:	89 c6                	mov    %eax,%esi
  801111:	89 e8                	mov    %ebp,%eax
  801113:	89 f7                	mov    %esi,%edi
  801115:	f7 f1                	div    %ecx
  801117:	89 fa                	mov    %edi,%edx
  801119:	83 c4 1c             	add    $0x1c,%esp
  80111c:	5b                   	pop    %ebx
  80111d:	5e                   	pop    %esi
  80111e:	5f                   	pop    %edi
  80111f:	5d                   	pop    %ebp
  801120:	c3                   	ret    
  801121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801128:	39 f2                	cmp    %esi,%edx
  80112a:	77 1c                	ja     801148 <__udivdi3+0x88>
  80112c:	0f bd fa             	bsr    %edx,%edi
  80112f:	83 f7 1f             	xor    $0x1f,%edi
  801132:	75 2c                	jne    801160 <__udivdi3+0xa0>
  801134:	39 f2                	cmp    %esi,%edx
  801136:	72 06                	jb     80113e <__udivdi3+0x7e>
  801138:	31 c0                	xor    %eax,%eax
  80113a:	39 eb                	cmp    %ebp,%ebx
  80113c:	77 a9                	ja     8010e7 <__udivdi3+0x27>
  80113e:	b8 01 00 00 00       	mov    $0x1,%eax
  801143:	eb a2                	jmp    8010e7 <__udivdi3+0x27>
  801145:	8d 76 00             	lea    0x0(%esi),%esi
  801148:	31 ff                	xor    %edi,%edi
  80114a:	31 c0                	xor    %eax,%eax
  80114c:	89 fa                	mov    %edi,%edx
  80114e:	83 c4 1c             	add    $0x1c,%esp
  801151:	5b                   	pop    %ebx
  801152:	5e                   	pop    %esi
  801153:	5f                   	pop    %edi
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    
  801156:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80115d:	8d 76 00             	lea    0x0(%esi),%esi
  801160:	89 f9                	mov    %edi,%ecx
  801162:	b8 20 00 00 00       	mov    $0x20,%eax
  801167:	29 f8                	sub    %edi,%eax
  801169:	d3 e2                	shl    %cl,%edx
  80116b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80116f:	89 c1                	mov    %eax,%ecx
  801171:	89 da                	mov    %ebx,%edx
  801173:	d3 ea                	shr    %cl,%edx
  801175:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801179:	09 d1                	or     %edx,%ecx
  80117b:	89 f2                	mov    %esi,%edx
  80117d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801181:	89 f9                	mov    %edi,%ecx
  801183:	d3 e3                	shl    %cl,%ebx
  801185:	89 c1                	mov    %eax,%ecx
  801187:	d3 ea                	shr    %cl,%edx
  801189:	89 f9                	mov    %edi,%ecx
  80118b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80118f:	89 eb                	mov    %ebp,%ebx
  801191:	d3 e6                	shl    %cl,%esi
  801193:	89 c1                	mov    %eax,%ecx
  801195:	d3 eb                	shr    %cl,%ebx
  801197:	09 de                	or     %ebx,%esi
  801199:	89 f0                	mov    %esi,%eax
  80119b:	f7 74 24 08          	divl   0x8(%esp)
  80119f:	89 d6                	mov    %edx,%esi
  8011a1:	89 c3                	mov    %eax,%ebx
  8011a3:	f7 64 24 0c          	mull   0xc(%esp)
  8011a7:	39 d6                	cmp    %edx,%esi
  8011a9:	72 15                	jb     8011c0 <__udivdi3+0x100>
  8011ab:	89 f9                	mov    %edi,%ecx
  8011ad:	d3 e5                	shl    %cl,%ebp
  8011af:	39 c5                	cmp    %eax,%ebp
  8011b1:	73 04                	jae    8011b7 <__udivdi3+0xf7>
  8011b3:	39 d6                	cmp    %edx,%esi
  8011b5:	74 09                	je     8011c0 <__udivdi3+0x100>
  8011b7:	89 d8                	mov    %ebx,%eax
  8011b9:	31 ff                	xor    %edi,%edi
  8011bb:	e9 27 ff ff ff       	jmp    8010e7 <__udivdi3+0x27>
  8011c0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8011c3:	31 ff                	xor    %edi,%edi
  8011c5:	e9 1d ff ff ff       	jmp    8010e7 <__udivdi3+0x27>
  8011ca:	66 90                	xchg   %ax,%ax
  8011cc:	66 90                	xchg   %ax,%ax
  8011ce:	66 90                	xchg   %ax,%ax

008011d0 <__umoddi3>:
  8011d0:	55                   	push   %ebp
  8011d1:	57                   	push   %edi
  8011d2:	56                   	push   %esi
  8011d3:	53                   	push   %ebx
  8011d4:	83 ec 1c             	sub    $0x1c,%esp
  8011d7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8011db:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8011df:	8b 74 24 30          	mov    0x30(%esp),%esi
  8011e3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8011e7:	89 da                	mov    %ebx,%edx
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	75 43                	jne    801230 <__umoddi3+0x60>
  8011ed:	39 df                	cmp    %ebx,%edi
  8011ef:	76 17                	jbe    801208 <__umoddi3+0x38>
  8011f1:	89 f0                	mov    %esi,%eax
  8011f3:	f7 f7                	div    %edi
  8011f5:	89 d0                	mov    %edx,%eax
  8011f7:	31 d2                	xor    %edx,%edx
  8011f9:	83 c4 1c             	add    $0x1c,%esp
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    
  801201:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  801208:	89 fd                	mov    %edi,%ebp
  80120a:	85 ff                	test   %edi,%edi
  80120c:	75 0b                	jne    801219 <__umoddi3+0x49>
  80120e:	b8 01 00 00 00       	mov    $0x1,%eax
  801213:	31 d2                	xor    %edx,%edx
  801215:	f7 f7                	div    %edi
  801217:	89 c5                	mov    %eax,%ebp
  801219:	89 d8                	mov    %ebx,%eax
  80121b:	31 d2                	xor    %edx,%edx
  80121d:	f7 f5                	div    %ebp
  80121f:	89 f0                	mov    %esi,%eax
  801221:	f7 f5                	div    %ebp
  801223:	89 d0                	mov    %edx,%eax
  801225:	eb d0                	jmp    8011f7 <__umoddi3+0x27>
  801227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80122e:	66 90                	xchg   %ax,%ax
  801230:	89 f1                	mov    %esi,%ecx
  801232:	39 d8                	cmp    %ebx,%eax
  801234:	76 0a                	jbe    801240 <__umoddi3+0x70>
  801236:	89 f0                	mov    %esi,%eax
  801238:	83 c4 1c             	add    $0x1c,%esp
  80123b:	5b                   	pop    %ebx
  80123c:	5e                   	pop    %esi
  80123d:	5f                   	pop    %edi
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    
  801240:	0f bd e8             	bsr    %eax,%ebp
  801243:	83 f5 1f             	xor    $0x1f,%ebp
  801246:	75 20                	jne    801268 <__umoddi3+0x98>
  801248:	39 d8                	cmp    %ebx,%eax
  80124a:	0f 82 b0 00 00 00    	jb     801300 <__umoddi3+0x130>
  801250:	39 f7                	cmp    %esi,%edi
  801252:	0f 86 a8 00 00 00    	jbe    801300 <__umoddi3+0x130>
  801258:	89 c8                	mov    %ecx,%eax
  80125a:	83 c4 1c             	add    $0x1c,%esp
  80125d:	5b                   	pop    %ebx
  80125e:	5e                   	pop    %esi
  80125f:	5f                   	pop    %edi
  801260:	5d                   	pop    %ebp
  801261:	c3                   	ret    
  801262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  801268:	89 e9                	mov    %ebp,%ecx
  80126a:	ba 20 00 00 00       	mov    $0x20,%edx
  80126f:	29 ea                	sub    %ebp,%edx
  801271:	d3 e0                	shl    %cl,%eax
  801273:	89 44 24 08          	mov    %eax,0x8(%esp)
  801277:	89 d1                	mov    %edx,%ecx
  801279:	89 f8                	mov    %edi,%eax
  80127b:	d3 e8                	shr    %cl,%eax
  80127d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801281:	89 54 24 04          	mov    %edx,0x4(%esp)
  801285:	8b 54 24 04          	mov    0x4(%esp),%edx
  801289:	09 c1                	or     %eax,%ecx
  80128b:	89 d8                	mov    %ebx,%eax
  80128d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801291:	89 e9                	mov    %ebp,%ecx
  801293:	d3 e7                	shl    %cl,%edi
  801295:	89 d1                	mov    %edx,%ecx
  801297:	d3 e8                	shr    %cl,%eax
  801299:	89 e9                	mov    %ebp,%ecx
  80129b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80129f:	d3 e3                	shl    %cl,%ebx
  8012a1:	89 c7                	mov    %eax,%edi
  8012a3:	89 d1                	mov    %edx,%ecx
  8012a5:	89 f0                	mov    %esi,%eax
  8012a7:	d3 e8                	shr    %cl,%eax
  8012a9:	89 e9                	mov    %ebp,%ecx
  8012ab:	89 fa                	mov    %edi,%edx
  8012ad:	d3 e6                	shl    %cl,%esi
  8012af:	09 d8                	or     %ebx,%eax
  8012b1:	f7 74 24 08          	divl   0x8(%esp)
  8012b5:	89 d1                	mov    %edx,%ecx
  8012b7:	89 f3                	mov    %esi,%ebx
  8012b9:	f7 64 24 0c          	mull   0xc(%esp)
  8012bd:	89 c6                	mov    %eax,%esi
  8012bf:	89 d7                	mov    %edx,%edi
  8012c1:	39 d1                	cmp    %edx,%ecx
  8012c3:	72 06                	jb     8012cb <__umoddi3+0xfb>
  8012c5:	75 10                	jne    8012d7 <__umoddi3+0x107>
  8012c7:	39 c3                	cmp    %eax,%ebx
  8012c9:	73 0c                	jae    8012d7 <__umoddi3+0x107>
  8012cb:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8012cf:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8012d3:	89 d7                	mov    %edx,%edi
  8012d5:	89 c6                	mov    %eax,%esi
  8012d7:	89 ca                	mov    %ecx,%edx
  8012d9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8012de:	29 f3                	sub    %esi,%ebx
  8012e0:	19 fa                	sbb    %edi,%edx
  8012e2:	89 d0                	mov    %edx,%eax
  8012e4:	d3 e0                	shl    %cl,%eax
  8012e6:	89 e9                	mov    %ebp,%ecx
  8012e8:	d3 eb                	shr    %cl,%ebx
  8012ea:	d3 ea                	shr    %cl,%edx
  8012ec:	09 d8                	or     %ebx,%eax
  8012ee:	83 c4 1c             	add    $0x1c,%esp
  8012f1:	5b                   	pop    %ebx
  8012f2:	5e                   	pop    %esi
  8012f3:	5f                   	pop    %edi
  8012f4:	5d                   	pop    %ebp
  8012f5:	c3                   	ret    
  8012f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8012fd:	8d 76 00             	lea    0x0(%esi),%esi
  801300:	89 da                	mov    %ebx,%edx
  801302:	29 fe                	sub    %edi,%esi
  801304:	19 c2                	sbb    %eax,%edx
  801306:	89 f1                	mov    %esi,%ecx
  801308:	89 c8                	mov    %ecx,%eax
  80130a:	e9 4b ff ff ff       	jmp    80125a <__umoddi3+0x8a>
