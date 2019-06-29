
obj/user/faultbadhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 81 0c 00 00       	call   800cc8 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xDeadBeef);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 ef be ad de       	push   $0xdeadbeef
  80004f:	6a 00                	push   $0x0
  800051:	e8 bd 0d 00 00       	call   800e13 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.

	envid_t curenv = sys_getenvid();
  800070:	e8 15 0c 00 00       	call   800c8a <sys_getenvid>
	thisenv = envs + ENVX(curenv);
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  800080:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800085:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008a:	85 db                	test   %ebx,%ebx
  80008c:	7e 07                	jle    800095 <libmain+0x30>
		binaryname = argv[0];
  80008e:	8b 06                	mov    (%esi),%eax
  800090:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800095:	83 ec 08             	sub    $0x8,%esp
  800098:	56                   	push   %esi
  800099:	53                   	push   %ebx
  80009a:	e8 94 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009f:	e8 0a 00 00 00       	call   8000ae <exit>
}
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000aa:	5b                   	pop    %ebx
  8000ab:	5e                   	pop    %esi
  8000ac:	5d                   	pop    %ebp
  8000ad:	c3                   	ret    

008000ae <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ae:	55                   	push   %ebp
  8000af:	89 e5                	mov    %esp,%ebp
  8000b1:	83 ec 0c             	sub    $0xc,%esp
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  8000b4:	a1 08 40 80 00       	mov    0x804008,%eax
  8000b9:	8b 40 48             	mov    0x48(%eax),%eax
  8000bc:	68 18 25 80 00       	push   $0x802518
  8000c1:	50                   	push   %eax
  8000c2:	68 0a 25 80 00       	push   $0x80250a
  8000c7:	e8 ab 00 00 00       	call   800177 <cprintf>
	close_all();
  8000cc:	e8 c4 10 00 00       	call   801195 <close_all>
	sys_env_destroy(0);
  8000d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000d8:	e8 6c 0b 00 00       	call   800c49 <sys_env_destroy>
}
  8000dd:	83 c4 10             	add    $0x10,%esp
  8000e0:	c9                   	leave  
  8000e1:	c3                   	ret    

008000e2 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e2:	55                   	push   %ebp
  8000e3:	89 e5                	mov    %esp,%ebp
  8000e5:	53                   	push   %ebx
  8000e6:	83 ec 04             	sub    $0x4,%esp
  8000e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ec:	8b 13                	mov    (%ebx),%edx
  8000ee:	8d 42 01             	lea    0x1(%edx),%eax
  8000f1:	89 03                	mov    %eax,(%ebx)
  8000f3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000f6:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000fa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000ff:	74 09                	je     80010a <putch+0x28>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800101:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800105:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800108:	c9                   	leave  
  800109:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80010a:	83 ec 08             	sub    $0x8,%esp
  80010d:	68 ff 00 00 00       	push   $0xff
  800112:	8d 43 08             	lea    0x8(%ebx),%eax
  800115:	50                   	push   %eax
  800116:	e8 f1 0a 00 00       	call   800c0c <sys_cputs>
		b->idx = 0;
  80011b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	eb db                	jmp    800101 <putch+0x1f>

00800126 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800126:	55                   	push   %ebp
  800127:	89 e5                	mov    %esp,%ebp
  800129:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80012f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800136:	00 00 00 
	b.cnt = 0;
  800139:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800140:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800143:	ff 75 0c             	pushl  0xc(%ebp)
  800146:	ff 75 08             	pushl  0x8(%ebp)
  800149:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80014f:	50                   	push   %eax
  800150:	68 e2 00 80 00       	push   $0x8000e2
  800155:	e8 4a 01 00 00       	call   8002a4 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80015a:	83 c4 08             	add    $0x8,%esp
  80015d:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800163:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800169:	50                   	push   %eax
  80016a:	e8 9d 0a 00 00       	call   800c0c <sys_cputs>

	return b.cnt;
}
  80016f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800175:	c9                   	leave  
  800176:	c3                   	ret    

00800177 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800177:	55                   	push   %ebp
  800178:	89 e5                	mov    %esp,%ebp
  80017a:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80017d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800180:	50                   	push   %eax
  800181:	ff 75 08             	pushl  0x8(%ebp)
  800184:	e8 9d ff ff ff       	call   800126 <vcprintf>
	va_end(ap);

	return cnt;
}
  800189:	c9                   	leave  
  80018a:	c3                   	ret    

0080018b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80018b:	55                   	push   %ebp
  80018c:	89 e5                	mov    %esp,%ebp
  80018e:	57                   	push   %edi
  80018f:	56                   	push   %esi
  800190:	53                   	push   %ebx
  800191:	83 ec 1c             	sub    $0x1c,%esp
  800194:	89 c6                	mov    %eax,%esi
  800196:	89 d7                	mov    %edx,%edi
  800198:	8b 45 08             	mov    0x8(%ebp),%eax
  80019b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80019e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8001a1:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8001a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8001a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
	// if cprintf'parameter includes pattern of the form "%-", padding
	// space on the right side if neccesary.
	// you can add helper function if needed.
	// your code here:
	if(padc == '-'){
  8001aa:	83 7d 18 2d          	cmpl   $0x2d,0x18(%ebp)
  8001ae:	74 2c                	je     8001dc <printnum+0x51>
		while (--width > 0)
			putch(padc, putdat);
	}
	else {
		// first recursively print all preceding (more significant) digits
		if (num >= base) {
  8001b0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001b3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8001ba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8001bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8001c0:	39 c2                	cmp    %eax,%edx
  8001c2:	1b 4d dc             	sbb    -0x24(%ebp),%ecx
  8001c5:	73 43                	jae    80020a <printnum+0x7f>
			printnum(putch, putdat, num / base, base, width - 1, padc);
		} else {
			// print any needed pad characters before first digit
			while (--width > 0)
  8001c7:	83 eb 01             	sub    $0x1,%ebx
  8001ca:	85 db                	test   %ebx,%ebx
  8001cc:	7e 6c                	jle    80023a <printnum+0xaf>
				putch(padc, putdat);
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	57                   	push   %edi
  8001d2:	ff 75 18             	pushl  0x18(%ebp)
  8001d5:	ff d6                	call   *%esi
  8001d7:	83 c4 10             	add    $0x10,%esp
  8001da:	eb eb                	jmp    8001c7 <printnum+0x3c>
		printnum(putch, putdat, num, base, 0, padc);
  8001dc:	83 ec 0c             	sub    $0xc,%esp
  8001df:	6a 20                	push   $0x20
  8001e1:	6a 00                	push   $0x0
  8001e3:	50                   	push   %eax
  8001e4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001e7:	ff 75 e0             	pushl  -0x20(%ebp)
  8001ea:	89 fa                	mov    %edi,%edx
  8001ec:	89 f0                	mov    %esi,%eax
  8001ee:	e8 98 ff ff ff       	call   80018b <printnum>
		while (--width > 0)
  8001f3:	83 c4 20             	add    $0x20,%esp
  8001f6:	83 eb 01             	sub    $0x1,%ebx
  8001f9:	85 db                	test   %ebx,%ebx
  8001fb:	7e 65                	jle    800262 <printnum+0xd7>
			putch(padc, putdat);
  8001fd:	83 ec 08             	sub    $0x8,%esp
  800200:	57                   	push   %edi
  800201:	6a 20                	push   $0x20
  800203:	ff d6                	call   *%esi
  800205:	83 c4 10             	add    $0x10,%esp
  800208:	eb ec                	jmp    8001f6 <printnum+0x6b>
			printnum(putch, putdat, num / base, base, width - 1, padc);
  80020a:	83 ec 0c             	sub    $0xc,%esp
  80020d:	ff 75 18             	pushl  0x18(%ebp)
  800210:	83 eb 01             	sub    $0x1,%ebx
  800213:	53                   	push   %ebx
  800214:	50                   	push   %eax
  800215:	83 ec 08             	sub    $0x8,%esp
  800218:	ff 75 dc             	pushl  -0x24(%ebp)
  80021b:	ff 75 d8             	pushl  -0x28(%ebp)
  80021e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800221:	ff 75 e0             	pushl  -0x20(%ebp)
  800224:	e8 87 20 00 00       	call   8022b0 <__udivdi3>
  800229:	83 c4 18             	add    $0x18,%esp
  80022c:	52                   	push   %edx
  80022d:	50                   	push   %eax
  80022e:	89 fa                	mov    %edi,%edx
  800230:	89 f0                	mov    %esi,%eax
  800232:	e8 54 ff ff ff       	call   80018b <printnum>
  800237:	83 c4 20             	add    $0x20,%esp
		}

		// then print this (the least significant) digit
		putch("0123456789abcdef"[num % base], putdat);
  80023a:	83 ec 08             	sub    $0x8,%esp
  80023d:	57                   	push   %edi
  80023e:	83 ec 04             	sub    $0x4,%esp
  800241:	ff 75 dc             	pushl  -0x24(%ebp)
  800244:	ff 75 d8             	pushl  -0x28(%ebp)
  800247:	ff 75 e4             	pushl  -0x1c(%ebp)
  80024a:	ff 75 e0             	pushl  -0x20(%ebp)
  80024d:	e8 6e 21 00 00       	call   8023c0 <__umoddi3>
  800252:	83 c4 14             	add    $0x14,%esp
  800255:	0f be 80 1d 25 80 00 	movsbl 0x80251d(%eax),%eax
  80025c:	50                   	push   %eax
  80025d:	ff d6                	call   *%esi
  80025f:	83 c4 10             	add    $0x10,%esp
	}
}
  800262:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800265:	5b                   	pop    %ebx
  800266:	5e                   	pop    %esi
  800267:	5f                   	pop    %edi
  800268:	5d                   	pop    %ebp
  800269:	c3                   	ret    

0080026a <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80026a:	55                   	push   %ebp
  80026b:	89 e5                	mov    %esp,%ebp
  80026d:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800270:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800274:	8b 10                	mov    (%eax),%edx
  800276:	3b 50 04             	cmp    0x4(%eax),%edx
  800279:	73 0a                	jae    800285 <sprintputch+0x1b>
		*b->buf++ = ch;
  80027b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80027e:	89 08                	mov    %ecx,(%eax)
  800280:	8b 45 08             	mov    0x8(%ebp),%eax
  800283:	88 02                	mov    %al,(%edx)
}
  800285:	5d                   	pop    %ebp
  800286:	c3                   	ret    

00800287 <printfmt>:
{
  800287:	55                   	push   %ebp
  800288:	89 e5                	mov    %esp,%ebp
  80028a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80028d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800290:	50                   	push   %eax
  800291:	ff 75 10             	pushl  0x10(%ebp)
  800294:	ff 75 0c             	pushl  0xc(%ebp)
  800297:	ff 75 08             	pushl  0x8(%ebp)
  80029a:	e8 05 00 00 00       	call   8002a4 <vprintfmt>
}
  80029f:	83 c4 10             	add    $0x10,%esp
  8002a2:	c9                   	leave  
  8002a3:	c3                   	ret    

008002a4 <vprintfmt>:
{
  8002a4:	55                   	push   %ebp
  8002a5:	89 e5                	mov    %esp,%ebp
  8002a7:	57                   	push   %edi
  8002a8:	56                   	push   %esi
  8002a9:	53                   	push   %ebx
  8002aa:	83 ec 3c             	sub    $0x3c,%esp
  8002ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b3:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002b6:	e9 32 04 00 00       	jmp    8006ed <vprintfmt+0x449>
		padc = ' ';
  8002bb:	c6 45 cf 20          	movb   $0x20,-0x31(%ebp)
		plusflag = 0;
  8002bf:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
		altflag = 0;
  8002c6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
		precision = -1;
  8002cd:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
		width = -1;
  8002d4:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8002db:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
  8002e2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002e7:	8d 47 01             	lea    0x1(%edi),%eax
  8002ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ed:	0f b6 17             	movzbl (%edi),%edx
  8002f0:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002f3:	3c 55                	cmp    $0x55,%al
  8002f5:	0f 87 12 05 00 00    	ja     80080d <vprintfmt+0x569>
  8002fb:	0f b6 c0             	movzbl %al,%eax
  8002fe:	ff 24 85 00 27 80 00 	jmp    *0x802700(,%eax,4)
  800305:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800308:	c6 45 cf 2d          	movb   $0x2d,-0x31(%ebp)
  80030c:	eb d9                	jmp    8002e7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800311:	c6 45 cf 30          	movb   $0x30,-0x31(%ebp)
  800315:	eb d0                	jmp    8002e7 <vprintfmt+0x43>
		switch (ch = *(unsigned char *) fmt++) {
  800317:	0f b6 d2             	movzbl %dl,%edx
  80031a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			for (precision = 0; ; ++fmt) {
  80031d:	b8 00 00 00 00       	mov    $0x0,%eax
  800322:	89 75 08             	mov    %esi,0x8(%ebp)
  800325:	eb 03                	jmp    80032a <vprintfmt+0x86>
  800327:	83 c7 01             	add    $0x1,%edi
				precision = precision * 10 + ch - '0';
  80032a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80032d:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
				ch = *fmt;
  800331:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800334:	8d 72 d0             	lea    -0x30(%edx),%esi
  800337:	83 fe 09             	cmp    $0x9,%esi
  80033a:	76 eb                	jbe    800327 <vprintfmt+0x83>
  80033c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80033f:	8b 75 08             	mov    0x8(%ebp),%esi
  800342:	eb 14                	jmp    800358 <vprintfmt+0xb4>
			precision = va_arg(ap, int);
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8b 00                	mov    (%eax),%eax
  800349:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80034c:	8b 45 14             	mov    0x14(%ebp),%eax
  80034f:	8d 40 04             	lea    0x4(%eax),%eax
  800352:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800358:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80035c:	79 89                	jns    8002e7 <vprintfmt+0x43>
				width = precision, precision = -1;
  80035e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800361:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800364:	c7 45 d8 ff ff ff ff 	movl   $0xffffffff,-0x28(%ebp)
  80036b:	e9 77 ff ff ff       	jmp    8002e7 <vprintfmt+0x43>
  800370:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800373:	85 c0                	test   %eax,%eax
  800375:	0f 48 c1             	cmovs  %ecx,%eax
  800378:	89 45 e0             	mov    %eax,-0x20(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80037b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80037e:	e9 64 ff ff ff       	jmp    8002e7 <vprintfmt+0x43>
  800383:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800386:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
			goto reswitch;
  80038d:	e9 55 ff ff ff       	jmp    8002e7 <vprintfmt+0x43>
			lflag++;
  800392:	83 45 c8 01          	addl   $0x1,-0x38(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800396:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800399:	e9 49 ff ff ff       	jmp    8002e7 <vprintfmt+0x43>
			putch(va_arg(ap, int), putdat);
  80039e:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a1:	8d 78 04             	lea    0x4(%eax),%edi
  8003a4:	83 ec 08             	sub    $0x8,%esp
  8003a7:	53                   	push   %ebx
  8003a8:	ff 30                	pushl  (%eax)
  8003aa:	ff d6                	call   *%esi
			break;
  8003ac:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003af:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003b2:	e9 33 03 00 00       	jmp    8006ea <vprintfmt+0x446>
			err = va_arg(ap, int);
  8003b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ba:	8d 78 04             	lea    0x4(%eax),%edi
  8003bd:	8b 00                	mov    (%eax),%eax
  8003bf:	99                   	cltd   
  8003c0:	31 d0                	xor    %edx,%eax
  8003c2:	29 d0                	sub    %edx,%eax
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003c4:	83 f8 11             	cmp    $0x11,%eax
  8003c7:	7f 23                	jg     8003ec <vprintfmt+0x148>
  8003c9:	8b 14 85 60 28 80 00 	mov    0x802860(,%eax,4),%edx
  8003d0:	85 d2                	test   %edx,%edx
  8003d2:	74 18                	je     8003ec <vprintfmt+0x148>
				printfmt(putch, putdat, "%s", p);
  8003d4:	52                   	push   %edx
  8003d5:	68 7d 29 80 00       	push   $0x80297d
  8003da:	53                   	push   %ebx
  8003db:	56                   	push   %esi
  8003dc:	e8 a6 fe ff ff       	call   800287 <printfmt>
  8003e1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003e4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003e7:	e9 fe 02 00 00       	jmp    8006ea <vprintfmt+0x446>
				printfmt(putch, putdat, "error %d", err);
  8003ec:	50                   	push   %eax
  8003ed:	68 35 25 80 00       	push   $0x802535
  8003f2:	53                   	push   %ebx
  8003f3:	56                   	push   %esi
  8003f4:	e8 8e fe ff ff       	call   800287 <printfmt>
  8003f9:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003fc:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003ff:	e9 e6 02 00 00       	jmp    8006ea <vprintfmt+0x446>
			if ((p = va_arg(ap, char *)) == NULL)
  800404:	8b 45 14             	mov    0x14(%ebp),%eax
  800407:	83 c0 04             	add    $0x4,%eax
  80040a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80040d:	8b 45 14             	mov    0x14(%ebp),%eax
  800410:	8b 08                	mov    (%eax),%ecx
				p = "(null)";
  800412:	85 c9                	test   %ecx,%ecx
  800414:	b8 2e 25 80 00       	mov    $0x80252e,%eax
  800419:	0f 45 c1             	cmovne %ecx,%eax
  80041c:	89 45 c8             	mov    %eax,-0x38(%ebp)
			if (width > 0 && padc != '-')
  80041f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800423:	7e 06                	jle    80042b <vprintfmt+0x187>
  800425:	80 7d cf 2d          	cmpb   $0x2d,-0x31(%ebp)
  800429:	75 0d                	jne    800438 <vprintfmt+0x194>
				for (width -= strnlen(p, precision); width > 0; width--)
  80042b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042e:	89 c7                	mov    %eax,%edi
  800430:	03 45 e0             	add    -0x20(%ebp),%eax
  800433:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800436:	eb 53                	jmp    80048b <vprintfmt+0x1e7>
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	ff 75 d8             	pushl  -0x28(%ebp)
  80043e:	50                   	push   %eax
  80043f:	e8 71 04 00 00       	call   8008b5 <strnlen>
  800444:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800447:	29 c1                	sub    %eax,%ecx
  800449:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80044c:	83 c4 10             	add    $0x10,%esp
  80044f:	89 cf                	mov    %ecx,%edi
					putch(padc, putdat);
  800451:	0f be 45 cf          	movsbl -0x31(%ebp),%eax
  800455:	89 45 e0             	mov    %eax,-0x20(%ebp)
				for (width -= strnlen(p, precision); width > 0; width--)
  800458:	eb 0f                	jmp    800469 <vprintfmt+0x1c5>
					putch(padc, putdat);
  80045a:	83 ec 08             	sub    $0x8,%esp
  80045d:	53                   	push   %ebx
  80045e:	ff 75 e0             	pushl  -0x20(%ebp)
  800461:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800463:	83 ef 01             	sub    $0x1,%edi
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	85 ff                	test   %edi,%edi
  80046b:	7f ed                	jg     80045a <vprintfmt+0x1b6>
  80046d:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800470:	85 c9                	test   %ecx,%ecx
  800472:	b8 00 00 00 00       	mov    $0x0,%eax
  800477:	0f 49 c1             	cmovns %ecx,%eax
  80047a:	29 c1                	sub    %eax,%ecx
  80047c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80047f:	eb aa                	jmp    80042b <vprintfmt+0x187>
					putch(ch, putdat);
  800481:	83 ec 08             	sub    $0x8,%esp
  800484:	53                   	push   %ebx
  800485:	52                   	push   %edx
  800486:	ff d6                	call   *%esi
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80048e:	29 f9                	sub    %edi,%ecx
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800490:	83 c7 01             	add    $0x1,%edi
  800493:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800497:	0f be d0             	movsbl %al,%edx
  80049a:	85 d2                	test   %edx,%edx
  80049c:	74 4b                	je     8004e9 <vprintfmt+0x245>
  80049e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a2:	78 06                	js     8004aa <vprintfmt+0x206>
  8004a4:	83 6d d8 01          	subl   $0x1,-0x28(%ebp)
  8004a8:	78 1e                	js     8004c8 <vprintfmt+0x224>
				if (altflag && (ch < ' ' || ch > '~'))
  8004aa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8004ae:	74 d1                	je     800481 <vprintfmt+0x1dd>
  8004b0:	0f be c0             	movsbl %al,%eax
  8004b3:	83 e8 20             	sub    $0x20,%eax
  8004b6:	83 f8 5e             	cmp    $0x5e,%eax
  8004b9:	76 c6                	jbe    800481 <vprintfmt+0x1dd>
					putch('?', putdat);
  8004bb:	83 ec 08             	sub    $0x8,%esp
  8004be:	53                   	push   %ebx
  8004bf:	6a 3f                	push   $0x3f
  8004c1:	ff d6                	call   *%esi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	eb c3                	jmp    80048b <vprintfmt+0x1e7>
  8004c8:	89 cf                	mov    %ecx,%edi
  8004ca:	eb 0e                	jmp    8004da <vprintfmt+0x236>
				putch(' ', putdat);
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	53                   	push   %ebx
  8004d0:	6a 20                	push   $0x20
  8004d2:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004d4:	83 ef 01             	sub    $0x1,%edi
  8004d7:	83 c4 10             	add    $0x10,%esp
  8004da:	85 ff                	test   %edi,%edi
  8004dc:	7f ee                	jg     8004cc <vprintfmt+0x228>
			if ((p = va_arg(ap, char *)) == NULL)
  8004de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004e1:	89 45 14             	mov    %eax,0x14(%ebp)
  8004e4:	e9 01 02 00 00       	jmp    8006ea <vprintfmt+0x446>
  8004e9:	89 cf                	mov    %ecx,%edi
  8004eb:	eb ed                	jmp    8004da <vprintfmt+0x236>
		switch (ch = *(unsigned char *) fmt++) {
  8004ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			plusflag = 1;
  8004f0:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
			goto reswitch;
  8004f7:	e9 eb fd ff ff       	jmp    8002e7 <vprintfmt+0x43>
	if (lflag >= 2)
  8004fc:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800500:	7f 21                	jg     800523 <vprintfmt+0x27f>
	else if (lflag)
  800502:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  800506:	74 68                	je     800570 <vprintfmt+0x2cc>
		return va_arg(*ap, long);
  800508:	8b 45 14             	mov    0x14(%ebp),%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800510:	89 c1                	mov    %eax,%ecx
  800512:	c1 f9 1f             	sar    $0x1f,%ecx
  800515:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800518:	8b 45 14             	mov    0x14(%ebp),%eax
  80051b:	8d 40 04             	lea    0x4(%eax),%eax
  80051e:	89 45 14             	mov    %eax,0x14(%ebp)
  800521:	eb 17                	jmp    80053a <vprintfmt+0x296>
		return va_arg(*ap, long long);
  800523:	8b 45 14             	mov    0x14(%ebp),%eax
  800526:	8b 50 04             	mov    0x4(%eax),%edx
  800529:	8b 00                	mov    (%eax),%eax
  80052b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80052e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800531:	8b 45 14             	mov    0x14(%ebp),%eax
  800534:	8d 40 08             	lea    0x8(%eax),%eax
  800537:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80053a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80053d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800540:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800543:	89 55 dc             	mov    %edx,-0x24(%ebp)
			if ((long long) num < 0) {
  800546:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80054a:	78 3f                	js     80058b <vprintfmt+0x2e7>
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
			else if(plusflag){
  800551:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
  800555:	0f 84 71 01 00 00    	je     8006cc <vprintfmt+0x428>
				putch('+', putdat);
  80055b:	83 ec 08             	sub    $0x8,%esp
  80055e:	53                   	push   %ebx
  80055f:	6a 2b                	push   $0x2b
  800561:	ff d6                	call   *%esi
  800563:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800566:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056b:	e9 5c 01 00 00       	jmp    8006cc <vprintfmt+0x428>
		return va_arg(*ap, int);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800578:	89 c1                	mov    %eax,%ecx
  80057a:	c1 f9 1f             	sar    $0x1f,%ecx
  80057d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800580:	8b 45 14             	mov    0x14(%ebp),%eax
  800583:	8d 40 04             	lea    0x4(%eax),%eax
  800586:	89 45 14             	mov    %eax,0x14(%ebp)
  800589:	eb af                	jmp    80053a <vprintfmt+0x296>
				putch('-', putdat);
  80058b:	83 ec 08             	sub    $0x8,%esp
  80058e:	53                   	push   %ebx
  80058f:	6a 2d                	push   $0x2d
  800591:	ff d6                	call   *%esi
				num = -(long long) num;
  800593:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800596:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800599:	f7 d8                	neg    %eax
  80059b:	83 d2 00             	adc    $0x0,%edx
  80059e:	f7 da                	neg    %edx
  8005a0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005a6:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005a9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ae:	e9 19 01 00 00       	jmp    8006cc <vprintfmt+0x428>
	if (lflag >= 2)
  8005b3:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  8005b7:	7f 29                	jg     8005e2 <vprintfmt+0x33e>
	else if (lflag)
  8005b9:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  8005bd:	74 44                	je     800603 <vprintfmt+0x35f>
		return va_arg(*ap, unsigned long);
  8005bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c2:	8b 00                	mov    (%eax),%eax
  8005c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 40 04             	lea    0x4(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d8:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005dd:	e9 ea 00 00 00       	jmp    8006cc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 50 04             	mov    0x4(%eax),%edx
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ed:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f3:	8d 40 08             	lea    0x8(%eax),%eax
  8005f6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005fe:	e9 c9 00 00 00       	jmp    8006cc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  800603:	8b 45 14             	mov    0x14(%ebp),%eax
  800606:	8b 00                	mov    (%eax),%eax
  800608:	ba 00 00 00 00       	mov    $0x0,%edx
  80060d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800610:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	8d 40 04             	lea    0x4(%eax),%eax
  800619:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80061c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800621:	e9 a6 00 00 00       	jmp    8006cc <vprintfmt+0x428>
			putch('0', putdat);
  800626:	83 ec 08             	sub    $0x8,%esp
  800629:	53                   	push   %ebx
  80062a:	6a 30                	push   $0x30
  80062c:	ff d6                	call   *%esi
	if (lflag >= 2)
  80062e:	83 c4 10             	add    $0x10,%esp
  800631:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800635:	7f 26                	jg     80065d <vprintfmt+0x3b9>
	else if (lflag)
  800637:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80063b:	74 3e                	je     80067b <vprintfmt+0x3d7>
		return va_arg(*ap, unsigned long);
  80063d:	8b 45 14             	mov    0x14(%ebp),%eax
  800640:	8b 00                	mov    (%eax),%eax
  800642:	ba 00 00 00 00       	mov    $0x0,%edx
  800647:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80064a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80064d:	8b 45 14             	mov    0x14(%ebp),%eax
  800650:	8d 40 04             	lea    0x4(%eax),%eax
  800653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800656:	b8 08 00 00 00       	mov    $0x8,%eax
  80065b:	eb 6f                	jmp    8006cc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80065d:	8b 45 14             	mov    0x14(%ebp),%eax
  800660:	8b 50 04             	mov    0x4(%eax),%edx
  800663:	8b 00                	mov    (%eax),%eax
  800665:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800668:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80066b:	8b 45 14             	mov    0x14(%ebp),%eax
  80066e:	8d 40 08             	lea    0x8(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800674:	b8 08 00 00 00       	mov    $0x8,%eax
  800679:	eb 51                	jmp    8006cc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 00                	mov    (%eax),%eax
  800680:	ba 00 00 00 00       	mov    $0x0,%edx
  800685:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800688:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80068b:	8b 45 14             	mov    0x14(%ebp),%eax
  80068e:	8d 40 04             	lea    0x4(%eax),%eax
  800691:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800694:	b8 08 00 00 00       	mov    $0x8,%eax
  800699:	eb 31                	jmp    8006cc <vprintfmt+0x428>
			putch('0', putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	53                   	push   %ebx
  80069f:	6a 30                	push   $0x30
  8006a1:	ff d6                	call   *%esi
			putch('x', putdat);
  8006a3:	83 c4 08             	add    $0x8,%esp
  8006a6:	53                   	push   %ebx
  8006a7:	6a 78                	push   $0x78
  8006a9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ae:	8b 00                	mov    (%eax),%eax
  8006b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
			goto number;
  8006bb:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 40 04             	lea    0x4(%eax),%eax
  8006c4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006cc:	83 ec 0c             	sub    $0xc,%esp
  8006cf:	0f be 55 cf          	movsbl -0x31(%ebp),%edx
  8006d3:	52                   	push   %edx
  8006d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d7:	50                   	push   %eax
  8006d8:	ff 75 dc             	pushl  -0x24(%ebp)
  8006db:	ff 75 d8             	pushl  -0x28(%ebp)
  8006de:	89 da                	mov    %ebx,%edx
  8006e0:	89 f0                	mov    %esi,%eax
  8006e2:	e8 a4 fa ff ff       	call   80018b <printnum>
			break;
  8006e7:	83 c4 20             	add    $0x20,%esp
			if ((p = va_arg(ap, char *)) == NULL)
  8006ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ed:	83 c7 01             	add    $0x1,%edi
  8006f0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006f4:	83 f8 25             	cmp    $0x25,%eax
  8006f7:	0f 84 be fb ff ff    	je     8002bb <vprintfmt+0x17>
			if (ch == '\0')
  8006fd:	85 c0                	test   %eax,%eax
  8006ff:	0f 84 28 01 00 00    	je     80082d <vprintfmt+0x589>
			putch(ch, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	53                   	push   %ebx
  800709:	50                   	push   %eax
  80070a:	ff d6                	call   *%esi
  80070c:	83 c4 10             	add    $0x10,%esp
  80070f:	eb dc                	jmp    8006ed <vprintfmt+0x449>
	if (lflag >= 2)
  800711:	83 7d c8 01          	cmpl   $0x1,-0x38(%ebp)
  800715:	7f 26                	jg     80073d <vprintfmt+0x499>
	else if (lflag)
  800717:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  80071b:	74 41                	je     80075e <vprintfmt+0x4ba>
		return va_arg(*ap, unsigned long);
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	ba 00 00 00 00       	mov    $0x0,%edx
  800727:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80072a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8d 40 04             	lea    0x4(%eax),%eax
  800733:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800736:	b8 10 00 00 00       	mov    $0x10,%eax
  80073b:	eb 8f                	jmp    8006cc <vprintfmt+0x428>
		return va_arg(*ap, unsigned long long);
  80073d:	8b 45 14             	mov    0x14(%ebp),%eax
  800740:	8b 50 04             	mov    0x4(%eax),%edx
  800743:	8b 00                	mov    (%eax),%eax
  800745:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800748:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	8d 40 08             	lea    0x8(%eax),%eax
  800751:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800754:	b8 10 00 00 00       	mov    $0x10,%eax
  800759:	e9 6e ff ff ff       	jmp    8006cc <vprintfmt+0x428>
		return va_arg(*ap, unsigned int);
  80075e:	8b 45 14             	mov    0x14(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	ba 00 00 00 00       	mov    $0x0,%edx
  800768:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80076b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80076e:	8b 45 14             	mov    0x14(%ebp),%eax
  800771:	8d 40 04             	lea    0x4(%eax),%eax
  800774:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800777:	b8 10 00 00 00       	mov    $0x10,%eax
  80077c:	e9 4b ff ff ff       	jmp    8006cc <vprintfmt+0x428>
					if ((p = va_arg(ap, char *)) == NULL){
  800781:	8b 45 14             	mov    0x14(%ebp),%eax
  800784:	83 c0 04             	add    $0x4,%eax
  800787:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8b 00                	mov    (%eax),%eax
  80078f:	85 c0                	test   %eax,%eax
  800791:	74 14                	je     8007a7 <vprintfmt+0x503>
					}else if(*(int *)putdat > 127){
  800793:	8b 13                	mov    (%ebx),%edx
  800795:	83 fa 7f             	cmp    $0x7f,%edx
  800798:	7f 37                	jg     8007d1 <vprintfmt+0x52d>
						*(char *)p = *(int *)putdat;
  80079a:	88 10                	mov    %dl,(%eax)
					if ((p = va_arg(ap, char *)) == NULL){
  80079c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80079f:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a2:	e9 43 ff ff ff       	jmp    8006ea <vprintfmt+0x446>
						for (; (ch = *tmp++) != '\0';){
  8007a7:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007ac:	bf 51 26 80 00       	mov    $0x802651,%edi
							putch(ch, putdat);
  8007b1:	83 ec 08             	sub    $0x8,%esp
  8007b4:	53                   	push   %ebx
  8007b5:	50                   	push   %eax
  8007b6:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007b8:	83 c7 01             	add    $0x1,%edi
  8007bb:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007bf:	83 c4 10             	add    $0x10,%esp
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	75 eb                	jne    8007b1 <vprintfmt+0x50d>
					if ((p = va_arg(ap, char *)) == NULL){
  8007c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cc:	e9 19 ff ff ff       	jmp    8006ea <vprintfmt+0x446>
						*(char *)p = *(int *)putdat;
  8007d1:	88 10                	mov    %dl,(%eax)
						for (; (ch = *tmp++) != '\0';){
  8007d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d8:	bf 89 26 80 00       	mov    $0x802689,%edi
							putch(ch, putdat);
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	53                   	push   %ebx
  8007e1:	50                   	push   %eax
  8007e2:	ff d6                	call   *%esi
						for (; (ch = *tmp++) != '\0';){
  8007e4:	83 c7 01             	add    $0x1,%edi
  8007e7:	0f be 47 ff          	movsbl -0x1(%edi),%eax
  8007eb:	83 c4 10             	add    $0x10,%esp
  8007ee:	85 c0                	test   %eax,%eax
  8007f0:	75 eb                	jne    8007dd <vprintfmt+0x539>
					if ((p = va_arg(ap, char *)) == NULL){
  8007f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8007f8:	e9 ed fe ff ff       	jmp    8006ea <vprintfmt+0x446>
			putch(ch, putdat);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	53                   	push   %ebx
  800801:	6a 25                	push   $0x25
  800803:	ff d6                	call   *%esi
			break;
  800805:	83 c4 10             	add    $0x10,%esp
  800808:	e9 dd fe ff ff       	jmp    8006ea <vprintfmt+0x446>
			putch('%', putdat);
  80080d:	83 ec 08             	sub    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	6a 25                	push   $0x25
  800813:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800815:	83 c4 10             	add    $0x10,%esp
  800818:	89 f8                	mov    %edi,%eax
  80081a:	eb 03                	jmp    80081f <vprintfmt+0x57b>
  80081c:	83 e8 01             	sub    $0x1,%eax
  80081f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800823:	75 f7                	jne    80081c <vprintfmt+0x578>
  800825:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800828:	e9 bd fe ff ff       	jmp    8006ea <vprintfmt+0x446>
}
  80082d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800830:	5b                   	pop    %ebx
  800831:	5e                   	pop    %esi
  800832:	5f                   	pop    %edi
  800833:	5d                   	pop    %ebp
  800834:	c3                   	ret    

00800835 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	83 ec 18             	sub    $0x18,%esp
  80083b:	8b 45 08             	mov    0x8(%ebp),%eax
  80083e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800841:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800844:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800848:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80084b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800852:	85 c0                	test   %eax,%eax
  800854:	74 26                	je     80087c <vsnprintf+0x47>
  800856:	85 d2                	test   %edx,%edx
  800858:	7e 22                	jle    80087c <vsnprintf+0x47>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80085a:	ff 75 14             	pushl  0x14(%ebp)
  80085d:	ff 75 10             	pushl  0x10(%ebp)
  800860:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800863:	50                   	push   %eax
  800864:	68 6a 02 80 00       	push   $0x80026a
  800869:	e8 36 fa ff ff       	call   8002a4 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80086e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800871:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800877:	83 c4 10             	add    $0x10,%esp
}
  80087a:	c9                   	leave  
  80087b:	c3                   	ret    
		return -E_INVAL;
  80087c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800881:	eb f7                	jmp    80087a <vsnprintf+0x45>

00800883 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800889:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80088c:	50                   	push   %eax
  80088d:	ff 75 10             	pushl  0x10(%ebp)
  800890:	ff 75 0c             	pushl  0xc(%ebp)
  800893:	ff 75 08             	pushl  0x8(%ebp)
  800896:	e8 9a ff ff ff       	call   800835 <vsnprintf>
	va_end(ap);

	return rc;
}
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8008a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8008ac:	74 05                	je     8008b3 <strlen+0x16>
		n++;
  8008ae:	83 c0 01             	add    $0x1,%eax
  8008b1:	eb f5                	jmp    8008a8 <strlen+0xb>
	return n;
}
  8008b3:	5d                   	pop    %ebp
  8008b4:	c3                   	ret    

008008b5 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8008b5:	55                   	push   %ebp
  8008b6:	89 e5                	mov    %esp,%ebp
  8008b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008bb:	8b 45 0c             	mov    0xc(%ebp),%eax
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8008be:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c3:	39 c2                	cmp    %eax,%edx
  8008c5:	74 0d                	je     8008d4 <strnlen+0x1f>
  8008c7:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  8008cb:	74 05                	je     8008d2 <strnlen+0x1d>
		n++;
  8008cd:	83 c2 01             	add    $0x1,%edx
  8008d0:	eb f1                	jmp    8008c3 <strnlen+0xe>
  8008d2:	89 d0                	mov    %edx,%eax
	return n;
}
  8008d4:	5d                   	pop    %ebp
  8008d5:	c3                   	ret    

008008d6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	53                   	push   %ebx
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8008e5:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008e9:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008ec:	83 c2 01             	add    $0x1,%edx
  8008ef:	84 c9                	test   %cl,%cl
  8008f1:	75 f2                	jne    8008e5 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008f3:	5b                   	pop    %ebx
  8008f4:	5d                   	pop    %ebp
  8008f5:	c3                   	ret    

008008f6 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008f6:	55                   	push   %ebp
  8008f7:	89 e5                	mov    %esp,%ebp
  8008f9:	53                   	push   %ebx
  8008fa:	83 ec 10             	sub    $0x10,%esp
  8008fd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800900:	53                   	push   %ebx
  800901:	e8 97 ff ff ff       	call   80089d <strlen>
  800906:	83 c4 08             	add    $0x8,%esp
	strcpy(dst + len, src);
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	01 d8                	add    %ebx,%eax
  80090e:	50                   	push   %eax
  80090f:	e8 c2 ff ff ff       	call   8008d6 <strcpy>
	return dst;
}
  800914:	89 d8                	mov    %ebx,%eax
  800916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800919:	c9                   	leave  
  80091a:	c3                   	ret    

0080091b <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80091b:	55                   	push   %ebp
  80091c:	89 e5                	mov    %esp,%ebp
  80091e:	56                   	push   %esi
  80091f:	53                   	push   %ebx
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800926:	89 c6                	mov    %eax,%esi
  800928:	03 75 10             	add    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80092b:	89 c2                	mov    %eax,%edx
  80092d:	39 f2                	cmp    %esi,%edx
  80092f:	74 11                	je     800942 <strncpy+0x27>
		*dst++ = *src;
  800931:	83 c2 01             	add    $0x1,%edx
  800934:	0f b6 19             	movzbl (%ecx),%ebx
  800937:	88 5a ff             	mov    %bl,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80093a:	80 fb 01             	cmp    $0x1,%bl
  80093d:	83 d9 ff             	sbb    $0xffffffff,%ecx
  800940:	eb eb                	jmp    80092d <strncpy+0x12>
	}
	return ret;
}
  800942:	5b                   	pop    %ebx
  800943:	5e                   	pop    %esi
  800944:	5d                   	pop    %ebp
  800945:	c3                   	ret    

00800946 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	56                   	push   %esi
  80094a:	53                   	push   %ebx
  80094b:	8b 75 08             	mov    0x8(%ebp),%esi
  80094e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800951:	8b 55 10             	mov    0x10(%ebp),%edx
  800954:	89 f0                	mov    %esi,%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800956:	85 d2                	test   %edx,%edx
  800958:	74 21                	je     80097b <strlcpy+0x35>
  80095a:	8d 44 16 ff          	lea    -0x1(%esi,%edx,1),%eax
  80095e:	89 f2                	mov    %esi,%edx
		while (--size > 0 && *src != '\0')
  800960:	39 c2                	cmp    %eax,%edx
  800962:	74 14                	je     800978 <strlcpy+0x32>
  800964:	0f b6 19             	movzbl (%ecx),%ebx
  800967:	84 db                	test   %bl,%bl
  800969:	74 0b                	je     800976 <strlcpy+0x30>
			*dst++ = *src++;
  80096b:	83 c1 01             	add    $0x1,%ecx
  80096e:	83 c2 01             	add    $0x1,%edx
  800971:	88 5a ff             	mov    %bl,-0x1(%edx)
  800974:	eb ea                	jmp    800960 <strlcpy+0x1a>
  800976:	89 d0                	mov    %edx,%eax
		*dst = '\0';
  800978:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80097b:	29 f0                	sub    %esi,%eax
}
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800987:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80098a:	0f b6 01             	movzbl (%ecx),%eax
  80098d:	84 c0                	test   %al,%al
  80098f:	74 0c                	je     80099d <strcmp+0x1c>
  800991:	3a 02                	cmp    (%edx),%al
  800993:	75 08                	jne    80099d <strcmp+0x1c>
		p++, q++;
  800995:	83 c1 01             	add    $0x1,%ecx
  800998:	83 c2 01             	add    $0x1,%edx
  80099b:	eb ed                	jmp    80098a <strcmp+0x9>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80099d:	0f b6 c0             	movzbl %al,%eax
  8009a0:	0f b6 12             	movzbl (%edx),%edx
  8009a3:	29 d0                	sub    %edx,%eax
}
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    

008009a7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8009a7:	55                   	push   %ebp
  8009a8:	89 e5                	mov    %esp,%ebp
  8009aa:	53                   	push   %ebx
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	89 c3                	mov    %eax,%ebx
  8009b3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8009b6:	eb 06                	jmp    8009be <strncmp+0x17>
		n--, p++, q++;
  8009b8:	83 c0 01             	add    $0x1,%eax
  8009bb:	83 c2 01             	add    $0x1,%edx
	while (n > 0 && *p && *p == *q)
  8009be:	39 d8                	cmp    %ebx,%eax
  8009c0:	74 16                	je     8009d8 <strncmp+0x31>
  8009c2:	0f b6 08             	movzbl (%eax),%ecx
  8009c5:	84 c9                	test   %cl,%cl
  8009c7:	74 04                	je     8009cd <strncmp+0x26>
  8009c9:	3a 0a                	cmp    (%edx),%cl
  8009cb:	74 eb                	je     8009b8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009cd:	0f b6 00             	movzbl (%eax),%eax
  8009d0:	0f b6 12             	movzbl (%edx),%edx
  8009d3:	29 d0                	sub    %edx,%eax
}
  8009d5:	5b                   	pop    %ebx
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    
		return 0;
  8009d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dd:	eb f6                	jmp    8009d5 <strncmp+0x2e>

008009df <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e9:	0f b6 10             	movzbl (%eax),%edx
  8009ec:	84 d2                	test   %dl,%dl
  8009ee:	74 09                	je     8009f9 <strchr+0x1a>
		if (*s == c)
  8009f0:	38 ca                	cmp    %cl,%dl
  8009f2:	74 0a                	je     8009fe <strchr+0x1f>
	for (; *s; s++)
  8009f4:	83 c0 01             	add    $0x1,%eax
  8009f7:	eb f0                	jmp    8009e9 <strchr+0xa>
			return (char *) s;
	return 0;
  8009f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009fe:	5d                   	pop    %ebp
  8009ff:	c3                   	ret    

00800a00 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a00:	55                   	push   %ebp
  800a01:	89 e5                	mov    %esp,%ebp
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a0a:	0f b6 10             	movzbl (%eax),%edx
		if (*s == c)
  800a0d:	38 ca                	cmp    %cl,%dl
  800a0f:	74 09                	je     800a1a <strfind+0x1a>
  800a11:	84 d2                	test   %dl,%dl
  800a13:	74 05                	je     800a1a <strfind+0x1a>
	for (; *s; s++)
  800a15:	83 c0 01             	add    $0x1,%eax
  800a18:	eb f0                	jmp    800a0a <strfind+0xa>
			break;
	return (char *) s;
}
  800a1a:	5d                   	pop    %ebp
  800a1b:	c3                   	ret    

00800a1c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a1c:	55                   	push   %ebp
  800a1d:	89 e5                	mov    %esp,%ebp
  800a1f:	57                   	push   %edi
  800a20:	56                   	push   %esi
  800a21:	53                   	push   %ebx
  800a22:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a28:	85 c9                	test   %ecx,%ecx
  800a2a:	74 31                	je     800a5d <memset+0x41>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a2c:	89 f8                	mov    %edi,%eax
  800a2e:	09 c8                	or     %ecx,%eax
  800a30:	a8 03                	test   $0x3,%al
  800a32:	75 23                	jne    800a57 <memset+0x3b>
		c &= 0xFF;
  800a34:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a38:	89 d3                	mov    %edx,%ebx
  800a3a:	c1 e3 08             	shl    $0x8,%ebx
  800a3d:	89 d0                	mov    %edx,%eax
  800a3f:	c1 e0 18             	shl    $0x18,%eax
  800a42:	89 d6                	mov    %edx,%esi
  800a44:	c1 e6 10             	shl    $0x10,%esi
  800a47:	09 f0                	or     %esi,%eax
  800a49:	09 c2                	or     %eax,%edx
  800a4b:	09 da                	or     %ebx,%edx
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
  800a4d:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a50:	89 d0                	mov    %edx,%eax
  800a52:	fc                   	cld    
  800a53:	f3 ab                	rep stos %eax,%es:(%edi)
  800a55:	eb 06                	jmp    800a5d <memset+0x41>
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a5a:	fc                   	cld    
  800a5b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a5d:	89 f8                	mov    %edi,%eax
  800a5f:	5b                   	pop    %ebx
  800a60:	5e                   	pop    %esi
  800a61:	5f                   	pop    %edi
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    

00800a64 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a64:	55                   	push   %ebp
  800a65:	89 e5                	mov    %esp,%ebp
  800a67:	57                   	push   %edi
  800a68:	56                   	push   %esi
  800a69:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a6f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a72:	39 c6                	cmp    %eax,%esi
  800a74:	73 32                	jae    800aa8 <memmove+0x44>
  800a76:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a79:	39 c2                	cmp    %eax,%edx
  800a7b:	76 2b                	jbe    800aa8 <memmove+0x44>
		s += n;
		d += n;
  800a7d:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a80:	89 fe                	mov    %edi,%esi
  800a82:	09 ce                	or     %ecx,%esi
  800a84:	09 d6                	or     %edx,%esi
  800a86:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a8c:	75 0e                	jne    800a9c <memmove+0x38>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a8e:	83 ef 04             	sub    $0x4,%edi
  800a91:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a94:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a97:	fd                   	std    
  800a98:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a9a:	eb 09                	jmp    800aa5 <memmove+0x41>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a9c:	83 ef 01             	sub    $0x1,%edi
  800a9f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aa2:	fd                   	std    
  800aa3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800aa5:	fc                   	cld    
  800aa6:	eb 1a                	jmp    800ac2 <memmove+0x5e>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa8:	89 c2                	mov    %eax,%edx
  800aaa:	09 ca                	or     %ecx,%edx
  800aac:	09 f2                	or     %esi,%edx
  800aae:	f6 c2 03             	test   $0x3,%dl
  800ab1:	75 0a                	jne    800abd <memmove+0x59>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ab3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ab6:	89 c7                	mov    %eax,%edi
  800ab8:	fc                   	cld    
  800ab9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800abb:	eb 05                	jmp    800ac2 <memmove+0x5e>
		else
			asm volatile("cld; rep movsb\n"
  800abd:	89 c7                	mov    %eax,%edi
  800abf:	fc                   	cld    
  800ac0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ac2:	5e                   	pop    %esi
  800ac3:	5f                   	pop    %edi
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800acc:	ff 75 10             	pushl  0x10(%ebp)
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	ff 75 08             	pushl  0x8(%ebp)
  800ad5:	e8 8a ff ff ff       	call   800a64 <memmove>
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	56                   	push   %esi
  800ae0:	53                   	push   %ebx
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ae7:	89 c6                	mov    %eax,%esi
  800ae9:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aec:	39 f0                	cmp    %esi,%eax
  800aee:	74 1c                	je     800b0c <memcmp+0x30>
		if (*s1 != *s2)
  800af0:	0f b6 08             	movzbl (%eax),%ecx
  800af3:	0f b6 1a             	movzbl (%edx),%ebx
  800af6:	38 d9                	cmp    %bl,%cl
  800af8:	75 08                	jne    800b02 <memcmp+0x26>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	83 c2 01             	add    $0x1,%edx
  800b00:	eb ea                	jmp    800aec <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b02:	0f b6 c1             	movzbl %cl,%eax
  800b05:	0f b6 db             	movzbl %bl,%ebx
  800b08:	29 d8                	sub    %ebx,%eax
  800b0a:	eb 05                	jmp    800b11 <memcmp+0x35>
	}

	return 0;
  800b0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b11:	5b                   	pop    %ebx
  800b12:	5e                   	pop    %esi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b1e:	89 c2                	mov    %eax,%edx
  800b20:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b23:	39 d0                	cmp    %edx,%eax
  800b25:	73 09                	jae    800b30 <memfind+0x1b>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b27:	38 08                	cmp    %cl,(%eax)
  800b29:	74 05                	je     800b30 <memfind+0x1b>
	for (; s < ends; s++)
  800b2b:	83 c0 01             	add    $0x1,%eax
  800b2e:	eb f3                	jmp    800b23 <memfind+0xe>
			break;
	return (void *) s;
}
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
  800b35:	57                   	push   %edi
  800b36:	56                   	push   %esi
  800b37:	53                   	push   %ebx
  800b38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b3b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b3e:	eb 03                	jmp    800b43 <strtol+0x11>
		s++;
  800b40:	83 c1 01             	add    $0x1,%ecx
	while (*s == ' ' || *s == '\t')
  800b43:	0f b6 01             	movzbl (%ecx),%eax
  800b46:	3c 20                	cmp    $0x20,%al
  800b48:	74 f6                	je     800b40 <strtol+0xe>
  800b4a:	3c 09                	cmp    $0x9,%al
  800b4c:	74 f2                	je     800b40 <strtol+0xe>

	// plus/minus sign
	if (*s == '+')
  800b4e:	3c 2b                	cmp    $0x2b,%al
  800b50:	74 2a                	je     800b7c <strtol+0x4a>
	int neg = 0;
  800b52:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;
	else if (*s == '-')
  800b57:	3c 2d                	cmp    $0x2d,%al
  800b59:	74 2b                	je     800b86 <strtol+0x54>
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b5b:	f7 c3 ef ff ff ff    	test   $0xffffffef,%ebx
  800b61:	75 0f                	jne    800b72 <strtol+0x40>
  800b63:	80 39 30             	cmpb   $0x30,(%ecx)
  800b66:	74 28                	je     800b90 <strtol+0x5e>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b68:	85 db                	test   %ebx,%ebx
  800b6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b6f:	0f 44 d8             	cmove  %eax,%ebx
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	89 5d 10             	mov    %ebx,0x10(%ebp)
  800b7a:	eb 50                	jmp    800bcc <strtol+0x9a>
		s++;
  800b7c:	83 c1 01             	add    $0x1,%ecx
	int neg = 0;
  800b7f:	bf 00 00 00 00       	mov    $0x0,%edi
  800b84:	eb d5                	jmp    800b5b <strtol+0x29>
		s++, neg = 1;
  800b86:	83 c1 01             	add    $0x1,%ecx
  800b89:	bf 01 00 00 00       	mov    $0x1,%edi
  800b8e:	eb cb                	jmp    800b5b <strtol+0x29>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b90:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b94:	74 0e                	je     800ba4 <strtol+0x72>
	else if (base == 0 && s[0] == '0')
  800b96:	85 db                	test   %ebx,%ebx
  800b98:	75 d8                	jne    800b72 <strtol+0x40>
		s++, base = 8;
  800b9a:	83 c1 01             	add    $0x1,%ecx
  800b9d:	bb 08 00 00 00       	mov    $0x8,%ebx
  800ba2:	eb ce                	jmp    800b72 <strtol+0x40>
		s += 2, base = 16;
  800ba4:	83 c1 02             	add    $0x2,%ecx
  800ba7:	bb 10 00 00 00       	mov    $0x10,%ebx
  800bac:	eb c4                	jmp    800b72 <strtol+0x40>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bae:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bb1:	89 f3                	mov    %esi,%ebx
  800bb3:	80 fb 19             	cmp    $0x19,%bl
  800bb6:	77 29                	ja     800be1 <strtol+0xaf>
			dig = *s - 'a' + 10;
  800bb8:	0f be d2             	movsbl %dl,%edx
  800bbb:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800bbe:	3b 55 10             	cmp    0x10(%ebp),%edx
  800bc1:	7d 30                	jge    800bf3 <strtol+0xc1>
			break;
		s++, val = (val * base) + dig;
  800bc3:	83 c1 01             	add    $0x1,%ecx
  800bc6:	0f af 45 10          	imul   0x10(%ebp),%eax
  800bca:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800bcc:	0f b6 11             	movzbl (%ecx),%edx
  800bcf:	8d 72 d0             	lea    -0x30(%edx),%esi
  800bd2:	89 f3                	mov    %esi,%ebx
  800bd4:	80 fb 09             	cmp    $0x9,%bl
  800bd7:	77 d5                	ja     800bae <strtol+0x7c>
			dig = *s - '0';
  800bd9:	0f be d2             	movsbl %dl,%edx
  800bdc:	83 ea 30             	sub    $0x30,%edx
  800bdf:	eb dd                	jmp    800bbe <strtol+0x8c>
		else if (*s >= 'A' && *s <= 'Z')
  800be1:	8d 72 bf             	lea    -0x41(%edx),%esi
  800be4:	89 f3                	mov    %esi,%ebx
  800be6:	80 fb 19             	cmp    $0x19,%bl
  800be9:	77 08                	ja     800bf3 <strtol+0xc1>
			dig = *s - 'A' + 10;
  800beb:	0f be d2             	movsbl %dl,%edx
  800bee:	83 ea 37             	sub    $0x37,%edx
  800bf1:	eb cb                	jmp    800bbe <strtol+0x8c>
		// we don't properly detect overflow!
	}

	if (endptr)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 05                	je     800bfe <strtol+0xcc>
		*endptr = (char *) s;
  800bf9:	8b 75 0c             	mov    0xc(%ebp),%esi
  800bfc:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800bfe:	89 c2                	mov    %eax,%edx
  800c00:	f7 da                	neg    %edx
  800c02:	85 ff                	test   %edi,%edi
  800c04:	0f 45 c2             	cmovne %edx,%eax
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c12:	b8 00 00 00 00       	mov    $0x0,%eax
  800c17:	8b 55 08             	mov    0x8(%ebp),%edx
  800c1a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c1d:	89 c3                	mov    %eax,%ebx
  800c1f:	89 c7                	mov    %eax,%edi
  800c21:	89 c6                	mov    %eax,%esi
  800c23:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c25:	5b                   	pop    %ebx
  800c26:	5e                   	pop    %esi
  800c27:	5f                   	pop    %edi
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <sys_cgetc>:

int
sys_cgetc(void)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	57                   	push   %edi
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c30:	ba 00 00 00 00       	mov    $0x0,%edx
  800c35:	b8 01 00 00 00       	mov    $0x1,%eax
  800c3a:	89 d1                	mov    %edx,%ecx
  800c3c:	89 d3                	mov    %edx,%ebx
  800c3e:	89 d7                	mov    %edx,%edi
  800c40:	89 d6                	mov    %edx,%esi
  800c42:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c44:	5b                   	pop    %ebx
  800c45:	5e                   	pop    %esi
  800c46:	5f                   	pop    %edi
  800c47:	5d                   	pop    %ebp
  800c48:	c3                   	ret    

00800c49 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c49:	55                   	push   %ebp
  800c4a:	89 e5                	mov    %esp,%ebp
  800c4c:	57                   	push   %edi
  800c4d:	56                   	push   %esi
  800c4e:	53                   	push   %ebx
  800c4f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c52:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c57:	8b 55 08             	mov    0x8(%ebp),%edx
  800c5a:	b8 03 00 00 00       	mov    $0x3,%eax
  800c5f:	89 cb                	mov    %ecx,%ebx
  800c61:	89 cf                	mov    %ecx,%edi
  800c63:	89 ce                	mov    %ecx,%esi
  800c65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c67:	85 c0                	test   %eax,%eax
  800c69:	7f 08                	jg     800c73 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c6e:	5b                   	pop    %ebx
  800c6f:	5e                   	pop    %esi
  800c70:	5f                   	pop    %edi
  800c71:	5d                   	pop    %ebp
  800c72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c73:	83 ec 0c             	sub    $0xc,%esp
  800c76:	50                   	push   %eax
  800c77:	6a 03                	push   $0x3
  800c79:	68 a8 28 80 00       	push   $0x8028a8
  800c7e:	6a 43                	push   $0x43
  800c80:	68 c5 28 80 00       	push   $0x8028c5
  800c85:	e8 89 14 00 00       	call   802113 <_panic>

00800c8a <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	57                   	push   %edi
  800c8e:	56                   	push   %esi
  800c8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c90:	ba 00 00 00 00       	mov    $0x0,%edx
  800c95:	b8 02 00 00 00       	mov    $0x2,%eax
  800c9a:	89 d1                	mov    %edx,%ecx
  800c9c:	89 d3                	mov    %edx,%ebx
  800c9e:	89 d7                	mov    %edx,%edi
  800ca0:	89 d6                	mov    %edx,%esi
  800ca2:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    

00800ca9 <sys_yield>:

void
sys_yield(void)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	57                   	push   %edi
  800cad:	56                   	push   %esi
  800cae:	53                   	push   %ebx
	asm volatile("int %1\n"
  800caf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cb9:	89 d1                	mov    %edx,%ecx
  800cbb:	89 d3                	mov    %edx,%ebx
  800cbd:	89 d7                	mov    %edx,%edi
  800cbf:	89 d6                	mov    %edx,%esi
  800cc1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cc3:	5b                   	pop    %ebx
  800cc4:	5e                   	pop    %esi
  800cc5:	5f                   	pop    %edi
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	57                   	push   %edi
  800ccc:	56                   	push   %esi
  800ccd:	53                   	push   %ebx
  800cce:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd1:	be 00 00 00 00       	mov    $0x0,%esi
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cdc:	b8 04 00 00 00       	mov    $0x4,%eax
  800ce1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ce4:	89 f7                	mov    %esi,%edi
  800ce6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce8:	85 c0                	test   %eax,%eax
  800cea:	7f 08                	jg     800cf4 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800cec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cef:	5b                   	pop    %ebx
  800cf0:	5e                   	pop    %esi
  800cf1:	5f                   	pop    %edi
  800cf2:	5d                   	pop    %ebp
  800cf3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf4:	83 ec 0c             	sub    $0xc,%esp
  800cf7:	50                   	push   %eax
  800cf8:	6a 04                	push   $0x4
  800cfa:	68 a8 28 80 00       	push   $0x8028a8
  800cff:	6a 43                	push   $0x43
  800d01:	68 c5 28 80 00       	push   $0x8028c5
  800d06:	e8 08 14 00 00       	call   802113 <_panic>

00800d0b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d0b:	55                   	push   %ebp
  800d0c:	89 e5                	mov    %esp,%ebp
  800d0e:	57                   	push   %edi
  800d0f:	56                   	push   %esi
  800d10:	53                   	push   %ebx
  800d11:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d14:	8b 55 08             	mov    0x8(%ebp),%edx
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	b8 05 00 00 00       	mov    $0x5,%eax
  800d1f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d22:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d25:	8b 75 18             	mov    0x18(%ebp),%esi
  800d28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2a:	85 c0                	test   %eax,%eax
  800d2c:	7f 08                	jg     800d36 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d31:	5b                   	pop    %ebx
  800d32:	5e                   	pop    %esi
  800d33:	5f                   	pop    %edi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	6a 05                	push   $0x5
  800d3c:	68 a8 28 80 00       	push   $0x8028a8
  800d41:	6a 43                	push   $0x43
  800d43:	68 c5 28 80 00       	push   $0x8028c5
  800d48:	e8 c6 13 00 00       	call   802113 <_panic>

00800d4d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d4d:	55                   	push   %ebp
  800d4e:	89 e5                	mov    %esp,%ebp
  800d50:	57                   	push   %edi
  800d51:	56                   	push   %esi
  800d52:	53                   	push   %ebx
  800d53:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d56:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d61:	b8 06 00 00 00       	mov    $0x6,%eax
  800d66:	89 df                	mov    %ebx,%edi
  800d68:	89 de                	mov    %ebx,%esi
  800d6a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d6c:	85 c0                	test   %eax,%eax
  800d6e:	7f 08                	jg     800d78 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800d70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d78:	83 ec 0c             	sub    $0xc,%esp
  800d7b:	50                   	push   %eax
  800d7c:	6a 06                	push   $0x6
  800d7e:	68 a8 28 80 00       	push   $0x8028a8
  800d83:	6a 43                	push   $0x43
  800d85:	68 c5 28 80 00       	push   $0x8028c5
  800d8a:	e8 84 13 00 00       	call   802113 <_panic>

00800d8f <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
  800d92:	57                   	push   %edi
  800d93:	56                   	push   %esi
  800d94:	53                   	push   %ebx
  800d95:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da3:	b8 08 00 00 00       	mov    $0x8,%eax
  800da8:	89 df                	mov    %ebx,%edi
  800daa:	89 de                	mov    %ebx,%esi
  800dac:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dae:	85 c0                	test   %eax,%eax
  800db0:	7f 08                	jg     800dba <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dba:	83 ec 0c             	sub    $0xc,%esp
  800dbd:	50                   	push   %eax
  800dbe:	6a 08                	push   $0x8
  800dc0:	68 a8 28 80 00       	push   $0x8028a8
  800dc5:	6a 43                	push   $0x43
  800dc7:	68 c5 28 80 00       	push   $0x8028c5
  800dcc:	e8 42 13 00 00       	call   802113 <_panic>

00800dd1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
  800dd4:	57                   	push   %edi
  800dd5:	56                   	push   %esi
  800dd6:	53                   	push   %ebx
  800dd7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dda:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddf:	8b 55 08             	mov    0x8(%ebp),%edx
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de5:	b8 09 00 00 00       	mov    $0x9,%eax
  800dea:	89 df                	mov    %ebx,%edi
  800dec:	89 de                	mov    %ebx,%esi
  800dee:	cd 30                	int    $0x30
	if(check && ret > 0)
  800df0:	85 c0                	test   %eax,%eax
  800df2:	7f 08                	jg     800dfc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800df4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df7:	5b                   	pop    %ebx
  800df8:	5e                   	pop    %esi
  800df9:	5f                   	pop    %edi
  800dfa:	5d                   	pop    %ebp
  800dfb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dfc:	83 ec 0c             	sub    $0xc,%esp
  800dff:	50                   	push   %eax
  800e00:	6a 09                	push   $0x9
  800e02:	68 a8 28 80 00       	push   $0x8028a8
  800e07:	6a 43                	push   $0x43
  800e09:	68 c5 28 80 00       	push   $0x8028c5
  800e0e:	e8 00 13 00 00       	call   802113 <_panic>

00800e13 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e13:	55                   	push   %ebp
  800e14:	89 e5                	mov    %esp,%ebp
  800e16:	57                   	push   %edi
  800e17:	56                   	push   %esi
  800e18:	53                   	push   %ebx
  800e19:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e1c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e27:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e2c:	89 df                	mov    %ebx,%edi
  800e2e:	89 de                	mov    %ebx,%esi
  800e30:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e32:	85 c0                	test   %eax,%eax
  800e34:	7f 08                	jg     800e3e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e36:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e39:	5b                   	pop    %ebx
  800e3a:	5e                   	pop    %esi
  800e3b:	5f                   	pop    %edi
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e3e:	83 ec 0c             	sub    $0xc,%esp
  800e41:	50                   	push   %eax
  800e42:	6a 0a                	push   $0xa
  800e44:	68 a8 28 80 00       	push   $0x8028a8
  800e49:	6a 43                	push   $0x43
  800e4b:	68 c5 28 80 00       	push   $0x8028c5
  800e50:	e8 be 12 00 00       	call   802113 <_panic>

00800e55 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	57                   	push   %edi
  800e59:	56                   	push   %esi
  800e5a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e61:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e66:	be 00 00 00 00       	mov    $0x0,%esi
  800e6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e6e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e71:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e73:	5b                   	pop    %ebx
  800e74:	5e                   	pop    %esi
  800e75:	5f                   	pop    %edi
  800e76:	5d                   	pop    %ebp
  800e77:	c3                   	ret    

00800e78 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e78:	55                   	push   %ebp
  800e79:	89 e5                	mov    %esp,%ebp
  800e7b:	57                   	push   %edi
  800e7c:	56                   	push   %esi
  800e7d:	53                   	push   %ebx
  800e7e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e86:	8b 55 08             	mov    0x8(%ebp),%edx
  800e89:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e8e:	89 cb                	mov    %ecx,%ebx
  800e90:	89 cf                	mov    %ecx,%edi
  800e92:	89 ce                	mov    %ecx,%esi
  800e94:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e96:	85 c0                	test   %eax,%eax
  800e98:	7f 08                	jg     800ea2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9d:	5b                   	pop    %ebx
  800e9e:	5e                   	pop    %esi
  800e9f:	5f                   	pop    %edi
  800ea0:	5d                   	pop    %ebp
  800ea1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea2:	83 ec 0c             	sub    $0xc,%esp
  800ea5:	50                   	push   %eax
  800ea6:	6a 0d                	push   $0xd
  800ea8:	68 a8 28 80 00       	push   $0x8028a8
  800ead:	6a 43                	push   $0x43
  800eaf:	68 c5 28 80 00       	push   $0x8028c5
  800eb4:	e8 5a 12 00 00       	call   802113 <_panic>

00800eb9 <sys_map_kernel_page>:

int
sys_map_kernel_page(void* kpage, void* va)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	57                   	push   %edi
  800ebd:	56                   	push   %esi
  800ebe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eca:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ecf:	89 df                	mov    %ebx,%edi
  800ed1:	89 de                	mov    %ebx,%esi
  800ed3:	cd 30                	int    $0x30
	return syscall(SYS_map_kernel_page, 0, (uint32_t)kpage, (uint32_t)va, 0, 0, 0);
}
  800ed5:	5b                   	pop    %ebx
  800ed6:	5e                   	pop    %esi
  800ed7:	5f                   	pop    %edi
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_sbrk>:

int
sys_sbrk(uint32_t inc)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	57                   	push   %edi
  800ede:	56                   	push   %esi
  800edf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ee0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ee5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eed:	89 cb                	mov    %ecx,%ebx
  800eef:	89 cf                	mov    %ecx,%edi
  800ef1:	89 ce                	mov    %ecx,%esi
  800ef3:	cd 30                	int    $0x30
	return syscall(SYS_sbrk, 0, (uint32_t)inc, (uint32_t)0, 0, 0, 0);
}
  800ef5:	5b                   	pop    %ebx
  800ef6:	5e                   	pop    %esi
  800ef7:	5f                   	pop    %edi
  800ef8:	5d                   	pop    %ebp
  800ef9:	c3                   	ret    

00800efa <sys_time_msec>:

unsigned int
sys_time_msec(void)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	57                   	push   %edi
  800efe:	56                   	push   %esi
  800eff:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f00:	ba 00 00 00 00       	mov    $0x0,%edx
  800f05:	b8 10 00 00 00       	mov    $0x10,%eax
  800f0a:	89 d1                	mov    %edx,%ecx
  800f0c:	89 d3                	mov    %edx,%ebx
  800f0e:	89 d7                	mov    %edx,%edi
  800f10:	89 d6                	mov    %edx,%esi
  800f12:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f14:	5b                   	pop    %ebx
  800f15:	5e                   	pop    %esi
  800f16:	5f                   	pop    %edi
  800f17:	5d                   	pop    %ebp
  800f18:	c3                   	ret    

00800f19 <sys_net_send>:

int
sys_net_send(const void *buf, uint32_t len)
{
  800f19:	55                   	push   %ebp
  800f1a:	89 e5                	mov    %esp,%ebp
  800f1c:	57                   	push   %edi
  800f1d:	56                   	push   %esi
  800f1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f24:	8b 55 08             	mov    0x8(%ebp),%edx
  800f27:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2a:	b8 11 00 00 00       	mov    $0x11,%eax
  800f2f:	89 df                	mov    %ebx,%edi
  800f31:	89 de                	mov    %ebx,%esi
  800f33:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_send, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f35:	5b                   	pop    %ebx
  800f36:	5e                   	pop    %esi
  800f37:	5f                   	pop    %edi
  800f38:	5d                   	pop    %ebp
  800f39:	c3                   	ret    

00800f3a <sys_net_recv>:

int
sys_net_recv(void *buf, uint32_t len)
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
  800f4b:	b8 12 00 00 00       	mov    $0x12,%eax
  800f50:	89 df                	mov    %ebx,%edi
  800f52:	89 de                	mov    %ebx,%esi
  800f54:	cd 30                	int    $0x30
	return (unsigned int) syscall(SYS_net_recv, 0, (uint32_t) buf, len, 0, 0, 0);
}
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5f                   	pop    %edi
  800f59:	5d                   	pop    %ebp
  800f5a:	c3                   	ret    

00800f5b <sys_clear_access_bit>:
int
sys_clear_access_bit(envid_t envid, void *va)
{
  800f5b:	55                   	push   %ebp
  800f5c:	89 e5                	mov    %esp,%ebp
  800f5e:	57                   	push   %edi
  800f5f:	56                   	push   %esi
  800f60:	53                   	push   %ebx
  800f61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f69:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6f:	b8 13 00 00 00       	mov    $0x13,%eax
  800f74:	89 df                	mov    %ebx,%edi
  800f76:	89 de                	mov    %ebx,%esi
  800f78:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	7f 08                	jg     800f86 <sys_clear_access_bit+0x2b>
	return syscall(SYS_clear_access_bit, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f7e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f81:	5b                   	pop    %ebx
  800f82:	5e                   	pop    %esi
  800f83:	5f                   	pop    %edi
  800f84:	5d                   	pop    %ebp
  800f85:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f86:	83 ec 0c             	sub    $0xc,%esp
  800f89:	50                   	push   %eax
  800f8a:	6a 13                	push   $0x13
  800f8c:	68 a8 28 80 00       	push   $0x8028a8
  800f91:	6a 43                	push   $0x43
  800f93:	68 c5 28 80 00       	push   $0x8028c5
  800f98:	e8 76 11 00 00       	call   802113 <_panic>

00800f9d <sys_get_mac_addr>:

void
sys_get_mac_addr(uint64_t *mac_addr_store)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
  800fa0:	57                   	push   %edi
  800fa1:	56                   	push   %esi
  800fa2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fab:	b8 14 00 00 00       	mov    $0x14,%eax
  800fb0:	89 cb                	mov    %ecx,%ebx
  800fb2:	89 cf                	mov    %ecx,%edi
  800fb4:	89 ce                	mov    %ecx,%esi
  800fb6:	cd 30                	int    $0x30
    syscall(SYS_get_mac_addr, 0, (uint32_t) mac_addr_store, 0, 0, 0, 0);
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc3:	05 00 00 00 30       	add    $0x30000000,%eax
  800fc8:	c1 e8 0c             	shr    $0xc,%eax
}
  800fcb:	5d                   	pop    %ebp
  800fcc:	c3                   	ret    

00800fcd <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800fcd:	55                   	push   %ebp
  800fce:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800fd8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800fdd:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800fe2:	5d                   	pop    %ebp
  800fe3:	c3                   	ret    

00800fe4 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800fec:	89 c2                	mov    %eax,%edx
  800fee:	c1 ea 16             	shr    $0x16,%edx
  800ff1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ff8:	f6 c2 01             	test   $0x1,%dl
  800ffb:	74 2d                	je     80102a <fd_alloc+0x46>
  800ffd:	89 c2                	mov    %eax,%edx
  800fff:	c1 ea 0c             	shr    $0xc,%edx
  801002:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801009:	f6 c2 01             	test   $0x1,%dl
  80100c:	74 1c                	je     80102a <fd_alloc+0x46>
  80100e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801013:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801018:	75 d2                	jne    800fec <fd_alloc+0x8>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80101a:	8b 45 08             	mov    0x8(%ebp),%eax
  80101d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_MAX_OPEN;
  801023:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801028:	eb 0a                	jmp    801034 <fd_alloc+0x50>
			*fd_store = fd;
  80102a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80102d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80102f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801034:	5d                   	pop    %ebp
  801035:	c3                   	ret    

00801036 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801036:	55                   	push   %ebp
  801037:	89 e5                	mov    %esp,%ebp
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80103c:	83 f8 1f             	cmp    $0x1f,%eax
  80103f:	77 30                	ja     801071 <fd_lookup+0x3b>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801041:	c1 e0 0c             	shl    $0xc,%eax
  801044:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801049:	8b 15 00 dd 7b ef    	mov    0xef7bdd00,%edx
  80104f:	f6 c2 01             	test   $0x1,%dl
  801052:	74 24                	je     801078 <fd_lookup+0x42>
  801054:	89 c2                	mov    %eax,%edx
  801056:	c1 ea 0c             	shr    $0xc,%edx
  801059:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801060:	f6 c2 01             	test   $0x1,%dl
  801063:	74 1a                	je     80107f <fd_lookup+0x49>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801065:	8b 55 0c             	mov    0xc(%ebp),%edx
  801068:	89 02                	mov    %eax,(%edx)
	return 0;
  80106a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106f:	5d                   	pop    %ebp
  801070:	c3                   	ret    
		return -E_INVAL;
  801071:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801076:	eb f7                	jmp    80106f <fd_lookup+0x39>
		return -E_INVAL;
  801078:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80107d:	eb f0                	jmp    80106f <fd_lookup+0x39>
  80107f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801084:	eb e9                	jmp    80106f <fd_lookup+0x39>

00801086 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801086:	55                   	push   %ebp
  801087:	89 e5                	mov    %esp,%ebp
  801089:	83 ec 08             	sub    $0x8,%esp
  80108c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; devtab[i]; i++)
  80108f:	ba 00 00 00 00       	mov    $0x0,%edx
  801094:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801099:	39 08                	cmp    %ecx,(%eax)
  80109b:	74 38                	je     8010d5 <dev_lookup+0x4f>
	for (i = 0; devtab[i]; i++)
  80109d:	83 c2 01             	add    $0x1,%edx
  8010a0:	8b 04 95 50 29 80 00 	mov    0x802950(,%edx,4),%eax
  8010a7:	85 c0                	test   %eax,%eax
  8010a9:	75 ee                	jne    801099 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010ab:	a1 08 40 80 00       	mov    0x804008,%eax
  8010b0:	8b 40 48             	mov    0x48(%eax),%eax
  8010b3:	83 ec 04             	sub    $0x4,%esp
  8010b6:	51                   	push   %ecx
  8010b7:	50                   	push   %eax
  8010b8:	68 d4 28 80 00       	push   $0x8028d4
  8010bd:	e8 b5 f0 ff ff       	call   800177 <cprintf>
	*dev = 0;
  8010c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8010cb:	83 c4 10             	add    $0x10,%esp
  8010ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    
			*dev = devtab[i];
  8010d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d8:	89 01                	mov    %eax,(%ecx)
			return 0;
  8010da:	b8 00 00 00 00       	mov    $0x0,%eax
  8010df:	eb f2                	jmp    8010d3 <dev_lookup+0x4d>

008010e1 <fd_close>:
{
  8010e1:	55                   	push   %ebp
  8010e2:	89 e5                	mov    %esp,%ebp
  8010e4:	57                   	push   %edi
  8010e5:	56                   	push   %esi
  8010e6:	53                   	push   %ebx
  8010e7:	83 ec 24             	sub    $0x24,%esp
  8010ea:	8b 75 08             	mov    0x8(%ebp),%esi
  8010ed:	8b 7d 0c             	mov    0xc(%ebp),%edi
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010f3:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010f4:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8010fa:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8010fd:	50                   	push   %eax
  8010fe:	e8 33 ff ff ff       	call   801036 <fd_lookup>
  801103:	89 c3                	mov    %eax,%ebx
  801105:	83 c4 10             	add    $0x10,%esp
  801108:	85 c0                	test   %eax,%eax
  80110a:	78 05                	js     801111 <fd_close+0x30>
	    || fd != fd2)
  80110c:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
  80110f:	74 16                	je     801127 <fd_close+0x46>
		return (must_exist ? r : 0);
  801111:	89 f8                	mov    %edi,%eax
  801113:	84 c0                	test   %al,%al
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
  80111a:	0f 44 d8             	cmove  %eax,%ebx
}
  80111d:	89 d8                	mov    %ebx,%eax
  80111f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801122:	5b                   	pop    %ebx
  801123:	5e                   	pop    %esi
  801124:	5f                   	pop    %edi
  801125:	5d                   	pop    %ebp
  801126:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801127:	83 ec 08             	sub    $0x8,%esp
  80112a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80112d:	50                   	push   %eax
  80112e:	ff 36                	pushl  (%esi)
  801130:	e8 51 ff ff ff       	call   801086 <dev_lookup>
  801135:	89 c3                	mov    %eax,%ebx
  801137:	83 c4 10             	add    $0x10,%esp
  80113a:	85 c0                	test   %eax,%eax
  80113c:	78 1a                	js     801158 <fd_close+0x77>
		if (dev->dev_close)
  80113e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801141:	8b 40 10             	mov    0x10(%eax),%eax
			r = 0;
  801144:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (dev->dev_close)
  801149:	85 c0                	test   %eax,%eax
  80114b:	74 0b                	je     801158 <fd_close+0x77>
			r = (*dev->dev_close)(fd);
  80114d:	83 ec 0c             	sub    $0xc,%esp
  801150:	56                   	push   %esi
  801151:	ff d0                	call   *%eax
  801153:	89 c3                	mov    %eax,%ebx
  801155:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801158:	83 ec 08             	sub    $0x8,%esp
  80115b:	56                   	push   %esi
  80115c:	6a 00                	push   $0x0
  80115e:	e8 ea fb ff ff       	call   800d4d <sys_page_unmap>
	return r;
  801163:	83 c4 10             	add    $0x10,%esp
  801166:	eb b5                	jmp    80111d <fd_close+0x3c>

00801168 <close>:

int
close(int fdnum)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	83 ec 20             	sub    $0x20,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80116e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801171:	50                   	push   %eax
  801172:	ff 75 08             	pushl  0x8(%ebp)
  801175:	e8 bc fe ff ff       	call   801036 <fd_lookup>
  80117a:	83 c4 10             	add    $0x10,%esp
  80117d:	85 c0                	test   %eax,%eax
  80117f:	79 02                	jns    801183 <close+0x1b>
		return r;
	else
		return fd_close(fd, 1);
}
  801181:	c9                   	leave  
  801182:	c3                   	ret    
		return fd_close(fd, 1);
  801183:	83 ec 08             	sub    $0x8,%esp
  801186:	6a 01                	push   $0x1
  801188:	ff 75 f4             	pushl  -0xc(%ebp)
  80118b:	e8 51 ff ff ff       	call   8010e1 <fd_close>
  801190:	83 c4 10             	add    $0x10,%esp
  801193:	eb ec                	jmp    801181 <close+0x19>

00801195 <close_all>:

void
close_all(void)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	53                   	push   %ebx
  801199:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80119c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011a1:	83 ec 0c             	sub    $0xc,%esp
  8011a4:	53                   	push   %ebx
  8011a5:	e8 be ff ff ff       	call   801168 <close>
	for (i = 0; i < MAXFD; i++)
  8011aa:	83 c3 01             	add    $0x1,%ebx
  8011ad:	83 c4 10             	add    $0x10,%esp
  8011b0:	83 fb 20             	cmp    $0x20,%ebx
  8011b3:	75 ec                	jne    8011a1 <close_all+0xc>
}
  8011b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b8:	c9                   	leave  
  8011b9:	c3                   	ret    

008011ba <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	57                   	push   %edi
  8011be:	56                   	push   %esi
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011c3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011c6:	50                   	push   %eax
  8011c7:	ff 75 08             	pushl  0x8(%ebp)
  8011ca:	e8 67 fe ff ff       	call   801036 <fd_lookup>
  8011cf:	89 c3                	mov    %eax,%ebx
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	85 c0                	test   %eax,%eax
  8011d6:	0f 88 81 00 00 00    	js     80125d <dup+0xa3>
		return r;
	close(newfdnum);
  8011dc:	83 ec 0c             	sub    $0xc,%esp
  8011df:	ff 75 0c             	pushl  0xc(%ebp)
  8011e2:	e8 81 ff ff ff       	call   801168 <close>

	newfd = INDEX2FD(newfdnum);
  8011e7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8011ea:	c1 e6 0c             	shl    $0xc,%esi
  8011ed:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8011f3:	83 c4 04             	add    $0x4,%esp
  8011f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011f9:	e8 cf fd ff ff       	call   800fcd <fd2data>
  8011fe:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801200:	89 34 24             	mov    %esi,(%esp)
  801203:	e8 c5 fd ff ff       	call   800fcd <fd2data>
  801208:	83 c4 10             	add    $0x10,%esp
  80120b:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80120d:	89 d8                	mov    %ebx,%eax
  80120f:	c1 e8 16             	shr    $0x16,%eax
  801212:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801219:	a8 01                	test   $0x1,%al
  80121b:	74 11                	je     80122e <dup+0x74>
  80121d:	89 d8                	mov    %ebx,%eax
  80121f:	c1 e8 0c             	shr    $0xc,%eax
  801222:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801229:	f6 c2 01             	test   $0x1,%dl
  80122c:	75 39                	jne    801267 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80122e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801231:	89 d0                	mov    %edx,%eax
  801233:	c1 e8 0c             	shr    $0xc,%eax
  801236:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80123d:	83 ec 0c             	sub    $0xc,%esp
  801240:	25 07 0e 00 00       	and    $0xe07,%eax
  801245:	50                   	push   %eax
  801246:	56                   	push   %esi
  801247:	6a 00                	push   $0x0
  801249:	52                   	push   %edx
  80124a:	6a 00                	push   $0x0
  80124c:	e8 ba fa ff ff       	call   800d0b <sys_page_map>
  801251:	89 c3                	mov    %eax,%ebx
  801253:	83 c4 20             	add    $0x20,%esp
  801256:	85 c0                	test   %eax,%eax
  801258:	78 31                	js     80128b <dup+0xd1>
		goto err;

	return newfdnum;
  80125a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80125d:	89 d8                	mov    %ebx,%eax
  80125f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801262:	5b                   	pop    %ebx
  801263:	5e                   	pop    %esi
  801264:	5f                   	pop    %edi
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801267:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80126e:	83 ec 0c             	sub    $0xc,%esp
  801271:	25 07 0e 00 00       	and    $0xe07,%eax
  801276:	50                   	push   %eax
  801277:	57                   	push   %edi
  801278:	6a 00                	push   $0x0
  80127a:	53                   	push   %ebx
  80127b:	6a 00                	push   $0x0
  80127d:	e8 89 fa ff ff       	call   800d0b <sys_page_map>
  801282:	89 c3                	mov    %eax,%ebx
  801284:	83 c4 20             	add    $0x20,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	79 a3                	jns    80122e <dup+0x74>
	sys_page_unmap(0, newfd);
  80128b:	83 ec 08             	sub    $0x8,%esp
  80128e:	56                   	push   %esi
  80128f:	6a 00                	push   $0x0
  801291:	e8 b7 fa ff ff       	call   800d4d <sys_page_unmap>
	sys_page_unmap(0, nva);
  801296:	83 c4 08             	add    $0x8,%esp
  801299:	57                   	push   %edi
  80129a:	6a 00                	push   $0x0
  80129c:	e8 ac fa ff ff       	call   800d4d <sys_page_unmap>
	return r;
  8012a1:	83 c4 10             	add    $0x10,%esp
  8012a4:	eb b7                	jmp    80125d <dup+0xa3>

008012a6 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012a6:	55                   	push   %ebp
  8012a7:	89 e5                	mov    %esp,%ebp
  8012a9:	53                   	push   %ebx
  8012aa:	83 ec 1c             	sub    $0x1c,%esp
  8012ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b3:	50                   	push   %eax
  8012b4:	53                   	push   %ebx
  8012b5:	e8 7c fd ff ff       	call   801036 <fd_lookup>
  8012ba:	83 c4 10             	add    $0x10,%esp
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	78 3f                	js     801300 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c1:	83 ec 08             	sub    $0x8,%esp
  8012c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c7:	50                   	push   %eax
  8012c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cb:	ff 30                	pushl  (%eax)
  8012cd:	e8 b4 fd ff ff       	call   801086 <dev_lookup>
  8012d2:	83 c4 10             	add    $0x10,%esp
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	78 27                	js     801300 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8012d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012dc:	8b 42 08             	mov    0x8(%edx),%eax
  8012df:	83 e0 03             	and    $0x3,%eax
  8012e2:	83 f8 01             	cmp    $0x1,%eax
  8012e5:	74 1e                	je     801305 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8012e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012ea:	8b 40 08             	mov    0x8(%eax),%eax
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	74 35                	je     801326 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8012f1:	83 ec 04             	sub    $0x4,%esp
  8012f4:	ff 75 10             	pushl  0x10(%ebp)
  8012f7:	ff 75 0c             	pushl  0xc(%ebp)
  8012fa:	52                   	push   %edx
  8012fb:	ff d0                	call   *%eax
  8012fd:	83 c4 10             	add    $0x10,%esp
}
  801300:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801303:	c9                   	leave  
  801304:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801305:	a1 08 40 80 00       	mov    0x804008,%eax
  80130a:	8b 40 48             	mov    0x48(%eax),%eax
  80130d:	83 ec 04             	sub    $0x4,%esp
  801310:	53                   	push   %ebx
  801311:	50                   	push   %eax
  801312:	68 15 29 80 00       	push   $0x802915
  801317:	e8 5b ee ff ff       	call   800177 <cprintf>
		return -E_INVAL;
  80131c:	83 c4 10             	add    $0x10,%esp
  80131f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801324:	eb da                	jmp    801300 <read+0x5a>
		return -E_NOT_SUPP;
  801326:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80132b:	eb d3                	jmp    801300 <read+0x5a>

0080132d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	57                   	push   %edi
  801331:	56                   	push   %esi
  801332:	53                   	push   %ebx
  801333:	83 ec 0c             	sub    $0xc,%esp
  801336:	8b 7d 08             	mov    0x8(%ebp),%edi
  801339:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80133c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801341:	39 f3                	cmp    %esi,%ebx
  801343:	73 23                	jae    801368 <readn+0x3b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801345:	83 ec 04             	sub    $0x4,%esp
  801348:	89 f0                	mov    %esi,%eax
  80134a:	29 d8                	sub    %ebx,%eax
  80134c:	50                   	push   %eax
  80134d:	89 d8                	mov    %ebx,%eax
  80134f:	03 45 0c             	add    0xc(%ebp),%eax
  801352:	50                   	push   %eax
  801353:	57                   	push   %edi
  801354:	e8 4d ff ff ff       	call   8012a6 <read>
		if (m < 0)
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 06                	js     801366 <readn+0x39>
			return m;
		if (m == 0)
  801360:	74 06                	je     801368 <readn+0x3b>
	for (tot = 0; tot < n; tot += m) {
  801362:	01 c3                	add    %eax,%ebx
  801364:	eb db                	jmp    801341 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801366:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801368:	89 d8                	mov    %ebx,%eax
  80136a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136d:	5b                   	pop    %ebx
  80136e:	5e                   	pop    %esi
  80136f:	5f                   	pop    %edi
  801370:	5d                   	pop    %ebp
  801371:	c3                   	ret    

00801372 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801372:	55                   	push   %ebp
  801373:	89 e5                	mov    %esp,%ebp
  801375:	53                   	push   %ebx
  801376:	83 ec 1c             	sub    $0x1c,%esp
  801379:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80137c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80137f:	50                   	push   %eax
  801380:	53                   	push   %ebx
  801381:	e8 b0 fc ff ff       	call   801036 <fd_lookup>
  801386:	83 c4 10             	add    $0x10,%esp
  801389:	85 c0                	test   %eax,%eax
  80138b:	78 3a                	js     8013c7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138d:	83 ec 08             	sub    $0x8,%esp
  801390:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801393:	50                   	push   %eax
  801394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801397:	ff 30                	pushl  (%eax)
  801399:	e8 e8 fc ff ff       	call   801086 <dev_lookup>
  80139e:	83 c4 10             	add    $0x10,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	78 22                	js     8013c7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013a8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013ac:	74 1e                	je     8013cc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8013b4:	85 d2                	test   %edx,%edx
  8013b6:	74 35                	je     8013ed <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013b8:	83 ec 04             	sub    $0x4,%esp
  8013bb:	ff 75 10             	pushl  0x10(%ebp)
  8013be:	ff 75 0c             	pushl  0xc(%ebp)
  8013c1:	50                   	push   %eax
  8013c2:	ff d2                	call   *%edx
  8013c4:	83 c4 10             	add    $0x10,%esp
}
  8013c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ca:	c9                   	leave  
  8013cb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8013cc:	a1 08 40 80 00       	mov    0x804008,%eax
  8013d1:	8b 40 48             	mov    0x48(%eax),%eax
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	53                   	push   %ebx
  8013d8:	50                   	push   %eax
  8013d9:	68 31 29 80 00       	push   $0x802931
  8013de:	e8 94 ed ff ff       	call   800177 <cprintf>
		return -E_INVAL;
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8013eb:	eb da                	jmp    8013c7 <write+0x55>
		return -E_NOT_SUPP;
  8013ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013f2:	eb d3                	jmp    8013c7 <write+0x55>

008013f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 20             	sub    $0x20,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fd:	50                   	push   %eax
  8013fe:	ff 75 08             	pushl  0x8(%ebp)
  801401:	e8 30 fc ff ff       	call   801036 <fd_lookup>
  801406:	83 c4 10             	add    $0x10,%esp
  801409:	85 c0                	test   %eax,%eax
  80140b:	78 0e                	js     80141b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80140d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801413:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801416:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	53                   	push   %ebx
  801421:	83 ec 1c             	sub    $0x1c,%esp
  801424:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801427:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80142a:	50                   	push   %eax
  80142b:	53                   	push   %ebx
  80142c:	e8 05 fc ff ff       	call   801036 <fd_lookup>
  801431:	83 c4 10             	add    $0x10,%esp
  801434:	85 c0                	test   %eax,%eax
  801436:	78 37                	js     80146f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801438:	83 ec 08             	sub    $0x8,%esp
  80143b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80143e:	50                   	push   %eax
  80143f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801442:	ff 30                	pushl  (%eax)
  801444:	e8 3d fc ff ff       	call   801086 <dev_lookup>
  801449:	83 c4 10             	add    $0x10,%esp
  80144c:	85 c0                	test   %eax,%eax
  80144e:	78 1f                	js     80146f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801453:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801457:	74 1b                	je     801474 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801459:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80145c:	8b 52 18             	mov    0x18(%edx),%edx
  80145f:	85 d2                	test   %edx,%edx
  801461:	74 32                	je     801495 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801463:	83 ec 08             	sub    $0x8,%esp
  801466:	ff 75 0c             	pushl  0xc(%ebp)
  801469:	50                   	push   %eax
  80146a:	ff d2                	call   *%edx
  80146c:	83 c4 10             	add    $0x10,%esp
}
  80146f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801472:	c9                   	leave  
  801473:	c3                   	ret    
			thisenv->env_id, fdnum);
  801474:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801479:	8b 40 48             	mov    0x48(%eax),%eax
  80147c:	83 ec 04             	sub    $0x4,%esp
  80147f:	53                   	push   %ebx
  801480:	50                   	push   %eax
  801481:	68 f4 28 80 00       	push   $0x8028f4
  801486:	e8 ec ec ff ff       	call   800177 <cprintf>
		return -E_INVAL;
  80148b:	83 c4 10             	add    $0x10,%esp
  80148e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801493:	eb da                	jmp    80146f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801495:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80149a:	eb d3                	jmp    80146f <ftruncate+0x52>

0080149c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	53                   	push   %ebx
  8014a0:	83 ec 1c             	sub    $0x1c,%esp
  8014a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014a9:	50                   	push   %eax
  8014aa:	ff 75 08             	pushl  0x8(%ebp)
  8014ad:	e8 84 fb ff ff       	call   801036 <fd_lookup>
  8014b2:	83 c4 10             	add    $0x10,%esp
  8014b5:	85 c0                	test   %eax,%eax
  8014b7:	78 4b                	js     801504 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014b9:	83 ec 08             	sub    $0x8,%esp
  8014bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014bf:	50                   	push   %eax
  8014c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c3:	ff 30                	pushl  (%eax)
  8014c5:	e8 bc fb ff ff       	call   801086 <dev_lookup>
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	78 33                	js     801504 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8014d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8014d8:	74 2f                	je     801509 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8014da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8014dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8014e4:	00 00 00 
	stat->st_isdir = 0;
  8014e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8014ee:	00 00 00 
	stat->st_dev = dev;
  8014f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8014f7:	83 ec 08             	sub    $0x8,%esp
  8014fa:	53                   	push   %ebx
  8014fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8014fe:	ff 50 14             	call   *0x14(%eax)
  801501:	83 c4 10             	add    $0x10,%esp
}
  801504:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801507:	c9                   	leave  
  801508:	c3                   	ret    
		return -E_NOT_SUPP;
  801509:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80150e:	eb f4                	jmp    801504 <fstat+0x68>

00801510 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	56                   	push   %esi
  801514:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801515:	83 ec 08             	sub    $0x8,%esp
  801518:	6a 00                	push   $0x0
  80151a:	ff 75 08             	pushl  0x8(%ebp)
  80151d:	e8 22 02 00 00       	call   801744 <open>
  801522:	89 c3                	mov    %eax,%ebx
  801524:	83 c4 10             	add    $0x10,%esp
  801527:	85 c0                	test   %eax,%eax
  801529:	78 1b                	js     801546 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80152b:	83 ec 08             	sub    $0x8,%esp
  80152e:	ff 75 0c             	pushl  0xc(%ebp)
  801531:	50                   	push   %eax
  801532:	e8 65 ff ff ff       	call   80149c <fstat>
  801537:	89 c6                	mov    %eax,%esi
	close(fd);
  801539:	89 1c 24             	mov    %ebx,(%esp)
  80153c:	e8 27 fc ff ff       	call   801168 <close>
	return r;
  801541:	83 c4 10             	add    $0x10,%esp
  801544:	89 f3                	mov    %esi,%ebx
}
  801546:	89 d8                	mov    %ebx,%eax
  801548:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80154b:	5b                   	pop    %ebx
  80154c:	5e                   	pop    %esi
  80154d:	5d                   	pop    %ebp
  80154e:	c3                   	ret    

0080154f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	56                   	push   %esi
  801553:	53                   	push   %ebx
  801554:	89 c6                	mov    %eax,%esi
  801556:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801558:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80155f:	74 27                	je     801588 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801561:	6a 07                	push   $0x7
  801563:	68 00 50 80 00       	push   $0x805000
  801568:	56                   	push   %esi
  801569:	ff 35 00 40 80 00    	pushl  0x804000
  80156f:	e8 69 0c 00 00       	call   8021dd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801574:	83 c4 0c             	add    $0xc,%esp
  801577:	6a 00                	push   $0x0
  801579:	53                   	push   %ebx
  80157a:	6a 00                	push   $0x0
  80157c:	e8 f3 0b 00 00       	call   802174 <ipc_recv>
}
  801581:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801584:	5b                   	pop    %ebx
  801585:	5e                   	pop    %esi
  801586:	5d                   	pop    %ebp
  801587:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801588:	83 ec 0c             	sub    $0xc,%esp
  80158b:	6a 01                	push   $0x1
  80158d:	e8 a3 0c 00 00       	call   802235 <ipc_find_env>
  801592:	a3 00 40 80 00       	mov    %eax,0x804000
  801597:	83 c4 10             	add    $0x10,%esp
  80159a:	eb c5                	jmp    801561 <fsipc+0x12>

0080159c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8015bf:	e8 8b ff ff ff       	call   80154f <fsipc>
}
  8015c4:	c9                   	leave  
  8015c5:	c3                   	ret    

008015c6 <devfile_flush>:
{
  8015c6:	55                   	push   %ebp
  8015c7:	89 e5                	mov    %esp,%ebp
  8015c9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8015cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d2:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8015d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8015dc:	b8 06 00 00 00       	mov    $0x6,%eax
  8015e1:	e8 69 ff ff ff       	call   80154f <fsipc>
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <devfile_stat>:
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	53                   	push   %ebx
  8015ec:	83 ec 04             	sub    $0x4,%esp
  8015ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f8:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8015fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801602:	b8 05 00 00 00       	mov    $0x5,%eax
  801607:	e8 43 ff ff ff       	call   80154f <fsipc>
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 2c                	js     80163c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	68 00 50 80 00       	push   $0x805000
  801618:	53                   	push   %ebx
  801619:	e8 b8 f2 ff ff       	call   8008d6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80161e:	a1 80 50 80 00       	mov    0x805080,%eax
  801623:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801629:	a1 84 50 80 00       	mov    0x805084,%eax
  80162e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801634:	83 c4 10             	add    $0x10,%esp
  801637:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80163c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163f:	c9                   	leave  
  801640:	c3                   	ret    

00801641 <devfile_write>:
{
  801641:	55                   	push   %ebp
  801642:	89 e5                	mov    %esp,%ebp
  801644:	53                   	push   %ebx
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	8b 5d 10             	mov    0x10(%ebp),%ebx
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80164b:	8b 45 08             	mov    0x8(%ebp),%eax
  80164e:	8b 40 0c             	mov    0xc(%eax),%eax
  801651:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.write.req_n = n;
  801656:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	memcpy(fsipcbuf.write.req_buf, buf, n);
  80165c:	53                   	push   %ebx
  80165d:	ff 75 0c             	pushl  0xc(%ebp)
  801660:	68 08 50 80 00       	push   $0x805008
  801665:	e8 5c f4 ff ff       	call   800ac6 <memcpy>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0)
  80166a:	ba 00 00 00 00       	mov    $0x0,%edx
  80166f:	b8 04 00 00 00       	mov    $0x4,%eax
  801674:	e8 d6 fe ff ff       	call   80154f <fsipc>
  801679:	83 c4 10             	add    $0x10,%esp
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 0b                	js     80168b <devfile_write+0x4a>
	assert(r <= n);
  801680:	39 d8                	cmp    %ebx,%eax
  801682:	77 0c                	ja     801690 <devfile_write+0x4f>
	assert(r <= PGSIZE);
  801684:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801689:	7f 1e                	jg     8016a9 <devfile_write+0x68>
}
  80168b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    
	assert(r <= n);
  801690:	68 64 29 80 00       	push   $0x802964
  801695:	68 6b 29 80 00       	push   $0x80296b
  80169a:	68 98 00 00 00       	push   $0x98
  80169f:	68 80 29 80 00       	push   $0x802980
  8016a4:	e8 6a 0a 00 00       	call   802113 <_panic>
	assert(r <= PGSIZE);
  8016a9:	68 8b 29 80 00       	push   $0x80298b
  8016ae:	68 6b 29 80 00       	push   $0x80296b
  8016b3:	68 99 00 00 00       	push   $0x99
  8016b8:	68 80 29 80 00       	push   $0x802980
  8016bd:	e8 51 0a 00 00       	call   802113 <_panic>

008016c2 <devfile_read>:
{
  8016c2:	55                   	push   %ebp
  8016c3:	89 e5                	mov    %esp,%ebp
  8016c5:	56                   	push   %esi
  8016c6:	53                   	push   %ebx
  8016c7:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8016ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8016cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8016d0:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8016d5:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8016db:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e0:	b8 03 00 00 00       	mov    $0x3,%eax
  8016e5:	e8 65 fe ff ff       	call   80154f <fsipc>
  8016ea:	89 c3                	mov    %eax,%ebx
  8016ec:	85 c0                	test   %eax,%eax
  8016ee:	78 1f                	js     80170f <devfile_read+0x4d>
	assert(r <= n);
  8016f0:	39 f0                	cmp    %esi,%eax
  8016f2:	77 24                	ja     801718 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8016f4:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016f9:	7f 33                	jg     80172e <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	50                   	push   %eax
  8016ff:	68 00 50 80 00       	push   $0x805000
  801704:	ff 75 0c             	pushl  0xc(%ebp)
  801707:	e8 58 f3 ff ff       	call   800a64 <memmove>
	return r;
  80170c:	83 c4 10             	add    $0x10,%esp
}
  80170f:	89 d8                	mov    %ebx,%eax
  801711:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801714:	5b                   	pop    %ebx
  801715:	5e                   	pop    %esi
  801716:	5d                   	pop    %ebp
  801717:	c3                   	ret    
	assert(r <= n);
  801718:	68 64 29 80 00       	push   $0x802964
  80171d:	68 6b 29 80 00       	push   $0x80296b
  801722:	6a 7c                	push   $0x7c
  801724:	68 80 29 80 00       	push   $0x802980
  801729:	e8 e5 09 00 00       	call   802113 <_panic>
	assert(r <= PGSIZE);
  80172e:	68 8b 29 80 00       	push   $0x80298b
  801733:	68 6b 29 80 00       	push   $0x80296b
  801738:	6a 7d                	push   $0x7d
  80173a:	68 80 29 80 00       	push   $0x802980
  80173f:	e8 cf 09 00 00       	call   802113 <_panic>

00801744 <open>:
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	56                   	push   %esi
  801748:	53                   	push   %ebx
  801749:	83 ec 1c             	sub    $0x1c,%esp
  80174c:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80174f:	56                   	push   %esi
  801750:	e8 48 f1 ff ff       	call   80089d <strlen>
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80175d:	7f 6c                	jg     8017cb <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80175f:	83 ec 0c             	sub    $0xc,%esp
  801762:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801765:	50                   	push   %eax
  801766:	e8 79 f8 ff ff       	call   800fe4 <fd_alloc>
  80176b:	89 c3                	mov    %eax,%ebx
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	85 c0                	test   %eax,%eax
  801772:	78 3c                	js     8017b0 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801774:	83 ec 08             	sub    $0x8,%esp
  801777:	56                   	push   %esi
  801778:	68 00 50 80 00       	push   $0x805000
  80177d:	e8 54 f1 ff ff       	call   8008d6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801782:	8b 45 0c             	mov    0xc(%ebp),%eax
  801785:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80178a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80178d:	b8 01 00 00 00       	mov    $0x1,%eax
  801792:	e8 b8 fd ff ff       	call   80154f <fsipc>
  801797:	89 c3                	mov    %eax,%ebx
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 19                	js     8017b9 <open+0x75>
	return fd2num(fd);
  8017a0:	83 ec 0c             	sub    $0xc,%esp
  8017a3:	ff 75 f4             	pushl  -0xc(%ebp)
  8017a6:	e8 12 f8 ff ff       	call   800fbd <fd2num>
  8017ab:	89 c3                	mov    %eax,%ebx
  8017ad:	83 c4 10             	add    $0x10,%esp
}
  8017b0:	89 d8                	mov    %ebx,%eax
  8017b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017b5:	5b                   	pop    %ebx
  8017b6:	5e                   	pop    %esi
  8017b7:	5d                   	pop    %ebp
  8017b8:	c3                   	ret    
		fd_close(fd, 0);
  8017b9:	83 ec 08             	sub    $0x8,%esp
  8017bc:	6a 00                	push   $0x0
  8017be:	ff 75 f4             	pushl  -0xc(%ebp)
  8017c1:	e8 1b f9 ff ff       	call   8010e1 <fd_close>
		return r;
  8017c6:	83 c4 10             	add    $0x10,%esp
  8017c9:	eb e5                	jmp    8017b0 <open+0x6c>
		return -E_BAD_PATH;
  8017cb:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8017d0:	eb de                	jmp    8017b0 <open+0x6c>

008017d2 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
  8017d5:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8017d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017dd:	b8 08 00 00 00       	mov    $0x8,%eax
  8017e2:	e8 68 fd ff ff       	call   80154f <fsipc>
}
  8017e7:	c9                   	leave  
  8017e8:	c3                   	ret    

008017e9 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<sock>");
  8017ef:	68 97 29 80 00       	push   $0x802997
  8017f4:	ff 75 0c             	pushl  0xc(%ebp)
  8017f7:	e8 da f0 ff ff       	call   8008d6 <strcpy>
	return 0;
}
  8017fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <devsock_close>:
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	53                   	push   %ebx
  801807:	83 ec 10             	sub    $0x10,%esp
  80180a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (pageref(fd) == 1)
  80180d:	53                   	push   %ebx
  80180e:	e8 61 0a 00 00       	call   802274 <pageref>
  801813:	83 c4 10             	add    $0x10,%esp
		return 0;
  801816:	ba 00 00 00 00       	mov    $0x0,%edx
	if (pageref(fd) == 1)
  80181b:	83 f8 01             	cmp    $0x1,%eax
  80181e:	74 07                	je     801827 <devsock_close+0x24>
}
  801820:	89 d0                	mov    %edx,%eax
  801822:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801825:	c9                   	leave  
  801826:	c3                   	ret    
		return nsipc_close(fd->fd_sock.sockid);
  801827:	83 ec 0c             	sub    $0xc,%esp
  80182a:	ff 73 0c             	pushl  0xc(%ebx)
  80182d:	e8 b9 02 00 00       	call   801aeb <nsipc_close>
  801832:	89 c2                	mov    %eax,%edx
  801834:	83 c4 10             	add    $0x10,%esp
  801837:	eb e7                	jmp    801820 <devsock_close+0x1d>

00801839 <devsock_write>:
{
  801839:	55                   	push   %ebp
  80183a:	89 e5                	mov    %esp,%ebp
  80183c:	83 ec 08             	sub    $0x8,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80183f:	6a 00                	push   $0x0
  801841:	ff 75 10             	pushl  0x10(%ebp)
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	ff 70 0c             	pushl  0xc(%eax)
  80184d:	e8 76 03 00 00       	call   801bc8 <nsipc_send>
}
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <devsock_read>:
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	83 ec 08             	sub    $0x8,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  80185a:	6a 00                	push   $0x0
  80185c:	ff 75 10             	pushl  0x10(%ebp)
  80185f:	ff 75 0c             	pushl  0xc(%ebp)
  801862:	8b 45 08             	mov    0x8(%ebp),%eax
  801865:	ff 70 0c             	pushl  0xc(%eax)
  801868:	e8 ef 02 00 00       	call   801b5c <nsipc_recv>
}
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <fd2sockid>:
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fd, &sfd)) < 0)
  801875:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801878:	52                   	push   %edx
  801879:	50                   	push   %eax
  80187a:	e8 b7 f7 ff ff       	call   801036 <fd_lookup>
  80187f:	83 c4 10             	add    $0x10,%esp
  801882:	85 c0                	test   %eax,%eax
  801884:	78 10                	js     801896 <fd2sockid+0x27>
	if (sfd->fd_dev_id != devsock.dev_id)
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	8b 0d 20 30 80 00    	mov    0x803020,%ecx
  80188f:	39 08                	cmp    %ecx,(%eax)
  801891:	75 05                	jne    801898 <fd2sockid+0x29>
	return sfd->fd_sock.sockid;
  801893:	8b 40 0c             	mov    0xc(%eax),%eax
}
  801896:	c9                   	leave  
  801897:	c3                   	ret    
		return -E_NOT_SUPP;
  801898:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189d:	eb f7                	jmp    801896 <fd2sockid+0x27>

0080189f <alloc_sockfd>:
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	83 ec 1c             	sub    $0x1c,%esp
  8018a7:	89 c6                	mov    %eax,%esi
	if ((r = fd_alloc(&sfd)) < 0
  8018a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ac:	50                   	push   %eax
  8018ad:	e8 32 f7 ff ff       	call   800fe4 <fd_alloc>
  8018b2:	89 c3                	mov    %eax,%ebx
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	85 c0                	test   %eax,%eax
  8018b9:	78 43                	js     8018fe <alloc_sockfd+0x5f>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0) {
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	68 07 04 00 00       	push   $0x407
  8018c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c6:	6a 00                	push   $0x0
  8018c8:	e8 fb f3 ff ff       	call   800cc8 <sys_page_alloc>
  8018cd:	89 c3                	mov    %eax,%ebx
  8018cf:	83 c4 10             	add    $0x10,%esp
  8018d2:	85 c0                	test   %eax,%eax
  8018d4:	78 28                	js     8018fe <alloc_sockfd+0x5f>
	sfd->fd_dev_id = devsock.dev_id;
  8018d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d9:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018df:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8018e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e4:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8018eb:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8018ee:	83 ec 0c             	sub    $0xc,%esp
  8018f1:	50                   	push   %eax
  8018f2:	e8 c6 f6 ff ff       	call   800fbd <fd2num>
  8018f7:	89 c3                	mov    %eax,%ebx
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	eb 0c                	jmp    80190a <alloc_sockfd+0x6b>
		nsipc_close(sockid);
  8018fe:	83 ec 0c             	sub    $0xc,%esp
  801901:	56                   	push   %esi
  801902:	e8 e4 01 00 00       	call   801aeb <nsipc_close>
		return r;
  801907:	83 c4 10             	add    $0x10,%esp
}
  80190a:	89 d8                	mov    %ebx,%eax
  80190c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80190f:	5b                   	pop    %ebx
  801910:	5e                   	pop    %esi
  801911:	5d                   	pop    %ebp
  801912:	c3                   	ret    

00801913 <accept>:
{
  801913:	55                   	push   %ebp
  801914:	89 e5                	mov    %esp,%ebp
  801916:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801919:	8b 45 08             	mov    0x8(%ebp),%eax
  80191c:	e8 4e ff ff ff       	call   80186f <fd2sockid>
  801921:	85 c0                	test   %eax,%eax
  801923:	78 1b                	js     801940 <accept+0x2d>
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801925:	83 ec 04             	sub    $0x4,%esp
  801928:	ff 75 10             	pushl  0x10(%ebp)
  80192b:	ff 75 0c             	pushl  0xc(%ebp)
  80192e:	50                   	push   %eax
  80192f:	e8 0e 01 00 00       	call   801a42 <nsipc_accept>
  801934:	83 c4 10             	add    $0x10,%esp
  801937:	85 c0                	test   %eax,%eax
  801939:	78 05                	js     801940 <accept+0x2d>
	return alloc_sockfd(r);
  80193b:	e8 5f ff ff ff       	call   80189f <alloc_sockfd>
}
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <bind>:
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
  801945:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801948:	8b 45 08             	mov    0x8(%ebp),%eax
  80194b:	e8 1f ff ff ff       	call   80186f <fd2sockid>
  801950:	85 c0                	test   %eax,%eax
  801952:	78 12                	js     801966 <bind+0x24>
	return nsipc_bind(r, name, namelen);
  801954:	83 ec 04             	sub    $0x4,%esp
  801957:	ff 75 10             	pushl  0x10(%ebp)
  80195a:	ff 75 0c             	pushl  0xc(%ebp)
  80195d:	50                   	push   %eax
  80195e:	e8 31 01 00 00       	call   801a94 <nsipc_bind>
  801963:	83 c4 10             	add    $0x10,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <shutdown>:
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	e8 f9 fe ff ff       	call   80186f <fd2sockid>
  801976:	85 c0                	test   %eax,%eax
  801978:	78 0f                	js     801989 <shutdown+0x21>
	return nsipc_shutdown(r, how);
  80197a:	83 ec 08             	sub    $0x8,%esp
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	50                   	push   %eax
  801981:	e8 43 01 00 00       	call   801ac9 <nsipc_shutdown>
  801986:	83 c4 10             	add    $0x10,%esp
}
  801989:	c9                   	leave  
  80198a:	c3                   	ret    

0080198b <connect>:
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	e8 d6 fe ff ff       	call   80186f <fd2sockid>
  801999:	85 c0                	test   %eax,%eax
  80199b:	78 12                	js     8019af <connect+0x24>
	return nsipc_connect(r, name, namelen);
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	ff 75 10             	pushl  0x10(%ebp)
  8019a3:	ff 75 0c             	pushl  0xc(%ebp)
  8019a6:	50                   	push   %eax
  8019a7:	e8 59 01 00 00       	call   801b05 <nsipc_connect>
  8019ac:	83 c4 10             	add    $0x10,%esp
}
  8019af:	c9                   	leave  
  8019b0:	c3                   	ret    

008019b1 <listen>:
{
  8019b1:	55                   	push   %ebp
  8019b2:	89 e5                	mov    %esp,%ebp
  8019b4:	83 ec 08             	sub    $0x8,%esp
	if ((r = fd2sockid(s)) < 0)
  8019b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ba:	e8 b0 fe ff ff       	call   80186f <fd2sockid>
  8019bf:	85 c0                	test   %eax,%eax
  8019c1:	78 0f                	js     8019d2 <listen+0x21>
	return nsipc_listen(r, backlog);
  8019c3:	83 ec 08             	sub    $0x8,%esp
  8019c6:	ff 75 0c             	pushl  0xc(%ebp)
  8019c9:	50                   	push   %eax
  8019ca:	e8 6b 01 00 00       	call   801b3a <nsipc_listen>
  8019cf:	83 c4 10             	add    $0x10,%esp
}
  8019d2:	c9                   	leave  
  8019d3:	c3                   	ret    

008019d4 <socket>:

int
socket(int domain, int type, int protocol)
{
  8019d4:	55                   	push   %ebp
  8019d5:	89 e5                	mov    %esp,%ebp
  8019d7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8019da:	ff 75 10             	pushl  0x10(%ebp)
  8019dd:	ff 75 0c             	pushl  0xc(%ebp)
  8019e0:	ff 75 08             	pushl  0x8(%ebp)
  8019e3:	e8 3e 02 00 00       	call   801c26 <nsipc_socket>
  8019e8:	83 c4 10             	add    $0x10,%esp
  8019eb:	85 c0                	test   %eax,%eax
  8019ed:	78 05                	js     8019f4 <socket+0x20>
		return r;
	return alloc_sockfd(r);
  8019ef:	e8 ab fe ff ff       	call   80189f <alloc_sockfd>
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
  8019f9:	53                   	push   %ebx
  8019fa:	83 ec 04             	sub    $0x4,%esp
  8019fd:	89 c3                	mov    %eax,%ebx
	static envid_t nsenv;
	if (nsenv == 0)
  8019ff:	83 3d 04 40 80 00 00 	cmpl   $0x0,0x804004
  801a06:	74 26                	je     801a2e <nsipc+0x38>
	static_assert(sizeof(nsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] nsipc %d\n", thisenv->env_id, type);

	ipc_send(nsenv, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801a08:	6a 07                	push   $0x7
  801a0a:	68 00 60 80 00       	push   $0x806000
  801a0f:	53                   	push   %ebx
  801a10:	ff 35 04 40 80 00    	pushl  0x804004
  801a16:	e8 c2 07 00 00       	call   8021dd <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801a1b:	83 c4 0c             	add    $0xc,%esp
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	e8 4b 07 00 00       	call   802174 <ipc_recv>
}
  801a29:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    
		nsenv = ipc_find_env(ENV_TYPE_NS);
  801a2e:	83 ec 0c             	sub    $0xc,%esp
  801a31:	6a 02                	push   $0x2
  801a33:	e8 fd 07 00 00       	call   802235 <ipc_find_env>
  801a38:	a3 04 40 80 00       	mov    %eax,0x804004
  801a3d:	83 c4 10             	add    $0x10,%esp
  801a40:	eb c6                	jmp    801a08 <nsipc+0x12>

00801a42 <nsipc_accept>:

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
  801a45:	56                   	push   %esi
  801a46:	53                   	push   %ebx
  801a47:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.accept.req_s = s;
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.accept.req_addrlen = *addrlen;
  801a52:	8b 06                	mov    (%esi),%eax
  801a54:	a3 04 60 80 00       	mov    %eax,0x806004
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a59:	b8 01 00 00 00       	mov    $0x1,%eax
  801a5e:	e8 93 ff ff ff       	call   8019f6 <nsipc>
  801a63:	89 c3                	mov    %eax,%ebx
  801a65:	85 c0                	test   %eax,%eax
  801a67:	79 09                	jns    801a72 <nsipc_accept+0x30>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
		*addrlen = ret->ret_addrlen;
	}
	return r;
}
  801a69:	89 d8                	mov    %ebx,%eax
  801a6b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5e                   	pop    %esi
  801a70:	5d                   	pop    %ebp
  801a71:	c3                   	ret    
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a72:	83 ec 04             	sub    $0x4,%esp
  801a75:	ff 35 10 60 80 00    	pushl  0x806010
  801a7b:	68 00 60 80 00       	push   $0x806000
  801a80:	ff 75 0c             	pushl  0xc(%ebp)
  801a83:	e8 dc ef ff ff       	call   800a64 <memmove>
		*addrlen = ret->ret_addrlen;
  801a88:	a1 10 60 80 00       	mov    0x806010,%eax
  801a8d:	89 06                	mov    %eax,(%esi)
  801a8f:	83 c4 10             	add    $0x10,%esp
	return r;
  801a92:	eb d5                	jmp    801a69 <nsipc_accept+0x27>

00801a94 <nsipc_bind>:

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	53                   	push   %ebx
  801a98:	83 ec 08             	sub    $0x8,%esp
  801a9b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa1:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801aa6:	53                   	push   %ebx
  801aa7:	ff 75 0c             	pushl  0xc(%ebp)
  801aaa:	68 04 60 80 00       	push   $0x806004
  801aaf:	e8 b0 ef ff ff       	call   800a64 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801ab4:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801aba:	b8 02 00 00 00       	mov    $0x2,%eax
  801abf:	e8 32 ff ff ff       	call   8019f6 <nsipc>
}
  801ac4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <nsipc_shutdown>:

int
nsipc_shutdown(int s, int how)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  801ad7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ada:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  801adf:	b8 03 00 00 00       	mov    $0x3,%eax
  801ae4:	e8 0d ff ff ff       	call   8019f6 <nsipc>
}
  801ae9:	c9                   	leave  
  801aea:	c3                   	ret    

00801aeb <nsipc_close>:

int
nsipc_close(int s)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801af9:	b8 04 00 00 00       	mov    $0x4,%eax
  801afe:	e8 f3 fe ff ff       	call   8019f6 <nsipc>
}
  801b03:	c9                   	leave  
  801b04:	c3                   	ret    

00801b05 <nsipc_connect>:

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	53                   	push   %ebx
  801b09:	83 ec 08             	sub    $0x8,%esp
  801b0c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b12:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801b17:	53                   	push   %ebx
  801b18:	ff 75 0c             	pushl  0xc(%ebp)
  801b1b:	68 04 60 80 00       	push   $0x806004
  801b20:	e8 3f ef ff ff       	call   800a64 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801b25:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  801b2b:	b8 05 00 00 00       	mov    $0x5,%eax
  801b30:	e8 c1 fe ff ff       	call   8019f6 <nsipc>
}
  801b35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <nsipc_listen>:

int
nsipc_listen(int s, int backlog)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801b40:	8b 45 08             	mov    0x8(%ebp),%eax
  801b43:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  801b48:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b4b:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801b50:	b8 06 00 00 00       	mov    $0x6,%eax
  801b55:	e8 9c fe ff ff       	call   8019f6 <nsipc>
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <nsipc_recv>:

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
  801b61:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801b6c:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  801b72:	8b 45 14             	mov    0x14(%ebp),%eax
  801b75:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801b7a:	b8 07 00 00 00       	mov    $0x7,%eax
  801b7f:	e8 72 fe ff ff       	call   8019f6 <nsipc>
  801b84:	89 c3                	mov    %eax,%ebx
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 1f                	js     801ba9 <nsipc_recv+0x4d>
		assert(r < 1600 && r <= len);
  801b8a:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801b8f:	7f 21                	jg     801bb2 <nsipc_recv+0x56>
  801b91:	39 c6                	cmp    %eax,%esi
  801b93:	7c 1d                	jl     801bb2 <nsipc_recv+0x56>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801b95:	83 ec 04             	sub    $0x4,%esp
  801b98:	50                   	push   %eax
  801b99:	68 00 60 80 00       	push   $0x806000
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	e8 be ee ff ff       	call   800a64 <memmove>
  801ba6:	83 c4 10             	add    $0x10,%esp
	}

	return r;
}
  801ba9:	89 d8                	mov    %ebx,%eax
  801bab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bae:	5b                   	pop    %ebx
  801baf:	5e                   	pop    %esi
  801bb0:	5d                   	pop    %ebp
  801bb1:	c3                   	ret    
		assert(r < 1600 && r <= len);
  801bb2:	68 a3 29 80 00       	push   $0x8029a3
  801bb7:	68 6b 29 80 00       	push   $0x80296b
  801bbc:	6a 62                	push   $0x62
  801bbe:	68 b8 29 80 00       	push   $0x8029b8
  801bc3:	e8 4b 05 00 00       	call   802113 <_panic>

00801bc8 <nsipc_send>:

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd5:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  801bda:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801be0:	7f 2e                	jg     801c10 <nsipc_send+0x48>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801be2:	83 ec 04             	sub    $0x4,%esp
  801be5:	53                   	push   %ebx
  801be6:	ff 75 0c             	pushl  0xc(%ebp)
  801be9:	68 0c 60 80 00       	push   $0x80600c
  801bee:	e8 71 ee ff ff       	call   800a64 <memmove>
	nsipcbuf.send.req_size = size;
  801bf3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801bf9:	8b 45 14             	mov    0x14(%ebp),%eax
  801bfc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801c01:	b8 08 00 00 00       	mov    $0x8,%eax
  801c06:	e8 eb fd ff ff       	call   8019f6 <nsipc>
}
  801c0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c0e:	c9                   	leave  
  801c0f:	c3                   	ret    
	assert(size < 1600);
  801c10:	68 c4 29 80 00       	push   $0x8029c4
  801c15:	68 6b 29 80 00       	push   $0x80296b
  801c1a:	6a 6d                	push   $0x6d
  801c1c:	68 b8 29 80 00       	push   $0x8029b8
  801c21:	e8 ed 04 00 00       	call   802113 <_panic>

00801c26 <nsipc_socket>:

int
nsipc_socket(int domain, int type, int protocol)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801c34:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c37:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  801c3c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801c44:	b8 09 00 00 00       	mov    $0x9,%eax
  801c49:	e8 a8 fd ff ff       	call   8019f6 <nsipc>
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	56                   	push   %esi
  801c54:	53                   	push   %ebx
  801c55:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c58:	83 ec 0c             	sub    $0xc,%esp
  801c5b:	ff 75 08             	pushl  0x8(%ebp)
  801c5e:	e8 6a f3 ff ff       	call   800fcd <fd2data>
  801c63:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c65:	83 c4 08             	add    $0x8,%esp
  801c68:	68 d0 29 80 00       	push   $0x8029d0
  801c6d:	53                   	push   %ebx
  801c6e:	e8 63 ec ff ff       	call   8008d6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c73:	8b 46 04             	mov    0x4(%esi),%eax
  801c76:	2b 06                	sub    (%esi),%eax
  801c78:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_isdir = 0;
  801c7e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801c85:	00 00 00 
	stat->st_dev = &devpipe;
  801c88:	c7 83 88 00 00 00 3c 	movl   $0x80303c,0x88(%ebx)
  801c8f:	30 80 00 
	return 0;
}
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c9a:	5b                   	pop    %ebx
  801c9b:	5e                   	pop    %esi
  801c9c:	5d                   	pop    %ebp
  801c9d:	c3                   	ret    

00801c9e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	53                   	push   %ebx
  801ca2:	83 ec 0c             	sub    $0xc,%esp
  801ca5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ca8:	53                   	push   %ebx
  801ca9:	6a 00                	push   $0x0
  801cab:	e8 9d f0 ff ff       	call   800d4d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801cb0:	89 1c 24             	mov    %ebx,(%esp)
  801cb3:	e8 15 f3 ff ff       	call   800fcd <fd2data>
  801cb8:	83 c4 08             	add    $0x8,%esp
  801cbb:	50                   	push   %eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	e8 8a f0 ff ff       	call   800d4d <sys_page_unmap>
}
  801cc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cc6:	c9                   	leave  
  801cc7:	c3                   	ret    

00801cc8 <_pipeisclosed>:
{
  801cc8:	55                   	push   %ebp
  801cc9:	89 e5                	mov    %esp,%ebp
  801ccb:	57                   	push   %edi
  801ccc:	56                   	push   %esi
  801ccd:	53                   	push   %ebx
  801cce:	83 ec 1c             	sub    $0x1c,%esp
  801cd1:	89 c7                	mov    %eax,%edi
  801cd3:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cd5:	a1 08 40 80 00       	mov    0x804008,%eax
  801cda:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cdd:	83 ec 0c             	sub    $0xc,%esp
  801ce0:	57                   	push   %edi
  801ce1:	e8 8e 05 00 00       	call   802274 <pageref>
  801ce6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801ce9:	89 34 24             	mov    %esi,(%esp)
  801cec:	e8 83 05 00 00       	call   802274 <pageref>
		nn = thisenv->env_runs;
  801cf1:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801cf7:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cfa:	83 c4 10             	add    $0x10,%esp
  801cfd:	39 cb                	cmp    %ecx,%ebx
  801cff:	74 1b                	je     801d1c <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801d01:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d04:	75 cf                	jne    801cd5 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801d06:	8b 42 58             	mov    0x58(%edx),%eax
  801d09:	6a 01                	push   $0x1
  801d0b:	50                   	push   %eax
  801d0c:	53                   	push   %ebx
  801d0d:	68 d7 29 80 00       	push   $0x8029d7
  801d12:	e8 60 e4 ff ff       	call   800177 <cprintf>
  801d17:	83 c4 10             	add    $0x10,%esp
  801d1a:	eb b9                	jmp    801cd5 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d1c:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d1f:	0f 94 c0             	sete   %al
  801d22:	0f b6 c0             	movzbl %al,%eax
}
  801d25:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d28:	5b                   	pop    %ebx
  801d29:	5e                   	pop    %esi
  801d2a:	5f                   	pop    %edi
  801d2b:	5d                   	pop    %ebp
  801d2c:	c3                   	ret    

00801d2d <devpipe_write>:
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
  801d30:	57                   	push   %edi
  801d31:	56                   	push   %esi
  801d32:	53                   	push   %ebx
  801d33:	83 ec 28             	sub    $0x28,%esp
  801d36:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d39:	56                   	push   %esi
  801d3a:	e8 8e f2 ff ff       	call   800fcd <fd2data>
  801d3f:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d41:	83 c4 10             	add    $0x10,%esp
  801d44:	bf 00 00 00 00       	mov    $0x0,%edi
  801d49:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d4c:	74 4f                	je     801d9d <devpipe_write+0x70>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d4e:	8b 43 04             	mov    0x4(%ebx),%eax
  801d51:	8b 0b                	mov    (%ebx),%ecx
  801d53:	8d 51 20             	lea    0x20(%ecx),%edx
  801d56:	39 d0                	cmp    %edx,%eax
  801d58:	72 14                	jb     801d6e <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d5a:	89 da                	mov    %ebx,%edx
  801d5c:	89 f0                	mov    %esi,%eax
  801d5e:	e8 65 ff ff ff       	call   801cc8 <_pipeisclosed>
  801d63:	85 c0                	test   %eax,%eax
  801d65:	75 3b                	jne    801da2 <devpipe_write+0x75>
			sys_yield();
  801d67:	e8 3d ef ff ff       	call   800ca9 <sys_yield>
  801d6c:	eb e0                	jmp    801d4e <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801d71:	0f b6 0c 39          	movzbl (%ecx,%edi,1),%ecx
  801d75:	88 4d e7             	mov    %cl,-0x19(%ebp)
  801d78:	89 c2                	mov    %eax,%edx
  801d7a:	c1 fa 1f             	sar    $0x1f,%edx
  801d7d:	89 d1                	mov    %edx,%ecx
  801d7f:	c1 e9 1b             	shr    $0x1b,%ecx
  801d82:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d85:	83 e2 1f             	and    $0x1f,%edx
  801d88:	29 ca                	sub    %ecx,%edx
  801d8a:	0f b6 4d e7          	movzbl -0x19(%ebp),%ecx
  801d8e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801d92:	83 c0 01             	add    $0x1,%eax
  801d95:	89 43 04             	mov    %eax,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d98:	83 c7 01             	add    $0x1,%edi
  801d9b:	eb ac                	jmp    801d49 <devpipe_write+0x1c>
	return i;
  801d9d:	8b 45 10             	mov    0x10(%ebp),%eax
  801da0:	eb 05                	jmp    801da7 <devpipe_write+0x7a>
				return 0;
  801da2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801da7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801daa:	5b                   	pop    %ebx
  801dab:	5e                   	pop    %esi
  801dac:	5f                   	pop    %edi
  801dad:	5d                   	pop    %ebp
  801dae:	c3                   	ret    

00801daf <devpipe_read>:
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	57                   	push   %edi
  801db3:	56                   	push   %esi
  801db4:	53                   	push   %ebx
  801db5:	83 ec 18             	sub    $0x18,%esp
  801db8:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801dbb:	57                   	push   %edi
  801dbc:	e8 0c f2 ff ff       	call   800fcd <fd2data>
  801dc1:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	be 00 00 00 00       	mov    $0x0,%esi
  801dcb:	3b 75 10             	cmp    0x10(%ebp),%esi
  801dce:	75 14                	jne    801de4 <devpipe_read+0x35>
	return i;
  801dd0:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd3:	eb 02                	jmp    801dd7 <devpipe_read+0x28>
				return i;
  801dd5:	89 f0                	mov    %esi,%eax
}
  801dd7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801dda:	5b                   	pop    %ebx
  801ddb:	5e                   	pop    %esi
  801ddc:	5f                   	pop    %edi
  801ddd:	5d                   	pop    %ebp
  801dde:	c3                   	ret    
			sys_yield();
  801ddf:	e8 c5 ee ff ff       	call   800ca9 <sys_yield>
		while (p->p_rpos == p->p_wpos) {
  801de4:	8b 03                	mov    (%ebx),%eax
  801de6:	3b 43 04             	cmp    0x4(%ebx),%eax
  801de9:	75 18                	jne    801e03 <devpipe_read+0x54>
			if (i > 0)
  801deb:	85 f6                	test   %esi,%esi
  801ded:	75 e6                	jne    801dd5 <devpipe_read+0x26>
			if (_pipeisclosed(fd, p))
  801def:	89 da                	mov    %ebx,%edx
  801df1:	89 f8                	mov    %edi,%eax
  801df3:	e8 d0 fe ff ff       	call   801cc8 <_pipeisclosed>
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	74 e3                	je     801ddf <devpipe_read+0x30>
				return 0;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801e01:	eb d4                	jmp    801dd7 <devpipe_read+0x28>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801e03:	99                   	cltd   
  801e04:	c1 ea 1b             	shr    $0x1b,%edx
  801e07:	01 d0                	add    %edx,%eax
  801e09:	83 e0 1f             	and    $0x1f,%eax
  801e0c:	29 d0                	sub    %edx,%eax
  801e0e:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801e13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e16:	88 04 31             	mov    %al,(%ecx,%esi,1)
		p->p_rpos++;
  801e19:	83 03 01             	addl   $0x1,(%ebx)
	for (i = 0; i < n; i++) {
  801e1c:	83 c6 01             	add    $0x1,%esi
  801e1f:	eb aa                	jmp    801dcb <devpipe_read+0x1c>

00801e21 <pipe>:
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	56                   	push   %esi
  801e25:	53                   	push   %ebx
  801e26:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e29:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e2c:	50                   	push   %eax
  801e2d:	e8 b2 f1 ff ff       	call   800fe4 <fd_alloc>
  801e32:	89 c3                	mov    %eax,%ebx
  801e34:	83 c4 10             	add    $0x10,%esp
  801e37:	85 c0                	test   %eax,%eax
  801e39:	0f 88 23 01 00 00    	js     801f62 <pipe+0x141>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3f:	83 ec 04             	sub    $0x4,%esp
  801e42:	68 07 04 00 00       	push   $0x407
  801e47:	ff 75 f4             	pushl  -0xc(%ebp)
  801e4a:	6a 00                	push   $0x0
  801e4c:	e8 77 ee ff ff       	call   800cc8 <sys_page_alloc>
  801e51:	89 c3                	mov    %eax,%ebx
  801e53:	83 c4 10             	add    $0x10,%esp
  801e56:	85 c0                	test   %eax,%eax
  801e58:	0f 88 04 01 00 00    	js     801f62 <pipe+0x141>
	if ((r = fd_alloc(&fd1)) < 0
  801e5e:	83 ec 0c             	sub    $0xc,%esp
  801e61:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e64:	50                   	push   %eax
  801e65:	e8 7a f1 ff ff       	call   800fe4 <fd_alloc>
  801e6a:	89 c3                	mov    %eax,%ebx
  801e6c:	83 c4 10             	add    $0x10,%esp
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	0f 88 db 00 00 00    	js     801f52 <pipe+0x131>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e77:	83 ec 04             	sub    $0x4,%esp
  801e7a:	68 07 04 00 00       	push   $0x407
  801e7f:	ff 75 f0             	pushl  -0x10(%ebp)
  801e82:	6a 00                	push   $0x0
  801e84:	e8 3f ee ff ff       	call   800cc8 <sys_page_alloc>
  801e89:	89 c3                	mov    %eax,%ebx
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	0f 88 bc 00 00 00    	js     801f52 <pipe+0x131>
	va = fd2data(fd0);
  801e96:	83 ec 0c             	sub    $0xc,%esp
  801e99:	ff 75 f4             	pushl  -0xc(%ebp)
  801e9c:	e8 2c f1 ff ff       	call   800fcd <fd2data>
  801ea1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ea3:	83 c4 0c             	add    $0xc,%esp
  801ea6:	68 07 04 00 00       	push   $0x407
  801eab:	50                   	push   %eax
  801eac:	6a 00                	push   $0x0
  801eae:	e8 15 ee ff ff       	call   800cc8 <sys_page_alloc>
  801eb3:	89 c3                	mov    %eax,%ebx
  801eb5:	83 c4 10             	add    $0x10,%esp
  801eb8:	85 c0                	test   %eax,%eax
  801eba:	0f 88 82 00 00 00    	js     801f42 <pipe+0x121>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ec0:	83 ec 0c             	sub    $0xc,%esp
  801ec3:	ff 75 f0             	pushl  -0x10(%ebp)
  801ec6:	e8 02 f1 ff ff       	call   800fcd <fd2data>
  801ecb:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ed2:	50                   	push   %eax
  801ed3:	6a 00                	push   $0x0
  801ed5:	56                   	push   %esi
  801ed6:	6a 00                	push   $0x0
  801ed8:	e8 2e ee ff ff       	call   800d0b <sys_page_map>
  801edd:	89 c3                	mov    %eax,%ebx
  801edf:	83 c4 20             	add    $0x20,%esp
  801ee2:	85 c0                	test   %eax,%eax
  801ee4:	78 4e                	js     801f34 <pipe+0x113>
	fd0->fd_dev_id = devpipe.dev_id;
  801ee6:	a1 3c 30 80 00       	mov    0x80303c,%eax
  801eeb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801eee:	89 02                	mov    %eax,(%edx)
	fd0->fd_omode = O_RDONLY;
  801ef0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef3:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
	fd1->fd_dev_id = devpipe.dev_id;
  801efa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801efd:	89 02                	mov    %eax,(%edx)
	fd1->fd_omode = O_WRONLY;
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f02:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801f09:	83 ec 0c             	sub    $0xc,%esp
  801f0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f0f:	e8 a9 f0 ff ff       	call   800fbd <fd2num>
  801f14:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f17:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801f19:	83 c4 04             	add    $0x4,%esp
  801f1c:	ff 75 f0             	pushl  -0x10(%ebp)
  801f1f:	e8 99 f0 ff ff       	call   800fbd <fd2num>
  801f24:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f27:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f32:	eb 2e                	jmp    801f62 <pipe+0x141>
	sys_page_unmap(0, va);
  801f34:	83 ec 08             	sub    $0x8,%esp
  801f37:	56                   	push   %esi
  801f38:	6a 00                	push   $0x0
  801f3a:	e8 0e ee ff ff       	call   800d4d <sys_page_unmap>
  801f3f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f42:	83 ec 08             	sub    $0x8,%esp
  801f45:	ff 75 f0             	pushl  -0x10(%ebp)
  801f48:	6a 00                	push   $0x0
  801f4a:	e8 fe ed ff ff       	call   800d4d <sys_page_unmap>
  801f4f:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f52:	83 ec 08             	sub    $0x8,%esp
  801f55:	ff 75 f4             	pushl  -0xc(%ebp)
  801f58:	6a 00                	push   $0x0
  801f5a:	e8 ee ed ff ff       	call   800d4d <sys_page_unmap>
  801f5f:	83 c4 10             	add    $0x10,%esp
}
  801f62:	89 d8                	mov    %ebx,%eax
  801f64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f67:	5b                   	pop    %ebx
  801f68:	5e                   	pop    %esi
  801f69:	5d                   	pop    %ebp
  801f6a:	c3                   	ret    

00801f6b <pipeisclosed>:
{
  801f6b:	55                   	push   %ebp
  801f6c:	89 e5                	mov    %esp,%ebp
  801f6e:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f71:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f74:	50                   	push   %eax
  801f75:	ff 75 08             	pushl  0x8(%ebp)
  801f78:	e8 b9 f0 ff ff       	call   801036 <fd_lookup>
  801f7d:	83 c4 10             	add    $0x10,%esp
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 18                	js     801f9c <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f84:	83 ec 0c             	sub    $0xc,%esp
  801f87:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8a:	e8 3e f0 ff ff       	call   800fcd <fd2data>
	return _pipeisclosed(fd, p);
  801f8f:	89 c2                	mov    %eax,%edx
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	e8 2f fd ff ff       	call   801cc8 <_pipeisclosed>
  801f99:	83 c4 10             	add    $0x10,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <devcons_close>:
devcons_close(struct Fd *fd)
{
	USED(fd);

	return 0;
}
  801f9e:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa3:	c3                   	ret    

00801fa4 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801fa4:	55                   	push   %ebp
  801fa5:	89 e5                	mov    %esp,%ebp
  801fa7:	83 ec 10             	sub    $0x10,%esp
	strcpy(stat->st_name, "<cons>");
  801faa:	68 ef 29 80 00       	push   $0x8029ef
  801faf:	ff 75 0c             	pushl  0xc(%ebp)
  801fb2:	e8 1f e9 ff ff       	call   8008d6 <strcpy>
	return 0;
}
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <devcons_write>:
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	57                   	push   %edi
  801fc2:	56                   	push   %esi
  801fc3:	53                   	push   %ebx
  801fc4:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fca:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fcf:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fd5:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fd8:	73 31                	jae    80200b <devcons_write+0x4d>
		m = n - tot;
  801fda:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fdd:	29 f3                	sub    %esi,%ebx
  801fdf:	83 fb 7f             	cmp    $0x7f,%ebx
  801fe2:	b8 7f 00 00 00       	mov    $0x7f,%eax
  801fe7:	0f 47 d8             	cmova  %eax,%ebx
		memmove(buf, (char*)vbuf + tot, m);
  801fea:	83 ec 04             	sub    $0x4,%esp
  801fed:	53                   	push   %ebx
  801fee:	89 f0                	mov    %esi,%eax
  801ff0:	03 45 0c             	add    0xc(%ebp),%eax
  801ff3:	50                   	push   %eax
  801ff4:	57                   	push   %edi
  801ff5:	e8 6a ea ff ff       	call   800a64 <memmove>
		sys_cputs(buf, m);
  801ffa:	83 c4 08             	add    $0x8,%esp
  801ffd:	53                   	push   %ebx
  801ffe:	57                   	push   %edi
  801fff:	e8 08 ec ff ff       	call   800c0c <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  802004:	01 de                	add    %ebx,%esi
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	eb ca                	jmp    801fd5 <devcons_write+0x17>
}
  80200b:	89 f0                	mov    %esi,%eax
  80200d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802010:	5b                   	pop    %ebx
  802011:	5e                   	pop    %esi
  802012:	5f                   	pop    %edi
  802013:	5d                   	pop    %ebp
  802014:	c3                   	ret    

00802015 <devcons_read>:
{
  802015:	55                   	push   %ebp
  802016:	89 e5                	mov    %esp,%ebp
  802018:	83 ec 08             	sub    $0x8,%esp
  80201b:	b8 00 00 00 00       	mov    $0x0,%eax
	if (n == 0)
  802020:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802024:	74 21                	je     802047 <devcons_read+0x32>
	while ((c = sys_cgetc()) == 0)
  802026:	e8 ff eb ff ff       	call   800c2a <sys_cgetc>
  80202b:	85 c0                	test   %eax,%eax
  80202d:	75 07                	jne    802036 <devcons_read+0x21>
		sys_yield();
  80202f:	e8 75 ec ff ff       	call   800ca9 <sys_yield>
  802034:	eb f0                	jmp    802026 <devcons_read+0x11>
	if (c < 0)
  802036:	78 0f                	js     802047 <devcons_read+0x32>
	if (c == 0x04)	// ctl-d is eof
  802038:	83 f8 04             	cmp    $0x4,%eax
  80203b:	74 0c                	je     802049 <devcons_read+0x34>
	*(char*)vbuf = c;
  80203d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802040:	88 02                	mov    %al,(%edx)
	return 1;
  802042:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802047:	c9                   	leave  
  802048:	c3                   	ret    
		return 0;
  802049:	b8 00 00 00 00       	mov    $0x0,%eax
  80204e:	eb f7                	jmp    802047 <devcons_read+0x32>

00802050 <cputchar>:
{
  802050:	55                   	push   %ebp
  802051:	89 e5                	mov    %esp,%ebp
  802053:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802056:	8b 45 08             	mov    0x8(%ebp),%eax
  802059:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80205c:	6a 01                	push   $0x1
  80205e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802061:	50                   	push   %eax
  802062:	e8 a5 eb ff ff       	call   800c0c <sys_cputs>
}
  802067:	83 c4 10             	add    $0x10,%esp
  80206a:	c9                   	leave  
  80206b:	c3                   	ret    

0080206c <getchar>:
{
  80206c:	55                   	push   %ebp
  80206d:	89 e5                	mov    %esp,%ebp
  80206f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802072:	6a 01                	push   $0x1
  802074:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802077:	50                   	push   %eax
  802078:	6a 00                	push   $0x0
  80207a:	e8 27 f2 ff ff       	call   8012a6 <read>
	if (r < 0)
  80207f:	83 c4 10             	add    $0x10,%esp
  802082:	85 c0                	test   %eax,%eax
  802084:	78 06                	js     80208c <getchar+0x20>
	if (r < 1)
  802086:	74 06                	je     80208e <getchar+0x22>
	return c;
  802088:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80208c:	c9                   	leave  
  80208d:	c3                   	ret    
		return -E_EOF;
  80208e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802093:	eb f7                	jmp    80208c <getchar+0x20>

00802095 <iscons>:
{
  802095:	55                   	push   %ebp
  802096:	89 e5                	mov    %esp,%ebp
  802098:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80209b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80209e:	50                   	push   %eax
  80209f:	ff 75 08             	pushl  0x8(%ebp)
  8020a2:	e8 8f ef ff ff       	call   801036 <fd_lookup>
  8020a7:	83 c4 10             	add    $0x10,%esp
  8020aa:	85 c0                	test   %eax,%eax
  8020ac:	78 11                	js     8020bf <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b1:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020b7:	39 10                	cmp    %edx,(%eax)
  8020b9:	0f 94 c0             	sete   %al
  8020bc:	0f b6 c0             	movzbl %al,%eax
}
  8020bf:	c9                   	leave  
  8020c0:	c3                   	ret    

008020c1 <opencons>:
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ca:	50                   	push   %eax
  8020cb:	e8 14 ef ff ff       	call   800fe4 <fd_alloc>
  8020d0:	83 c4 10             	add    $0x10,%esp
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 3a                	js     802111 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020d7:	83 ec 04             	sub    $0x4,%esp
  8020da:	68 07 04 00 00       	push   $0x407
  8020df:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e2:	6a 00                	push   $0x0
  8020e4:	e8 df eb ff ff       	call   800cc8 <sys_page_alloc>
  8020e9:	83 c4 10             	add    $0x10,%esp
  8020ec:	85 c0                	test   %eax,%eax
  8020ee:	78 21                	js     802111 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	8b 15 58 30 80 00    	mov    0x803058,%edx
  8020f9:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fe:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802105:	83 ec 0c             	sub    $0xc,%esp
  802108:	50                   	push   %eax
  802109:	e8 af ee ff ff       	call   800fbd <fd2num>
  80210e:	83 c4 10             	add    $0x10,%esp
}
  802111:	c9                   	leave  
  802112:	c3                   	ret    

00802113 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  802113:	55                   	push   %ebp
  802114:	89 e5                	mov    %esp,%ebp
  802116:	56                   	push   %esi
  802117:	53                   	push   %ebx
	cprintf("%d: in %s\n", thisenv->env_id, __FUNCTION__);
  802118:	a1 08 40 80 00       	mov    0x804008,%eax
  80211d:	8b 40 48             	mov    0x48(%eax),%eax
  802120:	83 ec 04             	sub    $0x4,%esp
  802123:	68 20 2a 80 00       	push   $0x802a20
  802128:	50                   	push   %eax
  802129:	68 0a 25 80 00       	push   $0x80250a
  80212e:	e8 44 e0 ff ff       	call   800177 <cprintf>
	va_list ap;

	va_start(ap, fmt);
  802133:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Print the panic message
	// cprintf("[%08x] user panic in %s at %s:%d: ",
	// 	sys_getenvid(), binaryname, file, line);
	cprintf("[%08x] user panic in %s at %s:%d: ",
  802136:	8b 35 00 30 80 00    	mov    0x803000,%esi
  80213c:	e8 49 eb ff ff       	call   800c8a <sys_getenvid>
  802141:	83 c4 04             	add    $0x4,%esp
  802144:	ff 75 0c             	pushl  0xc(%ebp)
  802147:	ff 75 08             	pushl  0x8(%ebp)
  80214a:	56                   	push   %esi
  80214b:	50                   	push   %eax
  80214c:	68 fc 29 80 00       	push   $0x8029fc
  802151:	e8 21 e0 ff ff       	call   800177 <cprintf>
		sys_getenvid(), binaryname, file, line);
	vcprintf(fmt, ap);
  802156:	83 c4 18             	add    $0x18,%esp
  802159:	53                   	push   %ebx
  80215a:	ff 75 10             	pushl  0x10(%ebp)
  80215d:	e8 c4 df ff ff       	call   800126 <vcprintf>
	cprintf("\n");
  802162:	c7 04 24 3a 2a 80 00 	movl   $0x802a3a,(%esp)
  802169:	e8 09 e0 ff ff       	call   800177 <cprintf>
  80216e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802171:	cc                   	int3   
  802172:	eb fd                	jmp    802171 <_panic+0x5e>

00802174 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802174:	55                   	push   %ebp
  802175:	89 e5                	mov    %esp,%ebp
  802177:	56                   	push   %esi
  802178:	53                   	push   %ebx
  802179:	8b 75 08             	mov    0x8(%ebp),%esi
  80217c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80217f:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 4: Your code here.
	// panic("ipc_recv not implemented");
	int ret;
	if(!pg)
  802182:	85 c0                	test   %eax,%eax
		pg = (void *)UTOP;
  802184:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
  802189:	0f 44 c2             	cmove  %edx,%eax
	ret = sys_ipc_recv(pg);
  80218c:	83 ec 0c             	sub    $0xc,%esp
  80218f:	50                   	push   %eax
  802190:	e8 e3 ec ff ff       	call   800e78 <sys_ipc_recv>
	if(ret < 0){
  802195:	83 c4 10             	add    $0x10,%esp
  802198:	85 c0                	test   %eax,%eax
  80219a:	78 2b                	js     8021c7 <ipc_recv+0x53>
			*from_env_store = 0;
		if(perm_store)
			*perm_store = 0;
		return ret;
	}
	if(from_env_store){
  80219c:	85 f6                	test   %esi,%esi
  80219e:	74 0a                	je     8021aa <ipc_recv+0x36>
		*from_env_store = thisenv->env_ipc_from;
  8021a0:	a1 08 40 80 00       	mov    0x804008,%eax
  8021a5:	8b 40 78             	mov    0x78(%eax),%eax
  8021a8:	89 06                	mov    %eax,(%esi)
	}
	if(perm_store){
  8021aa:	85 db                	test   %ebx,%ebx
  8021ac:	74 0a                	je     8021b8 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8021ae:	a1 08 40 80 00       	mov    0x804008,%eax
  8021b3:	8b 40 7c             	mov    0x7c(%eax),%eax
  8021b6:	89 03                	mov    %eax,(%ebx)
	}
	return thisenv->env_ipc_value;
  8021b8:	a1 08 40 80 00       	mov    0x804008,%eax
  8021bd:	8b 40 74             	mov    0x74(%eax),%eax
}
  8021c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8021c3:	5b                   	pop    %ebx
  8021c4:	5e                   	pop    %esi
  8021c5:	5d                   	pop    %ebp
  8021c6:	c3                   	ret    
		if(from_env_store)
  8021c7:	85 f6                	test   %esi,%esi
  8021c9:	74 06                	je     8021d1 <ipc_recv+0x5d>
			*from_env_store = 0;
  8021cb:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
		if(perm_store)
  8021d1:	85 db                	test   %ebx,%ebx
  8021d3:	74 eb                	je     8021c0 <ipc_recv+0x4c>
			*perm_store = 0;
  8021d5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8021db:	eb e3                	jmp    8021c0 <ipc_recv+0x4c>

008021dd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{	
  8021dd:	55                   	push   %ebp
  8021de:	89 e5                	mov    %esp,%ebp
  8021e0:	57                   	push   %edi
  8021e1:	56                   	push   %esi
  8021e2:	53                   	push   %ebx
  8021e3:	83 ec 0c             	sub    $0xc,%esp
  8021e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8021e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8021ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// cprintf("%d: in %s to_env is %d\n", thisenv->env_id, __FUNCTION__, to_env);
	int ret;
	if(!pg)
		pg = (void *)UTOP;
  8021ef:	85 db                	test   %ebx,%ebx
  8021f1:	b8 00 00 c0 ee       	mov    $0xeec00000,%eax
  8021f6:	0f 44 d8             	cmove  %eax,%ebx
  8021f9:	eb 05                	jmp    802200 <ipc_send+0x23>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
			panic("panic at ipc_send()\n");
		}
		sys_yield();
  8021fb:	e8 a9 ea ff ff       	call   800ca9 <sys_yield>
	while((ret = sys_ipc_try_send(to_env, val, pg, perm))){
  802200:	ff 75 14             	pushl  0x14(%ebp)
  802203:	53                   	push   %ebx
  802204:	56                   	push   %esi
  802205:	57                   	push   %edi
  802206:	e8 4a ec ff ff       	call   800e55 <sys_ipc_try_send>
  80220b:	83 c4 10             	add    $0x10,%esp
  80220e:	85 c0                	test   %eax,%eax
  802210:	74 1b                	je     80222d <ipc_send+0x50>
		if(ret < 0 && ret != -E_IPC_NOT_RECV){
  802212:	79 e7                	jns    8021fb <ipc_send+0x1e>
  802214:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802217:	74 e2                	je     8021fb <ipc_send+0x1e>
			panic("panic at ipc_send()\n");
  802219:	83 ec 04             	sub    $0x4,%esp
  80221c:	68 27 2a 80 00       	push   $0x802a27
  802221:	6a 46                	push   $0x46
  802223:	68 3c 2a 80 00       	push   $0x802a3c
  802228:	e8 e6 fe ff ff       	call   802113 <_panic>
	}
	// LAB 4: Your code here.
	// panic("ipc_send not implemented");
}
  80222d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802230:	5b                   	pop    %ebx
  802231:	5e                   	pop    %esi
  802232:	5f                   	pop    %edi
  802233:	5d                   	pop    %ebp
  802234:	c3                   	ret    

00802235 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802235:	55                   	push   %ebp
  802236:	89 e5                	mov    %esp,%ebp
  802238:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80223b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802240:	69 d0 84 00 00 00    	imul   $0x84,%eax,%edx
  802246:	81 c2 00 00 c0 ee    	add    $0xeec00000,%edx
  80224c:	8b 52 50             	mov    0x50(%edx),%edx
  80224f:	39 ca                	cmp    %ecx,%edx
  802251:	74 11                	je     802264 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802253:	83 c0 01             	add    $0x1,%eax
  802256:	3d 00 04 00 00       	cmp    $0x400,%eax
  80225b:	75 e3                	jne    802240 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80225d:	b8 00 00 00 00       	mov    $0x0,%eax
  802262:	eb 0e                	jmp    802272 <ipc_find_env+0x3d>
			return envs[i].env_id;
  802264:	69 c0 84 00 00 00    	imul   $0x84,%eax,%eax
  80226a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80226f:	8b 40 48             	mov    0x48(%eax),%eax
}
  802272:	5d                   	pop    %ebp
  802273:	c3                   	ret    

00802274 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	8b 55 08             	mov    0x8(%ebp),%edx
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80227a:	89 d0                	mov    %edx,%eax
  80227c:	c1 e8 16             	shr    $0x16,%eax
  80227f:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
		return 0;
  802286:	b8 00 00 00 00       	mov    $0x0,%eax
	if (!(uvpd[PDX(v)] & PTE_P))
  80228b:	f6 c1 01             	test   $0x1,%cl
  80228e:	74 1d                	je     8022ad <pageref+0x39>
	pte = uvpt[PGNUM(v)];
  802290:	c1 ea 0c             	shr    $0xc,%edx
  802293:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
	if (!(pte & PTE_P))
  80229a:	f6 c2 01             	test   $0x1,%dl
  80229d:	74 0e                	je     8022ad <pageref+0x39>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80229f:	c1 ea 0c             	shr    $0xc,%edx
  8022a2:	0f b7 04 d5 04 00 00 	movzwl -0x10fffffc(,%edx,8),%eax
  8022a9:	ef 
  8022aa:	0f b7 c0             	movzwl %ax,%eax
}
  8022ad:	5d                   	pop    %ebp
  8022ae:	c3                   	ret    
  8022af:	90                   	nop

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
