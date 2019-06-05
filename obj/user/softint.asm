
obj/user/softint.debug:     file format elf32-i386


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
  80002c:	e8 05 00 00 00       	call   800036 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
	asm volatile("int $14");	// page fault
  800033:	cd 0e                	int    $0xe
}
  800035:	c3                   	ret    

00800036 <libmain>:
        return &envs[ENVX(sys_getenvid())];
} 

void
libmain(int argc, char **argv)
{
  800036:	55                   	push   %ebp
  800037:	89 e5                	mov    %esp,%ebp
  800039:	57                   	push   %edi
  80003a:	56                   	push   %esi
  80003b:	53                   	push   %ebx
  80003c:	83 ec 0c             	sub    $0xc,%esp
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	thisenv = 0;
  80003f:	c7 05 08 40 80 00 00 	movl   $0x0,0x804008
  800046:	00 00 00 
	envid_t find = sys_getenvid();
  800049:	e8 4c 0c 00 00       	call   800c9a <sys_getenvid>
  80004e:	8b 1d 08 40 80 00    	mov    0x804008,%ebx
  800054:	be 00 00 00 00       	mov    $0x0,%esi
	for(int i = 0; i < NENV; i++){
  800059:	ba 00 00 00 00       	mov    $0x0,%edx
		if(envs[i].env_id == find)
  80005e:	bf 01 00 00 00       	mov    $0x1,%edi
  800063:	eb 0b                	jmp    800070 <libmain+0x3a>
	for(int i = 0; i < NENV; i++){
  800065:	83 c2 01             	add    $0x1,%edx
  800068:	81 fa 00 04 00 00    	cmp    $0x400,%edx
  80006e:	74 21                	je     800091 <libmain+0x5b>
		if(envs[i].env_id == find)
  800070:	89 d1                	mov    %edx,%ecx
  800072:	c1 e1 07             	shl    $0x7,%ecx
  800075:	81 c1 00 00 c0 ee    	add    $0xeec00000,%ecx
  80007b:	8b 49 48             	mov    0x48(%ecx),%ecx
  80007e:	39 c1                	cmp    %eax,%ecx
  800080:	75 e3                	jne    800065 <libmain+0x2f>
  800082:	89 d3                	mov    %edx,%ebx
  800084:	c1 e3 07             	shl    $0x7,%ebx
  800087:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
  80008d:	89 fe                	mov    %edi,%esi
  80008f:	eb d4                	jmp    800065 <libmain+0x2f>
  800091:	89 f0                	mov    %esi,%eax
  800093:	84 c0                	test   %al,%al
  800095:	74 06                	je     80009d <libmain+0x67>
  800097:	89 1d 08 40 80 00    	mov    %ebx,0x804008
			thisenv = &envs[i];
	}

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80009d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8000a1:	7e 0a                	jle    8000ad <libmain+0x77>
		binaryname = argv[0];
  8000a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a6:	8b 00                	mov    (%eax),%eax
  8000a8:	a3 00 30 80 00       	mov    %eax,0x803000

	cprintf("in libmain.c call umain!\n");
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	68 00 25 80 00       	push   $0x802500
  8000b5:	e8 cd 00 00 00       	call   800187 <cprintf>
	// call user main routine
	umain(argc, argv);
  8000ba:	83 c4 08             	add    $0x8,%esp
  8000bd:	ff 75 0c             	pushl  0xc(%ebp)
  8000c0:	ff 75 08             	pushl  0x8(%ebp)
  8000c3:	e8 6b ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000c8:	e8 0b 00 00 00       	call   8000d8 <exit>
}
  8000cd:	83 c4 10             	add    $0x10,%esp
  8000d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000d3:	5b                   	pop    %ebx
  8000d4:	5e                   	pop    %esi
  8000d5:	5f                   	pop    %edi
  8000d6:	5d                   	pop    %ebp
  8000d7:	c3                   	ret    

008000d8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000de:	e8 a2 10 00 00       	call   801185 <close_all>
	sys_env_destroy(0);
  8000e3:	83 ec 0c             	sub    $0xc,%esp
  8000e6:	6a 00                	push   $0x0
  8000e8:	e8 6c 0b 00 00       	call   800c59 <sys_env_destroy>
}
  8000ed:	83 c4 10             	add    $0x10,%esp
  8000f0:	c9                   	leave  
  8000f1:	c3                   	ret    

008000f2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000f2:	55                   	push   %ebp
  8000f3:	89 e5                	mov    %esp,%ebp
  8000f5:	53                   	push   %ebx
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000fc:	8b 13                	mov    (%ebx),%edx
  8000fe:	8d 42 01             	lea    0x1(%edx),%eax
  800101:	89 03                	mov    %eax,(%ebx)
  800103:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800106:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80010a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80010f:	74 09                	je     80011a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800111:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800115:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800118:	c9                   	leave  
  800119:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80011a:	83 ec 08             	sub    $0x8,%esp
  80011d:	68 ff 00 00 00       	push   $0xff
  800122:	8d 43 08             	lea    0x8(%ebx),%eax
  800125:	50                   	push   %eax
  800126:	e8 f1 0a 00 00       	call   800c1c <sys_cputs>
		b->idx = 0;
  80012b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	eb db                	jmp    800111 <putch+0x1f>

00800136 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800136:	55                   	push   %ebp
  800137:	89 e5                	mov    %esp,%ebp
  800139:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80013f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800146:	00 00 00 
	b.cnt = 0;
  800149:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800150:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800153:	ff 75 0c             	pushl  0xc(%ebp)
  800156:	ff 75 08             	pushl  0x8(%ebp)
  800159:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80015f:	50                   	push   %eax
  800160:	68 f2 00 80 00       	push   $0x8000f2
  800165:	e8 4a 01 00 00       	call   8002b4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80016a:	83 c4 08             	add    $0x8,%esp
  80016d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800173:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800179:	50                   	push   %eax
  80017a:	e8 9d 0a 00 00       	call   800c1c <sys_cputs>

	return b.cnt;
}
  80017f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800185:	c9                   	leave  
  800186:	c3                   	ret    

00800187 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800187:	55                   	push   %ebp
  800188:	89 e5                	mov    %esp,%ebp
  80018a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80018d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800190:	50                   	push   %eax
  800191:	ff 75 08             	pushl  0x8(%ebp)
  800194:	e8 9d ff ff ff       	call   800136 <vcprintf>
	va_end(ap);

	return cnt;
}
  800199:	c9                   	leave  
  80019a:	c3                   	ret    

0080019b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	57                   	push   %edi
  80019f:	56                   	push   %esi
  8001a0:	53                   	push   %ebx
  8001a1:	83 ec 1c             	sub    $0x1c,%esp
  8001a4:	89 c6                	mov    %eax,%esi
  8001a6:	89 d7                	mov    %edx,%edi
  8001a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001b1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001b7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001ba:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001be:	74 2c                	je     8001ec <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001c0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001cd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001d0:	39 c2                	cmp    %eax,%edx
  8001d2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001d5:	73 43                	jae    80021a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001d7:	83 eb 01             	sub    $0x1,%ebx
  8001da:	85 db                	test   %ebx,%ebx
  8001dc:	7e 6c                	jle    80024a <printnum+0xaf>
				putch(padc, putdat);
  8001de:	83 ec 08             	sub    $0x8,%esp
  8001e1:	57                   	push   %edi
  8001e2:	ff 75 18             	pushl  0x18(%ebp)
  8001e5:	ff d6                	call   *%esi
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	eb eb                	jmp    8001d7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	6a 20                	push   $0x20
  8001f1:	6a 00                	push   $0x0
  8001f3:	50                   	push   %eax
  8001f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001fa:	89 fa                	mov    %edi,%edx
  8001fc:	89 f0                	mov    %esi,%eax
  8001fe:	e8 98 ff ff ff       	call   80019b <printnum>
		while (--width > 0)
  800203:	83 c4 20             	add    $0x20,%esp
  800206:	83 eb 01             	sub    $0x1,%ebx
  800209:	85 db                	test   %ebx,%ebx
  80020b:	7e 65                	jle    800272 <printnum+0xd7>
			putch(padc, putdat);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	57                   	push   %edi
  800211:	6a 20                	push   $0x20
  800213:	ff d6                	call   *%esi
  800215:	83 c4 10             	add    $0x10,%esp
  800218:	eb ec                	jmp    800206 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	ff 75 18             	pushl  0x18(%ebp)
  800220:	83 eb 01             	sub    $0x1,%ebx
  800223:	53                   	push   %ebx
  800224:	50                   	push   %eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	ff 75 dc             	pushl  -0x24(%ebp)
  80022b:	ff 75 d8             	pushl  -0x28(%ebp)
  80022e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800231:	ff 75 e0             	pushl  -0x20(%ebp)
  800234:	e8 67 20 00 00       	call   8022a0 <__udivdi3>
  800239:	83 c4 18             	add    $0x18,%esp
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	89 fa                	mov    %edi,%edx
  800240:	89 f0                	mov    %esi,%eax
  800242:	e8 54 ff ff ff       	call   80019b <printnum>
  800247:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	57                   	push   %edi
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	ff 75 dc             	pushl  -0x24(%ebp)
  800254:	ff 75 d8             	pushl  -0x28(%ebp)
  800257:	ff 75 e4             	pushl  -0x1c(%ebp)
  80025a:	ff 75 e0             	pushl  -0x20(%ebp)
  80025d:	e8 4e 21 00 00       	call   8023b0 <__umoddi3>
  800262:	83 c4 14             	add    $0x14,%esp
  800265:	0f be 80 24 25 80 00 	movsbl 0x802524(%eax),%eax
  80026c:	50                   	push   %eax
  80026d:	ff d6                	call   *%esi
  80026f:	83 c4 10             	add    $0x10,%esp
	}
}
  800272:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800275:	5b                   	pop    %ebx
  800276:	5e                   	pop    %esi
  800277:	5f                   	pop    %edi
  800278:	5d                   	pop    %ebp
  800279:	c3                   	ret    

0080027a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80027a:	55                   	push   %ebp
  80027b:	89 e5                	mov    %esp,%ebp
  80027d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800280:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800284:	8b 10                	mov    (%eax),%edx
  800286:	3b 50 04             	cmp    0x4(%eax),%edx
  800289:	73 0a                	jae    800295 <sprintputch+0x1b>
		*b->buf++ = ch;
  80028b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80028e:	89 08                	mov    %ecx,(%eax)
  800290:	8b 45 08             	mov    0x8(%ebp),%eax
  800293:	88 02                	mov    %al,(%edx)
}
  800295:	5d                   	pop    %ebp
  800296:	c3                   	ret    

00800297 <printfmt>:
{
  800297:	55                   	push   %ebp
  800298:	89 e5                	mov    %esp,%ebp
  80029a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80029d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002a0:	50                   	push   %eax
  8002a1:	ff 75 10             	pushl  0x10(%ebp)
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	e8 05 00 00 00       	call   8002b4 <vprintfmt>
}
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	c9                   	leave  
  8002b3:	c3                   	ret    

008002b4 <vprintfmt>:
{
  8002b4:	55                   	push   %ebp
  8002b5:	89 e5                	mov    %esp,%ebp
  8002b7:	57                   	push   %edi
  8002b8:	56                   	push   %esi
  8002b9:	53                   	push   %ebx
  8002ba:	83 ec 3c             	sub    $0x3c,%esp
  8002bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8002c0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002c6:	e9 32 04 00 00       	jmp    8006fd <vprintfmt+0x449>
		padc = ' ';
  8002cb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002cf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002d6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002dd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002e4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002eb:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002f2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002f7:	8d 47 01             	lea    0x1(%edi),%eax
  8002fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002fd:	0f b6 17             	movzbl (%edi),%edx
  800300:	8d 42 dd             	lea    -0x23(%edx),%eax
  800303:	3c 55                	cmp    $0x55,%al
  800305:	0f 87 12 05 00 00    	ja     80081d <vprintfmt+0x569>
  80030b:	0f b6 c0             	movzbl %al,%eax
  80030e:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800315:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800318:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80031c:	eb d9                	jmp    8002f7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80031e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800321:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800325:	eb d0                	jmp    8002f7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800327:	0f b6 d2             	movzbl %dl,%edx
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80032d:	b8 00 00 00 00       	mov    $0x0,%eax
  800332:	89 75 08             	mov    %esi,0x8(%ebp)
  800335:	eb 03                	jmp    80033a <vprintfmt+0x86>
  800337:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80033a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80033d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800341:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800344:	8d 72 d0             	lea    -0x30(%edx),%esi
  800347:	83 fe 09             	cmp    $0x9,%esi
  80034a:	76 eb                	jbe    800337 <vprintfmt+0x83>
  80034c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034f:	8b 75 08             	mov    0x8(%ebp),%esi
  800352:	eb 14                	jmp    800368 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800354:	8b 45 14             	mov    0x14(%ebp),%eax
  800357:	8b 00                	mov    (%eax),%eax
  800359:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80035c:	8b 45 14             	mov    0x14(%ebp),%eax
  80035f:	8d 40 04             	lea    0x4(%eax),%eax
  800362:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800365:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800368:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80036c:	79 89                	jns    8002f7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80036e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800371:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800374:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80037b:	e9 77 ff ff ff       	jmp    8002f7 <vprintfmt+0x43>
  800380:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800383:	85 c0                	test   %eax,%eax
  800385:	0f 48 c1             	cmovs  %ecx,%eax
  800388:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80038b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80038e:	e9 64 ff ff ff       	jmp    8002f7 <vprintfmt+0x43>
  800393:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800396:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80039d:	e9 55 ff ff ff       	jmp    8002f7 <vprintfmt+0x43>
			lflag++;
  8003a2:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003a9:	e9 49 ff ff ff       	jmp    8002f7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	8d 78 04             	lea    0x4(%eax),%edi
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	53                   	push   %ebx
  8003b8:	ff 30                	pushl  (%eax)
  8003ba:	ff d6                	call   *%esi
			break;
  8003bc:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003bf:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003c2:	e9 33 03 00 00       	jmp    8006fa <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ca:	8d 78 04             	lea    0x4(%eax),%edi
  8003cd:	8b 00                	mov    (%eax),%eax
  8003cf:	99                   	cltd   
  8003d0:	31 d0                	xor    %edx,%eax
  8003d2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003d4:	83 f8 10             	cmp    $0x10,%eax
  8003d7:	7f 23                	jg     8003fc <vprintfmt+0x148>
  8003d9:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003e0:	85 d2                	test   %edx,%edx
  8003e2:	74 18                	je     8003fc <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003e4:	52                   	push   %edx
  8003e5:	68 79 29 80 00       	push   $0x802979
  8003ea:	53                   	push   %ebx
  8003eb:	56                   	push   %esi
  8003ec:	e8 a6 fe ff ff       	call   800297 <printfmt>
  8003f1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003f7:	e9 fe 02 00 00       	jmp    8006fa <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003fc:	50                   	push   %eax
  8003fd:	68 3c 25 80 00       	push   $0x80253c
  800402:	53                   	push   %ebx
  800403:	56                   	push   %esi
  800404:	e8 8e fe ff ff       	call   800297 <printfmt>
  800409:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80040c:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80040f:	e9 e6 02 00 00       	jmp    8006fa <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800414:	8b 45 14             	mov    0x14(%ebp),%eax
  800417:	83 c0 04             	add    $0x4,%eax
  80041a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80041d:	8b 45 14             	mov    0x14(%ebp),%eax
  800420:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800422:	85 c9                	test   %ecx,%ecx
  800424:	b8 35 25 80 00       	mov    $0x802535,%eax
  800429:	0f 45 c1             	cmovne %ecx,%eax
  80042c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80042f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800433:	7e 06                	jle    80043b <vprintfmt+0x187>
  800435:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800439:	75 0d                	jne    800448 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80043b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80043e:	89 c7                	mov    %eax,%edi
  800440:	03 45 e0             	add    -0x20(%ebp),%eax
  800443:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800446:	eb 53                	jmp    80049b <vprintfmt+0x1e7>
  800448:	83 ec 08             	sub    $0x8,%esp
  80044b:	ff 75 d8             	pushl  -0x28(%ebp)
  80044e:	50                   	push   %eax
  80044f:	e8 71 04 00 00       	call   8008c5 <strnlen>
  800454:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800457:	29 c1                	sub    %eax,%ecx
  800459:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80045c:	83 c4 10             	add    $0x10,%esp
  80045f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800461:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800465:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800468:	eb 0f                	jmp    800479 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80046a:	83 ec 08             	sub    $0x8,%esp
  80046d:	53                   	push   %ebx
  80046e:	ff 75 e0             	pushl  -0x20(%ebp)
  800471:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800473:	83 ef 01             	sub    $0x1,%edi
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	85 ff                	test   %edi,%edi
  80047b:	7f ed                	jg     80046a <vprintfmt+0x1b6>
  80047d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800480:	85 c9                	test   %ecx,%ecx
  800482:	b8 00 00 00 00       	mov    $0x0,%eax
  800487:	0f 49 c1             	cmovns %ecx,%eax
  80048a:	29 c1                	sub    %eax,%ecx
  80048c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80048f:	eb aa                	jmp    80043b <vprintfmt+0x187>
					putch(ch, putdat);
  800491:	83 ec 08             	sub    $0x8,%esp
  800494:	53                   	push   %ebx
  800495:	52                   	push   %edx
  800496:	ff d6                	call   *%esi
  800498:	83 c4 10             	add    $0x10,%esp
  80049b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80049e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004a0:	83 c7 01             	add    $0x1,%edi
  8004a3:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8004a7:	0f be d0             	movsbl %al,%edx
  8004aa:	85 d2                	test   %edx,%edx
  8004ac:	74 4b                	je     8004f9 <vprintfmt+0x245>
  8004ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004b2:	78 06                	js     8004ba <vprintfmt+0x206>
  8004b4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004b8:	78 1e                	js     8004d8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004ba:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004be:	74 d1                	je     800491 <vprintfmt+0x1dd>
  8004c0:	0f be c0             	movsbl %al,%eax
  8004c3:	83 e8 20             	sub    $0x20,%eax
  8004c6:	83 f8 5e             	cmp    $0x5e,%eax
  8004c9:	76 c6                	jbe    800491 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	53                   	push   %ebx
  8004cf:	6a 3f                	push   $0x3f
  8004d1:	ff d6                	call   *%esi
  8004d3:	83 c4 10             	add    $0x10,%esp
  8004d6:	eb c3                	jmp    80049b <vprintfmt+0x1e7>
  8004d8:	89 cf                	mov    %ecx,%edi
  8004da:	eb 0e                	jmp    8004ea <vprintfmt+0x236>
				putch(' ', putdat);
  8004dc:	83 ec 08             	sub    $0x8,%esp
  8004df:	53                   	push   %ebx
  8004e0:	6a 20                	push   $0x20
  8004e2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e4:	83 ef 01             	sub    $0x1,%edi
  8004e7:	83 c4 10             	add    $0x10,%esp
  8004ea:	85 ff                	test   %edi,%edi
  8004ec:	7f ee                	jg     8004dc <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ee:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f4:	e9 01 02 00 00       	jmp    8006fa <vprintfmt+0x446>
  8004f9:	89 cf                	mov    %ecx,%edi
  8004fb:	eb ed                	jmp    8004ea <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004fd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  800500:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  800507:	e9 eb fd ff ff       	jmp    8002f7 <vprintfmt+0x43>
	if (lflag >= 2)
  80050c:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800510:	7f 21                	jg     800533 <vprintfmt+0x27f>
	else if (lflag)
  800512:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800516:	74 68                	je     800580 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8b 00                	mov    (%eax),%eax
  80051d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800520:	89 c1                	mov    %eax,%ecx
  800522:	c1 f9 1f             	sar    $0x1f,%ecx
  800525:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800528:	8b 45 14             	mov    0x14(%ebp),%eax
  80052b:	8d 40 04             	lea    0x4(%eax),%eax
  80052e:	89 45 14             	mov    %eax,0x14(%ebp)
  800531:	eb 17                	jmp    80054a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800533:	8b 45 14             	mov    0x14(%ebp),%eax
  800536:	8b 50 04             	mov    0x4(%eax),%edx
  800539:	8b 00                	mov    (%eax),%eax
  80053b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80053e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 40 08             	lea    0x8(%eax),%eax
  800547:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80054a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80054d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800550:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800553:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800556:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80055a:	78 3f                	js     80059b <vprintfmt+0x2e7>
			base = 10;
  80055c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800561:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800565:	0f 84 71 01 00 00    	je     8006dc <vprintfmt+0x428>
				putch('+', putdat);
  80056b:	83 ec 08             	sub    $0x8,%esp
  80056e:	53                   	push   %ebx
  80056f:	6a 2b                	push   $0x2b
  800571:	ff d6                	call   *%esi
  800573:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800576:	b8 0a 00 00 00       	mov    $0xa,%eax
  80057b:	e9 5c 01 00 00       	jmp    8006dc <vprintfmt+0x428>
		return va_arg(*ap, int);
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8b 00                	mov    (%eax),%eax
  800585:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800588:	89 c1                	mov    %eax,%ecx
  80058a:	c1 f9 1f             	sar    $0x1f,%ecx
  80058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800590:	8b 45 14             	mov    0x14(%ebp),%eax
  800593:	8d 40 04             	lea    0x4(%eax),%eax
  800596:	89 45 14             	mov    %eax,0x14(%ebp)
  800599:	eb af                	jmp    80054a <vprintfmt+0x296>
				putch('-', putdat);
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	53                   	push   %ebx
  80059f:	6a 2d                	push   $0x2d
  8005a1:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8005a9:	f7 d8                	neg    %eax
  8005ab:	83 d2 00             	adc    $0x0,%edx
  8005ae:	f7 da                	neg    %edx
  8005b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005b6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005be:	e9 19 01 00 00       	jmp    8006dc <vprintfmt+0x428>
	if (lflag >= 2)
  8005c3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005c7:	7f 29                	jg     8005f2 <vprintfmt+0x33e>
	else if (lflag)
  8005c9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005cd:	74 44                	je     800613 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005dc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 40 04             	lea    0x4(%eax),%eax
  8005e5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ed:	e9 ea 00 00 00       	jmp    8006dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f5:	8b 50 04             	mov    0x4(%eax),%edx
  8005f8:	8b 00                	mov    (%eax),%eax
  8005fa:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005fd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800600:	8b 45 14             	mov    0x14(%ebp),%eax
  800603:	8d 40 08             	lea    0x8(%eax),%eax
  800606:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800609:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060e:	e9 c9 00 00 00       	jmp    8006dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8b 00                	mov    (%eax),%eax
  800618:	ba 00 00 00 00       	mov    $0x0,%edx
  80061d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800620:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800623:	8b 45 14             	mov    0x14(%ebp),%eax
  800626:	8d 40 04             	lea    0x4(%eax),%eax
  800629:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80062c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800631:	e9 a6 00 00 00       	jmp    8006dc <vprintfmt+0x428>
			putch('0', putdat);
  800636:	83 ec 08             	sub    $0x8,%esp
  800639:	53                   	push   %ebx
  80063a:	6a 30                	push   $0x30
  80063c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80063e:	83 c4 10             	add    $0x10,%esp
  800641:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800645:	7f 26                	jg     80066d <vprintfmt+0x3b9>
	else if (lflag)
  800647:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80064b:	74 3e                	je     80068b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	ba 00 00 00 00       	mov    $0x0,%edx
  800657:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80065a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8d 40 04             	lea    0x4(%eax),%eax
  800663:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800666:	b8 08 00 00 00       	mov    $0x8,%eax
  80066b:	eb 6f                	jmp    8006dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	8b 50 04             	mov    0x4(%eax),%edx
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800678:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8d 40 08             	lea    0x8(%eax),%eax
  800681:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800684:	b8 08 00 00 00       	mov    $0x8,%eax
  800689:	eb 51                	jmp    8006dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8b 00                	mov    (%eax),%eax
  800690:	ba 00 00 00 00       	mov    $0x0,%edx
  800695:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800698:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80069b:	8b 45 14             	mov    0x14(%ebp),%eax
  80069e:	8d 40 04             	lea    0x4(%eax),%eax
  8006a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a9:	eb 31                	jmp    8006dc <vprintfmt+0x428>
			putch('0', putdat);
  8006ab:	83 ec 08             	sub    $0x8,%esp
  8006ae:	53                   	push   %ebx
  8006af:	6a 30                	push   $0x30
  8006b1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006b3:	83 c4 08             	add    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	6a 78                	push   $0x78
  8006b9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006cb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006dc:	83 ec 0c             	sub    $0xc,%esp
  8006df:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006e3:	52                   	push   %edx
  8006e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8006eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8006ee:	89 da                	mov    %ebx,%edx
  8006f0:	89 f0                	mov    %esi,%eax
  8006f2:	e8 a4 fa ff ff       	call   80019b <printnum>
			break;
  8006f7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006fd:	83 c7 01             	add    $0x1,%edi
  800700:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800704:	83 f8 25             	cmp    $0x25,%eax
  800707:	0f 84 be fb ff ff    	je     8002cb <vprintfmt+0x17>
			if (ch == '\0')
  80070d:	85 c0                	test   %eax,%eax
  80070f:	0f 84 28 01 00 00    	je     80083d <vprintfmt+0x589>
			putch(ch, putdat);
  800715:	83 ec 08             	sub    $0x8,%esp
  800718:	53                   	push   %ebx
  800719:	50                   	push   %eax
  80071a:	ff d6                	call   *%esi
  80071c:	83 c4 10             	add    $0x10,%esp
  80071f:	eb dc                	jmp    8006fd <vprintfmt+0x449>
	if (lflag >= 2)
  800721:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800725:	7f 26                	jg     80074d <vprintfmt+0x499>
	else if (lflag)
  800727:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80072b:	74 41                	je     80076e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8b 00                	mov    (%eax),%eax
  800732:	ba 00 00 00 00       	mov    $0x0,%edx
  800737:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80073a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8d 40 04             	lea    0x4(%eax),%eax
  800743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800746:	b8 10 00 00 00       	mov    $0x10,%eax
  80074b:	eb 8f                	jmp    8006dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80074d:	8b 45 14             	mov    0x14(%ebp),%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800758:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80075b:	8b 45 14             	mov    0x14(%ebp),%eax
  80075e:	8d 40 08             	lea    0x8(%eax),%eax
  800761:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800764:	b8 10 00 00 00       	mov    $0x10,%eax
  800769:	e9 6e ff ff ff       	jmp    8006dc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	ba 00 00 00 00       	mov    $0x0,%edx
  800778:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80077b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80077e:	8b 45 14             	mov    0x14(%ebp),%eax
  800781:	8d 40 04             	lea    0x4(%eax),%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800787:	b8 10 00 00 00       	mov    $0x10,%eax
  80078c:	e9 4b ff ff ff       	jmp    8006dc <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800791:	8b 45 14             	mov    0x14(%ebp),%eax
  800794:	83 c0 04             	add    $0x4,%eax
  800797:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80079a:	8b 45 14             	mov    0x14(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	85 c0                	test   %eax,%eax
  8007a1:	74 14                	je     8007b7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  8007a3:	8b 13                	mov    (%ebx),%edx
  8007a5:	83 fa 7f             	cmp    $0x7f,%edx
  8007a8:	7f 37                	jg     8007e1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  8007aa:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  8007ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
  8007b2:	e9 43 ff ff ff       	jmp    8006fa <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007b7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007bc:	bf 59 26 80 00       	mov    $0x802659,%edi
							putch(ch, putdat);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	53                   	push   %ebx
  8007c5:	50                   	push   %eax
  8007c6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007c8:	83 c7 01             	add    $0x1,%edi
  8007cb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007cf:	83 c4 10             	add    $0x10,%esp
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	75 eb                	jne    8007c1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	e9 19 ff ff ff       	jmp    8006fa <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007e1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007e3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e8:	bf 91 26 80 00       	mov    $0x802691,%edi
							putch(ch, putdat);
  8007ed:	83 ec 08             	sub    $0x8,%esp
  8007f0:	53                   	push   %ebx
  8007f1:	50                   	push   %eax
  8007f2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007f4:	83 c7 01             	add    $0x1,%edi
  8007f7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007fb:	83 c4 10             	add    $0x10,%esp
  8007fe:	85 c0                	test   %eax,%eax
  800800:	75 eb                	jne    8007ed <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  800802:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800805:	89 45 14             	mov    %eax,0x14(%ebp)
  800808:	e9 ed fe ff ff       	jmp    8006fa <vprintfmt+0x446>
			putch(ch, putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	6a 25                	push   $0x25
  800813:	ff d6                	call   *%esi
			break;
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	e9 dd fe ff ff       	jmp    8006fa <vprintfmt+0x446>
			putch('%', putdat);
  80081d:	83 ec 08             	sub    $0x8,%esp
  800820:	53                   	push   %ebx
  800821:	6a 25                	push   $0x25
  800823:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	89 f8                	mov    %edi,%eax
  80082a:	eb 03                	jmp    80082f <vprintfmt+0x57b>
  80082c:	83 e8 01             	sub    $0x1,%eax
  80082f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800833:	75 f7                	jne    80082c <vprintfmt+0x578>
  800835:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800838:	e9 bd fe ff ff       	jmp    8006fa <vprintfmt+0x446>
}
  80083d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800840:	5b                   	pop    %ebx
  800841:	5e                   	pop    %esi
  800842:	5f                   	pop    %edi
  800843:	5d                   	pop    %ebp
  800844:	c3                   	ret    

00800845 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800845:	55                   	push   %ebp
  800846:	89 e5                	mov    %esp,%ebp
  800848:	83 ec 18             	sub    $0x18,%esp
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800851:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800854:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800858:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80085b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800862:	85 c0                	test   %eax,%eax
  800864:	74 26                	je     80088c <vsnprintf+0x47>
  800866:	85 d2                	test   %edx,%edx
  800868:	7e 22                	jle    80088c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80086a:	ff 75 14             	pushl  0x14(%ebp)
  80086d:	ff 75 10             	pushl  0x10(%ebp)
  800870:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800873:	50                   	push   %eax
  800874:	68 7a 02 80 00       	push   $0x80027a
  800879:	e8 36 fa ff ff       	call   8002b4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80087e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800881:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800887:	83 c4 10             	add    $0x10,%esp
}
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    
		return -E_INVAL;
  80088c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800891:	eb f7                	jmp    80088a <vsnprintf+0x45>

00800893 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800893:	55                   	push   %ebp
  800894:	89 e5                	mov    %esp,%ebp
  800896:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800899:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80089c:	50                   	push   %eax
  80089d:	ff 75 10             	pushl  0x10(%ebp)
  8008a0:	ff 75 0c             	pushl  0xc(%ebp)
  8008a3:	ff 75 08             	pushl  0x8(%ebp)
  8008a6:	e8 9a ff ff ff       	call   800845 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    

008008ad <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8008ad:	55                   	push   %ebp
  8008ae:	89 e5                	mov    %esp,%ebp
  8008b0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008b8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008bc:	74 05                	je     8008c3 <strlen+0x16>
		n++;
  8008be:	83 c0 01             	add    $0x1,%eax
  8008c1:	eb f5                	jmp    8008b8 <strlen+0xb>
	return n;
}
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8008d3:	39 c2                	cmp    %eax,%edx
  8008d5:	74 0d                	je     8008e4 <strnlen+0x1f>
  8008d7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008db:	74 05                	je     8008e2 <strnlen+0x1d>
		n++;
  8008dd:	83 c2 01             	add    $0x1,%edx
  8008e0:	eb f1                	jmp    8008d3 <strnlen+0xe>
  8008e2:	89 d0                	mov    %edx,%eax
	return n;
}
  8008e4:	5d                   	pop    %ebp
  8008e5:	c3                   	ret    

008008e6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
  8008e9:	53                   	push   %ebx
  8008ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008f0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008f9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008fc:	83 c2 01             	add    $0x1,%edx
  8008ff:	84 c9                	test   %cl,%cl
  800901:	75 f2                	jne    8008f5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800903:	5b                   	pop    %ebx
  800904:	5d                   	pop    %ebp
  800905:	c3                   	ret    

00800906 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	53                   	push   %ebx
  80090a:	83 ec 10             	sub    $0x10,%esp
  80090d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800910:	53                   	push   %ebx
  800911:	e8 97 ff ff ff       	call   8008ad <strlen>
  800916:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	01 d8                	add    %ebx,%eax
  80091e:	50                   	push   %eax
  80091f:	e8 c2 ff ff ff       	call   8008e6 <strcpy>
	return dst;
}
  800924:	89 d8                	mov    %ebx,%eax
  800926:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800929:	c9                   	leave  
  80092a:	c3                   	ret    

0080092b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	56                   	push   %esi
  80092f:	53                   	push   %ebx
  800930:	8b 45 08             	mov    0x8(%ebp),%eax
  800933:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800936:	89 c6                	mov    %eax,%esi
  800938:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80093b:	89 c2                	mov    %eax,%edx
  80093d:	39 f2                	cmp    %esi,%edx
  80093f:	74 11                	je     800952 <strncpy+0x27>
		*dst++ = *src;
  800941:	83 c2 01             	add    $0x1,%edx
  800944:	0f b6 19             	movzbl (%ecx),%ebx
  800947:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80094a:	80 fb 01             	cmp    $0x1,%bl
  80094d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800950:	eb eb                	jmp    80093d <strncpy+0x12>
	}
	return ret;
}
  800952:	5b                   	pop    %ebx
  800953:	5e                   	pop    %esi
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    

00800956 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800956:	55                   	push   %ebp
  800957:	89 e5                	mov    %esp,%ebp
  800959:	56                   	push   %esi
  80095a:	53                   	push   %ebx
  80095b:	8b 75 08             	mov    0x8(%ebp),%esi
  80095e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800961:	8b 55 10             	mov    0x10(%ebp),%edx
  800964:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800966:	85 d2                	test   %edx,%edx
  800968:	74 21                	je     80098b <strlcpy+0x35>
  80096a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80096e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800970:	39 c2                	cmp    %eax,%edx
  800972:	74 14                	je     800988 <strlcpy+0x32>
  800974:	0f b6 19             	movzbl (%ecx),%ebx
  800977:	84 db                	test   %bl,%bl
  800979:	74 0b                	je     800986 <strlcpy+0x30>
			*dst++ = *src++;
  80097b:	83 c1 01             	add    $0x1,%ecx
  80097e:	83 c2 01             	add    $0x1,%edx
  800981:	88 5a ff             	mov    %bl,-0x1(%edx)
  800984:	eb ea                	jmp    800970 <strlcpy+0x1a>
  800986:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800988:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80098b:	29 f0                	sub    %esi,%eax
}
  80098d:	5b                   	pop    %ebx
  80098e:	5e                   	pop    %esi
  80098f:	5d                   	pop    %ebp
  800990:	c3                   	ret    

00800991 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800991:	55                   	push   %ebp
  800992:	89 e5                	mov    %esp,%ebp
  800994:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800997:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80099a:	0f b6 01             	movzbl (%ecx),%eax
  80099d:	84 c0                	test   %al,%al
  80099f:	74 0c                	je     8009ad <strcmp+0x1c>
  8009a1:	3a 02                	cmp    (%edx),%al
  8009a3:	75 08                	jne    8009ad <strcmp+0x1c>
		p++, q++;
  8009a5:	83 c1 01             	add    $0x1,%ecx
  8009a8:	83 c2 01             	add    $0x1,%edx
  8009ab:	eb ed                	jmp    80099a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009ad:	0f b6 c0             	movzbl %al,%eax
  8009b0:	0f b6 12             	movzbl (%edx),%edx
  8009b3:	29 d0                	sub    %edx,%eax
}
  8009b5:	5d                   	pop    %ebp
  8009b6:	c3                   	ret    

008009b7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	53                   	push   %ebx
  8009bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c1:	89 c3                	mov    %eax,%ebx
  8009c3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009c6:	eb 06                	jmp    8009ce <strncmp+0x17>
		n--, p++, q++;
  8009c8:	83 c0 01             	add    $0x1,%eax
  8009cb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009ce:	39 d8                	cmp    %ebx,%eax
  8009d0:	74 16                	je     8009e8 <strncmp+0x31>
  8009d2:	0f b6 08             	movzbl (%eax),%ecx
  8009d5:	84 c9                	test   %cl,%cl
  8009d7:	74 04                	je     8009dd <strncmp+0x26>
  8009d9:	3a 0a                	cmp    (%edx),%cl
  8009db:	74 eb                	je     8009c8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009dd:	0f b6 00             	movzbl (%eax),%eax
  8009e0:	0f b6 12             	movzbl (%edx),%edx
  8009e3:	29 d0                	sub    %edx,%eax
}
  8009e5:	5b                   	pop    %ebx
  8009e6:	5d                   	pop    %ebp
  8009e7:	c3                   	ret    
		return 0;
  8009e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ed:	eb f6                	jmp    8009e5 <strncmp+0x2e>

008009ef <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009f9:	0f b6 10             	movzbl (%eax),%edx
  8009fc:	84 d2                	test   %dl,%dl
  8009fe:	74 09                	je     800a09 <strchr+0x1a>
		if (*s == c)
  800a00:	38 ca                	cmp    %cl,%dl
  800a02:	74 0a                	je     800a0e <strchr+0x1f>
	for (; *s; s++)
  800a04:	83 c0 01             	add    $0x1,%eax
  800a07:	eb f0                	jmp    8009f9 <strchr+0xa>
			return (char *) s;
	return 0;
  800a09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a0e:	5d                   	pop    %ebp
  800a0f:	c3                   	ret    

00800a10 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a1a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a1d:	38 ca                	cmp    %cl,%dl
  800a1f:	74 09                	je     800a2a <strfind+0x1a>
  800a21:	84 d2                	test   %dl,%dl
  800a23:	74 05                	je     800a2a <strfind+0x1a>
	for (; *s; s++)
  800a25:	83 c0 01             	add    $0x1,%eax
  800a28:	eb f0                	jmp    800a1a <strfind+0xa>
			break;
	return (char *) s;
}
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    

00800a2c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a2c:	55                   	push   %ebp
  800a2d:	89 e5                	mov    %esp,%ebp
  800a2f:	57                   	push   %edi
  800a30:	56                   	push   %esi
  800a31:	53                   	push   %ebx
  800a32:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a38:	85 c9                	test   %ecx,%ecx
  800a3a:	74 31                	je     800a6d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a3c:	89 f8                	mov    %edi,%eax
  800a3e:	09 c8                	or     %ecx,%eax
  800a40:	a8 03                	test   $0x3,%al
  800a42:	75 23                	jne    800a67 <memset+0x3b>
		c &= 0xFF;
  800a44:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a48:	89 d3                	mov    %edx,%ebx
  800a4a:	c1 e3 08             	shl    $0x8,%ebx
  800a4d:	89 d0                	mov    %edx,%eax
  800a4f:	c1 e0 18             	shl    $0x18,%eax
  800a52:	89 d6                	mov    %edx,%esi
  800a54:	c1 e6 10             	shl    $0x10,%esi
  800a57:	09 f0                	or     %esi,%eax
  800a59:	09 c2                	or     %eax,%edx
  800a5b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a5d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a60:	89 d0                	mov    %edx,%eax
  800a62:	fc                   	cld    
  800a63:	f3 ab                	rep stos %eax,%es:(%edi)
  800a65:	eb 06                	jmp    800a6d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a6a:	fc                   	cld    
  800a6b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a6d:	89 f8                	mov    %edi,%eax
  800a6f:	5b                   	pop    %ebx
  800a70:	5e                   	pop    %esi
  800a71:	5f                   	pop    %edi
  800a72:	5d                   	pop    %ebp
  800a73:	c3                   	ret    

00800a74 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	57                   	push   %edi
  800a78:	56                   	push   %esi
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a82:	39 c6                	cmp    %eax,%esi
  800a84:	73 32                	jae    800ab8 <memmove+0x44>
  800a86:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a89:	39 c2                	cmp    %eax,%edx
  800a8b:	76 2b                	jbe    800ab8 <memmove+0x44>
		s += n;
		d += n;
  800a8d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a90:	89 fe                	mov    %edi,%esi
  800a92:	09 ce                	or     %ecx,%esi
  800a94:	09 d6                	or     %edx,%esi
  800a96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a9c:	75 0e                	jne    800aac <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a9e:	83 ef 04             	sub    $0x4,%edi
  800aa1:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800aa7:	fd                   	std    
  800aa8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800aaa:	eb 09                	jmp    800ab5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800aac:	83 ef 01             	sub    $0x1,%edi
  800aaf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ab2:	fd                   	std    
  800ab3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab5:	fc                   	cld    
  800ab6:	eb 1a                	jmp    800ad2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab8:	89 c2                	mov    %eax,%edx
  800aba:	09 ca                	or     %ecx,%edx
  800abc:	09 f2                	or     %esi,%edx
  800abe:	f6 c2 03             	test   $0x3,%dl
  800ac1:	75 0a                	jne    800acd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ac3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ac6:	89 c7                	mov    %eax,%edi
  800ac8:	fc                   	cld    
  800ac9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800acb:	eb 05                	jmp    800ad2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800acd:	89 c7                	mov    %eax,%edi
  800acf:	fc                   	cld    
  800ad0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad2:	5e                   	pop    %esi
  800ad3:	5f                   	pop    %edi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800adc:	ff 75 10             	pushl  0x10(%ebp)
  800adf:	ff 75 0c             	pushl  0xc(%ebp)
  800ae2:	ff 75 08             	pushl  0x8(%ebp)
  800ae5:	e8 8a ff ff ff       	call   800a74 <memmove>
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	56                   	push   %esi
  800af0:	53                   	push   %ebx
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800af7:	89 c6                	mov    %eax,%esi
  800af9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800afc:	39 f0                	cmp    %esi,%eax
  800afe:	74 1c                	je     800b1c <memcmp+0x30>
		if (*s1 != *s2)
  800b00:	0f b6 08             	movzbl (%eax),%ecx
  800b03:	0f b6 1a             	movzbl (%edx),%ebx
  800b06:	38 d9                	cmp    %bl,%cl
  800b08:	75 08                	jne    800b12 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b0a:	83 c0 01             	add    $0x1,%eax
  800b0d:	83 c2 01             	add    $0x1,%edx
  800b10:	eb ea                	jmp    800afc <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b12:	0f b6 c1             	movzbl %cl,%eax
  800b15:	0f b6 db             	movzbl %bl,%ebx
  800b18:	29 d8                	sub    %ebx,%eax
  800b1a:	eb 05                	jmp    800b21 <memcmp+0x35>
	}

	return 0;
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b2e:	89 c2                	mov    %eax,%edx
  800b30:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b33:	39 d0                	cmp    %edx,%eax
  800b35:	73 09                	jae    800b40 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b37:	38 08                	cmp    %cl,(%eax)
  800b39:	74 05                	je     800b40 <memfind+0x1b>
	for (; s < ends; s++)
  800b3b:	83 c0 01             	add    $0x1,%eax
  800b3e:	eb f3                	jmp    800b33 <memfind+0xe>
			break;
	return (void *) s;
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
  800b45:	57                   	push   %edi
  800b46:	56                   	push   %esi
  800b47:	53                   	push   %ebx
  800b48:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b4e:	eb 03                	jmp    800b53 <strtol+0x11>
		s++;
  800b50:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b53:	0f b6 01             	movzbl (%ecx),%eax
  800b56:	3c 20                	cmp    $0x20,%al
  800b58:	74 f6                	je     800b50 <strtol+0xe>
  800b5a:	3c 09                	cmp    $0x9,%al
  800b5c:	74 f2                	je     800b50 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b5e:	3c 2b                	cmp    $0x2b,%al
  800b60:	74 2a                	je     800b8c <strtol+0x4a>
	int neg = 0;
  800b62:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b67:	3c 2d                	cmp    $0x2d,%al
  800b69:	74 2b                	je     800b96 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b6b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b71:	75 0f                	jne    800b82 <strtol+0x40>
  800b73:	80 39 30             	cmpb   $0x30,(%ecx)
  800b76:	74 28                	je     800ba0 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b78:	85 db                	test   %ebx,%ebx
  800b7a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7f:	0f 44 d8             	cmove  %eax,%ebx
  800b82:	b8 00 00 00 00       	mov    $0x0,%eax
  800b87:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b8a:	eb 50                	jmp    800bdc <strtol+0x9a>
		s++;
  800b8c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b8f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b94:	eb d5                	jmp    800b6b <strtol+0x29>
		s++, neg = 1;
  800b96:	83 c1 01             	add    $0x1,%ecx
  800b99:	bf 01 00 00 00       	mov    $0x1,%edi
  800b9e:	eb cb                	jmp    800b6b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ba4:	74 0e                	je     800bb4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800ba6:	85 db                	test   %ebx,%ebx
  800ba8:	75 d8                	jne    800b82 <strtol+0x40>
		s++, base = 8;
  800baa:	83 c1 01             	add    $0x1,%ecx
  800bad:	bb 08 00 00 00       	mov    $0x8,%ebx
  800bb2:	eb ce                	jmp    800b82 <strtol+0x40>
		s += 2, base = 16;
  800bb4:	83 c1 02             	add    $0x2,%ecx
  800bb7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bbc:	eb c4                	jmp    800b82 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bbe:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bc1:	89 f3                	mov    %esi,%ebx
  800bc3:	80 fb 19             	cmp    $0x19,%bl
  800bc6:	77 29                	ja     800bf1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bc8:	0f be d2             	movsbl %dl,%edx
  800bcb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bce:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bd1:	7d 30                	jge    800c03 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bd3:	83 c1 01             	add    $0x1,%ecx
  800bd6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bda:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bdc:	0f b6 11             	movzbl (%ecx),%edx
  800bdf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800be2:	89 f3                	mov    %esi,%ebx
  800be4:	80 fb 09             	cmp    $0x9,%bl
  800be7:	77 d5                	ja     800bbe <strtol+0x7c>
			dig = *s - '0';
  800be9:	0f be d2             	movsbl %dl,%edx
  800bec:	83 ea 30             	sub    $0x30,%edx
  800bef:	eb dd                	jmp    800bce <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800bf1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800bf4:	89 f3                	mov    %esi,%ebx
  800bf6:	80 fb 19             	cmp    $0x19,%bl
  800bf9:	77 08                	ja     800c03 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800bfb:	0f be d2             	movsbl %dl,%edx
  800bfe:	83 ea 37             	sub    $0x37,%edx
  800c01:	eb cb                	jmp    800bce <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c03:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c07:	74 05                	je     800c0e <strtol+0xcc>
		*endptr = (char *) s;
  800c09:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c0c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c0e:	89 c2                	mov    %eax,%edx
  800c10:	f7 da                	neg    %edx
  800c12:	85 ff                	test   %edi,%edi
  800c14:	0f 45 c2             	cmovne %edx,%eax
}
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    

00800c1c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	57                   	push   %edi
  800c20:	56                   	push   %esi
  800c21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c22:	b8 00 00 00 00       	mov    $0x0,%eax
  800c27:	8b 55 08             	mov    0x8(%ebp),%edx
  800c2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c2d:	89 c3                	mov    %eax,%ebx
  800c2f:	89 c7                	mov    %eax,%edi
  800c31:	89 c6                	mov    %eax,%esi
  800c33:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5f                   	pop    %edi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    

00800c3a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c3a:	55                   	push   %ebp
  800c3b:	89 e5                	mov    %esp,%ebp
  800c3d:	57                   	push   %edi
  800c3e:	56                   	push   %esi
  800c3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c40:	ba 00 00 00 00       	mov    $0x0,%edx
  800c45:	b8 01 00 00 00       	mov    $0x1,%eax
  800c4a:	89 d1                	mov    %edx,%ecx
  800c4c:	89 d3                	mov    %edx,%ebx
  800c4e:	89 d7                	mov    %edx,%edi
  800c50:	89 d6                	mov    %edx,%esi
  800c52:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5f                   	pop    %edi
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	57                   	push   %edi
  800c5d:	56                   	push   %esi
  800c5e:	53                   	push   %ebx
  800c5f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c62:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c67:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c6f:	89 cb                	mov    %ecx,%ebx
  800c71:	89 cf                	mov    %ecx,%edi
  800c73:	89 ce                	mov    %ecx,%esi
  800c75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c77:	85 c0                	test   %eax,%eax
  800c79:	7f 08                	jg     800c83 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	50                   	push   %eax
  800c87:	6a 03                	push   $0x3
  800c89:	68 a4 28 80 00       	push   $0x8028a4
  800c8e:	6a 43                	push   $0x43
  800c90:	68 c1 28 80 00       	push   $0x8028c1
  800c95:	e8 69 14 00 00       	call   802103 <_panic>

00800c9a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	57                   	push   %edi
  800c9e:	56                   	push   %esi
  800c9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ca0:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca5:	b8 02 00 00 00       	mov    $0x2,%eax
  800caa:	89 d1                	mov    %edx,%ecx
  800cac:	89 d3                	mov    %edx,%ebx
  800cae:	89 d7                	mov    %edx,%edi
  800cb0:	89 d6                	mov    %edx,%esi
  800cb2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cb4:	5b                   	pop    %ebx
  800cb5:	5e                   	pop    %esi
  800cb6:	5f                   	pop    %edi
  800cb7:	5d                   	pop    %ebp
  800cb8:	c3                   	ret    

00800cb9 <sys_yield>:

void
sys_yield(void)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
  800cbc:	57                   	push   %edi
  800cbd:	56                   	push   %esi
  800cbe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cc9:	89 d1                	mov    %edx,%ecx
  800ccb:	89 d3                	mov    %edx,%ebx
  800ccd:	89 d7                	mov    %edx,%edi
  800ccf:	89 d6                	mov    %edx,%esi
  800cd1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cd3:	5b                   	pop    %ebx
  800cd4:	5e                   	pop    %esi
  800cd5:	5f                   	pop    %edi
  800cd6:	5d                   	pop    %ebp
  800cd7:	c3                   	ret    

00800cd8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cd8:	55                   	push   %ebp
  800cd9:	89 e5                	mov    %esp,%ebp
  800cdb:	57                   	push   %edi
  800cdc:	56                   	push   %esi
  800cdd:	53                   	push   %ebx
  800cde:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce1:	be 00 00 00 00       	mov    $0x0,%esi
  800ce6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cec:	b8 04 00 00 00       	mov    $0x4,%eax
  800cf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cf4:	89 f7                	mov    %esi,%edi
  800cf6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf8:	85 c0                	test   %eax,%eax
  800cfa:	7f 08                	jg     800d04 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cff:	5b                   	pop    %ebx
  800d00:	5e                   	pop    %esi
  800d01:	5f                   	pop    %edi
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d04:	83 ec 0c             	sub    $0xc,%esp
  800d07:	50                   	push   %eax
  800d08:	6a 04                	push   $0x4
  800d0a:	68 a4 28 80 00       	push   $0x8028a4
  800d0f:	6a 43                	push   $0x43
  800d11:	68 c1 28 80 00       	push   $0x8028c1
  800d16:	e8 e8 13 00 00       	call   802103 <_panic>

00800d1b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	57                   	push   %edi
  800d1f:	56                   	push   %esi
  800d20:	53                   	push   %ebx
  800d21:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d24:	8b 55 08             	mov    0x8(%ebp),%edx
  800d27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d32:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d35:	8b 75 18             	mov    0x18(%ebp),%esi
  800d38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d3a:	85 c0                	test   %eax,%eax
  800d3c:	7f 08                	jg     800d46 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d41:	5b                   	pop    %ebx
  800d42:	5e                   	pop    %esi
  800d43:	5f                   	pop    %edi
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d46:	83 ec 0c             	sub    $0xc,%esp
  800d49:	50                   	push   %eax
  800d4a:	6a 05                	push   $0x5
  800d4c:	68 a4 28 80 00       	push   $0x8028a4
  800d51:	6a 43                	push   $0x43
  800d53:	68 c1 28 80 00       	push   $0x8028c1
  800d58:	e8 a6 13 00 00       	call   802103 <_panic>

00800d5d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	57                   	push   %edi
  800d61:	56                   	push   %esi
  800d62:	53                   	push   %ebx
  800d63:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d66:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d71:	b8 06 00 00 00       	mov    $0x6,%eax
  800d76:	89 df                	mov    %ebx,%edi
  800d78:	89 de                	mov    %ebx,%esi
  800d7a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d7c:	85 c0                	test   %eax,%eax
  800d7e:	7f 08                	jg     800d88 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d88:	83 ec 0c             	sub    $0xc,%esp
  800d8b:	50                   	push   %eax
  800d8c:	6a 06                	push   $0x6
  800d8e:	68 a4 28 80 00       	push   $0x8028a4
  800d93:	6a 43                	push   $0x43
  800d95:	68 c1 28 80 00       	push   $0x8028c1
  800d9a:	e8 64 13 00 00       	call   802103 <_panic>

00800d9f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d9f:	55                   	push   %ebp
  800da0:	89 e5                	mov    %esp,%ebp
  800da2:	57                   	push   %edi
  800da3:	56                   	push   %esi
  800da4:	53                   	push   %ebx
  800da5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800da8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dad:	8b 55 08             	mov    0x8(%ebp),%edx
  800db0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db3:	b8 08 00 00 00       	mov    $0x8,%eax
  800db8:	89 df                	mov    %ebx,%edi
  800dba:	89 de                	mov    %ebx,%esi
  800dbc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dbe:	85 c0                	test   %eax,%eax
  800dc0:	7f 08                	jg     800dca <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800dc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dca:	83 ec 0c             	sub    $0xc,%esp
  800dcd:	50                   	push   %eax
  800dce:	6a 08                	push   $0x8
  800dd0:	68 a4 28 80 00       	push   $0x8028a4
  800dd5:	6a 43                	push   $0x43
  800dd7:	68 c1 28 80 00       	push   $0x8028c1
  800ddc:	e8 22 13 00 00       	call   802103 <_panic>

00800de1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	57                   	push   %edi
  800de5:	56                   	push   %esi
  800de6:	53                   	push   %ebx
  800de7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dea:	bb 00 00 00 00       	mov    $0x0,%ebx
  800def:	8b 55 08             	mov    0x8(%ebp),%edx
  800df2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df5:	b8 09 00 00 00       	mov    $0x9,%eax
  800dfa:	89 df                	mov    %ebx,%edi
  800dfc:	89 de                	mov    %ebx,%esi
  800dfe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e00:	85 c0                	test   %eax,%eax
  800e02:	7f 08                	jg     800e0c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e04:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e07:	5b                   	pop    %ebx
  800e08:	5e                   	pop    %esi
  800e09:	5f                   	pop    %edi
  800e0a:	5d                   	pop    %ebp
  800e0b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0c:	83 ec 0c             	sub    $0xc,%esp
  800e0f:	50                   	push   %eax
  800e10:	6a 09                	push   $0x9
  800e12:	68 a4 28 80 00       	push   $0x8028a4
  800e17:	6a 43                	push   $0x43
  800e19:	68 c1 28 80 00       	push   $0x8028c1
  800e1e:	e8 e0 12 00 00       	call   802103 <_panic>

00800e23 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	57                   	push   %edi
  800e27:	56                   	push   %esi
  800e28:	53                   	push   %ebx
  800e29:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e31:	8b 55 08             	mov    0x8(%ebp),%edx
  800e34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e37:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e3c:	89 df                	mov    %ebx,%edi
  800e3e:	89 de                	mov    %ebx,%esi
  800e40:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e42:	85 c0                	test   %eax,%eax
  800e44:	7f 08                	jg     800e4e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e49:	5b                   	pop    %ebx
  800e4a:	5e                   	pop    %esi
  800e4b:	5f                   	pop    %edi
  800e4c:	5d                   	pop    %ebp
  800e4d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4e:	83 ec 0c             	sub    $0xc,%esp
  800e51:	50                   	push   %eax
  800e52:	6a 0a                	push   $0xa
  800e54:	68 a4 28 80 00       	push   $0x8028a4
  800e59:	6a 43                	push   $0x43
  800e5b:	68 c1 28 80 00       	push   $0x8028c1
  800e60:	e8 9e 12 00 00       	call   802103 <_panic>

00800e65 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	57                   	push   %edi
  800e69:	56                   	push   %esi
  800e6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e76:	be 00 00 00 00       	mov    $0x0,%esi
  800e7b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e7e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e81:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e83:	5b                   	pop    %ebx
  800e84:	5e                   	pop    %esi
  800e85:	5f                   	pop    %edi
  800e86:	5d                   	pop    %ebp
  800e87:	c3                   	ret    

00800e88 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	57                   	push   %edi
  800e8c:	56                   	push   %esi
  800e8d:	53                   	push   %ebx
  800e8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e96:	8b 55 08             	mov    0x8(%ebp),%edx
  800e99:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e9e:	89 cb                	mov    %ecx,%ebx
  800ea0:	89 cf                	mov    %ecx,%edi
  800ea2:	89 ce                	mov    %ecx,%esi
  800ea4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ea6:	85 c0                	test   %eax,%eax
  800ea8:	7f 08                	jg     800eb2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ead:	5b                   	pop    %ebx
  800eae:	5e                   	pop    %esi
  800eaf:	5f                   	pop    %edi
  800eb0:	5d                   	pop    %ebp
  800eb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	83 ec 0c             	sub    $0xc,%esp
  800eb5:	50                   	push   %eax
  800eb6:	6a 0d                	push   $0xd
  800eb8:	68 a4 28 80 00       	push   $0x8028a4
  800ebd:	6a 43                	push   $0x43
  800ebf:	68 c1 28 80 00       	push   $0x8028c1
  800ec4:	e8 3a 12 00 00       	call   802103 <_panic>

00800ec9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	57                   	push   %edi
  800ecd:	56                   	push   %esi
  800ece:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eda:	b8 0e 00 00 00       	mov    $0xe,%eax
  800edf:	89 df                	mov    %ebx,%edi
  800ee1:	89 de                	mov    %ebx,%esi
  800ee3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ee5:	5b                   	pop    %ebx
  800ee6:	5e                   	pop    %esi
  800ee7:	5f                   	pop    %edi
  800ee8:	5d                   	pop    %ebp
  800ee9:	c3                   	ret    

00800eea <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800efd:	89 cb                	mov    %ecx,%ebx
  800eff:	89 cf                	mov    %ecx,%edi
  800f01:	89 ce                	mov    %ecx,%esi
  800f03:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800f05:	5b                   	pop    %ebx
  800f06:	5e                   	pop    %esi
  800f07:	5f                   	pop    %edi
  800f08:	5d                   	pop    %ebp
  800f09:	c3                   	ret    

00800f0a <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800f0a:	55                   	push   %ebp
  800f0b:	89 e5                	mov    %esp,%ebp
  800f0d:	57                   	push   %edi
  800f0e:	56                   	push   %esi
  800f0f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f10:	ba 00 00 00 00       	mov    $0x0,%edx
  800f15:	b8 10 00 00 00       	mov    $0x10,%eax
  800f1a:	89 d1                	mov    %edx,%ecx
  800f1c:	89 d3                	mov    %edx,%ebx
  800f1e:	89 d7                	mov    %edx,%edi
  800f20:	89 d6                	mov    %edx,%esi
  800f22:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f24:	5b                   	pop    %ebx
  800f25:	5e                   	pop    %esi
  800f26:	5f                   	pop    %edi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    

00800f29 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f29:	55                   	push   %ebp
  800f2a:	89 e5                	mov    %esp,%ebp
  800f2c:	57                   	push   %edi
  800f2d:	56                   	push   %esi
  800f2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3a:	b8 11 00 00 00       	mov    $0x11,%eax
  800f3f:	89 df                	mov    %ebx,%edi
  800f41:	89 de                	mov    %ebx,%esi
  800f43:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f45:	5b                   	pop    %ebx
  800f46:	5e                   	pop    %esi
  800f47:	5f                   	pop    %edi
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	57                   	push   %edi
  800f4e:	56                   	push   %esi
  800f4f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f50:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5b:	b8 12 00 00 00       	mov    $0x12,%eax
  800f60:	89 df                	mov    %ebx,%edi
  800f62:	89 de                	mov    %ebx,%esi
  800f64:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5f                   	pop    %edi
  800f69:	5d                   	pop    %ebp
  800f6a:	c3                   	ret    

00800f6b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f6b:	55                   	push   %ebp
  800f6c:	89 e5                	mov    %esp,%ebp
  800f6e:	57                   	push   %edi
  800f6f:	56                   	push   %esi
  800f70:	53                   	push   %ebx
  800f71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7f:	b8 13 00 00 00       	mov    $0x13,%eax
  800f84:	89 df                	mov    %ebx,%edi
  800f86:	89 de                	mov    %ebx,%esi
  800f88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	7f 08                	jg     800f96 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f91:	5b                   	pop    %ebx
  800f92:	5e                   	pop    %esi
  800f93:	5f                   	pop    %edi
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f96:	83 ec 0c             	sub    $0xc,%esp
  800f99:	50                   	push   %eax
  800f9a:	6a 13                	push   $0x13
  800f9c:	68 a4 28 80 00       	push   $0x8028a4
  800fa1:	6a 43                	push   $0x43
  800fa3:	68 c1 28 80 00       	push   $0x8028c1
  800fa8:	e8 56 11 00 00       	call   802103 <_panic>

00800fad <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	05 00 00 00 30       	add    $0x30000000,%eax
  800fb8:	c1 e8 0c             	shr    $0xc,%eax
}
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fcd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fd2:	5d                   	pop    %ebp
  800fd3:	c3                   	ret    

00800fd4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fdc:	89 c2                	mov    %eax,%edx
  800fde:	c1 ea 16             	shr    $0x16,%edx
  800fe1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800fe8:	f6 c2 01             	test   $0x1,%dl
  800feb:	74 2d                	je     80101a <fd_alloc+0x46>
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	c1 ea 0c             	shr    $0xc,%edx
  800ff2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ff9:	f6 c2 01             	test   $0x1,%dl
  800ffc:	74 1c                	je     80101a <fd_alloc+0x46>
  800ffe:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801003:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801008:	75 d2                	jne    800fdc <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801013:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801018:	eb 0a                	jmp    801024 <fd_alloc+0x50>
			*fd_store = fd;
  80101a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80101d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80101f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80102c:	83 f8 1f             	cmp    $0x1f,%eax
  80102f:	77 30                	ja     801061 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801031:	c1 e0 0c             	shl    $0xc,%eax
  801034:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801039:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80103f:	f6 c2 01             	test   $0x1,%dl
  801042:	74 24                	je     801068 <fd_lookup+0x42>
  801044:	89 c2                	mov    %eax,%edx
  801046:	c1 ea 0c             	shr    $0xc,%edx
  801049:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801050:	f6 c2 01             	test   $0x1,%dl
  801053:	74 1a                	je     80106f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801055:	8b 55 0c             	mov    0xc(%ebp),%edx
  801058:	89 02                	mov    %eax,(%edx)
	return 0;
  80105a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80105f:	5d                   	pop    %ebp
  801060:	c3                   	ret    
		return -E_INVAL;
  801061:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801066:	eb f7                	jmp    80105f <fd_lookup+0x39>
		return -E_INVAL;
  801068:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80106d:	eb f0                	jmp    80105f <fd_lookup+0x39>
  80106f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801074:	eb e9                	jmp    80105f <fd_lookup+0x39>

00801076 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80107f:	ba 00 00 00 00       	mov    $0x0,%edx
  801084:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801089:	39 08                	cmp    %ecx,(%eax)
  80108b:	74 38                	je     8010c5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80108d:	83 c2 01             	add    $0x1,%edx
  801090:	8b 04 95 4c 29 80 00 	mov    0x80294c(,%edx,4),%eax
  801097:	85 c0                	test   %eax,%eax
  801099:	75 ee                	jne    801089 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80109b:	a1 08 40 80 00       	mov    0x804008,%eax
  8010a0:	8b 40 48             	mov    0x48(%eax),%eax
  8010a3:	83 ec 04             	sub    $0x4,%esp
  8010a6:	51                   	push   %ecx
  8010a7:	50                   	push   %eax
  8010a8:	68 d0 28 80 00       	push   $0x8028d0
  8010ad:	e8 d5 f0 ff ff       	call   800187 <cprintf>
	*dev = 0;
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010bb:	83 c4 10             	add    $0x10,%esp
  8010be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    
			*dev = devtab[i];
  8010c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cf:	eb f2                	jmp    8010c3 <dev_lookup+0x4d>

008010d1 <fd_close>:
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	57                   	push   %edi
  8010d5:	56                   	push   %esi
  8010d6:	53                   	push   %ebx
  8010d7:	83 ec 24             	sub    $0x24,%esp
  8010da:	8b 75 08             	mov    0x8(%ebp),%esi
  8010dd:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010e0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010e3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010ea:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010ed:	50                   	push   %eax
  8010ee:	e8 33 ff ff ff       	call   801026 <fd_lookup>
  8010f3:	89 c3                	mov    %eax,%ebx
  8010f5:	83 c4 10             	add    $0x10,%esp
  8010f8:	85 c0                	test   %eax,%eax
  8010fa:	78 05                	js     801101 <fd_close+0x30>
	    || fd != fd2)
  8010fc:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  8010ff:	74 16                	je     801117 <fd_close+0x46>
		return (must_exist ? r : 0);
  801101:	89 f8                	mov    %edi,%eax
  801103:	84 c0                	test   %al,%al
  801105:	b8 00 00 00 00       	mov    $0x0,%eax
  80110a:	0f 44 d8             	cmove  %eax,%ebx
}
  80110d:	89 d8                	mov    %ebx,%eax
  80110f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801112:	5b                   	pop    %ebx
  801113:	5e                   	pop    %esi
  801114:	5f                   	pop    %edi
  801115:	5d                   	pop    %ebp
  801116:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801117:	83 ec 08             	sub    $0x8,%esp
  80111a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80111d:	50                   	push   %eax
  80111e:	ff 36                	pushl  (%esi)
  801120:	e8 51 ff ff ff       	call   801076 <dev_lookup>
  801125:	89 c3                	mov    %eax,%ebx
  801127:	83 c4 10             	add    $0x10,%esp
  80112a:	85 c0                	test   %eax,%eax
  80112c:	78 1a                	js     801148 <fd_close+0x77>
		if (dev->dev_close)
  80112e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801131:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801134:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801139:	85 c0                	test   %eax,%eax
  80113b:	74 0b                	je     801148 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80113d:	83 ec 0c             	sub    $0xc,%esp
  801140:	56                   	push   %esi
  801141:	ff d0                	call   *%eax
  801143:	89 c3                	mov    %eax,%ebx
  801145:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801148:	83 ec 08             	sub    $0x8,%esp
  80114b:	56                   	push   %esi
  80114c:	6a 00                	push   $0x0
  80114e:	e8 0a fc ff ff       	call   800d5d <sys_page_unmap>
	return r;
  801153:	83 c4 10             	add    $0x10,%esp
  801156:	eb b5                	jmp    80110d <fd_close+0x3c>

00801158 <close>:

int
close(int fdnum)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80115e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801161:	50                   	push   %eax
  801162:	ff 75 08             	pushl  0x8(%ebp)
  801165:	e8 bc fe ff ff       	call   801026 <fd_lookup>
  80116a:	83 c4 10             	add    $0x10,%esp
  80116d:	85 c0                	test   %eax,%eax
  80116f:	79 02                	jns    801173 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801171:	c9                   	leave  
  801172:	c3                   	ret    
		return fd_close(fd, 1);
  801173:	83 ec 08             	sub    $0x8,%esp
  801176:	6a 01                	push   $0x1
  801178:	ff 75 f4             	pushl  -0xc(%ebp)
  80117b:	e8 51 ff ff ff       	call   8010d1 <fd_close>
  801180:	83 c4 10             	add    $0x10,%esp
  801183:	eb ec                	jmp    801171 <close+0x19>

00801185 <close_all>:

void
close_all(void)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	53                   	push   %ebx
  801189:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80118c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801191:	83 ec 0c             	sub    $0xc,%esp
  801194:	53                   	push   %ebx
  801195:	e8 be ff ff ff       	call   801158 <close>
	for (i = 0; i < MAXFD; i++)
  80119a:	83 c3 01             	add    $0x1,%ebx
  80119d:	83 c4 10             	add    $0x10,%esp
  8011a0:	83 fb 20             	cmp    $0x20,%ebx
  8011a3:	75 ec                	jne    801191 <close_all+0xc>
}
  8011a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a8:	c9                   	leave  
  8011a9:	c3                   	ret    

008011aa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	57                   	push   %edi
  8011ae:	56                   	push   %esi
  8011af:	53                   	push   %ebx
  8011b0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011b6:	50                   	push   %eax
  8011b7:	ff 75 08             	pushl  0x8(%ebp)
  8011ba:	e8 67 fe ff ff       	call   801026 <fd_lookup>
  8011bf:	89 c3                	mov    %eax,%ebx
  8011c1:	83 c4 10             	add    $0x10,%esp
  8011c4:	85 c0                	test   %eax,%eax
  8011c6:	0f 88 81 00 00 00    	js     80124d <dup+0xa3>
		return r;
	close(newfdnum);
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	ff 75 0c             	pushl  0xc(%ebp)
  8011d2:	e8 81 ff ff ff       	call   801158 <close>

	newfd = INDEX2FD(newfdnum);
  8011d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011da:	c1 e6 0c             	shl    $0xc,%esi
  8011dd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011e3:	83 c4 04             	add    $0x4,%esp
  8011e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011e9:	e8 cf fd ff ff       	call   800fbd <fd2data>
  8011ee:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8011f0:	89 34 24             	mov    %esi,(%esp)
  8011f3:	e8 c5 fd ff ff       	call   800fbd <fd2data>
  8011f8:	83 c4 10             	add    $0x10,%esp
  8011fb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8011fd:	89 d8                	mov    %ebx,%eax
  8011ff:	c1 e8 16             	shr    $0x16,%eax
  801202:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801209:	a8 01                	test   $0x1,%al
  80120b:	74 11                	je     80121e <dup+0x74>
  80120d:	89 d8                	mov    %ebx,%eax
  80120f:	c1 e8 0c             	shr    $0xc,%eax
  801212:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801219:	f6 c2 01             	test   $0x1,%dl
  80121c:	75 39                	jne    801257 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80121e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801221:	89 d0                	mov    %edx,%eax
  801223:	c1 e8 0c             	shr    $0xc,%eax
  801226:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	25 07 0e 00 00       	and    $0xe07,%eax
  801235:	50                   	push   %eax
  801236:	56                   	push   %esi
  801237:	6a 00                	push   $0x0
  801239:	52                   	push   %edx
  80123a:	6a 00                	push   $0x0
  80123c:	e8 da fa ff ff       	call   800d1b <sys_page_map>
  801241:	89 c3                	mov    %eax,%ebx
  801243:	83 c4 20             	add    $0x20,%esp
  801246:	85 c0                	test   %eax,%eax
  801248:	78 31                	js     80127b <dup+0xd1>
		goto err;

	return newfdnum;
  80124a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80124d:	89 d8                	mov    %ebx,%eax
  80124f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801252:	5b                   	pop    %ebx
  801253:	5e                   	pop    %esi
  801254:	5f                   	pop    %edi
  801255:	5d                   	pop    %ebp
  801256:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801257:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80125e:	83 ec 0c             	sub    $0xc,%esp
  801261:	25 07 0e 00 00       	and    $0xe07,%eax
  801266:	50                   	push   %eax
  801267:	57                   	push   %edi
  801268:	6a 00                	push   $0x0
  80126a:	53                   	push   %ebx
  80126b:	6a 00                	push   $0x0
  80126d:	e8 a9 fa ff ff       	call   800d1b <sys_page_map>
  801272:	89 c3                	mov    %eax,%ebx
  801274:	83 c4 20             	add    $0x20,%esp
  801277:	85 c0                	test   %eax,%eax
  801279:	79 a3                	jns    80121e <dup+0x74>
	sys_page_unmap(0, newfd);
  80127b:	83 ec 08             	sub    $0x8,%esp
  80127e:	56                   	push   %esi
  80127f:	6a 00                	push   $0x0
  801281:	e8 d7 fa ff ff       	call   800d5d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	57                   	push   %edi
  80128a:	6a 00                	push   $0x0
  80128c:	e8 cc fa ff ff       	call   800d5d <sys_page_unmap>
	return r;
  801291:	83 c4 10             	add    $0x10,%esp
  801294:	eb b7                	jmp    80124d <dup+0xa3>

00801296 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801296:	55                   	push   %ebp
  801297:	89 e5                	mov    %esp,%ebp
  801299:	53                   	push   %ebx
  80129a:	83 ec 1c             	sub    $0x1c,%esp
  80129d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a3:	50                   	push   %eax
  8012a4:	53                   	push   %ebx
  8012a5:	e8 7c fd ff ff       	call   801026 <fd_lookup>
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	85 c0                	test   %eax,%eax
  8012af:	78 3f                	js     8012f0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b1:	83 ec 08             	sub    $0x8,%esp
  8012b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b7:	50                   	push   %eax
  8012b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bb:	ff 30                	pushl  (%eax)
  8012bd:	e8 b4 fd ff ff       	call   801076 <dev_lookup>
  8012c2:	83 c4 10             	add    $0x10,%esp
  8012c5:	85 c0                	test   %eax,%eax
  8012c7:	78 27                	js     8012f0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012cc:	8b 42 08             	mov    0x8(%edx),%eax
  8012cf:	83 e0 03             	and    $0x3,%eax
  8012d2:	83 f8 01             	cmp    $0x1,%eax
  8012d5:	74 1e                	je     8012f5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012da:	8b 40 08             	mov    0x8(%eax),%eax
  8012dd:	85 c0                	test   %eax,%eax
  8012df:	74 35                	je     801316 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012e1:	83 ec 04             	sub    $0x4,%esp
  8012e4:	ff 75 10             	pushl  0x10(%ebp)
  8012e7:	ff 75 0c             	pushl  0xc(%ebp)
  8012ea:	52                   	push   %edx
  8012eb:	ff d0                	call   *%eax
  8012ed:	83 c4 10             	add    $0x10,%esp
}
  8012f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f3:	c9                   	leave  
  8012f4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8012f5:	a1 08 40 80 00       	mov    0x804008,%eax
  8012fa:	8b 40 48             	mov    0x48(%eax),%eax
  8012fd:	83 ec 04             	sub    $0x4,%esp
  801300:	53                   	push   %ebx
  801301:	50                   	push   %eax
  801302:	68 11 29 80 00       	push   $0x802911
  801307:	e8 7b ee ff ff       	call   800187 <cprintf>
		return -E_INVAL;
  80130c:	83 c4 10             	add    $0x10,%esp
  80130f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801314:	eb da                	jmp    8012f0 <read+0x5a>
		return -E_NOT_SUPP;
  801316:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131b:	eb d3                	jmp    8012f0 <read+0x5a>

0080131d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	57                   	push   %edi
  801321:	56                   	push   %esi
  801322:	53                   	push   %ebx
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	8b 7d 08             	mov    0x8(%ebp),%edi
  801329:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80132c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801331:	39 f3                	cmp    %esi,%ebx
  801333:	73 23                	jae    801358 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801335:	83 ec 04             	sub    $0x4,%esp
  801338:	89 f0                	mov    %esi,%eax
  80133a:	29 d8                	sub    %ebx,%eax
  80133c:	50                   	push   %eax
  80133d:	89 d8                	mov    %ebx,%eax
  80133f:	03 45 0c             	add    0xc(%ebp),%eax
  801342:	50                   	push   %eax
  801343:	57                   	push   %edi
  801344:	e8 4d ff ff ff       	call   801296 <read>
		if (m < 0)
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 06                	js     801356 <readn+0x39>
			return m;
		if (m == 0)
  801350:	74 06                	je     801358 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801352:	01 c3                	add    %eax,%ebx
  801354:	eb db                	jmp    801331 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801356:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801358:	89 d8                	mov    %ebx,%eax
  80135a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80135d:	5b                   	pop    %ebx
  80135e:	5e                   	pop    %esi
  80135f:	5f                   	pop    %edi
  801360:	5d                   	pop    %ebp
  801361:	c3                   	ret    

00801362 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801362:	55                   	push   %ebp
  801363:	89 e5                	mov    %esp,%ebp
  801365:	53                   	push   %ebx
  801366:	83 ec 1c             	sub    $0x1c,%esp
  801369:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80136c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80136f:	50                   	push   %eax
  801370:	53                   	push   %ebx
  801371:	e8 b0 fc ff ff       	call   801026 <fd_lookup>
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	85 c0                	test   %eax,%eax
  80137b:	78 3a                	js     8013b7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80137d:	83 ec 08             	sub    $0x8,%esp
  801380:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801383:	50                   	push   %eax
  801384:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801387:	ff 30                	pushl  (%eax)
  801389:	e8 e8 fc ff ff       	call   801076 <dev_lookup>
  80138e:	83 c4 10             	add    $0x10,%esp
  801391:	85 c0                	test   %eax,%eax
  801393:	78 22                	js     8013b7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801398:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80139c:	74 1e                	je     8013bc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80139e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013a1:	8b 52 0c             	mov    0xc(%edx),%edx
  8013a4:	85 d2                	test   %edx,%edx
  8013a6:	74 35                	je     8013dd <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	ff 75 10             	pushl  0x10(%ebp)
  8013ae:	ff 75 0c             	pushl  0xc(%ebp)
  8013b1:	50                   	push   %eax
  8013b2:	ff d2                	call   *%edx
  8013b4:	83 c4 10             	add    $0x10,%esp
}
  8013b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013bc:	a1 08 40 80 00       	mov    0x804008,%eax
  8013c1:	8b 40 48             	mov    0x48(%eax),%eax
  8013c4:	83 ec 04             	sub    $0x4,%esp
  8013c7:	53                   	push   %ebx
  8013c8:	50                   	push   %eax
  8013c9:	68 2d 29 80 00       	push   $0x80292d
  8013ce:	e8 b4 ed ff ff       	call   800187 <cprintf>
		return -E_INVAL;
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013db:	eb da                	jmp    8013b7 <write+0x55>
		return -E_NOT_SUPP;
  8013dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e2:	eb d3                	jmp    8013b7 <write+0x55>

008013e4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013e4:	55                   	push   %ebp
  8013e5:	89 e5                	mov    %esp,%ebp
  8013e7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ed:	50                   	push   %eax
  8013ee:	ff 75 08             	pushl  0x8(%ebp)
  8013f1:	e8 30 fc ff ff       	call   801026 <fd_lookup>
  8013f6:	83 c4 10             	add    $0x10,%esp
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	78 0e                	js     80140b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8013fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801403:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801406:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80140b:	c9                   	leave  
  80140c:	c3                   	ret    

0080140d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	53                   	push   %ebx
  801411:	83 ec 1c             	sub    $0x1c,%esp
  801414:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801417:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80141a:	50                   	push   %eax
  80141b:	53                   	push   %ebx
  80141c:	e8 05 fc ff ff       	call   801026 <fd_lookup>
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	85 c0                	test   %eax,%eax
  801426:	78 37                	js     80145f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801428:	83 ec 08             	sub    $0x8,%esp
  80142b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80142e:	50                   	push   %eax
  80142f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801432:	ff 30                	pushl  (%eax)
  801434:	e8 3d fc ff ff       	call   801076 <dev_lookup>
  801439:	83 c4 10             	add    $0x10,%esp
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 1f                	js     80145f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801440:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801443:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801447:	74 1b                	je     801464 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801449:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80144c:	8b 52 18             	mov    0x18(%edx),%edx
  80144f:	85 d2                	test   %edx,%edx
  801451:	74 32                	je     801485 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801453:	83 ec 08             	sub    $0x8,%esp
  801456:	ff 75 0c             	pushl  0xc(%ebp)
  801459:	50                   	push   %eax
  80145a:	ff d2                	call   *%edx
  80145c:	83 c4 10             	add    $0x10,%esp
}
  80145f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801462:	c9                   	leave  
  801463:	c3                   	ret    
			thisenv->env_id, fdnum);
  801464:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801469:	8b 40 48             	mov    0x48(%eax),%eax
  80146c:	83 ec 04             	sub    $0x4,%esp
  80146f:	53                   	push   %ebx
  801470:	50                   	push   %eax
  801471:	68 f0 28 80 00       	push   $0x8028f0
  801476:	e8 0c ed ff ff       	call   800187 <cprintf>
		return -E_INVAL;
  80147b:	83 c4 10             	add    $0x10,%esp
  80147e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801483:	eb da                	jmp    80145f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801485:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80148a:	eb d3                	jmp    80145f <ftruncate+0x52>

0080148c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	53                   	push   %ebx
  801490:	83 ec 1c             	sub    $0x1c,%esp
  801493:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801496:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801499:	50                   	push   %eax
  80149a:	ff 75 08             	pushl  0x8(%ebp)
  80149d:	e8 84 fb ff ff       	call   801026 <fd_lookup>
  8014a2:	83 c4 10             	add    $0x10,%esp
  8014a5:	85 c0                	test   %eax,%eax
  8014a7:	78 4b                	js     8014f4 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a9:	83 ec 08             	sub    $0x8,%esp
  8014ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014af:	50                   	push   %eax
  8014b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b3:	ff 30                	pushl  (%eax)
  8014b5:	e8 bc fb ff ff       	call   801076 <dev_lookup>
  8014ba:	83 c4 10             	add    $0x10,%esp
  8014bd:	85 c0                	test   %eax,%eax
  8014bf:	78 33                	js     8014f4 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014c8:	74 2f                	je     8014f9 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014ca:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014cd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014d4:	00 00 00 
	stat->st_isdir = 0;
  8014d7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014de:	00 00 00 
	stat->st_dev = dev;
  8014e1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014e7:	83 ec 08             	sub    $0x8,%esp
  8014ea:	53                   	push   %ebx
  8014eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8014ee:	ff 50 14             	call   *0x14(%eax)
  8014f1:	83 c4 10             	add    $0x10,%esp
}
  8014f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014f7:	c9                   	leave  
  8014f8:	c3                   	ret    
		return -E_NOT_SUPP;
  8014f9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014fe:	eb f4                	jmp    8014f4 <fstat+0x68>

00801500 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801500:	55                   	push   %ebp
  801501:	89 e5                	mov    %esp,%ebp
  801503:	56                   	push   %esi
  801504:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801505:	83 ec 08             	sub    $0x8,%esp
  801508:	6a 00                	push   $0x0
  80150a:	ff 75 08             	pushl  0x8(%ebp)
  80150d:	e8 22 02 00 00       	call   801734 <open>
  801512:	89 c3                	mov    %eax,%ebx
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	85 c0                	test   %eax,%eax
  801519:	78 1b                	js     801536 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80151b:	83 ec 08             	sub    $0x8,%esp
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	50                   	push   %eax
  801522:	e8 65 ff ff ff       	call   80148c <fstat>
  801527:	89 c6                	mov    %eax,%esi
	close(fd);
  801529:	89 1c 24             	mov    %ebx,(%esp)
  80152c:	e8 27 fc ff ff       	call   801158 <close>
	return r;
  801531:	83 c4 10             	add    $0x10,%esp
  801534:	89 f3                	mov    %esi,%ebx
}
  801536:	89 d8                	mov    %ebx,%eax
  801538:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80153b:	5b                   	pop    %ebx
  80153c:	5e                   	pop    %esi
  80153d:	5d                   	pop    %ebp
  80153e:	c3                   	ret    

0080153f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80153f:	55                   	push   %ebp
  801540:	89 e5                	mov    %esp,%ebp
  801542:	56                   	push   %esi
  801543:	53                   	push   %ebx
  801544:	89 c6                	mov    %eax,%esi
  801546:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801548:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80154f:	74 27                	je     801578 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801551:	6a 07                	push   $0x7
  801553:	68 00 50 80 00       	push   $0x805000
  801558:	56                   	push   %esi
  801559:	ff 35 00 40 80 00    	pushl  0x804000
  80155f:	e8 69 0c 00 00       	call   8021cd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801564:	83 c4 0c             	add    $0xc,%esp
  801567:	6a 00                	push   $0x0
  801569:	53                   	push   %ebx
  80156a:	6a 00                	push   $0x0
  80156c:	e8 f3 0b 00 00       	call   802164 <ipc_recv>
}
  801571:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801574:	5b                   	pop    %ebx
  801575:	5e                   	pop    %esi
  801576:	5d                   	pop    %ebp
  801577:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801578:	83 ec 0c             	sub    $0xc,%esp
  80157b:	6a 01                	push   $0x1
  80157d:	e8 a3 0c 00 00       	call   802225 <ipc_find_env>
  801582:	a3 00 40 80 00       	mov    %eax,0x804000
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	eb c5                	jmp    801551 <fsipc+0x12>

0080158c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80158c:	55                   	push   %ebp
  80158d:	89 e5                	mov    %esp,%ebp
  80158f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801592:	8b 45 08             	mov    0x8(%ebp),%eax
  801595:	8b 40 0c             	mov    0xc(%eax),%eax
  801598:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015aa:	b8 02 00 00 00       	mov    $0x2,%eax
  8015af:	e8 8b ff ff ff       	call   80153f <fsipc>
}
  8015b4:	c9                   	leave  
  8015b5:	c3                   	ret    

008015b6 <devfile_flush>:
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8015c2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015cc:	b8 06 00 00 00       	mov    $0x6,%eax
  8015d1:	e8 69 ff ff ff       	call   80153f <fsipc>
}
  8015d6:	c9                   	leave  
  8015d7:	c3                   	ret    

008015d8 <devfile_stat>:
{
  8015d8:	55                   	push   %ebp
  8015d9:	89 e5                	mov    %esp,%ebp
  8015db:	53                   	push   %ebx
  8015dc:	83 ec 04             	sub    $0x4,%esp
  8015df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f2:	b8 05 00 00 00       	mov    $0x5,%eax
  8015f7:	e8 43 ff ff ff       	call   80153f <fsipc>
  8015fc:	85 c0                	test   %eax,%eax
  8015fe:	78 2c                	js     80162c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801600:	83 ec 08             	sub    $0x8,%esp
  801603:	68 00 50 80 00       	push   $0x805000
  801608:	53                   	push   %ebx
  801609:	e8 d8 f2 ff ff       	call   8008e6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80160e:	a1 80 50 80 00       	mov    0x805080,%eax
  801613:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801619:	a1 84 50 80 00       	mov    0x805084,%eax
  80161e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801624:	83 c4 10             	add    $0x10,%esp
  801627:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80162c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80162f:	c9                   	leave  
  801630:	c3                   	ret    

00801631 <devfile_write>:
{
  801631:	55                   	push   %ebp
  801632:	89 e5                	mov    %esp,%ebp
  801634:	53                   	push   %ebx
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80163b:	8b 45 08             	mov    0x8(%ebp),%eax
  80163e:	8b 40 0c             	mov    0xc(%eax),%eax
  801641:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801646:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80164c:	53                   	push   %ebx
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	68 08 50 80 00       	push   $0x805008
  801655:	e8 7c f4 ff ff       	call   800ad6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80165a:	ba 00 00 00 00       	mov    $0x0,%edx
  80165f:	b8 04 00 00 00       	mov    $0x4,%eax
  801664:	e8 d6 fe ff ff       	call   80153f <fsipc>
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	85 c0                	test   %eax,%eax
  80166e:	78 0b                	js     80167b <devfile_write+0x4a>
	assert(r <= n);
  801670:	39 d8                	cmp    %ebx,%eax
  801672:	77 0c                	ja     801680 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801674:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801679:	7f 1e                	jg     801699 <devfile_write+0x68>
}
  80167b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167e:	c9                   	leave  
  80167f:	c3                   	ret    
	assert(r <= n);
  801680:	68 60 29 80 00       	push   $0x802960
  801685:	68 67 29 80 00       	push   $0x802967
  80168a:	68 98 00 00 00       	push   $0x98
  80168f:	68 7c 29 80 00       	push   $0x80297c
  801694:	e8 6a 0a 00 00       	call   802103 <_panic>
	assert(r <= PGSIZE);
  801699:	68 87 29 80 00       	push   $0x802987
  80169e:	68 67 29 80 00       	push   $0x802967
  8016a3:	68 99 00 00 00       	push   $0x99
  8016a8:	68 7c 29 80 00       	push   $0x80297c
  8016ad:	e8 51 0a 00 00       	call   802103 <_panic>

008016b2 <devfile_read>:
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
  8016b5:	56                   	push   %esi
  8016b6:	53                   	push   %ebx
  8016b7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8016c0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016c5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8016d0:	b8 03 00 00 00       	mov    $0x3,%eax
  8016d5:	e8 65 fe ff ff       	call   80153f <fsipc>
  8016da:	89 c3                	mov    %eax,%ebx
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	78 1f                	js     8016ff <devfile_read+0x4d>
	assert(r <= n);
  8016e0:	39 f0                	cmp    %esi,%eax
  8016e2:	77 24                	ja     801708 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016e4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016e9:	7f 33                	jg     80171e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016eb:	83 ec 04             	sub    $0x4,%esp
  8016ee:	50                   	push   %eax
  8016ef:	68 00 50 80 00       	push   $0x805000
  8016f4:	ff 75 0c             	pushl  0xc(%ebp)
  8016f7:	e8 78 f3 ff ff       	call   800a74 <memmove>
	return r;
  8016fc:	83 c4 10             	add    $0x10,%esp
}
  8016ff:	89 d8                	mov    %ebx,%eax
  801701:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801704:	5b                   	pop    %ebx
  801705:	5e                   	pop    %esi
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    
	assert(r <= n);
  801708:	68 60 29 80 00       	push   $0x802960
  80170d:	68 67 29 80 00       	push   $0x802967
  801712:	6a 7c                	push   $0x7c
  801714:	68 7c 29 80 00       	push   $0x80297c
  801719:	e8 e5 09 00 00       	call   802103 <_panic>
	assert(r <= PGSIZE);
  80171e:	68 87 29 80 00       	push   $0x802987
  801723:	68 67 29 80 00       	push   $0x802967
  801728:	6a 7d                	push   $0x7d
  80172a:	68 7c 29 80 00       	push   $0x80297c
  80172f:	e8 cf 09 00 00       	call   802103 <_panic>

00801734 <open>:
{
  801734:	55                   	push   %ebp
  801735:	89 e5                	mov    %esp,%ebp
  801737:	56                   	push   %esi
  801738:	53                   	push   %ebx
  801739:	83 ec 1c             	sub    $0x1c,%esp
  80173c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80173f:	56                   	push   %esi
  801740:	e8 68 f1 ff ff       	call   8008ad <strlen>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80174d:	7f 6c                	jg     8017bb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80174f:	83 ec 0c             	sub    $0xc,%esp
  801752:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801755:	50                   	push   %eax
  801756:	e8 79 f8 ff ff       	call   800fd4 <fd_alloc>
  80175b:	89 c3                	mov    %eax,%ebx
  80175d:	83 c4 10             	add    $0x10,%esp
  801760:	85 c0                	test   %eax,%eax
  801762:	78 3c                	js     8017a0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801764:	83 ec 08             	sub    $0x8,%esp
  801767:	56                   	push   %esi
  801768:	68 00 50 80 00       	push   $0x805000
  80176d:	e8 74 f1 ff ff       	call   8008e6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801772:	8b 45 0c             	mov    0xc(%ebp),%eax
  801775:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80177a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80177d:	b8 01 00 00 00       	mov    $0x1,%eax
  801782:	e8 b8 fd ff ff       	call   80153f <fsipc>
  801787:	89 c3                	mov    %eax,%ebx
  801789:	83 c4 10             	add    $0x10,%esp
  80178c:	85 c0                	test   %eax,%eax
  80178e:	78 19                	js     8017a9 <open+0x75>
	return fd2num(fd);
  801790:	83 ec 0c             	sub    $0xc,%esp
  801793:	ff 75 f4             	pushl  -0xc(%ebp)
  801796:	e8 12 f8 ff ff       	call   800fad <fd2num>
  80179b:	89 c3                	mov    %eax,%ebx
  80179d:	83 c4 10             	add    $0x10,%esp
}
  8017a0:	89 d8                	mov    %ebx,%eax
  8017a2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017a5:	5b                   	pop    %ebx
  8017a6:	5e                   	pop    %esi
  8017a7:	5d                   	pop    %ebp
  8017a8:	c3                   	ret    
		fd_close(fd, 0);
  8017a9:	83 ec 08             	sub    $0x8,%esp
  8017ac:	6a 00                	push   $0x0
  8017ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8017b1:	e8 1b f9 ff ff       	call   8010d1 <fd_close>
		return r;
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	eb e5                	jmp    8017a0 <open+0x6c>
		return -E_BAD_PATH;
  8017bb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017c0:	eb de                	jmp    8017a0 <open+0x6c>

008017c2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017c2:	55                   	push   %ebp
  8017c3:	89 e5                	mov    %esp,%ebp
  8017c5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cd:	b8 08 00 00 00       	mov    $0x8,%eax
  8017d2:	e8 68 fd ff ff       	call   80153f <fsipc>
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017df:	68 93 29 80 00       	push   $0x802993
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	e8 fa f0 ff ff       	call   8008e6 <strcpy>
	return 0;
}
  8017ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <devsock_close>:
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 10             	sub    $0x10,%esp
  8017fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  8017fd:	53                   	push   %ebx
  8017fe:	e8 5d 0a 00 00       	call   802260 <pageref>
  801803:	83 c4 10             	add    $0x10,%esp
		return 0;
  801806:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80180b:	83 f8 01             	cmp    $0x1,%eax
  80180e:	74 07                	je     801817 <devsock_close+0x24>
}
  801810:	89 d0                	mov    %edx,%eax
  801812:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801815:	c9                   	leave  
  801816:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801817:	83 ec 0c             	sub    $0xc,%esp
  80181a:	ff 73 0c             	pushl  0xc(%ebx)
  80181d:	e8 b9 02 00 00       	call   801adb <nsipc_close>
  801822:	89 c2                	mov    %eax,%edx
  801824:	83 c4 10             	add    $0x10,%esp
  801827:	eb e7                	jmp    801810 <devsock_close+0x1d>

00801829 <devsock_write>:
{
  801829:	55                   	push   %ebp
  80182a:	89 e5                	mov    %esp,%ebp
  80182c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80182f:	6a 00                	push   $0x0
  801831:	ff 75 10             	pushl  0x10(%ebp)
  801834:	ff 75 0c             	pushl  0xc(%ebp)
  801837:	8b 45 08             	mov    0x8(%ebp),%eax
  80183a:	ff 70 0c             	pushl  0xc(%eax)
  80183d:	e8 76 03 00 00       	call   801bb8 <nsipc_send>
}
  801842:	c9                   	leave  
  801843:	c3                   	ret    

00801844 <devsock_read>:
{
  801844:	55                   	push   %ebp
  801845:	89 e5                	mov    %esp,%ebp
  801847:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80184a:	6a 00                	push   $0x0
  80184c:	ff 75 10             	pushl  0x10(%ebp)
  80184f:	ff 75 0c             	pushl  0xc(%ebp)
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	ff 70 0c             	pushl  0xc(%eax)
  801858:	e8 ef 02 00 00       	call   801b4c <nsipc_recv>
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <fd2sockid>:
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801865:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801868:	52                   	push   %edx
  801869:	50                   	push   %eax
  80186a:	e8 b7 f7 ff ff       	call   801026 <fd_lookup>
  80186f:	83 c4 10             	add    $0x10,%esp
  801872:	85 c0                	test   %eax,%eax
  801874:	78 10                	js     801886 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801879:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80187f:	39 08                	cmp    %ecx,(%eax)
  801881:	75 05                	jne    801888 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801883:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801886:	c9                   	leave  
  801887:	c3                   	ret    
		return -E_NOT_SUPP;
  801888:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80188d:	eb f7                	jmp    801886 <fd2sockid+0x27>

0080188f <alloc_sockfd>:
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	83 ec 1c             	sub    $0x1c,%esp
  801897:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  801899:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80189c:	50                   	push   %eax
  80189d:	e8 32 f7 ff ff       	call   800fd4 <fd_alloc>
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	83 c4 10             	add    $0x10,%esp
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 43                	js     8018ee <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 07 04 00 00       	push   $0x407
  8018b3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b6:	6a 00                	push   $0x0
  8018b8:	e8 1b f4 ff ff       	call   800cd8 <sys_page_alloc>
  8018bd:	89 c3                	mov    %eax,%ebx
  8018bf:	83 c4 10             	add    $0x10,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	78 28                	js     8018ee <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018c9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018cf:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018db:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018de:	83 ec 0c             	sub    $0xc,%esp
  8018e1:	50                   	push   %eax
  8018e2:	e8 c6 f6 ff ff       	call   800fad <fd2num>
  8018e7:	89 c3                	mov    %eax,%ebx
  8018e9:	83 c4 10             	add    $0x10,%esp
  8018ec:	eb 0c                	jmp    8018fa <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	56                   	push   %esi
  8018f2:	e8 e4 01 00 00       	call   801adb <nsipc_close>
		return r;
  8018f7:	83 c4 10             	add    $0x10,%esp
}
  8018fa:	89 d8                	mov    %ebx,%eax
  8018fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ff:	5b                   	pop    %ebx
  801900:	5e                   	pop    %esi
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <accept>:
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	e8 4e ff ff ff       	call   80185f <fd2sockid>
  801911:	85 c0                	test   %eax,%eax
  801913:	78 1b                	js     801930 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801915:	83 ec 04             	sub    $0x4,%esp
  801918:	ff 75 10             	pushl  0x10(%ebp)
  80191b:	ff 75 0c             	pushl  0xc(%ebp)
  80191e:	50                   	push   %eax
  80191f:	e8 0e 01 00 00       	call   801a32 <nsipc_accept>
  801924:	83 c4 10             	add    $0x10,%esp
  801927:	85 c0                	test   %eax,%eax
  801929:	78 05                	js     801930 <accept+0x2d>
	return alloc_sockfd(r);
  80192b:	e8 5f ff ff ff       	call   80188f <alloc_sockfd>
}
  801930:	c9                   	leave  
  801931:	c3                   	ret    

00801932 <bind>:
{
  801932:	55                   	push   %ebp
  801933:	89 e5                	mov    %esp,%ebp
  801935:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	e8 1f ff ff ff       	call   80185f <fd2sockid>
  801940:	85 c0                	test   %eax,%eax
  801942:	78 12                	js     801956 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	ff 75 10             	pushl  0x10(%ebp)
  80194a:	ff 75 0c             	pushl  0xc(%ebp)
  80194d:	50                   	push   %eax
  80194e:	e8 31 01 00 00       	call   801a84 <nsipc_bind>
  801953:	83 c4 10             	add    $0x10,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <shutdown>:
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80195e:	8b 45 08             	mov    0x8(%ebp),%eax
  801961:	e8 f9 fe ff ff       	call   80185f <fd2sockid>
  801966:	85 c0                	test   %eax,%eax
  801968:	78 0f                	js     801979 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80196a:	83 ec 08             	sub    $0x8,%esp
  80196d:	ff 75 0c             	pushl  0xc(%ebp)
  801970:	50                   	push   %eax
  801971:	e8 43 01 00 00       	call   801ab9 <nsipc_shutdown>
  801976:	83 c4 10             	add    $0x10,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <connect>:
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
  80197e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	e8 d6 fe ff ff       	call   80185f <fd2sockid>
  801989:	85 c0                	test   %eax,%eax
  80198b:	78 12                	js     80199f <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	ff 75 10             	pushl  0x10(%ebp)
  801993:	ff 75 0c             	pushl  0xc(%ebp)
  801996:	50                   	push   %eax
  801997:	e8 59 01 00 00       	call   801af5 <nsipc_connect>
  80199c:	83 c4 10             	add    $0x10,%esp
}
  80199f:	c9                   	leave  
  8019a0:	c3                   	ret    

008019a1 <listen>:
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019aa:	e8 b0 fe ff ff       	call   80185f <fd2sockid>
  8019af:	85 c0                	test   %eax,%eax
  8019b1:	78 0f                	js     8019c2 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019b3:	83 ec 08             	sub    $0x8,%esp
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	50                   	push   %eax
  8019ba:	e8 6b 01 00 00       	call   801b2a <nsipc_listen>
  8019bf:	83 c4 10             	add    $0x10,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019ca:	ff 75 10             	pushl  0x10(%ebp)
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	ff 75 08             	pushl  0x8(%ebp)
  8019d3:	e8 3e 02 00 00       	call   801c16 <nsipc_socket>
  8019d8:	83 c4 10             	add    $0x10,%esp
  8019db:	85 c0                	test   %eax,%eax
  8019dd:	78 05                	js     8019e4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019df:	e8 ab fe ff ff       	call   80188f <alloc_sockfd>
}
  8019e4:	c9                   	leave  
  8019e5:	c3                   	ret    

008019e6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019e6:	55                   	push   %ebp
  8019e7:	89 e5                	mov    %esp,%ebp
  8019e9:	53                   	push   %ebx
  8019ea:	83 ec 04             	sub    $0x4,%esp
  8019ed:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019ef:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  8019f6:	74 26                	je     801a1e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8019f8:	6a 07                	push   $0x7
  8019fa:	68 00 60 80 00       	push   $0x806000
  8019ff:	53                   	push   %ebx
  801a00:	ff 35 04 40 80 00    	pushl  0x804004
  801a06:	e8 c2 07 00 00       	call   8021cd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a0b:	83 c4 0c             	add    $0xc,%esp
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	e8 4b 07 00 00       	call   802164 <ipc_recv>
}
  801a19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a1c:	c9                   	leave  
  801a1d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	6a 02                	push   $0x2
  801a23:	e8 fd 07 00 00       	call   802225 <ipc_find_env>
  801a28:	a3 04 40 80 00       	mov    %eax,0x804004
  801a2d:	83 c4 10             	add    $0x10,%esp
  801a30:	eb c6                	jmp    8019f8 <nsipc+0x12>

00801a32 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a32:	55                   	push   %ebp
  801a33:	89 e5                	mov    %esp,%ebp
  801a35:	56                   	push   %esi
  801a36:	53                   	push   %ebx
  801a37:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a42:	8b 06                	mov    (%esi),%eax
  801a44:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a49:	b8 01 00 00 00       	mov    $0x1,%eax
  801a4e:	e8 93 ff ff ff       	call   8019e6 <nsipc>
  801a53:	89 c3                	mov    %eax,%ebx
  801a55:	85 c0                	test   %eax,%eax
  801a57:	79 09                	jns    801a62 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a59:	89 d8                	mov    %ebx,%eax
  801a5b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5d                   	pop    %ebp
  801a61:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a62:	83 ec 04             	sub    $0x4,%esp
  801a65:	ff 35 10 60 80 00    	pushl  0x806010
  801a6b:	68 00 60 80 00       	push   $0x806000
  801a70:	ff 75 0c             	pushl  0xc(%ebp)
  801a73:	e8 fc ef ff ff       	call   800a74 <memmove>
		*addrlen = ret->ret_addrlen;
  801a78:	a1 10 60 80 00       	mov    0x806010,%eax
  801a7d:	89 06                	mov    %eax,(%esi)
  801a7f:	83 c4 10             	add    $0x10,%esp
	return r;
  801a82:	eb d5                	jmp    801a59 <nsipc_accept+0x27>

00801a84 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a84:	55                   	push   %ebp
  801a85:	89 e5                	mov    %esp,%ebp
  801a87:	53                   	push   %ebx
  801a88:	83 ec 08             	sub    $0x8,%esp
  801a8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a91:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801a96:	53                   	push   %ebx
  801a97:	ff 75 0c             	pushl  0xc(%ebp)
  801a9a:	68 04 60 80 00       	push   $0x806004
  801a9f:	e8 d0 ef ff ff       	call   800a74 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801aa4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aaa:	b8 02 00 00 00       	mov    $0x2,%eax
  801aaf:	e8 32 ff ff ff       	call   8019e6 <nsipc>
}
  801ab4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801abf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ac7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aca:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801acf:	b8 03 00 00 00       	mov    $0x3,%eax
  801ad4:	e8 0d ff ff ff       	call   8019e6 <nsipc>
}
  801ad9:	c9                   	leave  
  801ada:	c3                   	ret    

00801adb <nsipc_close>:

int
nsipc_close(int s)
{
  801adb:	55                   	push   %ebp
  801adc:	89 e5                	mov    %esp,%ebp
  801ade:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801ae9:	b8 04 00 00 00       	mov    $0x4,%eax
  801aee:	e8 f3 fe ff ff       	call   8019e6 <nsipc>
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	53                   	push   %ebx
  801af9:	83 ec 08             	sub    $0x8,%esp
  801afc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801aff:	8b 45 08             	mov    0x8(%ebp),%eax
  801b02:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b07:	53                   	push   %ebx
  801b08:	ff 75 0c             	pushl  0xc(%ebp)
  801b0b:	68 04 60 80 00       	push   $0x806004
  801b10:	e8 5f ef ff ff       	call   800a74 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b15:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b1b:	b8 05 00 00 00       	mov    $0x5,%eax
  801b20:	e8 c1 fe ff ff       	call   8019e6 <nsipc>
}
  801b25:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
  801b2d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b30:	8b 45 08             	mov    0x8(%ebp),%eax
  801b33:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b38:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b3b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b40:	b8 06 00 00 00       	mov    $0x6,%eax
  801b45:	e8 9c fe ff ff       	call   8019e6 <nsipc>
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
  801b4f:	56                   	push   %esi
  801b50:	53                   	push   %ebx
  801b51:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b54:	8b 45 08             	mov    0x8(%ebp),%eax
  801b57:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b5c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b62:	8b 45 14             	mov    0x14(%ebp),%eax
  801b65:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b6a:	b8 07 00 00 00       	mov    $0x7,%eax
  801b6f:	e8 72 fe ff ff       	call   8019e6 <nsipc>
  801b74:	89 c3                	mov    %eax,%ebx
  801b76:	85 c0                	test   %eax,%eax
  801b78:	78 1f                	js     801b99 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b7a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b7f:	7f 21                	jg     801ba2 <nsipc_recv+0x56>
  801b81:	39 c6                	cmp    %eax,%esi
  801b83:	7c 1d                	jl     801ba2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b85:	83 ec 04             	sub    $0x4,%esp
  801b88:	50                   	push   %eax
  801b89:	68 00 60 80 00       	push   $0x806000
  801b8e:	ff 75 0c             	pushl  0xc(%ebp)
  801b91:	e8 de ee ff ff       	call   800a74 <memmove>
  801b96:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801b99:	89 d8                	mov    %ebx,%eax
  801b9b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b9e:	5b                   	pop    %ebx
  801b9f:	5e                   	pop    %esi
  801ba0:	5d                   	pop    %ebp
  801ba1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801ba2:	68 9f 29 80 00       	push   $0x80299f
  801ba7:	68 67 29 80 00       	push   $0x802967
  801bac:	6a 62                	push   $0x62
  801bae:	68 b4 29 80 00       	push   $0x8029b4
  801bb3:	e8 4b 05 00 00       	call   802103 <_panic>

00801bb8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 04             	sub    $0x4,%esp
  801bbf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bca:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801bd0:	7f 2e                	jg     801c00 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801bd2:	83 ec 04             	sub    $0x4,%esp
  801bd5:	53                   	push   %ebx
  801bd6:	ff 75 0c             	pushl  0xc(%ebp)
  801bd9:	68 0c 60 80 00       	push   $0x80600c
  801bde:	e8 91 ee ff ff       	call   800a74 <memmove>
	nsipcbuf.send.req_size = size;
  801be3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801be9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bec:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801bf1:	b8 08 00 00 00       	mov    $0x8,%eax
  801bf6:	e8 eb fd ff ff       	call   8019e6 <nsipc>
}
  801bfb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    
	assert(size < 1600);
  801c00:	68 c0 29 80 00       	push   $0x8029c0
  801c05:	68 67 29 80 00       	push   $0x802967
  801c0a:	6a 6d                	push   $0x6d
  801c0c:	68 b4 29 80 00       	push   $0x8029b4
  801c11:	e8 ed 04 00 00       	call   802103 <_panic>

00801c16 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
  801c19:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c27:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c2f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c34:	b8 09 00 00 00       	mov    $0x9,%eax
  801c39:	e8 a8 fd ff ff       	call   8019e6 <nsipc>
}
  801c3e:	c9                   	leave  
  801c3f:	c3                   	ret    

00801c40 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	56                   	push   %esi
  801c44:	53                   	push   %ebx
  801c45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	ff 75 08             	pushl  0x8(%ebp)
  801c4e:	e8 6a f3 ff ff       	call   800fbd <fd2data>
  801c53:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c55:	83 c4 08             	add    $0x8,%esp
  801c58:	68 cc 29 80 00       	push   $0x8029cc
  801c5d:	53                   	push   %ebx
  801c5e:	e8 83 ec ff ff       	call   8008e6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c63:	8b 46 04             	mov    0x4(%esi),%eax
  801c66:	2b 06                	sub    (%esi),%eax
  801c68:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c6e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c75:	00 00 00 
	stat->st_dev = &devpipe;
  801c78:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c7f:	30 80 00 
	return 0;
}
  801c82:	b8 00 00 00 00       	mov    $0x0,%eax
  801c87:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c8a:	5b                   	pop    %ebx
  801c8b:	5e                   	pop    %esi
  801c8c:	5d                   	pop    %ebp
  801c8d:	c3                   	ret    

00801c8e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	53                   	push   %ebx
  801c92:	83 ec 0c             	sub    $0xc,%esp
  801c95:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c98:	53                   	push   %ebx
  801c99:	6a 00                	push   $0x0
  801c9b:	e8 bd f0 ff ff       	call   800d5d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ca0:	89 1c 24             	mov    %ebx,(%esp)
  801ca3:	e8 15 f3 ff ff       	call   800fbd <fd2data>
  801ca8:	83 c4 08             	add    $0x8,%esp
  801cab:	50                   	push   %eax
  801cac:	6a 00                	push   $0x0
  801cae:	e8 aa f0 ff ff       	call   800d5d <sys_page_unmap>
}
  801cb3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <_pipeisclosed>:
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
  801cbb:	57                   	push   %edi
  801cbc:	56                   	push   %esi
  801cbd:	53                   	push   %ebx
  801cbe:	83 ec 1c             	sub    $0x1c,%esp
  801cc1:	89 c7                	mov    %eax,%edi
  801cc3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cc5:	a1 08 40 80 00       	mov    0x804008,%eax
  801cca:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801ccd:	83 ec 0c             	sub    $0xc,%esp
  801cd0:	57                   	push   %edi
  801cd1:	e8 8a 05 00 00       	call   802260 <pageref>
  801cd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cd9:	89 34 24             	mov    %esi,(%esp)
  801cdc:	e8 7f 05 00 00       	call   802260 <pageref>
		nn = thisenv->env_runs;
  801ce1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801ce7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cea:	83 c4 10             	add    $0x10,%esp
  801ced:	39 cb                	cmp    %ecx,%ebx
  801cef:	74 1b                	je     801d0c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cf1:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf4:	75 cf                	jne    801cc5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cf6:	8b 42 58             	mov    0x58(%edx),%eax
  801cf9:	6a 01                	push   $0x1
  801cfb:	50                   	push   %eax
  801cfc:	53                   	push   %ebx
  801cfd:	68 d3 29 80 00       	push   $0x8029d3
  801d02:	e8 80 e4 ff ff       	call   800187 <cprintf>
  801d07:	83 c4 10             	add    $0x10,%esp
  801d0a:	eb b9                	jmp    801cc5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d0c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d0f:	0f 94 c0             	sete   %al
  801d12:	0f b6 c0             	movzbl %al,%eax
}
  801d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <devpipe_write>:
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	57                   	push   %edi
  801d21:	56                   	push   %esi
  801d22:	53                   	push   %ebx
  801d23:	83 ec 28             	sub    $0x28,%esp
  801d26:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d29:	56                   	push   %esi
  801d2a:	e8 8e f2 ff ff       	call   800fbd <fd2data>
  801d2f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	bf 00 00 00 00       	mov    $0x0,%edi
  801d39:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d3c:	74 4f                	je     801d8d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d3e:	8b 43 04             	mov    0x4(%ebx),%eax
  801d41:	8b 0b                	mov    (%ebx),%ecx
  801d43:	8d 51 20             	lea    0x20(%ecx),%edx
  801d46:	39 d0                	cmp    %edx,%eax
  801d48:	72 14                	jb     801d5e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d4a:	89 da                	mov    %ebx,%edx
  801d4c:	89 f0                	mov    %esi,%eax
  801d4e:	e8 65 ff ff ff       	call   801cb8 <_pipeisclosed>
  801d53:	85 c0                	test   %eax,%eax
  801d55:	75 3b                	jne    801d92 <devpipe_write+0x75>
			sys_yield();
  801d57:	e8 5d ef ff ff       	call   800cb9 <sys_yield>
  801d5c:	eb e0                	jmp    801d3e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d61:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d65:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d68:	89 c2                	mov    %eax,%edx
  801d6a:	c1 fa 1f             	sar    $0x1f,%edx
  801d6d:	89 d1                	mov    %edx,%ecx
  801d6f:	c1 e9 1b             	shr    $0x1b,%ecx
  801d72:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d75:	83 e2 1f             	and    $0x1f,%edx
  801d78:	29 ca                	sub    %ecx,%edx
  801d7a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d7e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d82:	83 c0 01             	add    $0x1,%eax
  801d85:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d88:	83 c7 01             	add    $0x1,%edi
  801d8b:	eb ac                	jmp    801d39 <devpipe_write+0x1c>
	return i;
  801d8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801d90:	eb 05                	jmp    801d97 <devpipe_write+0x7a>
				return 0;
  801d92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5f                   	pop    %edi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    

00801d9f <devpipe_read>:
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	57                   	push   %edi
  801da3:	56                   	push   %esi
  801da4:	53                   	push   %ebx
  801da5:	83 ec 18             	sub    $0x18,%esp
  801da8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dab:	57                   	push   %edi
  801dac:	e8 0c f2 ff ff       	call   800fbd <fd2data>
  801db1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801db3:	83 c4 10             	add    $0x10,%esp
  801db6:	be 00 00 00 00       	mov    $0x0,%esi
  801dbb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dbe:	75 14                	jne    801dd4 <devpipe_read+0x35>
	return i;
  801dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  801dc3:	eb 02                	jmp    801dc7 <devpipe_read+0x28>
				return i;
  801dc5:	89 f0                	mov    %esi,%eax
}
  801dc7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dca:	5b                   	pop    %ebx
  801dcb:	5e                   	pop    %esi
  801dcc:	5f                   	pop    %edi
  801dcd:	5d                   	pop    %ebp
  801dce:	c3                   	ret    
			sys_yield();
  801dcf:	e8 e5 ee ff ff       	call   800cb9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801dd4:	8b 03                	mov    (%ebx),%eax
  801dd6:	3b 43 04             	cmp    0x4(%ebx),%eax
  801dd9:	75 18                	jne    801df3 <devpipe_read+0x54>
			if (i > 0)
  801ddb:	85 f6                	test   %esi,%esi
  801ddd:	75 e6                	jne    801dc5 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801ddf:	89 da                	mov    %ebx,%edx
  801de1:	89 f8                	mov    %edi,%eax
  801de3:	e8 d0 fe ff ff       	call   801cb8 <_pipeisclosed>
  801de8:	85 c0                	test   %eax,%eax
  801dea:	74 e3                	je     801dcf <devpipe_read+0x30>
				return 0;
  801dec:	b8 00 00 00 00       	mov    $0x0,%eax
  801df1:	eb d4                	jmp    801dc7 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801df3:	99                   	cltd   
  801df4:	c1 ea 1b             	shr    $0x1b,%edx
  801df7:	01 d0                	add    %edx,%eax
  801df9:	83 e0 1f             	and    $0x1f,%eax
  801dfc:	29 d0                	sub    %edx,%eax
  801dfe:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e03:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e06:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e09:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e0c:	83 c6 01             	add    $0x1,%esi
  801e0f:	eb aa                	jmp    801dbb <devpipe_read+0x1c>

00801e11 <pipe>:
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	56                   	push   %esi
  801e15:	53                   	push   %ebx
  801e16:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e19:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e1c:	50                   	push   %eax
  801e1d:	e8 b2 f1 ff ff       	call   800fd4 <fd_alloc>
  801e22:	89 c3                	mov    %eax,%ebx
  801e24:	83 c4 10             	add    $0x10,%esp
  801e27:	85 c0                	test   %eax,%eax
  801e29:	0f 88 23 01 00 00    	js     801f52 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e2f:	83 ec 04             	sub    $0x4,%esp
  801e32:	68 07 04 00 00       	push   $0x407
  801e37:	ff 75 f4             	pushl  -0xc(%ebp)
  801e3a:	6a 00                	push   $0x0
  801e3c:	e8 97 ee ff ff       	call   800cd8 <sys_page_alloc>
  801e41:	89 c3                	mov    %eax,%ebx
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	85 c0                	test   %eax,%eax
  801e48:	0f 88 04 01 00 00    	js     801f52 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e4e:	83 ec 0c             	sub    $0xc,%esp
  801e51:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e54:	50                   	push   %eax
  801e55:	e8 7a f1 ff ff       	call   800fd4 <fd_alloc>
  801e5a:	89 c3                	mov    %eax,%ebx
  801e5c:	83 c4 10             	add    $0x10,%esp
  801e5f:	85 c0                	test   %eax,%eax
  801e61:	0f 88 db 00 00 00    	js     801f42 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e67:	83 ec 04             	sub    $0x4,%esp
  801e6a:	68 07 04 00 00       	push   $0x407
  801e6f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e72:	6a 00                	push   $0x0
  801e74:	e8 5f ee ff ff       	call   800cd8 <sys_page_alloc>
  801e79:	89 c3                	mov    %eax,%ebx
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	85 c0                	test   %eax,%eax
  801e80:	0f 88 bc 00 00 00    	js     801f42 <pipe+0x131>
	va = fd2data(fd0);
  801e86:	83 ec 0c             	sub    $0xc,%esp
  801e89:	ff 75 f4             	pushl  -0xc(%ebp)
  801e8c:	e8 2c f1 ff ff       	call   800fbd <fd2data>
  801e91:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e93:	83 c4 0c             	add    $0xc,%esp
  801e96:	68 07 04 00 00       	push   $0x407
  801e9b:	50                   	push   %eax
  801e9c:	6a 00                	push   $0x0
  801e9e:	e8 35 ee ff ff       	call   800cd8 <sys_page_alloc>
  801ea3:	89 c3                	mov    %eax,%ebx
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	85 c0                	test   %eax,%eax
  801eaa:	0f 88 82 00 00 00    	js     801f32 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801eb0:	83 ec 0c             	sub    $0xc,%esp
  801eb3:	ff 75 f0             	pushl  -0x10(%ebp)
  801eb6:	e8 02 f1 ff ff       	call   800fbd <fd2data>
  801ebb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ec2:	50                   	push   %eax
  801ec3:	6a 00                	push   $0x0
  801ec5:	56                   	push   %esi
  801ec6:	6a 00                	push   $0x0
  801ec8:	e8 4e ee ff ff       	call   800d1b <sys_page_map>
  801ecd:	89 c3                	mov    %eax,%ebx
  801ecf:	83 c4 20             	add    $0x20,%esp
  801ed2:	85 c0                	test   %eax,%eax
  801ed4:	78 4e                	js     801f24 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ed6:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801edb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ede:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ee0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ee3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801eea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801eed:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef2:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	ff 75 f4             	pushl  -0xc(%ebp)
  801eff:	e8 a9 f0 ff ff       	call   800fad <fd2num>
  801f04:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f07:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f09:	83 c4 04             	add    $0x4,%esp
  801f0c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f0f:	e8 99 f0 ff ff       	call   800fad <fd2num>
  801f14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f17:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f1a:	83 c4 10             	add    $0x10,%esp
  801f1d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f22:	eb 2e                	jmp    801f52 <pipe+0x141>
	sys_page_unmap(0, va);
  801f24:	83 ec 08             	sub    $0x8,%esp
  801f27:	56                   	push   %esi
  801f28:	6a 00                	push   $0x0
  801f2a:	e8 2e ee ff ff       	call   800d5d <sys_page_unmap>
  801f2f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f32:	83 ec 08             	sub    $0x8,%esp
  801f35:	ff 75 f0             	pushl  -0x10(%ebp)
  801f38:	6a 00                	push   $0x0
  801f3a:	e8 1e ee ff ff       	call   800d5d <sys_page_unmap>
  801f3f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	ff 75 f4             	pushl  -0xc(%ebp)
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 0e ee ff ff       	call   800d5d <sys_page_unmap>
  801f4f:	83 c4 10             	add    $0x10,%esp
}
  801f52:	89 d8                	mov    %ebx,%eax
  801f54:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5d                   	pop    %ebp
  801f5a:	c3                   	ret    

00801f5b <pipeisclosed>:
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
  801f5e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f61:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f64:	50                   	push   %eax
  801f65:	ff 75 08             	pushl  0x8(%ebp)
  801f68:	e8 b9 f0 ff ff       	call   801026 <fd_lookup>
  801f6d:	83 c4 10             	add    $0x10,%esp
  801f70:	85 c0                	test   %eax,%eax
  801f72:	78 18                	js     801f8c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f74:	83 ec 0c             	sub    $0xc,%esp
  801f77:	ff 75 f4             	pushl  -0xc(%ebp)
  801f7a:	e8 3e f0 ff ff       	call   800fbd <fd2data>
	return _pipeisclosed(fd, p);
  801f7f:	89 c2                	mov    %eax,%edx
  801f81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f84:	e8 2f fd ff ff       	call   801cb8 <_pipeisclosed>
  801f89:	83 c4 10             	add    $0x10,%esp
}
  801f8c:	c9                   	leave  
  801f8d:	c3                   	ret    

00801f8e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f93:	c3                   	ret    

00801f94 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f94:	55                   	push   %ebp
  801f95:	89 e5                	mov    %esp,%ebp
  801f97:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801f9a:	68 eb 29 80 00       	push   $0x8029eb
  801f9f:	ff 75 0c             	pushl  0xc(%ebp)
  801fa2:	e8 3f e9 ff ff       	call   8008e6 <strcpy>
	return 0;
}
  801fa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fac:	c9                   	leave  
  801fad:	c3                   	ret    

00801fae <devcons_write>:
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	57                   	push   %edi
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fba:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fbf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fc5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fc8:	73 31                	jae    801ffb <devcons_write+0x4d>
		m = n - tot;
  801fca:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fcd:	29 f3                	sub    %esi,%ebx
  801fcf:	83 fb 7f             	cmp    $0x7f,%ebx
  801fd2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fd7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fda:	83 ec 04             	sub    $0x4,%esp
  801fdd:	53                   	push   %ebx
  801fde:	89 f0                	mov    %esi,%eax
  801fe0:	03 45 0c             	add    0xc(%ebp),%eax
  801fe3:	50                   	push   %eax
  801fe4:	57                   	push   %edi
  801fe5:	e8 8a ea ff ff       	call   800a74 <memmove>
		sys_cputs(buf, m);
  801fea:	83 c4 08             	add    $0x8,%esp
  801fed:	53                   	push   %ebx
  801fee:	57                   	push   %edi
  801fef:	e8 28 ec ff ff       	call   800c1c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ff4:	01 de                	add    %ebx,%esi
  801ff6:	83 c4 10             	add    $0x10,%esp
  801ff9:	eb ca                	jmp    801fc5 <devcons_write+0x17>
}
  801ffb:	89 f0                	mov    %esi,%eax
  801ffd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802000:	5b                   	pop    %ebx
  802001:	5e                   	pop    %esi
  802002:	5f                   	pop    %edi
  802003:	5d                   	pop    %ebp
  802004:	c3                   	ret    

00802005 <devcons_read>:
{
  802005:	55                   	push   %ebp
  802006:	89 e5                	mov    %esp,%ebp
  802008:	83 ec 08             	sub    $0x8,%esp
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802010:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802014:	74 21                	je     802037 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802016:	e8 1f ec ff ff       	call   800c3a <sys_cgetc>
  80201b:	85 c0                	test   %eax,%eax
  80201d:	75 07                	jne    802026 <devcons_read+0x21>
		sys_yield();
  80201f:	e8 95 ec ff ff       	call   800cb9 <sys_yield>
  802024:	eb f0                	jmp    802016 <devcons_read+0x11>
	if (c < 0)
  802026:	78 0f                	js     802037 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802028:	83 f8 04             	cmp    $0x4,%eax
  80202b:	74 0c                	je     802039 <devcons_read+0x34>
	*(char*)vbuf = c;
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	88 02                	mov    %al,(%edx)
	return 1;
  802032:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802037:	c9                   	leave  
  802038:	c3                   	ret    
		return 0;
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	eb f7                	jmp    802037 <devcons_read+0x32>

00802040 <cputchar>:
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80204c:	6a 01                	push   $0x1
  80204e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802051:	50                   	push   %eax
  802052:	e8 c5 eb ff ff       	call   800c1c <sys_cputs>
}
  802057:	83 c4 10             	add    $0x10,%esp
  80205a:	c9                   	leave  
  80205b:	c3                   	ret    

0080205c <getchar>:
{
  80205c:	55                   	push   %ebp
  80205d:	89 e5                	mov    %esp,%ebp
  80205f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802062:	6a 01                	push   $0x1
  802064:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802067:	50                   	push   %eax
  802068:	6a 00                	push   $0x0
  80206a:	e8 27 f2 ff ff       	call   801296 <read>
	if (r < 0)
  80206f:	83 c4 10             	add    $0x10,%esp
  802072:	85 c0                	test   %eax,%eax
  802074:	78 06                	js     80207c <getchar+0x20>
	if (r < 1)
  802076:	74 06                	je     80207e <getchar+0x22>
	return c;
  802078:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    
		return -E_EOF;
  80207e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802083:	eb f7                	jmp    80207c <getchar+0x20>

00802085 <iscons>:
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80208b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80208e:	50                   	push   %eax
  80208f:	ff 75 08             	pushl  0x8(%ebp)
  802092:	e8 8f ef ff ff       	call   801026 <fd_lookup>
  802097:	83 c4 10             	add    $0x10,%esp
  80209a:	85 c0                	test   %eax,%eax
  80209c:	78 11                	js     8020af <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80209e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020a7:	39 10                	cmp    %edx,(%eax)
  8020a9:	0f 94 c0             	sete   %al
  8020ac:	0f b6 c0             	movzbl %al,%eax
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <opencons>:
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ba:	50                   	push   %eax
  8020bb:	e8 14 ef ff ff       	call   800fd4 <fd_alloc>
  8020c0:	83 c4 10             	add    $0x10,%esp
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 3a                	js     802101 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020c7:	83 ec 04             	sub    $0x4,%esp
  8020ca:	68 07 04 00 00       	push   $0x407
  8020cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d2:	6a 00                	push   $0x0
  8020d4:	e8 ff eb ff ff       	call   800cd8 <sys_page_alloc>
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 21                	js     802101 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020e9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020f5:	83 ec 0c             	sub    $0xc,%esp
  8020f8:	50                   	push   %eax
  8020f9:	e8 af ee ff ff       	call   800fad <fd2num>
  8020fe:	83 c4 10             	add    $0x10,%esp
}
  802101:	c9                   	leave  
  802102:	c3                   	ret    

00802103 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	56                   	push   %esi
  802107:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802108:	a1 08 40 80 00       	mov    0x804008,%eax
  80210d:	8b 40 48             	mov    0x48(%eax),%eax
  802110:	83 ec 04             	sub    $0x4,%esp
  802113:	68 28 2a 80 00       	push   $0x802a28
  802118:	50                   	push   %eax
  802119:	68 f7 29 80 00       	push   $0x8029f7
  80211e:	e8 64 e0 ff ff       	call   800187 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802123:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802126:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80212c:	e8 69 eb ff ff       	call   800c9a <sys_getenvid>
  802131:	83 c4 04             	add    $0x4,%esp
  802134:	ff 75 0c             	pushl  0xc(%ebp)
  802137:	ff 75 08             	pushl  0x8(%ebp)
  80213a:	56                   	push   %esi
  80213b:	50                   	push   %eax
  80213c:	68 04 2a 80 00       	push   $0x802a04
  802141:	e8 41 e0 ff ff       	call   800187 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802146:	83 c4 18             	add    $0x18,%esp
  802149:	53                   	push   %ebx
  80214a:	ff 75 10             	pushl  0x10(%ebp)
  80214d:	e8 e4 df ff ff       	call   800136 <vcprintf>
	cprintf("\n");
  802152:	c7 04 24 18 25 80 00 	movl   $0x802518,(%esp)
  802159:	e8 29 e0 ff ff       	call   800187 <cprintf>
  80215e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802161:	cc                   	int3   
  802162:	eb fd                	jmp    802161 <_panic+0x5e>

00802164 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	56                   	push   %esi
  802168:	53                   	push   %ebx
  802169:	8b 75 08             	mov    0x8(%ebp),%esi
  80216c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802172:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802174:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802179:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80217c:	83 ec 0c             	sub    $0xc,%esp
  80217f:	50                   	push   %eax
  802180:	e8 03 ed ff ff       	call   800e88 <sys_ipc_recv>
	if(ret < 0){
  802185:	83 c4 10             	add    $0x10,%esp
  802188:	85 c0                	test   %eax,%eax
  80218a:	78 2b                	js     8021b7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80218c:	85 f6                	test   %esi,%esi
  80218e:	74 0a                	je     80219a <ipc_recv+0x36>
		// *from_env_store = getthisenv()->env_ipc_from;
		*from_env_store = thisenv->env_ipc_from;
  802190:	a1 08 40 80 00       	mov    0x804008,%eax
  802195:	8b 40 74             	mov    0x74(%eax),%eax
  802198:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  80219a:	85 db                	test   %ebx,%ebx
  80219c:	74 0a                	je     8021a8 <ipc_recv+0x44>
		// *perm_store = getthisenv()->env_ipc_perm;
		*perm_store = thisenv->env_ipc_perm;
  80219e:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a3:	8b 40 78             	mov    0x78(%eax),%eax
  8021a6:	89 03                	mov    %eax,(%ebx)
	}
	// return getthisenv()->env_ipc_value;
	return thisenv->env_ipc_value;
  8021a8:	a1 08 40 80 00       	mov    0x804008,%eax
  8021ad:	8b 40 70             	mov    0x70(%eax),%eax
}
  8021b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021b3:	5b                   	pop    %ebx
  8021b4:	5e                   	pop    %esi
  8021b5:	5d                   	pop    %ebp
  8021b6:	c3                   	ret    
		if(from_env_store)
  8021b7:	85 f6                	test   %esi,%esi
  8021b9:	74 06                	je     8021c1 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021bb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021c1:	85 db                	test   %ebx,%ebx
  8021c3:	74 eb                	je     8021b0 <ipc_recv+0x4c>
			*perm_store = 0;
  8021c5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021cb:	eb e3                	jmp    8021b0 <ipc_recv+0x4c>

008021cd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
  8021d0:	57                   	push   %edi
  8021d1:	56                   	push   %esi
  8021d2:	53                   	push   %ebx
  8021d3:	83 ec 0c             	sub    $0xc,%esp
  8021d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021df:	85 db                	test   %ebx,%ebx
  8021e1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021e6:	0f 44 d8             	cmove  %eax,%ebx
  8021e9:	eb 05                	jmp    8021f0 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021eb:	e8 c9 ea ff ff       	call   800cb9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  8021f0:	ff 75 14             	pushl  0x14(%ebp)
  8021f3:	53                   	push   %ebx
  8021f4:	56                   	push   %esi
  8021f5:	57                   	push   %edi
  8021f6:	e8 6a ec ff ff       	call   800e65 <sys_ipc_try_send>
  8021fb:	83 c4 10             	add    $0x10,%esp
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 1b                	je     80221d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802202:	79 e7                	jns    8021eb <ipc_send+0x1e>
  802204:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802207:	74 e2                	je     8021eb <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802209:	83 ec 04             	sub    $0x4,%esp
  80220c:	68 2f 2a 80 00       	push   $0x802a2f
  802211:	6a 48                	push   $0x48
  802213:	68 44 2a 80 00       	push   $0x802a44
  802218:	e8 e6 fe ff ff       	call   802103 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80221d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802220:	5b                   	pop    %ebx
  802221:	5e                   	pop    %esi
  802222:	5f                   	pop    %edi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    

00802225 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80222b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802230:	89 c2                	mov    %eax,%edx
  802232:	c1 e2 07             	shl    $0x7,%edx
  802235:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80223b:	8b 52 50             	mov    0x50(%edx),%edx
  80223e:	39 ca                	cmp    %ecx,%edx
  802240:	74 11                	je     802253 <ipc_find_env+0x2e>
	for (i = 0; i < NENV; i++)
  802242:	83 c0 01             	add    $0x1,%eax
  802245:	3d 00 04 00 00       	cmp    $0x400,%eax
  80224a:	75 e4                	jne    802230 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80224c:	b8 00 00 00 00       	mov    $0x0,%eax
  802251:	eb 0b                	jmp    80225e <ipc_find_env+0x39>
			return envs[i].env_id;
  802253:	c1 e0 07             	shl    $0x7,%eax
  802256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80225b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80225e:	5d                   	pop    %ebp
  80225f:	c3                   	ret    

00802260 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802266:	89 d0                	mov    %edx,%eax
  802268:	c1 e8 16             	shr    $0x16,%eax
  80226b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802272:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  802277:	f6 c1 01             	test   $0x1,%cl
  80227a:	74 1d                	je     802299 <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  80227c:	c1 ea 0c             	shr    $0xc,%edx
  80227f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  802286:	f6 c2 01             	test   $0x1,%dl
  802289:	74 0e                	je     802299 <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80228b:	c1 ea 0c             	shr    $0xc,%edx
  80228e:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  802295:	ef 
  802296:	0f b7 c0             	movzwl %ax,%eax
}
  802299:	5d                   	pop    %ebp
  80229a:	c3                   	ret    
  80229b:	66 90                	xchg   %ax,%ax
  80229d:	66 90                	xchg   %ax,%ax
  80229f:	90                   	nop

008022a0 <__udivdi3>:
  8022a0:	55                   	push   %ebp
  8022a1:	57                   	push   %edi
  8022a2:	56                   	push   %esi
  8022a3:	53                   	push   %ebx
  8022a4:	83 ec 1c             	sub    $0x1c,%esp
  8022a7:	8b 54 24 3c          	mov    0x3c(%esp),%edx
  8022ab:	8b 6c 24 30          	mov    0x30(%esp),%ebp
  8022af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8022b3:	8b 5c 24 38          	mov    0x38(%esp),%ebx
  8022b7:	85 d2                	test   %edx,%edx
  8022b9:	75 4d                	jne    802308 <__udivdi3+0x68>
  8022bb:	39 f3                	cmp    %esi,%ebx
  8022bd:	76 19                	jbe    8022d8 <__udivdi3+0x38>
  8022bf:	31 ff                	xor    %edi,%edi
  8022c1:	89 e8                	mov    %ebp,%eax
  8022c3:	89 f2                	mov    %esi,%edx
  8022c5:	f7 f3                	div    %ebx
  8022c7:	89 fa                	mov    %edi,%edx
  8022c9:	83 c4 1c             	add    $0x1c,%esp
  8022cc:	5b                   	pop    %ebx
  8022cd:	5e                   	pop    %esi
  8022ce:	5f                   	pop    %edi
  8022cf:	5d                   	pop    %ebp
  8022d0:	c3                   	ret    
  8022d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	89 d9                	mov    %ebx,%ecx
  8022da:	85 db                	test   %ebx,%ebx
  8022dc:	75 0b                	jne    8022e9 <__udivdi3+0x49>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f3                	div    %ebx
  8022e7:	89 c1                	mov    %eax,%ecx
  8022e9:	31 d2                	xor    %edx,%edx
  8022eb:	89 f0                	mov    %esi,%eax
  8022ed:	f7 f1                	div    %ecx
  8022ef:	89 c6                	mov    %eax,%esi
  8022f1:	89 e8                	mov    %ebp,%eax
  8022f3:	89 f7                	mov    %esi,%edi
  8022f5:	f7 f1                	div    %ecx
  8022f7:	89 fa                	mov    %edi,%edx
  8022f9:	83 c4 1c             	add    $0x1c,%esp
  8022fc:	5b                   	pop    %ebx
  8022fd:	5e                   	pop    %esi
  8022fe:	5f                   	pop    %edi
  8022ff:	5d                   	pop    %ebp
  802300:	c3                   	ret    
  802301:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  802308:	39 f2                	cmp    %esi,%edx
  80230a:	77 1c                	ja     802328 <__udivdi3+0x88>
  80230c:	0f bd fa             	bsr    %edx,%edi
  80230f:	83 f7 1f             	xor    $0x1f,%edi
  802312:	75 2c                	jne    802340 <__udivdi3+0xa0>
  802314:	39 f2                	cmp    %esi,%edx
  802316:	72 06                	jb     80231e <__udivdi3+0x7e>
  802318:	31 c0                	xor    %eax,%eax
  80231a:	39 eb                	cmp    %ebp,%ebx
  80231c:	77 a9                	ja     8022c7 <__udivdi3+0x27>
  80231e:	b8 01 00 00 00       	mov    $0x1,%eax
  802323:	eb a2                	jmp    8022c7 <__udivdi3+0x27>
  802325:	8d 76 00             	lea    0x0(%esi),%esi
  802328:	31 ff                	xor    %edi,%edi
  80232a:	31 c0                	xor    %eax,%eax
  80232c:	89 fa                	mov    %edi,%edx
  80232e:	83 c4 1c             	add    $0x1c,%esp
  802331:	5b                   	pop    %ebx
  802332:	5e                   	pop    %esi
  802333:	5f                   	pop    %edi
  802334:	5d                   	pop    %ebp
  802335:	c3                   	ret    
  802336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80233d:	8d 76 00             	lea    0x0(%esi),%esi
  802340:	89 f9                	mov    %edi,%ecx
  802342:	b8 20 00 00 00       	mov    $0x20,%eax
  802347:	29 f8                	sub    %edi,%eax
  802349:	d3 e2                	shl    %cl,%edx
  80234b:	89 54 24 08          	mov    %edx,0x8(%esp)
  80234f:	89 c1                	mov    %eax,%ecx
  802351:	89 da                	mov    %ebx,%edx
  802353:	d3 ea                	shr    %cl,%edx
  802355:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802359:	09 d1                	or     %edx,%ecx
  80235b:	89 f2                	mov    %esi,%edx
  80235d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802361:	89 f9                	mov    %edi,%ecx
  802363:	d3 e3                	shl    %cl,%ebx
  802365:	89 c1                	mov    %eax,%ecx
  802367:	d3 ea                	shr    %cl,%edx
  802369:	89 f9                	mov    %edi,%ecx
  80236b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80236f:	89 eb                	mov    %ebp,%ebx
  802371:	d3 e6                	shl    %cl,%esi
  802373:	89 c1                	mov    %eax,%ecx
  802375:	d3 eb                	shr    %cl,%ebx
  802377:	09 de                	or     %ebx,%esi
  802379:	89 f0                	mov    %esi,%eax
  80237b:	f7 74 24 08          	divl   0x8(%esp)
  80237f:	89 d6                	mov    %edx,%esi
  802381:	89 c3                	mov    %eax,%ebx
  802383:	f7 64 24 0c          	mull   0xc(%esp)
  802387:	39 d6                	cmp    %edx,%esi
  802389:	72 15                	jb     8023a0 <__udivdi3+0x100>
  80238b:	89 f9                	mov    %edi,%ecx
  80238d:	d3 e5                	shl    %cl,%ebp
  80238f:	39 c5                	cmp    %eax,%ebp
  802391:	73 04                	jae    802397 <__udivdi3+0xf7>
  802393:	39 d6                	cmp    %edx,%esi
  802395:	74 09                	je     8023a0 <__udivdi3+0x100>
  802397:	89 d8                	mov    %ebx,%eax
  802399:	31 ff                	xor    %edi,%edi
  80239b:	e9 27 ff ff ff       	jmp    8022c7 <__udivdi3+0x27>
  8023a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023a3:	31 ff                	xor    %edi,%edi
  8023a5:	e9 1d ff ff ff       	jmp    8022c7 <__udivdi3+0x27>
  8023aa:	66 90                	xchg   %ax,%ax
  8023ac:	66 90                	xchg   %ax,%ax
  8023ae:	66 90                	xchg   %ax,%ax

008023b0 <__umoddi3>:
  8023b0:	55                   	push   %ebp
  8023b1:	57                   	push   %edi
  8023b2:	56                   	push   %esi
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 1c             	sub    $0x1c,%esp
  8023b7:	8b 5c 24 34          	mov    0x34(%esp),%ebx
  8023bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023bf:	8b 74 24 30          	mov    0x30(%esp),%esi
  8023c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023c7:	89 da                	mov    %ebx,%edx
  8023c9:	85 c0                	test   %eax,%eax
  8023cb:	75 43                	jne    802410 <__umoddi3+0x60>
  8023cd:	39 df                	cmp    %ebx,%edi
  8023cf:	76 17                	jbe    8023e8 <__umoddi3+0x38>
  8023d1:	89 f0                	mov    %esi,%eax
  8023d3:	f7 f7                	div    %edi
  8023d5:	89 d0                	mov    %edx,%eax
  8023d7:	31 d2                	xor    %edx,%edx
  8023d9:	83 c4 1c             	add    $0x1c,%esp
  8023dc:	5b                   	pop    %ebx
  8023dd:	5e                   	pop    %esi
  8023de:	5f                   	pop    %edi
  8023df:	5d                   	pop    %ebp
  8023e0:	c3                   	ret    
  8023e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8023e8:	89 fd                	mov    %edi,%ebp
  8023ea:	85 ff                	test   %edi,%edi
  8023ec:	75 0b                	jne    8023f9 <__umoddi3+0x49>
  8023ee:	b8 01 00 00 00       	mov    $0x1,%eax
  8023f3:	31 d2                	xor    %edx,%edx
  8023f5:	f7 f7                	div    %edi
  8023f7:	89 c5                	mov    %eax,%ebp
  8023f9:	89 d8                	mov    %ebx,%eax
  8023fb:	31 d2                	xor    %edx,%edx
  8023fd:	f7 f5                	div    %ebp
  8023ff:	89 f0                	mov    %esi,%eax
  802401:	f7 f5                	div    %ebp
  802403:	89 d0                	mov    %edx,%eax
  802405:	eb d0                	jmp    8023d7 <__umoddi3+0x27>
  802407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  80240e:	66 90                	xchg   %ax,%ax
  802410:	89 f1                	mov    %esi,%ecx
  802412:	39 d8                	cmp    %ebx,%eax
  802414:	76 0a                	jbe    802420 <__umoddi3+0x70>
  802416:	89 f0                	mov    %esi,%eax
  802418:	83 c4 1c             	add    $0x1c,%esp
  80241b:	5b                   	pop    %ebx
  80241c:	5e                   	pop    %esi
  80241d:	5f                   	pop    %edi
  80241e:	5d                   	pop    %ebp
  80241f:	c3                   	ret    
  802420:	0f bd e8             	bsr    %eax,%ebp
  802423:	83 f5 1f             	xor    $0x1f,%ebp
  802426:	75 20                	jne    802448 <__umoddi3+0x98>
  802428:	39 d8                	cmp    %ebx,%eax
  80242a:	0f 82 b0 00 00 00    	jb     8024e0 <__umoddi3+0x130>
  802430:	39 f7                	cmp    %esi,%edi
  802432:	0f 86 a8 00 00 00    	jbe    8024e0 <__umoddi3+0x130>
  802438:	89 c8                	mov    %ecx,%eax
  80243a:	83 c4 1c             	add    $0x1c,%esp
  80243d:	5b                   	pop    %ebx
  80243e:	5e                   	pop    %esi
  80243f:	5f                   	pop    %edi
  802440:	5d                   	pop    %ebp
  802441:	c3                   	ret    
  802442:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802448:	89 e9                	mov    %ebp,%ecx
  80244a:	ba 20 00 00 00       	mov    $0x20,%edx
  80244f:	29 ea                	sub    %ebp,%edx
  802451:	d3 e0                	shl    %cl,%eax
  802453:	89 44 24 08          	mov    %eax,0x8(%esp)
  802457:	89 d1                	mov    %edx,%ecx
  802459:	89 f8                	mov    %edi,%eax
  80245b:	d3 e8                	shr    %cl,%eax
  80245d:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802461:	89 54 24 04          	mov    %edx,0x4(%esp)
  802465:	8b 54 24 04          	mov    0x4(%esp),%edx
  802469:	09 c1                	or     %eax,%ecx
  80246b:	89 d8                	mov    %ebx,%eax
  80246d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802471:	89 e9                	mov    %ebp,%ecx
  802473:	d3 e7                	shl    %cl,%edi
  802475:	89 d1                	mov    %edx,%ecx
  802477:	d3 e8                	shr    %cl,%eax
  802479:	89 e9                	mov    %ebp,%ecx
  80247b:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80247f:	d3 e3                	shl    %cl,%ebx
  802481:	89 c7                	mov    %eax,%edi
  802483:	89 d1                	mov    %edx,%ecx
  802485:	89 f0                	mov    %esi,%eax
  802487:	d3 e8                	shr    %cl,%eax
  802489:	89 e9                	mov    %ebp,%ecx
  80248b:	89 fa                	mov    %edi,%edx
  80248d:	d3 e6                	shl    %cl,%esi
  80248f:	09 d8                	or     %ebx,%eax
  802491:	f7 74 24 08          	divl   0x8(%esp)
  802495:	89 d1                	mov    %edx,%ecx
  802497:	89 f3                	mov    %esi,%ebx
  802499:	f7 64 24 0c          	mull   0xc(%esp)
  80249d:	89 c6                	mov    %eax,%esi
  80249f:	89 d7                	mov    %edx,%edi
  8024a1:	39 d1                	cmp    %edx,%ecx
  8024a3:	72 06                	jb     8024ab <__umoddi3+0xfb>
  8024a5:	75 10                	jne    8024b7 <__umoddi3+0x107>
  8024a7:	39 c3                	cmp    %eax,%ebx
  8024a9:	73 0c                	jae    8024b7 <__umoddi3+0x107>
  8024ab:	2b 44 24 0c          	sub    0xc(%esp),%eax
  8024af:	1b 54 24 08          	sbb    0x8(%esp),%edx
  8024b3:	89 d7                	mov    %edx,%edi
  8024b5:	89 c6                	mov    %eax,%esi
  8024b7:	89 ca                	mov    %ecx,%edx
  8024b9:	0f b6 4c 24 04       	movzbl 0x4(%esp),%ecx
  8024be:	29 f3                	sub    %esi,%ebx
  8024c0:	19 fa                	sbb    %edi,%edx
  8024c2:	89 d0                	mov    %edx,%eax
  8024c4:	d3 e0                	shl    %cl,%eax
  8024c6:	89 e9                	mov    %ebp,%ecx
  8024c8:	d3 eb                	shr    %cl,%ebx
  8024ca:	d3 ea                	shr    %cl,%edx
  8024cc:	09 d8                	or     %ebx,%eax
  8024ce:	83 c4 1c             	add    $0x1c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
  8024d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  8024dd:	8d 76 00             	lea    0x0(%esi),%esi
  8024e0:	89 da                	mov    %ebx,%edx
  8024e2:	29 fe                	sub    %edi,%esi
  8024e4:	19 c2                	sbb    %eax,%edx
  8024e6:	89 f1                	mov    %esi,%ecx
  8024e8:	89 c8                	mov    %ecx,%eax
  8024ea:	e9 4b ff ff ff       	jmp    80243a <__umoddi3+0x8a>
